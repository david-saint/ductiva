import AppIntents
import SwiftData
import SwiftUI

struct HabitSelectionIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Select Habit"
    static var description = IntentDescription("Selects a habit to track in this widget.")

    @Parameter(title: "Habit")
    var habit: HabitEntity?

    init(habit: HabitEntity? = nil) {
        self.habit = habit
    }
    
    init() {}
}

struct HabitEntity: AppEntity, Identifiable, Hashable {
    var id: String
    var title: String
    var iconName: String
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Habit"
    static var defaultQuery = HabitQuery()
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: LocalizedStringResource(stringLiteral: title),
            image: DisplayRepresentation.Image(systemName: iconName)
        )
    }
}

struct HabitQuery: EntityStringQuery {
    func entities(for identifiers: [HabitEntity.ID]) async throws -> [HabitEntity] {
        let allHabits = (try? await fetchHabits()) ?? []
        return allHabits.filter { identifiers.contains($0.id) }
    }
    
    func entities(matching string: String) async throws -> [HabitEntity] {
        let allHabits = (try? await fetchHabits()) ?? []
        return allHabits.filter { $0.title.localizedStandardContains(string) }
    }
    
    func suggestedEntities() async throws -> [HabitEntity] {
        (try? await fetchHabits()) ?? []
    }
    
    @MainActor
    private func fetchHabits() throws -> [HabitEntity] {
        let container = try SharedContainer.make()
        let context = container.mainContext
        let descriptor = FetchDescriptor<Habit>(sortBy: [SortDescriptor(\.createdAt, order: .forward)])
        let habits = try context.fetch(descriptor)
        
        var entities = [HabitEntity(id: "none", title: "None (2x2 Grid)", iconName: "square.grid.2x2")]
        entities += habits.map { habit in
            HabitEntity(id: habit.id.uuidString, title: habit.name, iconName: habit.iconName)
        }
        return entities
    }
}
