// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

//! A sandboxed bash for the in-app agent: bashkit with an in-memory
//! filesystem, no processes, no host files and no network. The only way
//! out is the host commands (`aid`, `sql`), which the app answers in Dart.

use std::sync::Arc;

use bashkit::{async_trait, Bash, Builtin, BuiltinContext, ExecResult};
use flutter_rust_bridge::{frb, DartFnFuture};
use tokio::sync::Mutex;

/// What a command or a script printed, and how it ended.
pub struct ShellOutput {
    pub stdout: String,
    pub stderr: String,
    pub exit_code: i32,
}

type Host = Arc<dyn Fn(String, Vec<String>, String) -> DartFnFuture<ShellOutput> + Send + Sync>;

/// One shell session: its files and variables last until it is dropped.
#[frb(opaque)]
pub struct AgentShell {
    bash: Mutex<Bash>,
}

impl AgentShell {
    /// A session whose [commands] are answered by [host] with the command
    /// name, its arguments and its standard input.
    #[frb(sync)]
    pub fn new(
        commands: Vec<String>,
        host: impl Fn(String, Vec<String>, String) -> DartFnFuture<ShellOutput>
            + Send
            + Sync
            + 'static,
    ) -> AgentShell {
        let host: Host = Arc::new(host);
        let mut builder = Bash::builder();
        for name in commands {
            builder = builder.builtin(
                &name.clone(),
                Box::new(HostCommand {
                    name,
                    host: host.clone(),
                }),
            );
        }
        AgentShell {
            bash: Mutex::new(builder.build()),
        }
    }

    /// Runs [script]; a parse or limit error comes back as exit code 2.
    pub async fn exec(&self, script: String) -> ShellOutput {
        let mut bash = self.bash.lock().await;
        match bash.exec(&script).await {
            Ok(result) => ShellOutput {
                stdout: result.stdout.text_lossy().into_owned(),
                stderr: result.stderr.text_lossy().into_owned(),
                exit_code: result.exit_code,
            },
            Err(error) => ShellOutput {
                stdout: String::new(),
                stderr: format!("{error}\n"),
                exit_code: 2,
            },
        }
    }
}

struct HostCommand {
    name: String,
    host: Host,
}

#[async_trait]
impl Builtin for HostCommand {
    async fn execute(&self, ctx: BuiltinContext<'_>) -> bashkit::Result<ExecResult> {
        let output = (self.host)(
            self.name.clone(),
            ctx.args.to_vec(),
            ctx.stdin
                .map(|stdin| stdin.text_lossy().into_owned())
                .unwrap_or_default(),
        )
        .await;
        let mut result = ExecResult::ok(output.stdout);
        result.stderr = output.stderr.into();
        result.exit_code = output.exit_code;
        Ok(result)
    }
}
