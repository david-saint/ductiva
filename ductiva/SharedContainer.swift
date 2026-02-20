import SwiftData
import Foundation

enum ContainerError: Error {
    case missingAppGroup
    case missingDatabaseInExtension
}

@MainActor
public struct SharedContainer {
    public static func make() throws -> ModelContainer {
        let schema = Schema([
            Item.self,
            Habit.self,
        ])
        
        guard let sharedAppGroupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: AppConfiguration.appGroupID) else {
            throw ContainerError.missingAppGroup
        }
        
        let databaseURL = sharedAppGroupURL.appendingPathComponent("ductiva.sqlite")
        let isExtension = Bundle.main.bundlePath.hasSuffix(".appex")
        
        if isExtension && !FileManager.default.fileExists(atPath: databaseURL.path) {
            throw ContainerError.missingDatabaseInExtension
        }
        
        // Removed allowsSave: !isExtension because it can cause Error 1 on macOS
        let modelConfiguration = ModelConfiguration(schema: schema, url: databaseURL)
        
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
    
    public static func makeInMemory() throws -> ModelContainer {
        let schema = Schema([
            Item.self,
            Habit.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    }
}