"""Domain models for the Mi IPTV Excel task tracker."""

from __future__ import annotations

from dataclasses import dataclass
from enum import Enum


class TaskStatus(str, Enum):
    """Exact Excel dropdown labels — never use SCREAMING_SNAKE tokens in cells."""

    NOT_STARTED = "Not started"
    IN_PROGRESS = "In progress"
    IN_REVIEW = "In review"
    BLOCKED = "Blocked"
    DONE = "Done"


class Priority(str, Enum):
    CRITICAL = "Critical"
    HIGH = "High"
    MEDIUM = "Medium"
    LOW = "Low"


class Phase(str, Enum):
    SPRINT_0 = "Sprint 0"
    MVP = "MVP"
    RELEASE_1 = "Release 1"
    RELEASE_2 = "Release 2"


# Sheets the autonomous executor may select from (Option A).
IN_SCOPE_SHEETS: frozenset[str] = frozenset(
    {
        "Android TV",
        "Companion",
        "Design",
        "QA",
        "Security",
    }
)

# Sheets never auto-selected for this Flutter-only repo.
OUT_OF_SCOPE_SHEETS: frozenset[str] = frozenset(
    {
        "Product",
        "Backend",
        "Infra",
    }
)

WORKSTREAM_SHEETS: frozenset[str] = IN_SCOPE_SHEETS | OUT_OF_SCOPE_SHEETS

HEADER_ROW = 4
DATA_START_ROW = 5

# Column letters matching the tracker schema (row 4 headers).
COL_ID = "A"
COL_EPIC = "B"
COL_TASK = "C"
COL_STATUS = "D"
COL_OWNER = "E"
COL_PHASE = "F"
COL_PRIORITY = "G"
COL_DETAILS = "H"
COL_REFS = "I"
COL_DEPENDS = "J"
COL_ORIGIN = "K"
COL_EST = "L"
COL_NOTES = "M"

EDITABLE_COLUMNS: frozenset[str] = frozenset(
    {COL_STATUS, COL_OWNER, COL_EST, COL_NOTES}
)

PHASE_RANK: dict[str, int] = {
    Phase.SPRINT_0.value: 0,
    Phase.MVP.value: 1,
    Phase.RELEASE_1.value: 2,
    Phase.RELEASE_2.value: 3,
}

PRIORITY_RANK: dict[str, int] = {
    Priority.CRITICAL.value: 0,
    Priority.HIGH.value: 1,
    Priority.MEDIUM.value: 2,
    Priority.LOW.value: 3,
}

# Heuristic keywords that usually mean the work is not implementable in this repo.
NON_CLIENT_KEYWORDS: tuple[str, ...] = (
    "figma",
    "cloud provider",
    "managed database",
    "postgresql",
    "endpoint list",
    "jwt signing",
    "decide tv ui toolkit",
    "decide companion",
    "select cloud",
    "close the proprietary catalog api contract",
    "realtime transport",
    "write user stories",
)


@dataclass(frozen=True)
class Task:
    """One backlog row from a workstream sheet."""

    id: str
    sheet: str
    row: int
    epic: str
    title: str
    status: str
    owner: str
    phase: str
    priority: str
    details: str
    refs: str
    depends_on: str
    origin: str
    estimate: str
    notes: str

    @property
    def dependency_ids(self) -> list[str]:
        if not self.depends_on.strip():
            return []
        return [part.strip() for part in self.depends_on.split(",") if part.strip()]


@dataclass(frozen=True)
class SelectionResult:
    """Outcome of next-task selection."""

    task: Task | None
    reason: str
    ready: tuple[Task, ...]
    blockers: tuple[Task, ...]
