"""OpenPyXL workbook IO that preserves formulas and sheet structure."""

from __future__ import annotations

from pathlib import Path

from openpyxl import Workbook, load_workbook
from openpyxl.worksheet.worksheet import Worksheet

from models import (
    COL_DEPENDS,
    COL_DETAILS,
    COL_EPIC,
    COL_EST,
    COL_ID,
    COL_NOTES,
    COL_ORIGIN,
    COL_OWNER,
    COL_PHASE,
    COL_PRIORITY,
    COL_REFS,
    COL_STATUS,
    COL_TASK,
    DATA_START_ROW,
    HEADER_ROW,
    WORKSTREAM_SHEETS,
    Task,
)

REPO_ROOT = Path(__file__).resolve().parents[2]
DEFAULT_WORKBOOK = REPO_ROOT / "task-tracker" / "MiIPTV_Project_Task_Tracker.xlsx"


def resolve_workbook_path(path: str | Path | None = None) -> Path:
    resolved = Path(path) if path else DEFAULT_WORKBOOK
    if not resolved.is_file():
        raise FileNotFoundError(f"Task tracker workbook not found: {resolved}")
    return resolved


def open_workbook(path: str | Path | None = None, *, read_only: bool = False) -> Workbook:
    """Load workbook with data_only=False so formulas are preserved on save."""
    workbook_path = resolve_workbook_path(path)
    return load_workbook(workbook_path, data_only=False, read_only=read_only)


def save_workbook(workbook: Workbook, path: str | Path) -> Path:
    """Persist workbook to path without converting formulas to cached values."""
    target = Path(path)
    workbook.save(target)
    return target


def _cell_str(sheet: Worksheet, column: str, row: int) -> str:
    value = sheet[f"{column}{row}"].value
    if value is None:
        return ""
    return str(value).strip()


def iter_workstream_sheets(workbook: Workbook) -> list[Worksheet]:
    sheets: list[Worksheet] = []
    for name in workbook.sheetnames:
        if name in WORKSTREAM_SHEETS:
            sheets.append(workbook[name])
    return sheets


def load_tasks(workbook: Workbook) -> dict[str, Task]:
    """Index all workstream tasks by ID."""
    tasks: dict[str, Task] = {}
    for sheet in iter_workstream_sheets(workbook):
        # Validate header row lightly.
        header_id = _cell_str(sheet, COL_ID, HEADER_ROW)
        if header_id != "ID":
            raise ValueError(
                f"Unexpected header on sheet '{sheet.title}' row {HEADER_ROW}: "
                f"expected ID, found {header_id!r}"
            )
        max_row = sheet.max_row or DATA_START_ROW
        for row in range(DATA_START_ROW, max_row + 1):
            task_id = _cell_str(sheet, COL_ID, row)
            if not task_id:
                continue
            task = Task(
                id=task_id,
                sheet=sheet.title,
                row=row,
                epic=_cell_str(sheet, COL_EPIC, row),
                title=_cell_str(sheet, COL_TASK, row),
                status=_cell_str(sheet, COL_STATUS, row),
                owner=_cell_str(sheet, COL_OWNER, row),
                phase=_cell_str(sheet, COL_PHASE, row),
                priority=_cell_str(sheet, COL_PRIORITY, row),
                details=_cell_str(sheet, COL_DETAILS, row),
                refs=_cell_str(sheet, COL_REFS, row),
                depends_on=_cell_str(sheet, COL_DEPENDS, row),
                origin=_cell_str(sheet, COL_ORIGIN, row),
                estimate=_cell_str(sheet, COL_EST, row),
                notes=_cell_str(sheet, COL_NOTES, row),
            )
            if task_id in tasks:
                raise ValueError(
                    f"Duplicate task ID {task_id!r} on sheets "
                    f"{tasks[task_id].sheet} and {sheet.title}"
                )
            tasks[task_id] = task
    return tasks


def find_task_row(workbook: Workbook, task_id: str) -> tuple[Worksheet, int]:
    for sheet in iter_workstream_sheets(workbook):
        max_row = sheet.max_row or DATA_START_ROW
        for row in range(DATA_START_ROW, max_row + 1):
            if _cell_str(sheet, COL_ID, row) == task_id:
                return sheet, row
    raise KeyError(f"Task not found: {task_id}")
