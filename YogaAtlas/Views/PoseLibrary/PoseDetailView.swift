import SwiftUI

struct PoseDetailView: View {
    let pose: Pose

    var body: some View {
        ZStack {
            YogaScreenBackground()
            ScrollView {
                VStack(spacing: 20) {
                    YogaHeroCard(imageName: pose.imageFile, height: 320) {
                        VStack(alignment: .leading, spacing: 8) {
                            Pill(text: pose.localCategory, color: .white)
                            Text(pose.localName)
                                .font(AppTheme.title(32))
                                .foregroundColor(.white)
                            Text(pose.sanskrit)
                                .font(AppTheme.body(16))
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }

                    HStack(spacing: 10) {
                        InfoTile(icon: "clock.fill", title: String(format: String(localized: "pose.duration.min"), pose.duration), subtitle: String(localized: "detail.duration.label"))
                        InfoTile(icon: "flame.fill", title: "Lv.\(pose.difficulty)", subtitle: String(localized: "detail.intensity.label"))
                        InfoTile(icon: "sparkles", title: chakraName(for: pose.chakra), subtitle: String(localized: "detail.chakra.label"))
                    }

                    DetailSection(title: String(localized: "detail.benefits"), items: pose.localBenefits, icon: "leaf.fill")
                    DetailSection(title: String(localized: "detail.instructions"), items: pose.localInstructions, icon: "list.number")
                    DetailSection(title: String(localized: "detail.cautions"), items: pose.localCautions, icon: "exclamationmark.triangle.fill")
                }
                .padding(18)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func chakraName(for id: String) -> String {
        Chakra.all.first { $0.id == id }?.localName ?? "Body"
    }
}

struct InfoTile: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        YogaCard {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(AppTheme.sageDeep)
                Text(title)
                    .font(AppTheme.body(15, weight: .semibold))
                    .foregroundColor(AppTheme.ink)
                    .minimumScaleFactor(0.75)
                    .lineLimit(1)
                Text(subtitle)
                    .font(AppTheme.caption(11))
                    .foregroundColor(AppTheme.muted)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct DetailSection: View {
    let title: String
    let items: [String]
    let icon: String

    var body: some View {
        YogaCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(AppTheme.clay)
                    Text(title)
                        .font(AppTheme.title(20))
                        .foregroundColor(AppTheme.ink)
                }
                ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                    HStack(alignment: .top, spacing: 10) {
                        Text("\(index + 1)")
                            .font(AppTheme.caption(12, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                            .background(AppTheme.sageDeep, in: Circle())
                        Text(item)
                            .font(AppTheme.body(15))
                            .foregroundColor(AppTheme.ink)
                            .lineSpacing(3)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
