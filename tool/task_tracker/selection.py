"""Select the next executable client-scoped task."""

from __future__ import annotations

from models import (
    IN_SCOPE_SHEETS,
    NON_CLIENT_KEYWORDS,
    PHASE_RANK,
    PRIORITY_RANK,
    SelectionResult,
    Task,
    TaskStatus,
)


def dependencies_satisfied(
    task: Task, tasks_by_id: dict[str, Task]
) -> tuple[bool, list[str]]:
    """Return whether all Depends-on IDs exist and are Done."""
    problems: list[str] = []
    for dep_id in task.dependency_ids:
        dep = tasks_by_id.get(dep_id)
        if dep is None:
            problems.append(f"{dep_id} (missing)")
            continue
        if dep.status != TaskStatus.DONE.value:
            problems.append(f"{dep_id} ({dep.status})")
    return len(problems) == 0, problems


def looks_client_implementable(task: Task) -> tuple[bool, str]:
    """Heuristic: reject obvious non-repo / human-decision work in scoped sheets."""
    haystack = f"{task.title}\n{task.details}".lower()
    for keyword in NON_CLIENT_KEYWORDS:
        if keyword in haystack:
            return False, f"Non-client / decision keyword matched: {keyword!r}"

    # Figma library / handoff tasks are design-tool work, not Flutter code.
    if "figma" in haystack and "handoff" in haystack:
        return False, "Figma library / handoff is outside this Flutter repo"

    if task.sheet == "Design" and haystack.startswith("set up the figma"):
        return False, "Figma setup is outside this Flutter repo"

    return True, "ok"


def active_claim(tasks_by_id: dict[str, Task]) -> Task | None:
    """Return the first In progress or In review task, if any."""
    for status in (TaskStatus.IN_PROGRESS.value, TaskStatus.IN_REVIEW.value):
        for task in tasks_by_id.values():
            if task.status == status:
                return task
    return None


def sort_key(task: Task) -> tuple[int, int, str]:
    return (
        PHASE_RANK.get(task.phase, 99),
        PRIORITY_RANK.get(task.priority, 99),
        task.id,
    )


def list_ready_tasks(tasks_by_id: dict[str, Task]) -> list[Task]:
    """In-scope Not started tasks with Done dependencies and client heuristic pass."""
    ready: list[Task] = []
    for task in tasks_by_id.values():
        if task.sheet not in IN_SCOPE_SHEETS:
            continue
        if task.status != TaskStatus.NOT_STARTED.value:
            continue
        ok, _ = dependencies_satisfied(task, tasks_by_id)
        if not ok:
            continue
        implementable, _ = looks_client_implementable(task)
        if not implementable:
            continue
        ready.append(task)
    ready.sort(key=sort_key)
    return ready


def list_heuristic_blockers(tasks_by_id: dict[str, Task]) -> list[Task]:
    """In-scope Not started + deps Done, but failed client-implementable heuristic."""
    blocked: list[Task] = []
    for task in tasks_by_id.values():
        if task.sheet not in IN_SCOPE_SHEETS:
            continue
        if task.status != TaskStatus.NOT_STARTED.value:
            continue
        ok, _ = dependencies_satisfied(task, tasks_by_id)
        if not ok:
            continue
        implementable, _ = looks_client_implementable(task)
        if not implementable:
            blocked.append(task)
    blocked.sort(key=sort_key)
    return blocked


def select_next_task(tasks_by_id: dict[str, Task]) -> SelectionResult:
    """Pick exactly one next task, or explain why none can start."""
    claim = active_claim(tasks_by_id)
    ready = tuple(list_ready_tasks(tasks_by_id))
    blockers = tuple(list_heuristic_blockers(tasks_by_id))

    if claim is not None:
        return SelectionResult(
            task=None,
            reason=(
                f"Cannot start a new task while {claim.id} is '{claim.status}'. "
                "Finish review/approval or unblock first."
            ),
            ready=ready,
            blockers=blockers,
        )

    if not ready:
        return SelectionResult(
            task=None,
            reason=(
                "No ready in-scope client-implementable tasks. "
                "Check dependencies, Product decisions, or heuristic blockers."
            ),
            ready=ready,
            blockers=blockers,
        )

    chosen = ready[0]
    return SelectionResult(
        task=chosen,
        reason=f"Selected {chosen.id} ({chosen.phase} / {chosen.priority})",
        ready=ready,
        blockers=blockers,
    )
