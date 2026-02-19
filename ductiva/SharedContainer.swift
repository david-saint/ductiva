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
        
        // In widgets, we should be read-only to avoid file lock contention
        let isExtension = Bundle.main.bundlePath.hasSuffix(".appex")
        let modelConfiguration = ModelConfiguration(schema: schema, url: databaseURL, allowsSave: !isExtension)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            print("Failed to load ModelContainer, deleting old store: \(error)")
            if !isExtension {
                try? FileManager.default.removeItem(at: databaseURL)
                try? FileManager.default.removeItem(at: databaseURL.deletingPathExtension().appendingPathExtension("sqlite-shm"))
                try? FileManager.default.removeItem(at: databaseURL.deletingPathExtension().appendingPathExtension("sqlite-wal"))
            }
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        }
    }
}