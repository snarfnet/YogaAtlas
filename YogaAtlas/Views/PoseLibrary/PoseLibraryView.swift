import SwiftUI

struct PoseLibraryView: View {
    @EnvironmentObject var store: DataStore
    @State private var searchText = ""
    @State private var selectedCategory: String? = nil

    private var categories: [String] {
        Array(Set(store.poses.map(\.category))).sorted()
    }

    private var filtered: [Pose] {
        store.poses.filter { pose in
            let matchesText = searchText.isEmpty
                || pose.nameJa.localizedCaseInsensitiveContains(searchText)
                || pose.nameEn.localizedCaseInsensitiveContains(searchText)
                || pose.sanskrit.localizedCaseInsensitiveContains(searchText)
            let matchesCategory = selectedCategory == nil || pose.category == selectedCategory
            return matchesText && matchesCategory
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                YogaScreenBackground()
                ScrollView {
                    VStack(spacing: 22) {
                        YogaHeroCard(imageName: "YogaHero", height: 260) {
                            VStack(alignment: .leading, spacing: 10) {
                                Pill(text: "Yoga Atlas", color: .white)
                                Text("呼吸から、体を読み解く。")
                                    .font(AppTheme.title(30))
                                    .foregroundColor(.white)
                                Text("ポーズ、瞑想、チャクラ、悩み別ケアをひとつの流れで学べます。")
                                    .font(AppTheme.body(15))
                                    .foregroundColor(.white.opacity(0.92))
                                    .lineSpacing(3)
                            }
                        }

                        HStack(spacing: 10) {
                            SummaryBadge(value: "\(store.poses.count)", label: "ポーズ")
                            SummaryBadge(value: "\(store.symptoms.count)", label: "悩み別")
                            SummaryBadge(value: "\(store.meditations.count)", label: "瞑想")
                        }

                        VStack(spacing: 14) {
                            SectionTitle(title: "ポーズ図鑑", subtitle: "目的に合わせて、無理なく選べる基本ポーズ")
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    CategoryChip(title: "すべて", isSelected: selectedCategory == nil) {
                                        selectedCategory = nil
                                    }
                                    ForEach(categories, id: \.self) { category in
                                        CategoryChip(title: category, isSelected: selectedCategory == category) {
                                            selectedCategory = selectedCategory == category ? nil : category
                                        }
                                    }
                                }
                                .padding(.vertical, 2)
                            }

                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                                ForEach(filtered) { pose in
                                    NavigationLink(value: pose.id) {
                                        PoseCard(pose: pose)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                    .padding(18)
                }
            }
            .navigationTitle("ヨガアトラス")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "ポーズを検索")
            .navigationDestination(for: String.self) { id in
                if let pose = store.pose(for: id) {
                    PoseDetailView(pose: pose)
                }
            }
        }
    }
}

struct SummaryBadge: View {
    let value: String
    let label: String

    var body: some View {
        YogaCard {
            VStack(spacing: 4) {
                Text(value)
                    .font(AppTheme.title(24))
                    .foregroundColor(AppTheme.sageDeep)
                Text(label)
                    .font(AppTheme.caption(12))
                    .foregroundColor(AppTheme.muted)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppTheme.caption(13, weight: .semibold))
                .foregroundColor(isSelected ? .white : AppTheme.sageDeep)
                .padding(.horizontal, 14)
                .padding(.vertical, 9)
                .background(isSelected ? AppTheme.sageDeep : .white.opacity(0.78), in: Capsule())
        }
    }
}

struct PoseCard: View {
    let pose: Pose

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(pose.imageFile)
                .resizable()
                .scaledToFill()
                .frame(height: 130)
                .frame(maxWidth: .infinity)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

            VStack(alignment: .leading, spacing: 5) {
                Text(pose.nameJa)
                    .font(AppTheme.body(17, weight: .semibold))
                    .foregroundColor(AppTheme.ink)
                    .lineLimit(1)
                Text(pose.sanskrit)
                    .font(AppTheme.caption(12))
                    .foregroundColor(AppTheme.muted)
                    .lineLimit(1)
                HStack {
                    Pill(text: "\(pose.duration)分", color: AppTheme.clay)
                    Spacer()
                    DifficultyDots(level: pose.difficulty)
                }
            }
        }
        .padding(10)
        .background(.white.opacity(0.82), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: AppTheme.sageDeep.opacity(0.10), radius: 12, x: 0, y: 8)
    }
}

struct DifficultyDots: View {
    let level: Int

    var body: some View {
        HStack(spacing: 3) {
            ForEach(1...3, id: \.self) { index in
                Circle()
                    .fill(index <= level ? AppTheme.gold : AppTheme.canvasDeep)
                    .frame(width: 7, height: 7)
            }
        }
    }
}
