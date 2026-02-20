# GEMINI.md - Project Context & Instructions

This file provides instructional context for Gemini CLI when working on the **Ductiva** project.

## 1. Project Overview

**Ductiva** is a macOS utility designed for tracking 1-4 critical daily habits with "zero cognitive friction." It follows a **"cockpit instrument" philosophy**—providing a stealthy, always-on display of personal discipline rather than a demanding, gamified app.

- **Primary Goal:** Ambient habit tracking for high-focus professionals.
- **Visual Aesthetic:** "Stealth Ceramic" theme, featuring transparent windows, ultra-thin materials, and minimalist typography.
- **Key Constraints:** Limited to 1-4 habits to maintain focus.

### Tech Stack
- **Platform:** macOS 14.0+ (Sonoma)
- **Language:** Swift 5.10+
- **UI Framework:** SwiftUI + AppKit (for window transparency and menu bar integration)
- **Persistence:** SwiftData
- **Architecture:** MVVM (Model-View-ViewModel)
- **Tooling:** Xcode 15+, Ruby (via `xcodeproj` gem for project manipulation).

---

## 2. Building, Running, and Testing

### Xcode Operations
- **Build & Run:** `Command + R`
- **Run Tests:** `Command + U`
- **Clean Build Folder:** `Command + Shift + K`

### Automation Scripts (Ruby)
The project uses several Ruby scripts in `.agent/scripts/` to manage the `.xcodeproj` file programmatically. This ensures consistency when adding files or targets.
- `.agent/scripts/add_swift_file.rb`: Adds a Swift file to the project and targets.
- `.agent/scripts/add_test_file.rb`: Adds a test file to the project and test target.
- `.agent/scripts/add_widget_target.rb`: Configures the widget extension target.
- `.agent/scripts/share_models.rb`: Handles linking models between the app and its extensions.
- `.agent/scripts/fix_bundle_id.rb`: Corrects bundle identifiers across targets.

**When to Use:**
- After creating any new `.swift` file (main app or tests).
- When configuring new targets or sharing resources across extensions.

**When to Add New Scripts:**
- If you find yourself performing a repetitive manual task in the `.xcodeproj` (e.g., adding a new framework to multiple targets, configuring a new build phase).
- Always use the `xcodeproj` Ruby gem for these scripts to maintain project integrity.

*Note: Always use these scripts or verify project membership after adding files manually.*

---

## 3. Development Workflow (The "Conductor" Protocol)

The project follows a strict **Research -> Strategy -> Execution** lifecycle, managed via the `conductor/` directory.

### Source of Truth
- **Product Definition:** `conductor/product.md`
- **Tech Stack:** `conductor/tech-stack.md`
- **Active Plan:** Found in `conductor/tracks/<track_id>/plan.md`

### Task Lifecycle (TDD Mandate)
1. **Mark In Progress:** Update `plan.md` task from `[ ]` to `[~]`.
2. **Red Phase:** Write failing unit tests in `ductivaTests/`.
3. **Green Phase:** Implement minimal code in `ductiva/` to pass tests.
4. **Refactor:** Clean up code while maintaining passing tests.
5. **Checkpoint:** Follow the "Phase Completion Verification" protocol in `conductor/workflow.md` when a phase ends.

### Commit Guidelines
- Use conventional commits: `feat(scope): message`, `fix(scope): message`, etc.
- **Git Notes:** After every commit, attach a summary of the task using `git notes add -m "<summary>" <hash>`.

---

## 4. Key Directory Structure

- `ductiva/`: Main application source code.
  - `Habit.swift`: The SwiftData model.
  - `HabitStore.swift`: Repository wrapper for `ModelContext`.
  - `ConfigurationView.swift`: The primary settings/management interface.
  - `StealthCeramicTheme.swift`: Centralized UI constants (colors, tracking, opacity).
- `ductivaWidgets/`: Source for macOS widgets (Small, Medium, Large variants).
- `ductivaTests/`: Comprehensive test suite. Every feature **must** have a corresponding test file.
- `conductor/`: Project governance and documentation.
- `design-inspiration/`: UI/UX reference images.

---

## 5. Coding Conventions

- **MVVM Pattern:** Views should observe ViewModels. ViewModels should interact with the `HabitStore`.
- **SwiftData Usage:** Use `@Model` for data entities. Avoid direct `ModelContext` access in Views; use the `HabitStore` abstraction.
- **UI Consistency:** Always use constants from `StealthCeramicTheme` for padding, colors, and fonts.
- **Transparency:** The app uses a custom `TransparentWindowModifier` in `ductivaApp.swift` to achieve its native, blended look.
- **Non-Interactive Commands:** When running shell commands, prefer flags that prevent interactive prompts (e.g., `CI=true`).

---

## 6. AI Agent Specific Instructions

- **Plan First:** Before modifying any code, check the active `plan.md` in `conductor/tracks/`.
- **No Gamification:** When suggesting features, avoid streaks, badges, or "leveling up." Focus on "cockpit" metrics and ambient awareness.
- **Testing:** If you add a file to `ductiva/`, you **must** add a corresponding test in `ductivaTests/`.
- **Project Membership:** After creating a file, remember to run the appropriate Ruby script (e.g., `ruby .agent/scripts/add_swift_file.rb ductiva/Path/To/File.swift`) to ensure it is added to the Xcode project.
- **Automation First:** If a repetitive task involving `.xcodeproj` configuration appears, consider creating a new Ruby script in `.agent/scripts/` to automate it.
