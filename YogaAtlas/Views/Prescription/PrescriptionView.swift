import SwiftUI

struct PrescriptionView: View {
    @EnvironmentObject var store: DataStore
    @State private var selected: Symptom? = nil

    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.parchment.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 12) {
                        Text("今日の不調を選んでください")
                            .font(AppTheme.caption(14))
                            .foregroundColor(AppTheme.inkLight)
                            .padding(.top, 8)

                        ForEach(store.symptoms) { symptom in
                            SymptomCard(symptom: symptom)
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        selected = selected?.id == symptom.id ? nil : symptom
                                    }
                                }

                            if selected?.id == symptom.id {
                                SymptomPrescriptionPanel(symptom: symptom, poses: store.poses)
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                                    .padding(.horizontal)
                            }
                        }
                        Spacer(minLength: 32)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("💊 症状別処方箋")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct SymptomCard: View {
    let symptom: Symptom

    var body: some View {
        HStack(spacing: 14) {
            Text(symptom.icon)
                .font(.system(size: 28))
                .frame(width: 44, height: 44)
                .background(AppTheme.parchmentDark)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            VStack(alignment: .leading, spacing: 2) {
                Text(symptom.nameJa)
                    .font(AppTheme.body(16))
                    .foregroundColor(AppTheme.inkBrown)
                Text(symptom.description)
                    .font(AppTheme.caption(12))
                    .foregroundColor(AppTheme.inkLight)
                    .lineLimit(2)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(AppTheme.goldAccent)
                .font(.caption)
        }
        .padding(12)
        .background(AppTheme.cardBackground())
    }
}

struct SymptomPrescriptionPanel: View {
    let symptom: Symptom
    let poses: [Pose]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Recommended poses
            Text("処方ポーズ")
                .font(AppTheme.title(15))
                .foregroundColor(AppTheme.inkBrown)

            ForEach(symptom.recommendedPoses, id: \.poseId) { rec in
                if let pose = poses.first(where: { $0.id == rec.poseId }) {
                    NavigationLink(destination: PoseDetailView(pose: pose)) {
                        PrescriptionPoseRow(pose: pose, reason: rec.reason, duration: rec.duration)
                    }
                    .buttonStyle(.plain)
                }
            }

            // Tips
            if !symptom.tips.isEmpty {
                Divider().background(AppTheme.goldAccent.opacity(0.3))
                Text("💡 アドバイス")
                    .font(AppTheme.title(15))
                    .foregroundColor(AppTheme.inkBrown)
                ForEach(symptom.tips, id: \.self) { tip in
                    HStack(alignment: .top, spacing: 8) {
                        Text("•").foregroundColor(AppTheme.goldAccent)
                        Text(tip)
                            .font(AppTheme.body(14))
                            .foregroundColor(AppTheme.inkBrown)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }

            // Avoid
            if !symptom.avoidPoses.isEmpty {
                HStack(spacing: 6) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(AppTheme.dustyRose)
                        .font(.caption)
                    Text("避けるべきポーズ: \(symptom.avoidPoses.joined(separator: ", "))")
                        .font(AppTheme.caption(12))
                        .foregroundColor(AppTheme.dustyRose)
                }
            }
        }
        .padding(14)
        .background(AppTheme.parchmentDark.opacity(0.5))
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppTheme.goldAccent.opacity(0.3)))
    }
}

struct PrescriptionPoseRow: View {
    let pose: Pose
    let reason: String
    let duration: Int

    var body: some View {
        HStack(spacing: 12) {
            Text("🧘")
                .font(.system(size: 24))
                .frame(width: 40, height: 40)
                .background(AppTheme.parchmentDark)
                .cornerRadius(8)
            VStack(alignment: .leading, spacing: 2) {
                Text(pose.nameJa)
                    .font(AppTheme.body(15))
                    .foregroundColor(AppTheme.inkBrown)
                Text(reason)
                    .font(AppTheme.caption(12))
                    .foregroundColor(AppTheme.inkLight)
                    .lineLimit(2)
            }
            Spacer()
            Text("\(duration)分")
                .font(AppTheme.caption(12))
                .foregroundColor(AppTheme.goldAccent)
        }
        .padding(.vertical, 4)
    }
}
