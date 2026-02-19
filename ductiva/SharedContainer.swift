import SwiftData
import Foundation

enum ContainerError: Error {
    case missingAppGroup
}

@MainActor
public struct SharedContainer {
    public static func make() throws -> ModelContainer {
        let schema = Schema([
            Item.self,
            Habit.self,
        ])
        
        guard let sharedAppGroupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.saint.ductiva") else {
            throw ContainerError.missingAppGroup
        }
        
        let databaseURL = sharedAppGroupURL.appendingPathComponent("ductiva.sqlite")
        let modelConfiguration = ModelConfiguration(schema: schema, url: databaseURL)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            // If the model container fails to load (e.g. due to schema changes during development),
            // delete the old store and try again.
            print("Failed to load ModelContainer, deleting old store: \(error)")
            try? FileManager.default.removeItem(at: databaseURL)
            try? FileManager.default.removeItem(at: databaseURL.deletingPathExtension().appendingPathExtension("sqlite-shm"))
            try? FileManager.default.removeItem(at: databaseURL.deletingPathExtension().appendingPathExtension("sqlite-wal"))
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        }
    }
}