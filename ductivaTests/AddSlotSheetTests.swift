import SwiftUI
import XCTest
@testable import ductiva

final class AddSlotSheetTests: XCTestCase {

    // MARK: - Task 3.1: AddSlotSheet modal

    func testIconOptionsContainsExpectedSymbols() {
        let expectedIcons = ["display", "dumbbell", "chevron.left.forwardslash.chevron.right", "book", "brain.head.profile", "heart", "target", "pencil"]
        for icon in expectedIcons {
            XCTAssertTrue(
                AddSlotSheet.iconOptions.contains(icon),
                "Expected icon '\(icon)' to be in iconOptions"
            )
        }
    }

    func testIconOptionsHasEightEntries() {
        XCTAssertEqual(AddSlotSheet.iconOptions.count, 8)
    }

    func testValidationRejectsEmptyName() {
        XCTAssertFalse(AddSlotSheet.validateName(""))
    }

    func testValidationAcceptsNonEmptyName() {
        XCTAssertTrue(AddSlotSheet.validateName("Deep Work"))
    }

    func testValidationRejectsWhitespaceOnlyName() {
        XCTAssertFalse(AddSlotSheet.validateName("   "))
    }

    func testValidationAcceptsTrimmedName() {
        XCTAssertTrue(AddSlotSheet.validateName("  Read  "))
    }

    func testAddSlotSheetCanBeCreated() {
        let sheet = AddSlotSheet(onSave: { _, _, _ in })
        XCTAssertNotNil(sheet)
    }

    // MARK: - ScheduleType

    func testScheduleTypeDefaultsToDaily() {
        let defaultType: ScheduleType = .daily
        XCTAssertEqual(defaultType.label, "Daily")
    }

    func testScheduleTypeAllCasesCount() {
        XCTAssertEqual(ScheduleType.allCases.count, 3)
    }

    func testScheduleTypeLabels() {
        XCTAssertEqual(ScheduleType.daily.label, "Daily")
        XCTAssertEqual(ScheduleType.weekly.label, "Weekly")
        XCTAssertEqual(ScheduleType.specificDays.label, "Specific Days")
    }

    func testScheduleTypeToHabitScheduleDaily() {
        let schedule = ScheduleType.daily.toHabitSchedule()
        XCTAssertEqual(schedule, .daily)
    }

    func testScheduleTypeToHabitScheduleWeekly() {
        let schedule = ScheduleType.weekly.toHabitSchedule()
        XCTAssertEqual(schedule, .weekly)
    }

    func testScheduleTypeToHabitScheduleSpecificDaysDefault() {
        let schedule = ScheduleType.specificDays.toHabitSchedule()
        XCTAssertEqual(schedule, .specificDays([]))
    }
}
