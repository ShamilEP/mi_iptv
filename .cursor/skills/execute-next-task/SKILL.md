---
name: execute-next-task
description: >-
  Selects the next ready client-scoped task from MiIPTV_Project_Task_Tracker.xlsx,
  implements it on a dedicated git branch, validates, sets In review, and stops for
  human approval. Use when the user invokes /execute-next-task, says "execute next
  task", or explicitly approves a task so it can be marked Done.
disable-model-invocation: true
---

# Execute next task

## Adapter setup
From repo root (PowerShell):

```powershell
$venv = "tool\task_tracker\.venv"
if (-not (Test-Path $venv)) { python -m venv $venv }
& "$venv\Scripts\pip.exe" install -r tool\task_tracker\requirements.txt
$py = "$venv\Scripts\python.exe"
```

CLI:

```powershell
& $py tool\task_tracker\cli.py --workbook task-tracker\MiIPTV_Project_Task_Tracker.xlsx <command>
```

Commands: `list-ready`, `show <ID>`, `claim <ID>`, `set-status <ID> "<Status>" [--note "..."]`, `append-note <ID> "..."`.
Use `--dry-run` on mutating commands when probing.

## Path A — Execute one task (`/execute-next-task`)

### Preconditions
- User explicitly invoked this skill / asked to execute the next task.
- No functional work without reading the Excel task first.
- Obey `.cursor/rules/task-execution.mdc` and the core harness (ask when unclear; no silent pubspec edits; no secrets files).

### Steps
1. `git status` — if tracked files are dirty with unrelated WIP, **stop** and report.
2. `list-ready` — if `selected` is null, report `reason` and heuristic blockers; **stop** (do not mass-edit Product/Backend/Infra).
3. Read full task via `show <ID>` (DoD, deps, refs).
4. If ambiguous / not safely implementable in this repo → `set-status <ID> "Blocked" --note "<reason>"` → report → **stop**.
5. `claim <ID>` → Status `In progress`.
6. `git fetch` if needed; create branch from `main`: `task/<ID>-<short-slug>` (lowercase, hyphens).
7. **Analyze** affected `lib/` / `test/` areas and architecture before edits.
8. Implement the minimum change that satisfies DoD.
9. Validate: `flutter analyze`, `flutter test` (and any DoD-specific checks).
10. Invoke the **verifier** subagent with task ID, DoD, and file list. On fail → fix or `Blocked`.
11. `git add` relevant files only (never the xlsx) → commit with message prefixed by task ID.
12. `set-status <ID> "In review" --note "<compact report: branch, files, tests>"`.
13. Print the completion report (template below) → **STOP**. Do not mark Done. Do not start another task.

### Completion report template
- Task: `<ID>` — `<title>` (`<sheet>`)
- Branch: `task/...`
- Files changed: …
- DoD / behavior summary: …
- Validation: analyze / test results
- Verifier: pass | fail
- Excel: `In review` (Notes updated)
- **Awaiting your approval** to mark Done and continue.

## Path B — Human approval (`approved` / `approve <ID>`)

1. Confirm the task is `In review` (`show <ID>`).
2. `set-status <ID> "Done" --note "Approved by human reviewer."`
3. Remind that the branch can be merged/PR’d; do not force-push; do not auto-start the next task unless the user also asks for `/execute-next-task`.

## Hard rules
- Exactly one task per execution path A.
- Excel labels only (`In review`, not `REVIEW`).
- Never modify `Done` rows.
- Never invent Product/Backend/Infra decisions.
- Preserve Excel formulas and non-editable backlog columns (adapter enforces editable columns).
