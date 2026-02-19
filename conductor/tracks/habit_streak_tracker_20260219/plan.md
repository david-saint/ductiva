# Implementation Plan: Habit Item Streak Tracker

## Phase 1: Core Logic & Calculations (TDD)
Focus on the underlying math for streaks and "Perfect Days" based on schedules.

- [ ] Task: Create `HabitStreakServiceTests.swift` and define initial test cases for daily habits.
- [ ] Task: Implement `HabitStreakService` to calculate current streaks and total completions.
- [ ] Task: Add test cases for `weekly` and `specificDays` schedules in `HabitStreakServiceTests`.
- [ ] Task: Update `HabitStreakService` to handle complex schedules and streak resets correctly.
- [ ] Task: Add tests for "Fire Visual" threshold detection (5+ days or 3+ consecutive weeks).
- [ ] Task: Implement threshold detection logic in `HabitStreakService`.
- [ ] Task: Conductor - User Manual Verification 'Phase 1: Core Logic & Calculations' (Protocol in workflow.md)

## Phase 2: Calendar ViewModel & Monthly Grid
Develop the logic for the calendar grid, including date calculations and navigation.

- [ ] Task: Create `HabitCalendarViewModelTests.swift` to verify month navigation and scheduled day identification.
- [ ] Task: Implement `HabitCalendarViewModel` to provide data for the calendar grid (dates, completion status, scheduled status).
- [ ] Task: Add tests for identifying the "current day" and non-scheduled days within the monthly grid.
- [ ] Task: Refine `HabitCalendarViewModel` to support month/year switching.
- [ ] Task: Conductor - User Manual Verification 'Phase 2: Calendar ViewModel & Monthly Grid' (Protocol in workflow.md)

## Phase 3: UI Implementation (Stealth Ceramic Style)
Build the visual components matching the design inspiration.

- [ ] Task: Create `HabitCalendarViewTests.swift` (Snapshot or UI tests if applicable, otherwise functional view tests).
- [ ] Task: Implement `HabitCalendarGridView` showing the days of the week and dots for scheduled days.
- [ ] Task: Implement `HabitMetricsView` to display "Current Streak" and "Perfect Days" with the split-pane design.
- [ ] Task: Integrate "Fire" visuals (color/icon/animation) for streaks meeting thresholds.
- [ ] Task: Replace `HabitStreakPlaceholderView` with the new integrated `HabitStreakDetailView`.
- [ ] Task: Conductor - User Manual Verification 'Phase 3: UI Implementation' (Protocol in workflow.md)

## Phase 4: Integration & Refinement
Ensure the streak tracker updates correctly when habits are completed and follows the theme.

- [ ] Task: Verify real-time updates of the streak view when a habit completion is toggled in the main view.
- [ ] Task: Audit UI against `StealthCeramicTheme` and design inspiration for spacing, tracking (4), and typography.
- [ ] Task: Final pass on accessibility labels for the calendar and metrics.
- [ ] Task: Conductor - User Manual Verification 'Phase 4: Integration & Refinement' (Protocol in workflow.md)
