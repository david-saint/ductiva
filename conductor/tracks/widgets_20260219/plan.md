# Implementation Plan: macOS Widget Extension (widgets_20260219)

## Phase 1: Infrastructure and Data Sharing
- [ ] Task: Create Widget Extension Target
    - [ ] Create a new "Widget Extension" target in the Xcode project named `ductivaWidgets`.
    - [ ] Configure the `Bundle Identifier` and `Target Membership`.
- [ ] Task: Configure App Groups for Shared Persistence
    - [ ] Add the `App Groups` capability to both the `ductiva` and `ductivaWidgets` targets.
    - [ ] Define a shared App Group ID (e.g., `group.com.saint.ductiva`).
    - [ ] Update `HabitStore` or the SwiftData container initialization to use the shared App Group URL.
- [ ] Task: Verify Shared Data Access
    - [ ] Write a test/utility to confirm the widget target can read data from the shared SwiftData container.
- [ ] Task: Conductor - User Manual Verification 'Phase 1: Infrastructure and Data Sharing' (Protocol in workflow.md)

## Phase 2: Core Widget Logic and Theming
- [ ] Task: Implement Widget Configuration Intent
    - [ ] Create `HabitSelectionIntent` (AppIntent) to allow users to select a habit for the Focus widget.
    - [ ] Implement a query to provide the list of available habits to the intent.
- [ ] Task: Develop HabitTimelineProvider
    - [ ] Implement `TimelineProvider` to fetch habit data and generate snapshots/entries.
    - [ ] Ensure the provider correctly handles "No Habits" or "Empty" states.
- [ ] Task: Create Shared Widget UI Components
    - [ ] Implement a "Liquid Glass" translucent background modifier/view for widgets.
    - [ ] Adapt `HabitCompletionRingView` for use in the widget environment.
- [ ] Task: Conductor - User Manual Verification 'Phase 2: Core Widget Logic and Theming' (Protocol in workflow.md)

## Phase 3: Small Widget Implementation (Standard & Focus)
- [ ] Task: Implement Small Standard Widget (2x2 Grid)
    - [ ] **Red Phase:** Write failing tests for the 2x2 grid layout and data mapping.
    - [ ] **Green Phase:** Implement the 2x2 grid view displaying up to 4 habits.
- [ ] Task: Implement Small Focus Widget (Single Habit)
    - [ ] **Red Phase:** Write failing tests for the Focus widget view with intent-based configuration.
    - [ ] **Green Phase:** Implement the Focus view showing a single habit's ring and name.
- [ ] Task: Conductor - User Manual Verification 'Phase 3: Small Widget Implementation' (Protocol in workflow.md)

## Phase 4: Medium and Large Widget Implementation
- [ ] Task: Implement Medium Summary Widget (4x2)
    - [ ] **Red Phase:** Write failing tests for the medium summary layout.
    - [ ] **Green Phase:** Implement the summary view showing multiple habits with streaks.
- [ ] Task: Implement Large Overview Widget (4x4)
    - [ ] **Red Phase:** Write failing tests for the large overview layout.
    - [ ] **Green Phase:** Implement the large view (e.g., a focused habit's monthly grid or all-habit summary).
- [ ] Task: Conductor - User Manual Verification 'Phase 4: Medium and Large Widget Implementation' (Protocol in workflow.md)

## Phase 5: Deep Linking and Final Polishing
- [ ] Task: Implement Deep Linking Support
    - [ ] Define a custom URL scheme (e.g., `ductiva://habit/{id}`).
    - [ ] Add `widgetURL` or `Link` modifiers to widget components.
    - [ ] Update `ductivaApp.swift` to handle incoming URLs and navigate to `HabitStreakDetailView`.
- [ ] Task: Final UI/UX Refinement
    - [ ] Verify translucency and "Liquid Glass" effects against design inspiration.
    - [ ] Ensure consistent typography and spacing across all widget sizes.
- [ ] Task: Conductor - User Manual Verification 'Phase 5: Deep Linking and Final Polishing' (Protocol in workflow.md)
