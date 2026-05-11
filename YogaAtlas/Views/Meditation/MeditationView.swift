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
                                Pill(text: String(localized: "med.hero.tag"), color: .white)
                                Text(String(localized: "med.hero.title"))
                                    .font(AppTheme.title(31))
                                    .foregroundColor(.white)
                                Text(String(localized: "med.hero.subtitle"))
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
            .navigationTitle(String(localized: "med.nav.title"))
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
                    Text(meditation.localName)
                        .font(AppTheme.title(21))
                        .foregroundColor(AppTheme.ink)
                    Text(meditation.localDescription)
                        .font(AppTheme.body(14))
                        .foregroundColor(AppTheme.muted)
                        .lineLimit(2)
                    HStack {
                        ForEach(meditation.localTags, id: \.self) { tag in
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
