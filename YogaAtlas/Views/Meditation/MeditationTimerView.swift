import SwiftUI

struct MeditationTimerView: View {
    let meditation: Meditation
    @State private var selectedMinutes: Int

    init(meditation: Meditation) {
        self.meditation = meditation
        _selectedMinutes = State(initialValue: meditation.defaultDuration)
    }

    var body: some View {
        ZStack {
            YogaScreenBackground()
            ScrollView {
                VStack(spacing: 24) {
                    YogaHeroCard(imageName: meditation.id == "chakra" ? "ChakraAura" : "MeditationCorner", height: 310) {
                        VStack(alignment: .leading, spacing: 9) {
                            Pill(text: String(format: String(localized: "med.timer.minutes"), selectedMinutes), color: .white)
                            Text(meditation.localName)
                                .font(AppTheme.title(31))
                                .foregroundColor(.white)
                            Text(meditation.localDescription)
                                .font(AppTheme.body(15))
                                .foregroundColor(.white.opacity(0.92))
                        }
                    }

                    YogaCard {
                        VStack(spacing: 16) {
                            Text(String(localized: "med.timer.select"))
                                .font(AppTheme.title(22))
                                .foregroundColor(AppTheme.ink)
                            HStack {
                                ForEach(meditation.durationOptions, id: \.self) { minutes in
                                    Button {
                                        selectedMinutes = minutes
                                    } label: {
                                        Text(String(format: String(localized: "med.timer.min"), minutes))
                                            .font(AppTheme.body(15, weight: .semibold))
                                            .foregroundColor(selectedMinutes == minutes ? .white : AppTheme.sageDeep)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 12)
                                            .background(selectedMinutes == minutes ? AppTheme.sageDeep : AppTheme.sage.opacity(0.15), in: Capsule())
                                    }
                                }
                            }
                        }
                    }

                    DetailSection(title: String(localized: "med.timer.guide"), items: meditation.localInstructions, icon: "quote.bubble.fill")
                    DetailSection(title: String(localized: "med.timer.benefits"), items: meditation.localBenefits, icon: "sparkles")
                }
                .padding(18)
            }
        }
        .navigationTitle(String(localized: "med.timer.nav"))
        .navigationBarTitleDisplayMode(.inline)
    }
}
