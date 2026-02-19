# Implementation Plan: macOS Widget Extension (widgets_20260219)

## Phase 1: Infrastructure and Data Sharing [checkpoint: 123270f]

- [x] Task: Create Widget Extension Target (8d75052)
  - [x] Create a new "Widget Extension" target in the Xcode project named `ductivaWidgets`.
  - [x] Configure the `Bundle Identifier` and `Target Membership`.
- [x] Task: Configure App Groups for Shared Persistence (8d75052)
  - [x] Add the `App Groups` capability to both the `ductiva` and `ductivaWidgets` targets.
  - [x] Define a shared App Group ID (e.g., `group.com.saint.ductiva`).
  - [x] Update `HabitStore` or the SwiftData container initialization to use the shared App Group URL.
- [x] Task: Verify Shared Data Access (8d75052)
  - [x] Write a test/utility to confirm the widget target can read data from the shared SwiftData container.
- [x] Task: Conductor - User Manual Verification 'Phase 1: Infrastructure and Data Sharing' (Protocol in workflow.md) (123270f)

## Phase 2: Core Widget Logic and Theming [checkpoint: a843401]

- [x] Task: Implement Widget Configuration Intent (5bd13a2)
  - [x] Create `HabitSelectionIntent` (AppIntent) to allow users to select a habit for the Focus widget.
  - [x] Implement a query to provide the list of available habits to the intent.
- [x] Task: Develop HabitTimelineProvider (552e173)
  - [x] Implement `TimelineProvider` to fetch habit data and generate snapshots/entries.
  - [x] Ensure the provider correctly handles "No Habits" or "Empty" states.
- [x] Task: Create Shared Widget UI Components
  - [x] Implement a "Liquid Glass" translucent background modifier/view for widgets.
  - [x] Adapt `HabitCompletionRingView` for use in the widget environment.
- [x] Task: Conductor - User Manual Verification 'Phase 2: Core Widget Logic and Theming' (Protocol in workflow.md) (a843401)

## Phase 3: Small Widget Implementation (Standard & Focus) [checkpoint: e72c5cb]

- [x] Task: Implement Small Standard Widget (2x2 Grid) (c0314b4)
  - [x] **Red Phase:** Write failing tests for the 2x2 grid layout and data mapping.
  - [x] **Green Phase:** Implement the 2x2 grid view displaying up to 4 habits.
- [x] Task: Implement Small Focus Widget (Single Habit) (b785afe)
  - [x] **Red Phase:** Write failing tests for the Focus widget view with intent-based configuration.
  - [x] **Green Phase:** Implement the Focus view showing a single habit's ring and name.
- [x] Task: Conductor - User Manual Verification 'Phase 3: Small Widget Implementation' (Protocol in workflow.md) (e72c5cb)

## Phase 4: Medium and Large Widget Implementation [checkpoint: a2963cf]

- [x] Task: Implement Medium Summary Widget (4x1 Grid) (4d16773)
  - [x] **Red Phase:** Write failing tests for the medium 4x1 layout.
  - [x] **Green Phase:** Implement the view showing a 4x1 row of habits, similar to the small widget.
- [x] Task: Implement Large Overview Widget (4x4) (1a613af)
  - [x] **Red Phase:** Write failing tests for the large overview layout.
  - [x] **Green Phase:** Implement the large view (e.g., a focused habit's monthly grid or all-habit summary).
- [x] Task: Conductor - User Manual Verification 'Phase 4: Medium and Large Widget Implementation' (Protocol in workflow.md) (a2963cf)

## Phase 5: Deep Linking and Final Polishing

- [x] Task: Implement Deep Linking Support (1413a82)
  - [x] Define a custom URL scheme (e.g., `ductiva://habit/{id}`).
  - [x] Add `widgetURL` or `Link` modifiers to widget components.
  - [x] Update `ductivaApp.swift` to handle incoming URLs and navigate to `HabitStreakDetailView`.
- [x] Task: Final UI/UX Refinement (1413a82)
  - [x] Verify translucency and "Liquid Glass" effects against design inspiration.
  - [x] Ensure consistent typography and spacing across all widget sizes.
- [~] Task: Conductor - User Manual Verification 'Phase 5: Deep Linking and Final Polishing' (Protocol in workflow.md)
