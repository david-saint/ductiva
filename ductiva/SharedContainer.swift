import SwiftData
import Foundation

enum ContainerError: Error {
    case missingAppGroup
    case missingDatabaseInExtension
    case modelContainerInitializationFailed(underlying: Error)
}

@MainActor
public struct SharedContainer {
    private static var cachedPersistentContainer: ModelContainer?

    public static func make() throws -> ModelContainer {
        if let cachedPersistentContainer {
            return cachedPersistentContainer
        }

        let schema = Schema([
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
        
        let modelConfiguration = ModelConfiguration(schema: schema, url: databaseURL)
        
        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            cachedPersistentContainer = container
            return container
        } catch {
            throw ContainerError.modelContainerInitializationFailed(underlying: error)
        }
    }
    
    public static func makeInMemory() throws -> ModelContainer {
        let schema = Schema([
            Habit.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    }
}
