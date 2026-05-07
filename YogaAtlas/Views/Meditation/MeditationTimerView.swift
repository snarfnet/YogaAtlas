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
                            Pill(text: "\(selectedMinutes) minutes", color: .white)
                            Text(meditation.nameJa)
                                .font(AppTheme.title(31))
                                .foregroundColor(.white)
                            Text(meditation.description)
                                .font(AppTheme.body(15))
                                .foregroundColor(.white.opacity(0.92))
                        }
                    }

                    YogaCard {
                        VStack(spacing: 16) {
                            Text("時間を選ぶ")
                                .font(AppTheme.title(22))
                                .foregroundColor(AppTheme.ink)
                            HStack {
                                ForEach(meditation.durationOptions, id: \.self) { minutes in
                                    Button {
                                        selectedMinutes = minutes
                                    } label: {
                                        Text("\(minutes)分")
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

                    DetailSection(title: "ガイド", items: meditation.instructions, icon: "quote.bubble.fill")
                    DetailSection(title: "期待できること", items: meditation.benefits, icon: "sparkles")
                }
                .padding(18)
            }
        }
        .navigationTitle("瞑想ガイド")
        .navigationBarTitleDisplayMode(.inline)
    }
}
