# Engineering principles and workflow

This is the project's engineering policy, researched on 2026-10-22 for a
personal Windows/Android diary app with a Flutter client, Dart CLI and Go
service. It explains how to choose and maintain rules. The [documentation
index](INDEX.md) identifies the primary home for each subject; it is not a
new framework, development service or source-code refactor.

## Build principles from the problem

Start with a user need, a failure we must avoid and the constraints we have.
Then choose a design and a way to verify it. An external recommendation is
evidence to consider, not an automatic new project requirement. Current owner
instructions and settled product choices take precedence over generic advice.
If a local rule conflicts with them, reconcile the document rather than
requiring the owner to approve the same action again.

For a lasting rule, answer three questions:

1. What problem or user outcome does it protect?
2. What concrete behavior does it require, and when does it apply?
3. How do we check it, and what new evidence would justify revisiting it?

Distinguish **required** project invariants, **default** practices that may need
a documented local adaptation, and **optional** tools. Mark a proposal or
unverified claim explicitly. Only consequential choices need a decision record;
a routine fix does not need a separate design document or an approval meeting.

For example, changing network paths must not restart a media transfer because
users move between networks. The existing design gives persistent chunk tasks
ownership of progress, with content verification independent of the socket.
The protocol belongs in [SYNC_NETWORK.md](SYNC_NETWORK.md); relevant tests and
physical-path evidence establish which parts work. A preference for a package
or a folder name does not have the same force as this data-safety invariant.

## Principles used here

| Principle | Project consequence | Where to verify or explain it |
|---|---|---|
| Protect the diary and user trust | Preserve local data on failure; encryption and device trust do not depend on the chosen route; recovery/reset is explicit | Decisions, architecture, sync contracts and failure/restore tests |
| Keep everyday use simple | Useful defaults and progressive disclosure; advanced flexibility stays behind the relevant options | Product decisions and phone/wide interaction review |
| Give data and rules clear owners | Stores own persisted data, shared actions own operations, views render state; avoid competing GUI/CLI implementations | Architecture and dependency/behavior tests |
| Solve the current problem with the smallest coherent design | No speculative frameworks, package migrations or reusable APIs without a caller; refactor when a real change exposes the need | Change review and the explicit scope of the task |
| Prefer explicit, replaceable boundaries | Separate UI, storage, network and native effects; pass dependencies where their substitution is useful; make failures observable | Architecture, constructor/API design and tests at those boundaries |
| Keep changes understandable | One coherent concern, meaningful names and consistent formatter/analyzer use; comments explain contracts or reasons | Diff review and language tooling |
| Tie claims to evidence | Separate source, build, test, deployment and user-visible acceptance; reuse only results valid for the tested state | Testing and dated acceptance records |
| Maintain one primary home for each fact | Update owning docs with code, link from entry points, remove obsolete instructions | Documentation index, links and command review |

These are project choices derived from its needs. They do not claim that all
existing code already meets every ideal or that every principle can be enforced
by a static test.

## Apply Flutter and language guidance honestly

