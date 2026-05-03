import SwiftUI

struct PoseDetailView: View {
    let pose: Pose

    var body: some View {
        ZStack {
            AppTheme.parchment.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // Hero image
                    ZStack {
                        Rectangle()
                            .fill(AppTheme.parchmentDark)
                            .frame(height: 260)
                        if let uiImage = UIImage(named: pose.imageFile) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 260)
                                .clipped()
                        } else {
                            Text("🧘")
                                .font(.system(size: 80))
                        }
                        // Golden overlay at bottom
                        VStack {
                            Spacer()
                            LinearGradient(
                                colors: [.clear, AppTheme.parchment],
                                startPoint: .top, endPoint: .bottom
                            )
                            .frame(height: 80)
                        }
                    }

                    // Title block
                    VStack(alignment: .leading, spacing: 4) {
                        Text(pose.nameJa)
                            .font(AppTheme.title(26))
                            .foregroundColor(AppTheme.inkBrown)
                        Text(pose.nameEn)
                            .font(AppTheme.body(16))
                            .foregroundColor(AppTheme.inkLight)
                        Text(pose.sanskrit)
                            .font(.custom("Georgia-Italic", size: 14))
                            .foregroundColor(AppTheme.goldAccent)
                    }
                    .padding(.horizontal)

                    // Tags row
                    HStack(spacing: 10) {
                        TagBadge(label: pose.category, color: AppTheme.sage)
                        TagBadge(label: "難易度 \(String(repeating: "●", count: pose.difficulty))", color: AppTheme.dustyRose)
                        TagBadge(label: "\(pose.duration)分", color: AppTheme.lavender)
                    }
                    .padding(.horizontal)

                    Divider().background(AppTheme.goldAccent.opacity(0.3)).padding(.horizontal)

                    // Benefits
                    SectionBlock(title: "✨ 効能", items: pose.benefits)

                    // Instructions
                    NumberedBlock(title: "📋 やり方", items: pose.instructions)

                    // Cautions
                    if !pose.cautions.isEmpty {
                        SectionBlock(title: "⚠️ 注意点", items: pose.cautions, color: AppTheme.dustyRose)
                    }

                    // Chakra
                    ChakraBadgeRow(chakraId: pose.chakra)
                        .padding(.horizontal)

                    Spacer(minLength: 32)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Sub-views
struct TagBadge: View {
    let label: String
    let color: Color

    var body: some View {
        Text(label)
            .font(AppTheme.caption(12))
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(color.opacity(0.8))
            .clipShape(Capsule())
    }
}

struct SectionBlock: View {
    let title: String
    let items: [String]
    var color: Color = AppTheme.sage

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(AppTheme.title(16))
                .foregroundColor(AppTheme.inkBrown)
                .padding(.horizontal)
            ForEach(items, id: \.self) { item in
                HStack(alignment: .top, spacing: 8) {
                    Circle()
                        .fill(color)
                        .frame(width: 6, height: 6)
                        .padding(.top, 6)
                    Text(item)
                        .font(AppTheme.body(15))
                        .foregroundColor(AppTheme.inkBrown)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal)
            }
        }
    }
}

struct NumberedBlock: View {
    let title: String
    let items: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(AppTheme.title(16))
                .foregroundColor(AppTheme.inkBrown)
                .padding(.horizontal)
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                HStack(alignment: .top, spacing: 10) {
                    Text("\(index + 1)")
                        .font(AppTheme.caption(13))
                        .foregroundColor(.white)
                        .frame(width: 22, height: 22)
                        .background(AppTheme.goldAccent)
                        .clipShape(Circle())
                    Text(item)
                        .font(AppTheme.body(15))
                        .foregroundColor(AppTheme.inkBrown)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal)
            }
        }
    }
}

struct ChakraBadgeRow: View {
    let chakraId: String

    private var chakra: Chakra? {
        Chakra.all.first { $0.id == chakraId }
    }

    var body: some View {
        if let c = chakra {
            HStack(spacing: 10) {
                Circle()
                    .fill(Color(hex: c.color))
                    .frame(width: 18, height: 18)
                Text("対応チャクラ: \(c.nameJa) (\(c.nameEn))")
                    .font(AppTheme.body(14))
                    .foregroundColor(AppTheme.inkBrown)
            }
        }
    }
}
