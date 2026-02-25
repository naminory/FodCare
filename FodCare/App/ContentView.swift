import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("ホーム", systemImage: "house")
                }

            FoodListView()
                .tabItem {
                    Label("図鑑", systemImage: "book")
                }

            AnalysisView()
                .tabItem {
                    Label("分析", systemImage: "chart.bar")
                }

            SettingsView()
                .tabItem {
                    Label("設定", systemImage: "gearshape")
                }
        }
        .tint(ColorTheme.primary)
    }
}
