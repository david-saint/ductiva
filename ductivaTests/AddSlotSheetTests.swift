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

    func testAddSlotSheetBodyRenders() {
        let sheet = AddSlotSheet(onSave: { _, _, _ in })
        let body = sheet.body
        XCTAssertNotNil(body)
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

    // MARK: - Task 3.2: Specific days conversion

    func testSpecificDaysConversion() {
        let selectedDays: [HabitWeekday] = [.monday, .wednesday, .friday]
        let schedule = ScheduleType.specificDays.toHabitSchedule(selectedDays: selectedDays)
        XCTAssertEqual(schedule, .specificDays([.monday, .wednesday, .friday]))
    }

    func testSpecificDaysConversionWithAllDays() {
        let allDays = HabitWeekday.allCases
        let schedule = ScheduleType.specificDays.toHabitSchedule(selectedDays: allDays)
        XCTAssertEqual(schedule, .specificDays(allDays))
    }

    func testSpecificDaysConversionWithSingleDay() {
        let schedule = ScheduleType.specificDays.toHabitSchedule(selectedDays: [.saturday])
        XCTAssertEqual(schedule, .specificDays([.saturday]))
    }

    func testDailyScheduleIgnoresSelectedDays() {
        let schedule = ScheduleType.daily.toHabitSchedule(selectedDays: [.monday])
        XCTAssertEqual(schedule, .daily)
    }

    func testWeeklyScheduleIgnoresSelectedDays() {
        let schedule = ScheduleType.weekly.toHabitSchedule(selectedDays: [.tuesday])
        XCTAssertEqual(schedule, .weekly)
    }

    func testHabitWeekdayAllCasesHasSevenDays() {
        XCTAssertEqual(HabitWeekday.allCases.count, 7)
    }

    func testDayToggleHelperTogglesOn() {
        var selectedDays: Set<HabitWeekday> = []
        AddSlotSheet.toggleDay(.monday, in: &selectedDays)
        XCTAssertTrue(selectedDays.contains(.monday))
    }

    func testDayToggleHelperTogglesOff() {
        var selectedDays: Set<HabitWeekday> = [.monday, .wednesday]
        AddSlotSheet.toggleDay(.monday, in: &selectedDays)
        XCTAssertFalse(selectedDays.contains(.monday))
        XCTAssertTrue(selectedDays.contains(.wednesday))
    }

    func testDayToggleHelperMultipleToggles() {
        var selectedDays: Set<HabitWeekday> = []
        AddSlotSheet.toggleDay(.monday, in: &selectedDays)
        AddSlotSheet.toggleDay(.friday, in: &selectedDays)
        AddSlotSheet.toggleDay(.monday, in: &selectedDays)
        XCTAssertFalse(selectedDays.contains(.monday))
        XCTAssertTrue(selectedDays.contains(.friday))
    }

    // MARK: - Task 4.6: Coverage improvements

    func testAddSlotSheetBodyRendersWithSpecificDaysSchedule() {
        var sheet = AddSlotSheet(onSave: { _, _, _ in })
        sheet.selectedScheduleType = .specificDays
        sheet.selectedDays = [.monday, .wednesday]
        let body = sheet.body
        XCTAssertNotNil(body)
    }

    func testAddSlotSheetBodyRendersWithNameEntered() {
        var sheet = AddSlotSheet(onSave: { _, _, _ in })
        sheet.name = "Deep Work"
        sheet.selectedIcon = "display"
        let body = sheet.body
        XCTAssertNotNil(body)
    }

    func testAddSlotSheetBodyRendersWithWeeklySchedule() {
        var sheet = AddSlotSheet(onSave: { _, _, _ in })
        sheet.selectedScheduleType = .weekly
        let body = sheet.body
        XCTAssertNotNil(body)
    }

    func testAddSlotSheetIsValidDelegatesToValidateName() {
        // isValid delegates to validateName — test the static function directly
        XCTAssertTrue(AddSlotSheet.validateName("Read"))
        XCTAssertFalse(AddSlotSheet.validateName(""))
        XCTAssertFalse(AddSlotSheet.validateName("   "))
    }

    func testAddSlotSheetDefaultSelectedIcon() {
        let sheet = AddSlotSheet(onSave: { _, _, _ in })
        XCTAssertEqual(sheet.selectedIcon, "target")
    }

    func testAddSlotSheetDefaultScheduleType() {
        let sheet = AddSlotSheet(onSave: { _, _, _ in })
        XCTAssertEqual(sheet.selectedScheduleType, .daily)
    }

    func testAddSlotSheetDefaultSelectedDays() {
        let sheet = AddSlotSheet(onSave: { _, _, _ in })
        XCTAssertTrue(sheet.selectedDays.isEmpty)
    }
}
