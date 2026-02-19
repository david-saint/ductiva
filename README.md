# Ductiva

A macOS utility for tracking 1-4 critical daily habits with zero cognitive friction. Ductiva rejects gamification in favor of a "cockpit instrument" philosophy—a stealthy, always-on display of personal discipline.

![Platform](https://img.shields.io/badge/platform-macOS-blue.svg)
![Swift](https://img.shields.io/badge/swift-5.9+-orange.svg)
![License](https://img.shields.io/badge/license-Apache%202.0-green.svg)

## Overview

Ductiva is designed for developers, designers, and focus-driven professionals who want habit tracking that feels like part of their OS architecture, not a demanding app. The app features a minimalist, transparent interface that blends seamlessly with your desktop environment.

## Features

- **Minimal Habit Tracking:** Track 1-4 essential habits without overwhelming complexity
- **Flexible Scheduling:** Set custom schedules (daily, weekly, monthly) for each habit
- **Streak Visualization:** Simple calendar view to highlight streaks and completion history
- **System Integration:** 
  - Menu bar integration for quick access
  - Native macOS notifications and reminders
  - SwiftData persistence for reliable data storage
- **Stealth UI:** Transparent window design that feels native to macOS

## Requirements

- macOS 14.0+
- Xcode 15.0+
- Swift 5.9+

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/ductiva.git
   ```

2. Open `ductiva.xcodeproj` in Xcode

3. Build and run (⌘R)

## Usage

1. Launch Ductiva from your Applications folder
2. Configure your 1-4 critical habits in the main window
3. Use the menu bar icon for quick access
4. Check off habits as you complete them throughout the day
5. View your streak history to maintain momentum

## Architecture

- **SwiftUI** for the user interface
- **SwiftData** for local data persistence
- **MVVM architecture** with ViewModels managing state
- **Transparent window design** using `NSWindow` customization

## Project Structure

```
ductiva/
├── ductiva/              # Main app source
│   ├── ductivaApp.swift  # App entry point
│   ├── ConfigurationView.swift
│   ├── HabitSlotRow.swift
│   ├── HabitStore.swift
│   ├── Habit.swift
│   └── ...
├── ductivaTests/         # Unit tests
├── conductor/            # Project documentation
└── design-inspiration/   # UI/UX reference
```

## Development

### Running Tests

Use Xcode's Test Navigator (⌘6) or press ⌘U to run all tests.

### Code Style

This project follows the Swift style guidelines defined in `conductor/code_styleguides/general.md`.

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Built with SwiftUI and SwiftData
- Inspired by the "cockpit instrument" philosophy of ambient computing

---

**Note:** This is a work in progress. Features and architecture may evolve as development continues.
