# Specification: Implement Core Habit Model and Persistence with SwiftData

## Goal
Establish the foundational data layer for the habit-tracking application using SwiftData.

## Requirements
- Define a `Habit` model with:
    - `name`: String
    - `createdAt`: Date
    - `schedule`: A representation of frequency (daily, weekly, specific days).
    - `completions`: A collection of completion records (dates).
- Set up the SwiftData `ModelContainer` in the main app entry point.
- Implement basic CRUD operations for `Habit` objects.
- Ensure integration with the "Stealth Ceramic" (matte-milled graphite) and "Liquid Glass" (transparency) aesthetic for any initial UI components.

## Success Criteria
- `Habit` model is successfully persisted and retrieved using SwiftData.
- Basic unit tests for CRUD operations pass.
- The app launches and initializes the model container without errors.
