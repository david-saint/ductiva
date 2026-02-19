# Implementation Plan: Habit Item Streak Tracker

## Phase 1: Core Logic & Calculations (TDD) [checkpoint: 592f22e]
Focus on the underlying math for streaks and "Perfect Days" based on schedules.

- [x] Task: Create `HabitStreakServiceTests.swift` and define initial test cases for daily habits. [dc80e91]
- [x] Task: Implement `HabitStreakService` to calculate current streaks and total completions. [dc80e91]
- [x] Task: Add test cases for `weekly` and `specificDays` schedules in `HabitStreakServiceTests`. [dc80e91]
- [x] Task: Update `HabitStreakService` to handle complex schedules and streak resets correctly. [dc80e91]
- [x] Task: Add tests for "Fire Visual" threshold detection (5+ days or 3+ consecutive weeks). [dc80e91]
- [x] Task: Implement threshold detection logic in `HabitStreakService`. [dc80e91]
- [x] Task: Conductor - User Manual Verification 'Phase 1: Core Logic & Calculations' (Protocol in workflow.md). [592f22e]

## Phase 2: Calendar ViewModel & Monthly Grid [checkpoint: 1334774]
Develop the logic for the calendar grid, including date calculations and navigation.

- [x] Task: Create `HabitCalendarViewModelTests.swift` to verify month navigation and scheduled day identification. [dc80e91]
- [x] Task: Implement `HabitCalendarViewModel` to provide data for the calendar grid (dates, completion status, scheduled status). [dc80e91]
- [x] Task: Add tests for identifying the "current day" and non-scheduled days within the monthly grid. [dc80e91]
- [x] Task: Refine `HabitCalendarViewModel` to support month/year switching. [dc80e91]
- [x] Task: Conductor - User Manual Verification 'Phase 2: Calendar ViewModel & Monthly Grid' (Protocol in workflow.md). [1334774]

## Phase 3: UI Implementation (Stealth Ceramic Style) [checkpoint: cb8608e]
Build the visual components matching the design inspiration.

- [x] Task: Create `HabitCalendarViewTests.swift` (Snapshot or UI tests if applicable, otherwise functional view tests). [b8a668e]
- [x] Task: Implement `HabitCalendarGridView` showing the days of the week and dots for scheduled days. [c84be58]
- [x] Task: Implement `HabitMetricsView` to display "Current Streak" and "Perfect Days" with the split-pane design. [c84be58]
- [x] Task: Integrate "Fire" visuals (color/icon/animation) for streaks meeting thresholds. [c84be58]
- [x] Task: Replace `HabitStreakPlaceholderView` with the new integrated `HabitStreakDetailView`. [c84be58]
- [x] Task: Conductor - User Manual Verification 'Phase 3: UI Implementation' (Protocol in workflow.md). [cb8608e]

## Phase 4: Integration & Refinement
Ensure the streak tracker updates correctly when habits are completed and follows the theme.

- [~] Task: Verify real-time updates of the streak view when a habit completion is toggled in the main view.
- [ ] Task: Audit UI against `StealthCeramicTheme` and design inspiration for spacing, tracking (4), and typography.
- [ ] Task: Final pass on accessibility labels for the calendar and metrics.
- [ ] Task: Conductor - User Manual Verification 'Phase 4: Integration & Refinement' (Protocol in workflow.md)
