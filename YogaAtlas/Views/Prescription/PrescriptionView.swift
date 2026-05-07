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
                                Pill(text: "Care Guide", color: .white)
                                Text("悩みから選ぶヨガ")
                                    .font(AppTheme.title(31))
                                    .foregroundColor(.white)
                                Text("疲れ、肩こり、眠り。今日の状態に合うやさしい処方です。")
                                    .font(AppTheme.body(15))
                                    .foregroundColor(.white.opacity(0.92))
                            }
                        }

                        VStack(spacing: 14) {
                            SectionTitle(title: "体調別ガイド", subtitle: "無理に頑張らず、必要なケアから始めましょう")
                            ForEach(store.symptoms) { symptom in
                                SymptomCard(symptom: symptom)
                            }
                        }
                    }
                    .padding(18)
                }
            }
            .navigationTitle("悩み別")
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
                        Text(symptom.nameJa)
                            .font(AppTheme.title(21))
                            .foregroundColor(AppTheme.ink)
                        Text(symptom.description)
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
                                    Text(pose.nameJa)
                                        .font(AppTheme.body(15, weight: .semibold))
                                        .foregroundColor(AppTheme.ink)
                                    Text(item.reason)
                                        .font(AppTheme.caption(12))
                                        .foregroundColor(AppTheme.muted)
                                }
                                Spacer()
                                Pill(text: "\(item.duration)分", color: AppTheme.sageDeep)
                            }
                        }
                    }
                }
            }
        }
    }
}
