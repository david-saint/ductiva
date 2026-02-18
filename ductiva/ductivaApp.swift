//
//  ductivaApp.swift
//  ductiva
//
//  Created by David Saint on 18/02/2026.
//

import SwiftUI
import SwiftData

@main
struct ductivaApp: App {
    var sharedModelContainer: ModelContainer = {
        do {
            return try makeModelContainer()
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    static func makeModelContainer(inMemoryOnly: Bool = false) throws -> ModelContainer {
        let schema = Schema([
            Item.self,
            Habit.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: inMemoryOnly)
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
