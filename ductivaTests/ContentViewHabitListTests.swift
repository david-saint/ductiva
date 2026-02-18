import Foundation
import SwiftData
import XCTest
@testable import ductiva

final class ContentViewHabitListTests: XCTestCase {
    func testHabitsFetchDescriptorReturnsNewestFirst() throws {
        let container = try ductivaApp.makeModelContainer(inMemoryOnly: true)
        let context = ModelContext(container)

        context.insert(Habit(name: "Older", createdAt: Date(timeIntervalSince1970: 1_700_000_000), schedule: .daily))
        context.insert(Habit(name: "Newest", createdAt: Date(timeIntervalSince1970: 1_800_000_000), schedule: .weekly))
        try context.save()

        let habits = try context.fetch(ContentView.habitsFetchDescriptor)

        XCTAssertEqual(habits.map(\.name), ["Newest", "Older"])
    }

    func testScheduleDescriptionForSpecificDays() {
        let description = ContentView.scheduleDescription(for: .specificDays([.monday, .wednesday, .friday]))

        XCTAssertEqual(description, "Mon, Wed, Fri")
    }
}
