# Specification: Habit Item Streak Tracker

## Overview
Implement a comprehensive habit streak tracking and visualization system for Ductiva. This feature will replace the existing `HabitStreakPlaceholderView` with a functional, design-accurate calendar and metrics display that monitors discipline based on each habit's specific schedule.

## Functional Requirements

### 1. Streak Calculation Logic
- **Scheduled-Aware Streaks:** The current streak is calculated by counting consecutive completions on *scheduled days*.
- **Miss Handling:** A streak resets if a scheduled day is missed. Skipping a non-scheduled day (e.g., a Tuesday for a Mon/Wed/Fri habit) does NOT break the streak.
- **Current Day Buffer:** The streak remains active until the end of the current scheduled day (allowing the user time to complete it).

### 2. Metrics Display
- **Current Streak:** Display the count of consecutive scheduled days completed.
- **Perfect Days:** Display the total number of completions for the habit since its creation.
- **Fire Visuals:** Apply a "fire" aesthetic (different color/icon/animation) when a streak reaches:
    - Daily habits: > 5 consecutive days.
    - Non-daily habits: 3 consecutive weeks of perfect scheduled completion (e.g., 9 completions for a 3x/week habit).

### 3. Calendar Visualization
- **Monthly Grid:** A grid-based calendar view matching the "HISTORY_LOG_V2.0" design.
- **Scheduled Day Focus:** Only display dots (empty or filled) for days where the habit is scheduled. Non-scheduled days should be blank.
- **Completion States:**
    - Filled Dot: Habit completed on a scheduled day.
    - Empty/Dimmed Dot: Habit not yet completed on a scheduled day.
- **Current Day Highlight:** Clearly distinguish today's date within the grid.
- **Navigation:** Allow users to navigate between months (Back/Forward arrows).

## Non-Functional Requirements
- **Performance:** Calculations for streaks should be efficient, even with many completions.
- **UI Consistency:** Strictly adhere to the `StealthCeramicTheme` and the provided visual design.
- **Accessibility:** Ensure the calendar grid and metrics are readable by VoiceOver.

## Acceptance Criteria
- [ ] Streak calculation correctly handles daily, weekly, and specific-day schedules.
- [ ] "Perfect Days" correctly reflects total completions.
- [ ] Calendar only shows dots for scheduled days.
- [ ] Fire visuals activate precisely at the defined thresholds.
- [ ] UI matches the provided design inspiration image.

## Out of Scope
- Detailed history log for *all* habits in a single view (this is per-habit).
- Editing habit schedules from the streak view (done in Configuration).
