import SwiftUI

struct OfficeYogaView: View {
    private let routines: [(titleKey: String, timeKey: String, icon: String, detailKey: String)] = [
        ("office.r1.title", "office.r1.time", "person.fill", "office.r1.detail"),
        ("office.r2.title", "office.r2.time", "arrow.up.and.down.and.arrow.left.and.right", "office.r2.detail"),
        ("office.r3.title", "office.r3.time", "eye.fill", "office.r3.detail"),
        ("office.r4.title", "office.r4.time", "bolt.fill", "office.r4.detail")
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                YogaScreenBackground()
                ScrollView {
                    VStack(spacing: 22) {
                        YogaHeroCard(imageName: "OfficeStretch", height: 285) {
                            VStack(alignment: .leading, spacing: 9) {
                                Pill(text: String(localized: "office.hero.tag"), color: .white)
                                Text(String(localized: "office.hero.title"))
                                    .font(AppTheme.title(31))
                                    .foregroundColor(.white)
                                Text(String(localized: "office.hero.subtitle"))
                                    .font(AppTheme.body(15))
                                    .foregroundColor(.white.opacity(0.92))
                            }
                        }

                        VStack(spacing: 14) {
                            SectionTitle(title: String(localized: "office.section.title"), subtitle: String(localized: "office.section.subtitle"))
                            ForEach(routines, id: \.titleKey) { routine in
                                YogaCard {
                                    HStack(spacing: 14) {
                                        Image(systemName: routine.icon)
                                            .font(.system(size: 22))
                                            .foregroundColor(.white)
                                            .frame(width: 50, height: 50)
                                            .background(AppTheme.sageDeep, in: Circle())
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text(String(localized: String.LocalizationValue(routine.titleKey)))
                                                .font(AppTheme.title(20))
                                                .foregroundColor(AppTheme.ink)
                                            Text(String(localized: String.LocalizationValue(routine.detailKey)))
                                                .font(AppTheme.body(14))
                                                .foregroundColor(AppTheme.muted)
                                                .lineSpacing(3)
                                        }
                                        Spacer()
                                        Pill(text: String(localized: String.LocalizationValue(routine.timeKey)), color: AppTheme.clay)
                                    }
                                }
                            }
                        }
                    }
                    .padding(18)
                }
            }
            .navigationTitle(String(localized: "office.nav.title"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
