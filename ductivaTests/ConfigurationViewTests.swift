import SwiftData
import XCTest
@testable import ductiva

final class ConfigurationViewTests: XCTestCase {
    func testConfigurationViewCanBeCreated() throws {
        let container = try SharedContainer.makeInMemory()
        let context = ModelContext(container)
        let store = HabitStore(modelContext: context)
        let viewModel = ConfigurationViewModel(habitStore: store)
        _ = ConfigurationView(viewModel: viewModel)
    }
}
