//
//  ductivaApp.swift
//  ductiva
//
//  Created by David Saint on 18/02/2026.
//

import SwiftUI
import SwiftData

// MARK: - App Routing
enum HabitAppRoute: Equatable {
    case habitDetail(id: UUID)
    
    init?(url: URL) {
        guard url.scheme == "ductiva", url.host == "habit" else {
            return nil
        }
        
        let pathComponent = url.pathComponents.dropFirst().first ?? url.lastPathComponent
        guard let uuid = UUID(uuidString: pathComponent) else {
            return nil
        }
        self = .habitDetail(id: uuid)
    }
}

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
    private struct WidgetsSheetToken: Identifiable {
        let id = UUID()
    }

    var sharedModelContainer: ModelContainer = {
        do {
            return try SharedContainer.make()
        } catch {
            assertionFailure("Could not create persistent ModelContainer: \(error)")
            do {
                return try SharedContainer.makeInMemory()
            } catch {
                preconditionFailure("Could not create fallback in-memory ModelContainer: \(error)")
            }
        }
    }()

    @State private var widgetsSheetToken: WidgetsSheetToken?

    @State private var viewModel: ConfigurationViewModel?

    var body: some Scene {
        WindowGroup {
            Group {
                if let viewModel {
                    ConfigurationView(viewModel: viewModel)
                        .sheet(item: $widgetsSheetToken) { _ in
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
                    widgetsSheetToken = WidgetsSheetToken()
                }
                .keyboardShortcut("w", modifiers: [.command, .shift])
            }
        }
    }
}
