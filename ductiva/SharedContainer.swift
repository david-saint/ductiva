import SwiftData
import Foundation

@MainActor
public struct SharedContainer {
    public static func make() throws -> ModelContainer {
        let schema = Schema([
            Item.self,
            Habit.self,
        ])
        
        let sharedAppGroupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.saint.ductiva")!
        let databaseURL = sharedAppGroupURL.appendingPathComponent("ductiva.sqlite")
        let modelConfiguration = ModelConfiguration(schema: schema, url: databaseURL)
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    }
}