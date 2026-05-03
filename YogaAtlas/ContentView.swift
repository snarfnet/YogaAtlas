import SwiftUI

struct ContentView: View {
    @StateObject private var store = DataStore.shared

    var body: some View {
        TabView {
            PoseLibraryView()
                .tabItem {
                    Label("大全", systemImage: "books.vertical.fill")
                }
            ChakraView()
                .tabItem {
                    Label("チャクラ", systemImage: "sparkles")
                }
            PrescriptionView()
                .tabItem {
                    Label("処方箋", systemImage: "cross.case.fill")
                }
            DailyYogaView()
                .tabItem {
                    Label("今日のヨガ", systemImage: "moon.stars.fill")
                }
            OfficeYogaView()
                .tabItem {
                    Label("オフィス", systemImage: "desktopcomputer")
                }
            MeditationView()
                .tabItem {
                    Label("瞑想", systemImage: "brain.head.profile")
                }
        }
        .accentColor(AppTheme.goldAccent)
        .background(AppTheme.parchment)
        .environmentObject(store)
    }
}
