# Implementation Plan: Develop Main Window (Configurations)

## Phase 1: Main Window & Navigation Architecture
- [ ] Task: Configure the application entry point to launch the Configuration window directly.
- [ ] Task: Implement the basic `ConfigurationView` with a macOS-native `NavigationSplitView` structure.
- [ ] Task: Add placeholder views for "Widgets" and "Habit Item Streak" detail screens.
- [ ] Task: Implement global navigation using macOS Toolbar and App Menu items.
- [ ] Task: Write unit tests to verify navigation logic and window state management.
- [ ] Task: Conductor - User Manual Verification 'Main Window & Navigation Architecture' (Protocol in workflow.md)

## Phase 2: Habit List Display & Styling
- [ ] Task: Update `ConfigurationView` to fetch and display the list of `Habit` objects from SwiftData.
- [ ] Task: Apply "Stealth Ceramic" (#1C1C1E) chassis styling to the main window and list background.
- [ ] Task: Implement "Liquid Glass" styling for habit list items (translucency, depth, and subtle hover effects).
- [ ] Task: Write unit tests to verify the habit list rendering and empty state handling.
- [ ] Task: Conductor - User Manual Verification 'Habit List Display & Styling' (Protocol in workflow.md)

## Phase 3: Add/Edit Habit Workflow
- [ ] Task: Create a "Liquid Glass" modal sheet for adding a new habit.
- [ ] Task: Implement the form for habit name and frequency selection (Daily, Weekly, Specific Days).
- [ ] Task: Integrate with `HabitStore` to persist new habits and update existing ones.
- [ ] Task: Add contextual navigation buttons within habit list items to link to the detail views.
- [ ] Task: Write unit tests for form validation and habit persistence via the UI.
- [ ] Task: Conductor - User Manual Verification 'Add/Edit Habit Workflow' (Protocol in workflow.md)

## Phase 4: Global Settings & Final Refinement
- [ ] Task: Implement a basic "Global Settings" view for system-wide preferences (Appearance, Notifications).
- [ ] Task: Refine animations and fluid transitions between views to match the project's "Calm & Stoic" tone.
- [ ] Task: Conduct a final visual audit against "Main Window - Configuration.png".
- [ ] Task: Verify overall code coverage for new modules meets the >80% target.
- [ ] Task: Conductor - User Manual Verification 'Global Settings & Final Refinement' (Protocol in workflow.md)
