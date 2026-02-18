//
//  ductivaApp.swift
//  ductiva
//
//  Created by David Saint on 18/02/2026.
//

import SwiftUI
import SwiftData

// MARK: - Transparent Window Helper

/// Makes the hosting NSWindow transparent so SwiftUI materials
/// blur through to the desktop instead of an opaque backing.
private struct TransparentWindowModifier: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            if let window = view.window {
                window.isOpaque = false
                window.backgroundColor = .clear
            }
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}

extension View {
    func transparentWindow() -> some View {
        background(TransparentWindowModifier())
    }
}

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

    @State private var viewModel: ConfigurationViewModel?

    var body: some Scene {
        WindowGroup {
            Group {
                if let viewModel {
                    ConfigurationView(viewModel: viewModel)
                        .sheet(isPresented: $showWidgets) {
                            WidgetsPlaceholderView()
                                .frame(minWidth: 360, minHeight: 400)
                        }
                }
            }
            .transparentWindow()
            .onAppear {
                if viewModel == nil {
                    let vm = ConfigurationViewModel(
                        habitStore: HabitStore(
                            modelContext: sharedModelContainer.mainContext
                        )
                    )
                    #if DEBUG
                    vm.seedSampleHabitsIfEmpty()
                    #endif
                    viewModel = vm
                }
            }
        }
        .modelContainer(sharedModelContainer)
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 365, height: 510)
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
