import SwiftUI

struct DailyYogaView: View {
    @EnvironmentObject var store: DataStore

    private var dailyPoses: [Pose] {
        ["easy_pose", "cat_cow", "tree_pose", "childs_pose"].compactMap { store.pose(for: $0) }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                YogaScreenBackground()
                ScrollView {
                    VStack(spacing: 22) {
                        YogaHeroCard(imageName: "PoseTree", height: 270) {
                            VStack(alignment: .leading, spacing: 9) {
                                Pill(text: "Today Practice", color: .white)
                                Text("今日の10分ヨガ")
                                    .font(AppTheme.title(32))
                                    .foregroundColor(.white)
                                Text("朝の呼吸、背骨、バランス、休息をやさしい流れで。")
                                    .font(AppTheme.body(15))
                                    .foregroundColor(.white.opacity(0.92))
                            }
                        }

                        YogaCard {
                            HStack(spacing: 14) {
                                Image(systemName: "sunrise.fill")
                                    .font(.system(size: 32))
                                    .foregroundColor(AppTheme.gold)
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("今日のテーマ")
                                        .font(AppTheme.body(18, weight: .semibold))
                                        .foregroundColor(AppTheme.ink)
                                    Text("息を急がず、背骨を気持ちよく目覚めさせる。")
                                        .font(AppTheme.body(14))
                                        .foregroundColor(AppTheme.muted)
                                }
                                Spacer()
                            }
                        }

                        VStack(spacing: 14) {
                            SectionTitle(title: "シークエンス", subtitle: "順番に行うと、自然に体が整います")
                            ForEach(Array(dailyPoses.enumerated()), id: \.element.id) { index, pose in
                                NavigationLink(value: pose.id) {
                                    DailyPoseRow(pose: pose, number: index + 1)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(18)
                }
            }
            .navigationTitle("今日のヨガ")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: String.self) { id in
                if let pose = store.pose(for: id) {
                    PoseDetailView(pose: pose)
                }
            }
        }
    }
}

struct DailyPoseRow: View {
    let pose: Pose
    let number: Int

    var body: some View {
        YogaCard {
            HStack(spacing: 14) {
                Text("\(number)")
                    .font(AppTheme.title(20))
                    .foregroundColor(.white)
                    .frame(width: 38, height: 38)
                    .background(AppTheme.sageDeep, in: Circle())

                Image(pose.imageFile)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                VStack(alignment: .leading, spacing: 4) {
                    Text(pose.nameJa)
                        .font(AppTheme.body(17, weight: .semibold))
                        .foregroundColor(AppTheme.ink)
                    Text("\(pose.duration)分 / \(pose.category)")
                        .font(AppTheme.caption(12))
                        .foregroundColor(AppTheme.muted)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(AppTheme.muted)
            }
        }
    }
}
