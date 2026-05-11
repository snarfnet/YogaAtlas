import SwiftUI

struct ChakraView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                YogaScreenBackground()
                ScrollView {
                    VStack(spacing: 22) {
                        YogaHeroCard(imageName: "ChakraAura", height: 310) {
                            VStack(alignment: .leading, spacing: 9) {
                                Pill(text: String(localized: "chakra.hero.tag"), color: .white)
                                Text(String(localized: "chakra.hero.title"))
                                    .font(AppTheme.title(31))
                                    .foregroundColor(.white)
                                Text(String(localized: "chakra.hero.subtitle"))
                                    .font(AppTheme.body(15))
                                    .foregroundColor(.white.opacity(0.92))
                            }
                        }

                        VStack(spacing: 13) {
                            SectionTitle(title: String(localized: "chakra.section.title"), subtitle: String(localized: "chakra.section.subtitle"))
                            ForEach(Chakra.all) { chakra in
                                ChakraRow(chakra: chakra)
                            }
                        }
                    }
                    .padding(18)
                }
            }
            .navigationTitle(String(localized: "chakra.nav.title"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ChakraRow: View {
    let chakra: Chakra

    var body: some View {
        YogaCard {
            HStack(alignment: .top, spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color(hex: chakra.color).opacity(0.20))
                        .frame(width: 58, height: 58)
                    Circle()
                        .fill(Color(hex: chakra.color))
                        .frame(width: 34, height: 34)
                    Text("\(chakra.number)")
                        .font(AppTheme.caption(12, weight: .bold))
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 7) {
                    Text(chakra.localName)
                        .font(AppTheme.title(20))
                        .foregroundColor(AppTheme.ink)
                    Text("\(chakra.nameEn) / \(chakra.localLocation) / \(chakra.localElement)")
                        .font(AppTheme.caption(12))
                        .foregroundColor(AppTheme.muted)
                    Text(chakra.localAffirmation)
                        .font(AppTheme.body(14))
                        .foregroundColor(AppTheme.ink)
                        .lineSpacing(3)
                    HStack {
                        ForEach(chakra.localKeywords, id: \.self) { keyword in
                            Pill(text: keyword, color: Color(hex: chakra.color))
                        }
                    }
                }
                Spacer()
            }
        }
    }
}
