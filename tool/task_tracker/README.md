# Excel task tracker adapter

Python (OpenPyXL) CLI used by the Cursor skill `/execute-next-task` to read and safely update [`task-tracker/MiIPTV_Project_Task_Tracker.xlsx`](../../task-tracker/MiIPTV_Project_Task_Tracker.xlsx).

The workbook is **gitignored**. This adapter preserves formulas (`data_only=False`) and only writes Status / Owner / Est. / Notes.

## Setup

```powershell
cd C:\Projects\mi_iptv
python -m venv tool\task_tracker\.venv
tool\task_tracker\.venv\Scripts\pip.exe install -r tool\task_tracker\requirements.txt
```

## Commands

```powershell
$py = "tool\task_tracker\.venv\Scripts\python.exe"
$wb = "task-tracker\MiIPTV_Project_Task_Tracker.xlsx"

& $py tool\task_tracker\cli.py --workbook $wb list-ready
& $py tool\task_tracker\cli.py --workbook $wb list-ready --json
& $py tool\task_tracker\cli.py --workbook $wb show DSN-006
& $py tool\task_tracker\cli.py --workbook $wb claim DSN-006 --dry-run
& $py tool\task_tracker\cli.py --workbook $wb set-status DSN-006 "In review" --note "…" --dry-run
```

## Status labels

Use exact Excel values: `Not started`, `In progress`, `In review`, `Blocked`, `Done`.

## Safety

- Refuses to modify rows already `Done`
- `Done` is only allowed from `In review` (human approval path)
- Selection is limited to Android TV, Companion, Design, QA, Security with a client-implementable heuristic
