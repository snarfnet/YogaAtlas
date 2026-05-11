import SwiftUI

struct PoseLibraryView: View {
    @EnvironmentObject var store: DataStore
    @State private var searchText = ""
    @State private var selectedCategory: String? = nil

    private var categories: [String] {
        Array(Set(store.poses.map(\.localCategory))).sorted()
    }

    private var filtered: [Pose] {
        store.poses.filter { pose in
            let matchesText = searchText.isEmpty
                || pose.nameJa.localizedCaseInsensitiveContains(searchText)
                || pose.nameEn.localizedCaseInsensitiveContains(searchText)
                || pose.sanskrit.localizedCaseInsensitiveContains(searchText)
            let matchesCategory = selectedCategory == nil || pose.localCategory == selectedCategory
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
                                Pill(text: String(localized: "pose.hero.tag"), color: .white)
                                Text(String(localized: "pose.hero.title"))
                                    .font(AppTheme.title(30))
                                    .foregroundColor(.white)
                                Text(String(localized: "pose.hero.subtitle"))
                                    .font(AppTheme.body(15))
                                    .foregroundColor(.white.opacity(0.92))
                                    .lineSpacing(3)
                            }
                        }

                        HStack(spacing: 10) {
                            SummaryBadge(value: "\(store.poses.count)", label: String(localized: "pose.badge.poses"))
                            SummaryBadge(value: "\(store.symptoms.count)", label: String(localized: "pose.badge.symptoms"))
                            SummaryBadge(value: "\(store.meditations.count)", label: String(localized: "pose.badge.meditations"))
                        }

                        VStack(spacing: 14) {
                            SectionTitle(title: String(localized: "pose.section.title"), subtitle: String(localized: "pose.section.subtitle"))
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    CategoryChip(title: String(localized: "pose.filter.all"), isSelected: selectedCategory == nil) {
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
            .navigationTitle(String(localized: "pose.nav.title"))
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: String(localized: "pose.search.prompt"))
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
                Text(pose.localName)
                    .font(AppTheme.body(17, weight: .semibold))
                    .foregroundColor(AppTheme.ink)
                    .lineLimit(1)
                Text(pose.sanskrit)
                    .font(AppTheme.caption(12))
                    .foregroundColor(AppTheme.muted)
                    .lineLimit(1)
                HStack {
                    Pill(text: String(format: String(localized: "pose.duration.min"), pose.duration), color: AppTheme.clay)
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
