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

    @State private var showWidgets = false

    var body: some Scene {
        WindowGroup {
            ConfigurationView(
                viewModel: ConfigurationViewModel(
                    habitStore: HabitStore(
                        modelContext: sharedModelContainer.mainContext
                    )
                )
            )
            .sheet(isPresented: $showWidgets) {
                WidgetsPlaceholderView()
                    .frame(minWidth: 360, minHeight: 400)
            }
        }
        .modelContainer(sharedModelContainer)
        .defaultSize(width: 480, height: 560)
        .commands {
            CommandGroup(after: .appInfo) {
                Button("Widgets...") {
                    showWidgets = true
                }
                .keyboardShortcut("w", modifiers: [.command, .shift])
            }
        }
    }
}
