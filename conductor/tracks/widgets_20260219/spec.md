# Specification: macOS Widget Extension (widgets_20260219)

## Overview
Implement a comprehensive suite of macOS widgets for Ductiva, providing users with a "cockpit instrument" view of their habits directly on their desktop or Notification Center. The widgets will mirror the app's "Stealth Ceramic" aesthetic with translucent "liquid glass" backgrounds and provide deep-linking functionality.

## Functional Requirements

### 1. Supported Widget Sizes & Types
- **Small (2x2):**
    - **Standard:** A 2x2 grid displaying status/completion for up to 4 habits.
    - **Focus:** Displays a single habit with its completion ring and name. Focus habit is configurable via the widget's "Edit" menu.
- **Medium (4x2):** A summary view showing multiple habits (up to 4) with their current streaks and completion rings.
- **Large (4x4):** A detailed overview showing the weekly/monthly streak grid for a focused habit or a summary of all habits.

### 2. Configuration & Data
- **Habit Selection (Focus Widget):** Users can select which habit to display in the Focus small widget using standard macOS widget configuration (App Intent).
- **Data Persistence:** Use a shared App Group to allow the Widget Extension to access the primary SwiftData container.
- **Real-time Updates:** Widgets should refresh periodically and when the main app data changes (via `WidgetCenter`).

### 3. Interaction
- **Deep Linking:** Tapping/clicking a habit within any widget will open Ductiva and navigate directly to the `HabitStreakDetailView` for that specific habit.

## Non-Functional Requirements
- **Visual Aesthetic:** 
    - Reuse `StealthCeramicTheme` for colors and typography.
    - Use `HabitCompletionRingView` and other existing UI components for consistency.
    - Implement a translucent "liquid glass" background effect matching `ConfigurationView`.
- **Performance:** Ensure widget timelines are optimized to minimize battery and system resource usage.
- **Platform:** Target macOS 14.0+ using the latest WidgetKit APIs.

## Acceptance Criteria
- [ ] Widget extension is correctly configured with an App Group.
- [ ] All three widget sizes (Small, Medium, Large) are implemented and selectable.
- [ ] Focus small widget supports habit selection via the "Edit" menu.
- [ ] Widgets accurately reflect habit data from the SwiftData store.
- [ ] Clicking a habit in the widget opens the app to the correct detail view.
- [ ] The UI matches the "Stealth Ceramic" and "Liquid Glass" design requirements.

## Out of Scope
- Interactive toggling of habit completion directly from the widget (deferred to a future track).
- Legacy widget support (pre-macOS 14).
