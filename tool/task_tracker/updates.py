"""Safe status / notes updates that never mutate Done rows or backlog columns."""

from __future__ import annotations

from datetime import datetime, timezone

from openpyxl import Workbook

from models import COL_NOTES, COL_OWNER, COL_STATUS, TaskStatus
from workbook import find_task_row, load_tasks

ALLOWED_STATUSES: frozenset[str] = frozenset(status.value for status in TaskStatus)


class TrackerUpdateError(Exception):
    """Raised when an update would violate tracker safety rules."""


def _utc_stamp() -> str:
    return datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M UTC")


def append_notes_text(existing: str, addition: str) -> str:
    addition = addition.strip()
    if not addition:
        return existing
    if not existing.strip():
        return addition
    return f"{existing.rstrip()}\n{addition}"


def set_status(
    workbook: Workbook,
    task_id: str,
    new_status: str,
    *,
    owner: str | None = None,
    note: str | None = None,
    allow_done_overwrite: bool = False,
) -> None:
    """Update Status (and optionally Owner / Notes) for one task.

    Never modifies a row that is already Done unless allow_done_overwrite is True
    (reserved for emergency recovery — CLI defaults to False).
    """
    if new_status not in ALLOWED_STATUSES:
        raise TrackerUpdateError(
            f"Invalid status {new_status!r}. Allowed: {sorted(ALLOWED_STATUSES)}"
        )

    tasks = load_tasks(workbook)
    task = tasks.get(task_id)
    if task is None:
        raise TrackerUpdateError(f"Task not found: {task_id}")

    if task.status == TaskStatus.DONE.value and not allow_done_overwrite:
        raise TrackerUpdateError(
            f"Refusing to modify {task_id}: status is already Done"
        )

    sheet, row = find_task_row(workbook, task_id)
    sheet[f"{COL_STATUS}{row}"] = new_status

    if owner is not None:
        sheet[f"{COL_OWNER}{row}"] = owner

    if note:
        stamped = f"[{_utc_stamp()}] {note.strip()}"
        current = sheet[f"{COL_NOTES}{row}"].value
        current_text = "" if current is None else str(current)
        sheet[f"{COL_NOTES}{row}"] = append_notes_text(current_text, stamped)


def claim_task(
    workbook: Workbook,
    task_id: str,
    *,
    owner: str = "Cursor Agent",
) -> None:
    """Mark Not started → In progress with a claim note."""
    tasks = load_tasks(workbook)
    task = tasks.get(task_id)
    if task is None:
        raise TrackerUpdateError(f"Task not found: {task_id}")
    if task.status != TaskStatus.NOT_STARTED.value:
        raise TrackerUpdateError(
            f"Cannot claim {task_id}: status is {task.status!r}, expected Not started"
        )
    set_status(
        workbook,
        task_id,
        TaskStatus.IN_PROGRESS.value,
        owner=owner,
        note="Claimed for autonomous execution.",
    )


def mark_in_review(
    workbook: Workbook,
    task_id: str,
    *,
    report: str,
    owner: str | None = None,
) -> None:
    """In progress → In review after implementation + validation."""
    tasks = load_tasks(workbook)
    task = tasks.get(task_id)
    if task is None:
        raise TrackerUpdateError(f"Task not found: {task_id}")
    if task.status not in {
        TaskStatus.IN_PROGRESS.value,
        TaskStatus.NOT_STARTED.value,
    }:
        raise TrackerUpdateError(
            f"Cannot mark {task_id} In review from status {task.status!r}"
        )
    set_status(
        workbook,
        task_id,
        TaskStatus.IN_REVIEW.value,
        owner=owner,
        note=report,
    )


def mark_blocked(
    workbook: Workbook,
    task_id: str,
    *,
    reason: str,
    owner: str | None = None,
) -> None:
    set_status(
        workbook,
        task_id,
        TaskStatus.BLOCKED.value,
        owner=owner,
        note=f"BLOCKED: {reason}",
    )


def mark_done(
    workbook: Workbook,
    task_id: str,
    *,
    note: str = "Approved by human reviewer.",
) -> None:
    """Only from In review after explicit human approval."""
    tasks = load_tasks(workbook)
    task = tasks.get(task_id)
    if task is None:
        raise TrackerUpdateError(f"Task not found: {task_id}")
    if task.status != TaskStatus.IN_REVIEW.value:
        raise TrackerUpdateError(
            f"Cannot mark {task_id} Done: status is {task.status!r}, "
            "expected In review (human approval required)"
        )
    # Done rows become immutable afterward; this transition is the last write.
    sheet, row = find_task_row(workbook, task_id)
    sheet[f"{COL_STATUS}{row}"] = TaskStatus.DONE.value
    stamped = f"[{_utc_stamp()}] {note.strip()}"
    current = sheet[f"{COL_NOTES}{row}"].value
    current_text = "" if current is None else str(current)
    sheet[f"{COL_NOTES}{row}"] = append_notes_text(current_text, stamped)


def append_note(workbook: Workbook, task_id: str, note: str) -> None:
    tasks = load_tasks(workbook)
    task = tasks.get(task_id)
    if task is None:
        raise TrackerUpdateError(f"Task not found: {task_id}")
    if task.status == TaskStatus.DONE.value:
        raise TrackerUpdateError(
            f"Refusing to modify notes on Done task {task_id}"
        )
    sheet, row = find_task_row(workbook, task_id)
    stamped = f"[{_utc_stamp()}] {note.strip()}"
    current = sheet[f"{COL_NOTES}{row}"].value
    current_text = "" if current is None else str(current)
    sheet[f"{COL_NOTES}{row}"] = append_notes_text(current_text, stamped)
