import SwiftData
import XCTest
@testable import ductiva

final class ModelContainerConfigurationTests: XCTestCase {
    func testMakeModelContainerInMemorySupportsHabitPersistence() throws {
        let container = try ductivaApp.makeModelContainer(inMemoryOnly: true)
        let context = ModelContext(container)

        let habit = Habit(name: "Hydrate")
        context.insert(habit)
        try context.save()

        let habits = try context.fetch(FetchDescriptor<Habit>())
        XCTAssertEqual(habits.count, 1)
        XCTAssertEqual(habits.first?.name, "Hydrate")
    }
}
