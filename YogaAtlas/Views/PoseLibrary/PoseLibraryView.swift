import SwiftUI

struct PoseLibraryView: View {
    @EnvironmentObject var store: DataStore
    @State private var searchText = ""
    @State private var selectedCategory: String? = nil

    private let categories = ["スタンディング", "バランス", "フォワードベンド",
                               "バックベンド", "ツイスト", "インバージョン",
                               "リストラティブ", "フロア"]

    private var filtered: [Pose] {
        store.poses.filter { pose in
            let matchSearch = searchText.isEmpty ||
                pose.nameJa.contains(searchText) ||
                pose.nameEn.localizedCaseInsensitiveContains(searchText) ||
                pose.sanskrit.localizedCaseInsensitiveContains(searchText)
            let matchCat = selectedCategory == nil || pose.category == selectedCategory
            return matchSearch && matchCat
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.parchment.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Category chips
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                CategoryChip(title: "すべて", isSelected: selectedCategory == nil) {
                                    selectedCategory = nil
                                }
                                ForEach(categories, id: \.self) { cat in
                                    CategoryChip(title: cat, isSelected: selectedCategory == cat) {
                                        selectedCategory = selectedCategory == cat ? nil : cat
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }

                        // Pose grid
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            ForEach(filtered) { pose in
                                NavigationLink(destination: PoseDetailView(pose: pose)) {
                                    PoseCard(pose: pose)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 8)
                }
            }
            .navigationTitle("📖 ポーズ大全")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "ポーズを検索…")
        }
    }
}

// MARK: - Sub-views
struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppTheme.caption(13))
                .foregroundColor(isSelected ? .white : AppTheme.inkBrown)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? AppTheme.goldAccent : AppTheme.parchmentDark)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(AppTheme.goldAccent.opacity(0.4), lineWidth: 1))
        }
    }
}

struct PoseCard: View {
    let pose: Pose

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Pose image placeholder
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(AppTheme.parchmentDark)
                    .frame(height: 120)
                if let uiImage = UIImage(named: pose.imageFile) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 120)
                        .clipped()
                        .cornerRadius(8)
                } else {
                    VStack(spacing: 4) {
                        Text("🧘")
                            .font(.system(size: 36))
                        Text(pose.nameJa)
                            .font(AppTheme.caption(11))
                            .foregroundColor(AppTheme.inkLight)
                            .multilineTextAlignment(.center)
                    }
                }
            }

            Text(pose.nameJa)
                .font(AppTheme.body(14))
                .foregroundColor(AppTheme.inkBrown)
                .lineLimit(1)

            Text(pose.sanskrit)
                .font(AppTheme.caption(11))
                .foregroundColor(AppTheme.inkLight)
                .lineLimit(1)

            HStack(spacing: 2) {
                ForEach(1...5, id: \.self) { i in
                    Circle()
                        .fill(i <= pose.difficulty ? AppTheme.goldAccent : AppTheme.parchmentDark)
                        .frame(width: 6, height: 6)
                }
                Spacer()
                Text("\(pose.duration)分")
                    .font(AppTheme.caption(11))
                    .foregroundColor(AppTheme.inkLight)
            }
        }
        .padding(10)
        .background(AppTheme.cardBackground())
    }
}