[Flutter's architecture guidance](https://docs.flutter.dev/app-architecture/recommendations)
distinguishes stronger recommendations from conditional ones and allows
adaptation. [Architecture](ARCHITECTURE.md) records our actual layers and
exceptions in its adoption table. In particular, existing singleton access and
partial view-model extraction are adaptations, not complete implementation of
all official recommendations. Conditional layers or package changes need a
demonstrated benefit; do not add them merely to match a sample application.

Use [Effective Dart](https://dart.dev/effective-dart) for language style,
documentation and API design; let `dart format` and the configured Flutter
lints settle mechanical consistency. Use `gofmt`/`go vet` for Go and uv for
Python. Change a lint baseline intentionally instead of suppressing a new
warning without examining its cause. This policy adds no new lint package.

## A change from intent to delivery

1. Establish the outcome, existing product decisions, actual code/configuration
   and relevant callers. Fetch remote updates first. For a concrete unfamiliar
   bug, consult current authoritative docs/issues before speculative experiments.
2. For a consequential change, write a short proposal in its owning document:
   problem, scope/non-goals, a small number of relevant alternatives, selected
   tradeoff and verification. Reuse existing sections; do not create a design
   document for every fix. Ask only when product direction or a genuinely
   unauthorized action remains unresolved.
3. Implement one understandable change including its necessary tests and docs.
   Separate unrelated cleanup; remove genuinely dead logic instead of leaving
   alternate implementations. Keep configuration, endpoints and user-facing
   strings in their existing configuration/localization owners.
4. Run the checks selected by [Testing](TESTING.md), then review the diff for
   behavior, complexity, dependency direction, failure/data handling, secrets,
   naming, tests and changed documentation. A solo self-review is useful but is
   not an independent review; do not invent another reviewer or require a PR.
5. Make a meaningful commit, integrate through the existing simple main/task
   worktree workflow, push, verify the remote revision and remove completed task
   branches/worktrees. Do not import Google's internal review tooling, fixed
   line-count limits or a multi-branch release model into this personal project.
6. If delivery includes deployment, follow the owning deployment runbook. Tie
   the artifact/configuration to source, preserve the intended data and previous
   artifact, then verify behavior in the destination. A successful build or
   uploaded file alone is not acceptance. Publication still requires its
   existing authorization; this document adds none.

The review standard is a working, clearer, maintainable improvement. Do not
delay it for unrelated perfection, or accept a known regression simply because
the change is small. Record material limitations rather than lowering the
definition of done silently.

## Documentation structure and maintenance

The author of a behavior change owns its documentation update in the same
change. The project owner remains the decision maker for product direction.
Use [INDEX.md](INDEX.md) to choose the home; another page links there rather
than maintaining a parallel specification.

- **Entry points** orient readers and link onward: root README, the document
  index and AGENTS. AGENTS keeps essential execution guardrails; move detailed
  recipes to their relevant guide. Do not put dated test/deployment results there.
- **Procedures** state prerequisites, working directory, user actions, expected
  result and cleanup/recovery where needed. Setup owns the local workflow;
  server README owns server operations and configuration.
- **Explanations/reference** describe the current system and stable contracts.
  Architecture owns component roles, not a copied version of Flutter's manual.
  A subsystem guide may contain several clearly labeled sections if splitting
  would create more navigation than value.
- **Decisions/proposals** explain why, alternatives and consequences. Record a
  date and status for consequential choices; when superseded, mark the old choice
  and link to the replacement. Proposed work is not present-tense behavior.
- **Evidence** records revision/date, environment, scope, result and remaining
  limits, following Testing. Keep historical checks separate from current
  capability and policy; old evidence does not automatically certify new code.
  Large raw logs belong in ignored local artifacts, not permanent instructions.

Start each substantial guide with its purpose, intended reader and scope.
Use English docs/comments, descriptive links, active sentences, actionable
steps and unambiguous dates. Explain important contracts/failure behavior in
API comments and non-obvious reasons in implementation comments; do not narrate
obvious code. Use a compact table or diagram when it clarifies relationships.

Keep an external source link instead of copying a general manual. For a local
rule, distinguish the source's advice from our adoption/adaptation and state a
reason. Versions, limits and paths belong in executable configuration when they
control behavior; documents point to it and show safe examples. Secrets and
personal diary contents stay out of docs, sample files, screenshots and logs.

When changing documentation, inspect the rendered structure or readable
Markdown, validate relevant links/commands and remove dead instructions. If a
page becomes hard to scan because it answers unrelated questions, split by
reader task and update incoming links in the same change. Do not split merely
to reach a fixed page length or create empty categories for future documents.

## Sources and project adaptations

Primary sources consulted on 2026-10-22; local choices above are not endorsed
or required verbatim by their authors:

| Source | What it contributes here |
|---|---|
| [Flutter architecture guide](https://docs.flutter.dev/app-architecture/guide) and [recommendations](https://docs.flutter.dev/app-architecture/recommendations) | Responsibility boundaries, state ownership and explicit adaptation; no wholesale folder/package migration |
| [Effective Dart](https://dart.dev/effective-dart) | Consistent, readable language/API conventions; no hand-copied style manual |
| [Google review standard](https://google.github.io/eng-practices/review/reviewer/standard.html), [review criteria](https://google.github.io/eng-practices/review/reviewer/looking-for.html) and [small changes](https://google.github.io/eng-practices/review/developer/small-cls.html) | Maintainability, correctness, proportional review and coherent changes; solo workflow stays simple |
| [Google documentation practices](https://google.github.io/styleguide/docguide/best_practices.html) and [philosophy](https://google.github.io/styleguide/docguide/philosophy.html) | Small maintained docs, canonical facts, updates with code and removal of stale instructions |
| [Software Engineering at Google: Documentation](https://abseil.io/resources/swe-book/html/ch10.html) | Reader/purpose, document ownership, source control and separation of reference, explanation, decisions and procedures |
| [Google developer style highlights](https://developers.google.com/style/highlights) | Clear language, descriptive links, accessible presentation and explicit steps |
| [Google SRE release engineering](https://sre.google/sre-book/release-engineering/) | Repeatable artifact/configuration handling and destination acceptance; no new release infrastructure |

The index is named `INDEX.md` inside `docs/`; package READMEs stay with the
code they introduce, consistent with [Google's README guidance](https://google.github.io/styleguide/docguide/READMEs.html).
