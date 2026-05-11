import SwiftUI

struct ContentView: View {
    @StateObject private var store = DataStore.shared
    @State private var selectedTab = AppRuntime.initialTab

    var body: some View {
        TabView(selection: $selectedTab) {
            PoseLibraryView()
                .tabItem { Label(String(localized: "tab.poses"), systemImage: "figure.walk") }
                .tag(0)

            PrescriptionView()
                .tabItem { Label(String(localized: "tab.symptoms"), systemImage: "heart.text.square.fill") }
                .tag(1)

            DailyYogaView()
                .tabItem { Label(String(localized: "tab.daily"), systemImage: "sun.max.fill") }
                .tag(2)

            MeditationView()
                .tabItem { Label(String(localized: "tab.meditation"), systemImage: "sparkles") }
                .tag(3)

            ChakraView()
                .tabItem { Label(String(localized: "tab.chakra"), systemImage: "circle.hexagongrid.fill") }
                .tag(4)

            OfficeYogaView()
                .tabItem { Label(String(localized: "tab.office"), systemImage: "desktopcomputer") }
                .tag(5)
        }
        .tint(AppTheme.sageDeep)
        .environmentObject(store)
    }
}
