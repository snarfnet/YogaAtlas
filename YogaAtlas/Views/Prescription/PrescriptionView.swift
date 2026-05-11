import SwiftUI

struct PrescriptionView: View {
    @EnvironmentObject var store: DataStore

    var body: some View {
        NavigationStack {
            ZStack {
                YogaScreenBackground()
                ScrollView {
                    VStack(spacing: 22) {
                        YogaHeroCard(imageName: "RestorativeProps", height: 265) {
                            VStack(alignment: .leading, spacing: 9) {
                                Pill(text: String(localized: "rx.hero.tag"), color: .white)
                                Text(String(localized: "rx.hero.title"))
                                    .font(AppTheme.title(31))
                                    .foregroundColor(.white)
                                Text(String(localized: "rx.hero.subtitle"))
                                    .font(AppTheme.body(15))
                                    .foregroundColor(.white.opacity(0.92))
                            }
                        }

                        VStack(spacing: 14) {
                            SectionTitle(title: String(localized: "rx.section.title"), subtitle: String(localized: "rx.section.subtitle"))
                            ForEach(store.symptoms) { symptom in
                                SymptomCard(symptom: symptom)
                            }
                        }
                    }
                    .padding(18)
                }
            }
            .navigationTitle(String(localized: "rx.nav.title"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SymptomCard: View {
    @EnvironmentObject var store: DataStore
    let symptom: Symptom

    var body: some View {
        YogaCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 12) {
                    Image(systemName: symptom.icon)
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .frame(width: 48, height: 48)
                        .background(AppTheme.clay, in: Circle())
                    VStack(alignment: .leading, spacing: 4) {
                        Text(symptom.localName)
                            .font(AppTheme.title(21))
                            .foregroundColor(AppTheme.ink)
                        Text(symptom.localDescription)
                            .font(AppTheme.body(14))
                            .foregroundColor(AppTheme.muted)
                            .lineSpacing(3)
                    }
                }

                VStack(spacing: 10) {
                    ForEach(symptom.recommendedPoses, id: \.poseId) { item in
                        if let pose = store.pose(for: item.poseId) {
                            HStack(spacing: 10) {
                                Image(pose.imageFile)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 54, height: 54)
                                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(pose.localName)
                                        .font(AppTheme.body(15, weight: .semibold))
                                        .foregroundColor(AppTheme.ink)
                                    Text(item.localReason)
                                        .font(AppTheme.caption(12))
                                        .foregroundColor(AppTheme.muted)
                                }
                                Spacer()
                                Pill(text: String(format: String(localized: "pose.duration.min"), item.duration), color: AppTheme.sageDeep)
                            }
                        }
                    }
                }
            }
        }
    }
}
