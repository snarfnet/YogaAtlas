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
                                Pill(text: "Energy Map", color: .white)
                                Text("チャクラで体を読む")
                                    .font(AppTheme.title(31))
                                    .foregroundColor(.white)
                                Text("ポーズの目的を、心と体の感覚でつなげます。")
                                    .font(AppTheme.body(15))
                                    .foregroundColor(.white.opacity(0.92))
                            }
                        }

                        VStack(spacing: 13) {
                            SectionTitle(title: "7つのエネルギー", subtitle: "気になるテーマから練習を選べます")
                            ForEach(Chakra.all) { chakra in
                                ChakraRow(chakra: chakra)
                            }
                        }
                    }
                    .padding(18)
                }
            }
            .navigationTitle("チャクラ")
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
                    Text(chakra.nameJa)
                        .font(AppTheme.title(20))
                        .foregroundColor(AppTheme.ink)
                    Text("\(chakra.nameEn) / \(chakra.location) / \(chakra.element)")
                        .font(AppTheme.caption(12))
                        .foregroundColor(AppTheme.muted)
                    Text(chakra.affirmation)
                        .font(AppTheme.body(14))
                        .foregroundColor(AppTheme.ink)
                        .lineSpacing(3)
                    HStack {
                        ForEach(chakra.keywords, id: \.self) { keyword in
                            Pill(text: keyword, color: Color(hex: chakra.color))
                        }
                    }
                }
                Spacer()
            }
        }
    }
}
