import SwiftUI
import SwiftData

@main
struct FodCareApp: App {
    let modelContainer: ModelContainer

    init() {
        do {
            let schema = Schema([
                FoodItem.self,
                MealRecord.self,
                MealFoodEntry.self,
                SymptomRecord.self
            ])
            modelContainer = try ModelContainer(for: schema)
        } catch {
            fatalError("ModelContainer初期化エラー: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    DataManager.seedIfNeeded(modelContext: modelContainer.mainContext)
                }
        }
        .modelContainer(modelContainer)
    }
}
