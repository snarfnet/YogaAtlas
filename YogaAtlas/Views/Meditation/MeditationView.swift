import SwiftUI

struct MeditationView: View {
    @EnvironmentObject var store: DataStore
    @State private var selectedMeditation: Meditation? = nil

    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.parchment.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 14) {
                        Text("心を静め、内側に繋がりましょう")
                            .font(AppTheme.caption(14))
                            .foregroundColor(AppTheme.inkLight)
                            .padding(.top, 8)

                        ForEach(store.meditations) { meditation in
                            NavigationLink(destination: MeditationTimerView(meditation: meditation)) {
                                MeditationCard(meditation: meditation)
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal)
                        }
                        Spacer(minLength: 32)
                    }
                }
            }
            .navigationTitle("🧘 瞑想")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct MeditationCard: View {
    let meditation: Meditation

    private var chakraColor: Color {
        guard let id = meditation.chakra,
              let c = Chakra.all.first(where: { $0.id == id }) else {
            return AppTheme.lavender
        }
        return Color(hex: c.color)
    }

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(chakraColor.opacity(0.15))
                    .frame(width: 52, height: 52)
                Text(meditation.icon)
                    .font(.system(size: 26))
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(meditation.nameJa)
                    .font(AppTheme.body(16))
                    .foregroundColor(AppTheme.inkBrown)
                Text(meditation.description)
                    .font(AppTheme.caption(12))
                    .foregroundColor(AppTheme.inkLight)
                    .lineLimit(2)
                HStack(spacing: 6) {
                    ForEach(meditation.tags.prefix(3), id: \.self) { tag in
                        Text(tag)
                            .font(.system(size: 10))
                            .foregroundColor(chakraColor)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(chakraColor.opacity(0.1))
                            .cornerRadius(4)
                    }
                }
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(meditation.defaultDuration)分")
                    .font(AppTheme.caption(13))
                    .foregroundColor(AppTheme.goldAccent)
                Image(systemName: "play.circle.fill")
                    .font(.title2)
                    .foregroundColor(AppTheme.goldAccent)
            }
        }
        .padding(12)
        .background(AppTheme.cardBackground())
    }
}
