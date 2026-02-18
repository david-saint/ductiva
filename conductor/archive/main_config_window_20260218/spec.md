# Track Specification: Develop Main Window (Configurations)

## Overview
This track focuses on implementing the "Main Window - Configuration" as the primary application entry point for Ductiva. Following the "cockpit instrument" philosophy, this standalone window will serve as the hub for habit management and navigation to other system modules (Widgets, Habit Item Streak).

## Functional Requirements
- **Standalone Configuration Window:** Implement the main application window as the entry point (no separate "tracking" window).
- **Habit List Management:**
    - Display a scrollable list of all habits stored in SwiftData.
    - Show high-level status for each habit (name, current streak).
- **Add/Edit Interface:**
    - Provide a seamless UI (Sheet or Modal) to create new habits and modify existing ones.
    - Support configuration of habit name and frequency (Daily, Weekly, Specific Days).
- **Navigation Hub:**
    - **Contextual Navigation:** Buttons within habit list items to navigate to the "Habit Item Streak" view for that specific habit.
    - **Global Navigation:** Toolbar or Menu items to access the "Widgets" view and "Global Settings".
- **Global Settings:** A dedicated section or view for system-wide preferences (Appearance, Notifications).

## Non-Functional Requirements
- **Visual Aesthetic:** Strictly adhere to "Stealth Ceramic" (#1C1C1E) for the chassis and "Liquid Glass" (translucency/depth) for overlays and interactive elements.
- **macOS Native feel:** Utilize SwiftUI's `NavigationSplitView` or similar patterns that feel native to macOS 14.0+.
- **Stoic Tone:** Use minimal, direct language for all UI labels and instructions.

## Acceptance Criteria
- [ ] The application launches directly into the Configuration window.
- [ ] Existing habits are fetched from SwiftData and displayed in a list.
- [ ] Users can trigger an "Add Habit" workflow.
- [ ] Navigation to "Habit Item Streak" and "Widgets" is functional (can be placeholders if those tracks are not yet implemented).
- [ ] The UI matches the "Main Window - Configuration.png" design inspiration.

## Out of Scope
- Full implementation of the "Widgets" module (Navigation/Placeholder only).
- Full implementation of the "Habit Item Streak" detail view (Navigation/Placeholder only).
