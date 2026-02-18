# Implementation Plan: Develop Main Window (Configurations)

## Phase 1: Configuration View Foundation

- [x] Task 1.1: Add `iconName` property to `Habit` model (2ae3aaf)
- [x] Task 1.2: Create `ConfigurationViewModel` with `@Observable` (a72ed1e)
- [x] Task 1.3: Create `ConfigurationView` (single-pane layout) (522b721)
- [x] Task 1.4: Wire `ConfigurationView` as app entry point & remove `ContentView` (517912e)
- [x] Task 1.5: Add placeholder views for Widgets and Habit Streak (6c256cb)
- [x] Task 1.6: Implement global navigation (Toolbar / App Menu) (6c256cb)
- [x] Task 1.7: Verify Phase 1 test coverage >80% (f3b737e)
- [x] Task 1.8: Phase Completion — Manual Verification & Checkpoint

## Phase 2: Habit List Display & Styling

- [x] Task 2.1: Create `HabitSlotRow` and display habits from SwiftData (4c81849)
- [x] Task 2.2: Apply "Stealth Ceramic" chassis styling (0c37562)
- [ ] Task 2.3: Apply "Liquid Glass" styling to interactive elements
- [ ] Task 2.4: Unit tests for list rendering & empty state
- [ ] Task 2.5: Phase Completion — Manual Verification & Checkpoint

## Phase 3: Add/Edit Habit Workflow

- [ ] Task 3.1: Create `AddSlotSheet` modal
- [ ] Task 3.2: Implement schedule selection (Daily / Weekly / Specific Days)
- [ ] Task 3.3: Integrate Add/Remove with `HabitStore`
- [ ] Task 3.4: Add contextual navigation from habit rows to detail
- [ ] Task 3.5: Verify Phase 3 test coverage
- [ ] Task 3.6: Phase Completion — Manual Verification & Checkpoint

## Phase 4: Global Settings & Final Refinement

- [ ] Task 4.1: Create `SettingsSection` (inline toggles)
- [ ] Task 4.2: Create `ActionBar` (Cancel + Save Changes)
- [ ] Task 4.3: Create `AddSlotButton` (dashed border)
- [ ] Task 4.4: Refine animations and transitions
- [ ] Task 4.5: Final visual audit against design
- [ ] Task 4.6: Verify >80% overall coverage
- [ ] Task 4.7: Phase Completion — Manual Verification & Checkpoint
