#!/usr/bin/env python3
"""CLI for the Mi IPTV Excel task tracker adapter."""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

# Allow `python cli.py` from this directory or via absolute path.
_SYS_DIR = Path(__file__).resolve().parent
if str(_SYS_DIR) not in sys.path:
    sys.path.insert(0, str(_SYS_DIR))

from models import TaskStatus  # noqa: E402
from selection import select_next_task  # noqa: E402
from updates import (  # noqa: E402
    TrackerUpdateError,
    append_note,
    claim_task,
    mark_blocked,
    mark_done,
    mark_in_review,
    set_status,
)
from workbook import (  # noqa: E402
    DEFAULT_WORKBOOK,
    load_tasks,
    open_workbook,
    resolve_workbook_path,
)


def _task_dict(task) -> dict:
    return {
        "id": task.id,
        "sheet": task.sheet,
        "row": task.row,
        "epic": task.epic,
        "title": task.title,
        "status": task.status,
        "owner": task.owner,
        "phase": task.phase,
        "priority": task.priority,
        "depends_on": task.depends_on,
        "details": task.details,
        "refs": task.refs,
        "origin": task.origin,
        "estimate": task.estimate,
        "notes": task.notes,
    }


def cmd_list_ready(args: argparse.Namespace) -> int:
    path = resolve_workbook_path(args.workbook)
    workbook = open_workbook(path, read_only=True)
    try:
        tasks = load_tasks(workbook)
    finally:
        workbook.close()

    result = select_next_task(tasks)
    payload = {
        "workbook": str(path),
        "selected": _task_dict(result.task) if result.task else None,
        "reason": result.reason,
        "ready_count": len(result.ready),
        "ready": [_task_dict(t) for t in result.ready[: args.limit]],
        "heuristic_blockers": [
            {
                **_task_dict(t),
                # Recompute reason via selection helper for visibility.
            }
            for t in result.blockers[: args.limit]
        ],
    }
    if args.json:
        print(json.dumps(payload, indent=2, ensure_ascii=False))
    else:
        print(f"Workbook: {path}")
        print(f"Reason: {result.reason}")
        print(f"Ready ({len(result.ready)}):")
        for task in result.ready[: args.limit]:
            print(
                f"  {task.id:10} | {task.phase:10} | {task.priority:8} | "
                f"{task.sheet:12} | {task.title}"
            )
        if result.blockers:
            print(f"Heuristic blockers ({len(result.blockers)}):")
            for task in result.blockers[: args.limit]:
                print(f"  {task.id:10} | {task.sheet:12} | {task.title}")
    return 0


def cmd_show(args: argparse.Namespace) -> int:
    path = resolve_workbook_path(args.workbook)
    workbook = open_workbook(path, read_only=True)
    try:
        tasks = load_tasks(workbook)
    finally:
        workbook.close()
    task = tasks.get(args.task_id)
    if task is None:
        print(f"Task not found: {args.task_id}", file=sys.stderr)
        return 1
    print(json.dumps(_task_dict(task), indent=2, ensure_ascii=False))
    return 0


def _save(workbook, path: Path, *, dry_run: bool) -> None:
    if dry_run:
        print(f"DRY-RUN: not writing {path}")
        return
    workbook.save(path)
    print(f"Saved: {path}")


def cmd_claim(args: argparse.Namespace) -> int:
    path = resolve_workbook_path(args.workbook)
    workbook = open_workbook(path)
    try:
        claim_task(workbook, args.task_id, owner=args.owner)
        _save(workbook, path, dry_run=args.dry_run)
    except TrackerUpdateError as exc:
        print(f"Error: {exc}", file=sys.stderr)
        return 1
    finally:
        workbook.close()
    return 0


def cmd_set_status(args: argparse.Namespace) -> int:
    path = resolve_workbook_path(args.workbook)
    workbook = open_workbook(path)
    try:
        if args.status == TaskStatus.IN_REVIEW.value:
            mark_in_review(
                workbook,
                args.task_id,
                report=args.note or "Implementation complete; awaiting approval.",
                owner=args.owner,
            )
        elif args.status == TaskStatus.BLOCKED.value:
            mark_blocked(
                workbook,
                args.task_id,
                reason=args.note or "No reason provided",
                owner=args.owner,
            )
        elif args.status == TaskStatus.DONE.value:
            mark_done(
                workbook,
                args.task_id,
                note=args.note or "Approved by human reviewer.",
            )
        else:
            set_status(
                workbook,
                args.task_id,
                args.status,
                owner=args.owner,
                note=args.note,
            )
        _save(workbook, path, dry_run=args.dry_run)
    except TrackerUpdateError as exc:
        print(f"Error: {exc}", file=sys.stderr)
        return 1
    finally:
        workbook.close()
    return 0


def cmd_append_note(args: argparse.Namespace) -> int:
    path = resolve_workbook_path(args.workbook)
    workbook = open_workbook(path)
    try:
        append_note(workbook, args.task_id, args.note)
        _save(workbook, path, dry_run=args.dry_run)
    except TrackerUpdateError as exc:
        print(f"Error: {exc}", file=sys.stderr)
        return 1
    finally:
        workbook.close()
    return 0


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Mi IPTV Excel task tracker adapter (OpenPyXL)",
    )
    parser.add_argument(
        "--workbook",
        default=str(DEFAULT_WORKBOOK),
        help=f"Path to xlsx (default: {DEFAULT_WORKBOOK})",
    )
    sub = parser.add_subparsers(dest="command", required=True)

    list_ready = sub.add_parser(
        "list-ready",
        help="List ready in-scope tasks and the selected next task (read-only)",
    )
    list_ready.add_argument("--json", action="store_true")
    list_ready.add_argument("--limit", type=int, default=25)
    list_ready.set_defaults(func=cmd_list_ready)

    show = sub.add_parser("show", help="Show one task as JSON (read-only)")
    show.add_argument("task_id")
    show.set_defaults(func=cmd_show)

    claim = sub.add_parser("claim", help="Set task to In progress")
    claim.add_argument("task_id")
    claim.add_argument("--owner", default="Cursor Agent")
    claim.add_argument("--dry-run", action="store_true")
    claim.set_defaults(func=cmd_claim)

    set_status_cmd = sub.add_parser(
        "set-status",
        help="Update status (In review / Blocked / Done / …)",
    )
    set_status_cmd.add_argument("task_id")
    set_status_cmd.add_argument(
        "status",
        choices=[s.value for s in TaskStatus],
    )
    set_status_cmd.add_argument("--note", default=None)
    set_status_cmd.add_argument("--owner", default=None)
    set_status_cmd.add_argument("--dry-run", action="store_true")
    set_status_cmd.set_defaults(func=cmd_set_status)

    note_cmd = sub.add_parser("append-note", help="Append a stamped Notes entry")
    note_cmd.add_argument("task_id")
    note_cmd.add_argument("note")
    note_cmd.add_argument("--dry-run", action="store_true")
    note_cmd.set_defaults(func=cmd_append_note)

    return parser


def main(argv: list[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    return args.func(args)


if __name__ == "__main__":
    raise SystemExit(main())
