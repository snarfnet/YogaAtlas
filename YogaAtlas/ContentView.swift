import SwiftUI

struct ContentView: View {
    @StateObject private var store = DataStore.shared
    @State private var selectedTab = AppRuntime.initialTab

    var body: some View {
        TabView(selection: $selectedTab) {
            PoseLibraryView()
                .tabItem { Label("ポーズ", systemImage: "figure.walk") }
                .tag(0)

            PrescriptionView()
                .tabItem { Label("悩み別", systemImage: "heart.text.square.fill") }
                .tag(1)

            DailyYogaView()
                .tabItem { Label("今日", systemImage: "sun.max.fill") }
                .tag(2)

            MeditationView()
                .tabItem { Label("瞑想", systemImage: "sparkles") }
                .tag(3)

            ChakraView()
                .tabItem { Label("チャクラ", systemImage: "circle.hexagongrid.fill") }
                .tag(4)

            OfficeYogaView()
                .tabItem { Label("仕事中", systemImage: "desktopcomputer") }
                .tag(5)
        }
        .tint(AppTheme.sageDeep)
        .environmentObject(store)
    }
}
