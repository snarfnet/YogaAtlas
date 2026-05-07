import SwiftUI

struct MeditationView: View {
    @EnvironmentObject var store: DataStore

    var body: some View {
        NavigationStack {
            ZStack {
                YogaScreenBackground()
                ScrollView {
                    VStack(spacing: 22) {
                        YogaHeroCard(imageName: "MeditationCorner", height: 280) {
                            VStack(alignment: .leading, spacing: 9) {
                                Pill(text: "Meditation", color: .white)
                                Text("静けさを、練習にする。")
                                    .font(AppTheme.title(31))
                                    .foregroundColor(.white)
                                Text("数分でも呼吸へ戻ると、体の感覚が変わります。")
                                    .font(AppTheme.body(15))
                                    .foregroundColor(.white.opacity(0.92))
                            }
                        }

                        ForEach(store.meditations) { meditation in
                            NavigationLink(destination: MeditationTimerView(meditation: meditation)) {
                                MeditationCard(meditation: meditation)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(18)
                }
            }
            .navigationTitle("瞑想")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct MeditationCard: View {
    let meditation: Meditation

    var body: some View {
        YogaCard {
            HStack(spacing: 14) {
                Image(systemName: meditation.icon)
                    .font(.system(size: 25))
                    .foregroundColor(.white)
                    .frame(width: 52, height: 52)
                    .background(AppTheme.lavender, in: Circle())
                VStack(alignment: .leading, spacing: 5) {
                    Text(meditation.nameJa)
                        .font(AppTheme.title(21))
                        .foregroundColor(AppTheme.ink)
                    Text(meditation.description)
                        .font(AppTheme.body(14))
                        .foregroundColor(AppTheme.muted)
                        .lineLimit(2)
                    HStack {
                        ForEach(meditation.tags, id: \.self) { tag in
                            Pill(text: tag, color: AppTheme.lavender)
                        }
                    }
                }
                Spacer()
                Image(systemName: "play.fill")
                    .foregroundColor(AppTheme.sageDeep)
            }
        }
    }
}
