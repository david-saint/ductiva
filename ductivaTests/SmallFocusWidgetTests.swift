import SwiftUI
import XCTest
@testable import ductiva

final class SmallFocusWidgetTests: XCTestCase {

    // MARK: - View Creation

    func testSmallFocusWidgetCanBeCreated() {
        let habit = makeHabit()
        let view = SmallFocusWidgetView(habit: habit, currentDate: Self.fixedDate)
        XCTAssertNotNil(view)
    }

    func testSmallFocusWidgetCanBeCreatedWithNilHabit() {
        let view = SmallFocusWidgetView(habit: nil, currentDate: Self.fixedDate)
        XCTAssertNotNil(view)
    }

    // MARK: - Data Mapping

    func testSmallFocusWidgetExposesHabitName() {
        let habit = makeHabit(name: "Deep Work")
        let view = SmallFocusWidgetView(habit: habit, currentDate: Self.fixedDate)
        XCTAssertEqual(view.habit?.name, "Deep Work")
    }

    func testSmallFocusWidgetExposesHabitIcon() {
        let habit = makeHabit(iconName: "display")
        let view = SmallFocusWidgetView(habit: habit, currentDate: Self.fixedDate)
        XCTAssertEqual(view.habit?.iconName, "display")
    }

    // MARK: - Completion State

    func testSmallFocusWidgetDetectsCompletedHabit() {
        let today = Self.fixedDate
        let calendar = Self.gregorianCalendar
        let habit = makeHabit(completions: [calendar.startOfDay(for: today)])
        let view = SmallFocusWidgetView(habit: habit, currentDate: today)
        XCTAssertTrue(view.isHabitCompleted)
    }

    func testSmallFocusWidgetDetectsIncompleteHabit() {
        let habit = makeHabit()
        let view = SmallFocusWidgetView(habit: habit, currentDate: Self.fixedDate)
        XCTAssertFalse(view.isHabitCompleted)
    }

    func testSmallFocusWidgetCompletedIsFalseWithNilHabit() {
        let view = SmallFocusWidgetView(habit: nil, currentDate: Self.fixedDate)
        XCTAssertFalse(view.isHabitCompleted)
    }

    // MARK: - Progress

    func testSmallFocusWidgetProgressValue() {
        let habit = makeHabit(schedule: .daily)
        let view = SmallFocusWidgetView(habit: habit, currentDate: Self.fixedDate)
        let progress = view.ringProgress
        // At noon (12:00) on a daily schedule, progress should be ~0.5
        XCTAssertGreaterThan(progress, 0.4)
        XCTAssertLessThan(progress, 0.6)
    }

    func testSmallFocusWidgetProgressIsOneWithNilHabit() {
        let view = SmallFocusWidgetView(habit: nil, currentDate: Self.fixedDate)
        XCTAssertEqual(view.ringProgress, 1.0)
    }

    // MARK: - Schedule Description

    func testSmallFocusWidgetScheduleDescriptionDaily() {
        let habit = makeHabit(schedule: .daily)
        let view = SmallFocusWidgetView(habit: habit, currentDate: Self.fixedDate)
        XCTAssertEqual(view.scheduleLabel, "Daily")
    }

    func testSmallFocusWidgetScheduleDescriptionWeekly() {
        let habit = makeHabit(schedule: .weekly)
        let view = SmallFocusWidgetView(habit: habit, currentDate: Self.fixedDate)
        XCTAssertEqual(view.scheduleLabel, "Weekly")
    }

    func testSmallFocusWidgetScheduleLabelNilHabit() {
        let view = SmallFocusWidgetView(habit: nil, currentDate: Self.fixedDate)
        XCTAssertNil(view.scheduleLabel)
    }

    // MARK: - Body Rendering

    func testSmallFocusWidgetBodyRenders() {
        let habit = makeHabit()
        let view = SmallFocusWidgetView(habit: habit, currentDate: Self.fixedDate)
        let body = view.body
        XCTAssertNotNil(body)
    }

    func testSmallFocusWidgetBodyRendersWithNilHabit() {
        let view = SmallFocusWidgetView(habit: nil, currentDate: Self.fixedDate)
        let body = view.body
        XCTAssertNotNil(body)
    }

    func testSmallFocusWidgetBodyRendersWithCompletedHabit() {
        let today = Self.fixedDate
        let calendar = Self.gregorianCalendar
        let habit = makeHabit(completions: [calendar.startOfDay(for: today)])
        let view = SmallFocusWidgetView(habit: habit, currentDate: today)
        let body = view.body
        XCTAssertNotNil(body)
    }

    // MARK: - Helpers

    private static let gregorianCalendar: Calendar = {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(identifier: "UTC")!
        return cal
    }()

    private static let fixedDate: Date = {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(identifier: "UTC")!
        return cal.date(from: DateComponents(year: 2026, month: 2, day: 19, hour: 12))!
    }()

    private func makeHabit(
        name: String = "Deep Work",
        iconName: String = "display",
        schedule: HabitSchedule = .daily,
        completions: [Date] = [],
        currentStreak: Int = 0
    ) -> WidgetHabitSnapshot {
        WidgetHabitSnapshot(
            id: UUID(),
            name: name,
            iconName: iconName,
            schedule: schedule,
            completions: completions,
            currentStreak: currentStreak
        )
    }
}
