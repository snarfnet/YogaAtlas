import SwiftUI

struct ChakraView: View {
    @EnvironmentObject var store: DataStore
    @State private var selected: Chakra? = nil

    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.parchment.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 0) {
                        // Header illustration
                        Text("🌈")
                            .font(.system(size: 48))
                            .padding(.top, 16)

                        Text("7つのチャクラ")
                            .font(AppTheme.title(20))
                            .foregroundColor(AppTheme.inkBrown)
                            .padding(.bottom, 4)
                        Text("エネルギーセンターを診断し、対応ポーズを実践しましょう")
                            .font(AppTheme.caption(13))
                            .foregroundColor(AppTheme.inkLight)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                            .padding(.bottom, 20)

                        // Chakra spine
                        ForEach(Chakra.all.reversed()) { chakra in
                            ChakraRow(chakra: chakra, isSelected: selected?.id == chakra.id)
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        selected = selected?.id == chakra.id ? nil : chakra
                                    }
                                }

                            if selected?.id == chakra.id {
                                ChakraDetail(chakra: chakra, poses: store.poses)
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                        }
                        Spacer(minLength: 32)
                    }
                }
            }
            .navigationTitle("🔮 チャクラ")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct ChakraRow: View {
    let chakra: Chakra
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 14) {
            // Color ball
            ZStack {
                Circle()
                    .fill(Color(hex: chakra.color).opacity(0.2))
                    .frame(width: 50, height: 50)
                Circle()
                    .fill(Color(hex: chakra.color))
                    .frame(width: 34, height: 34)
                Text("\(chakra.number)")
                    .font(AppTheme.caption(14))
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(chakra.nameJa)
                    .font(AppTheme.body(16))
                    .foregroundColor(AppTheme.inkBrown)
                Text(chakra.sanskritName)
                    .font(.custom("Georgia-Italic", size: 12))
                    .foregroundColor(AppTheme.goldAccent)
                Text(chakra.keywords.prefix(3).joined(separator: " · "))
                    .font(AppTheme.caption(12))
                    .foregroundColor(AppTheme.inkLight)
            }
            Spacer()
            Image(systemName: isSelected ? "chevron.up" : "chevron.down")
                .foregroundColor(AppTheme.goldAccent)
                .font(.caption)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(isSelected ? Color(hex: chakra.color).opacity(0.08) : Color.clear)
    }
}

struct ChakraDetail: View {
    let chakra: Chakra
    let poses: [Pose]

    private var relatedPoses: [Pose] {
        chakra.poseIds.compactMap { id in poses.first { $0.id == id } }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Affirmation
            Text("「\(chakra.affirmation)」")
                .font(.custom("Georgia-Italic", size: 15))
                .foregroundColor(Color(hex: chakra.color))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(hex: chakra.color).opacity(0.1))
                .cornerRadius(10)

            // Info
            HStack(spacing: 20) {
                InfoPill(icon: "📍", label: chakra.location)
                InfoPill(icon: "🌿", label: chakra.element)
            }

            // Related poses
            if !relatedPoses.isEmpty {
                Text("対応ポーズ")
                    .font(AppTheme.caption(13))
                    .foregroundColor(AppTheme.inkLight)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(relatedPoses) { pose in
                            NavigationLink(destination: PoseDetailView(pose: pose)) {
                                MiniPoseCard(pose: pose, accentColor: Color(hex: chakra.color))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
}

struct InfoPill: View {
    let icon: String
    let label: String

    var body: some View {
        HStack(spacing: 4) {
            Text(icon).font(.caption)
            Text(label).font(AppTheme.caption(13)).foregroundColor(AppTheme.inkBrown)
        }
    }
}

struct MiniPoseCard: View {
    let pose: Pose
    let accentColor: Color

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(accentColor.opacity(0.15))
                    .frame(width: 80, height: 80)
                Text("🧘").font(.system(size: 30))
            }
            Text(pose.nameJa)
                .font(AppTheme.caption(11))
                .foregroundColor(AppTheme.inkBrown)
                .frame(width: 80)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
    }
}
