# Project documentation

Start with the question you need to answer. These documents are maintained
with the code; the person changing the relevant behavior also updates its
owning document. The project owner settles product direction. Historical
results describe the revision and environment that were actually checked.

## Find the right document

| Your question | Primary document | What belongs there |
|---|---|---|
| What is this app, and where do I start? | [Project README](../README.md) | Product overview, screenshots and a short development entry point |
| How do we make engineering decisions and review changes? | [Engineering](ENGINEERING.md) | Principles, change workflow, review criteria and documentation rules |
| How is the code structured today? | [Architecture](ARCHITECTURE.md) | Layer boundaries, data owners, shared actions and explicit adaptations of Flutter guidance |
| Why was a product choice made? | [Decisions](DECISIONS.md) | Dated choices, reasons, consequences and unresolved product questions |
| How do I set up, build, debug or reach a device? | [Setup](SETUP.md) | Toolchain, local configuration, signing, development recipes and external asset locations |
| Which tests must I run, and what counts as a pass? | [Testing](TESTING.md) | Change matrix, regression/release gates, test fixtures and evidence rules |
| How does sync work, and what has been verified? | [Sync networking](SYNC_NETWORK.md) | Protocol design, current capability, dated acceptance evidence and network limits |
| How do I configure or deploy the Go service? | [Server README](../server/README.md) | Server commands, policy variables, wire/API reference and deployment procedure |
| How is Google Drive configured? | [Google Drive](GOOGLE_DRIVE.md) | Provider-specific OAuth and setup |
| How do I import a One Diary backup safely? | [One Diary import](ONE_DIARY_IMPORT.md) | Backup compatibility, independent diary dates, timezone evidence and verification |
| Why is a Xiaomi build stuck at 60 Hz, or Windows scrolling slow? | [Refresh rate and scrolling](REFRESH_RATE.md) | OEM diagnosis, isolated profile procedures and measured Windows limits |
| What is still proposed or deferred? | [TODO](../TODO.md) | Remaining ideas and work; not an implementation or approval claim |
| What is upstream, and which license applies? | [Source](../SOURCE.md), [license](../LICENSE.txt), [additional terms](../ADDITIONAL_TERMS.md) | Provenance and legal terms |
| What must an assistant read and obey first? | [AGENTS.md](../AGENTS.md) | Execution entry point and essential guardrails; detailed policy lives in the documents above |

## Suggested first pass

1. Read the project README and product decisions for purpose and scope.
2. Read Engineering and Architecture before a substantial code change.
3. Use Setup for the local environment and Testing for validation selection.
4. Open the relevant subsystem reference only when the task needs its details.

Do not turn this index into another specification. Link to the owning section
instead of repeating tool versions, server quotas, test counts or procedures.
Code/configuration defines actual behavior; documentation defines intended
contracts and explains it. A disagreement is a defect to investigate, not
permission to silently change an approved requirement.
