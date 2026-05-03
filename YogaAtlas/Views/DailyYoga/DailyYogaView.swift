import SwiftUI

struct DailyYogaView: View {
    @EnvironmentObject var store: DataStore

    private var moonPhase: MoonPhase { MoonPhase.current() }
    private var weekday: Int { Calendar.current.component(.weekday, from: Date()) }
    private var dailyPoses: [Pose] { moonPhase.recommendedPoseIds.compactMap { store.pose(for: $0) } }

    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.parchment.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 20) {

                        // Moon phase card
                        VStack(spacing: 8) {
                            Text(moonPhase.emoji)
                                .font(.system(size: 56))
                            Text(moonPhase.nameJa)
                                .font(AppTheme.title(22))
                                .foregroundColor(AppTheme.inkBrown)
                            Text(moonPhase.description)
                                .font(AppTheme.body(14))
                                .foregroundColor(AppTheme.inkLight)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                        }
                        .padding(.vertical, 24)
                        .frame(maxWidth: .infinity)
                        .background(
                            ZStack {
                                AppTheme.parchmentDark
                                LinearGradient(
                                    colors: [AppTheme.lavender.opacity(0.15), Color.clear],
                                    startPoint: .top, endPoint: .bottom
                                )
                            }
                        )
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(AppTheme.goldAccent.opacity(0.3)))
                        .padding(.horizontal)

                        // Weekday focus
                        HStack {
                            Text(WeekdayFocus.label(for: weekday))
                                .font(AppTheme.caption(13))
                                .foregroundColor(AppTheme.inkLight)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(AppTheme.parchmentDark)
                                .cornerRadius(8)
                            Spacer()
                        }
                        .padding(.horizontal)

                        // Today's sequence
                        VStack(alignment: .leading, spacing: 12) {
                            Text("今日のシーケンス")
                                .font(AppTheme.title(17))
                                .foregroundColor(AppTheme.inkBrown)
                                .padding(.horizontal)

                            if dailyPoses.isEmpty {
                                Text("ポーズデータを読み込み中…")
                                    .font(AppTheme.body(14))
                                    .foregroundColor(AppTheme.inkLight)
                                    .padding(.horizontal)
                            } else {
                                ForEach(Array(dailyPoses.enumerated()), id: \.element.id) { index, pose in
                                    NavigationLink(destination: PoseDetailView(pose: pose)) {
                                        DailyPoseRow(pose: pose, number: index + 1)
                                    }
                                    .buttonStyle(.plain)
                                    .padding(.horizontal)
                                }
                            }
                        }

                        Spacer(minLength: 32)
                    }
                    .padding(.top, 8)
                }
            }
            .navigationTitle("🌙 今日のヨガ")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct DailyPoseRow: View {
    let pose: Pose
    let number: Int

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle().fill(AppTheme.goldAccent).frame(width: 28, height: 28)
                Text("\(number)").font(AppTheme.caption(12)).foregroundColor(.white).fontWeight(.bold)
            }
            Text("🧘").font(.system(size: 22))
            VStack(alignment: .leading, spacing: 1) {
                Text(pose.nameJa).font(AppTheme.body(15)).foregroundColor(AppTheme.inkBrown)
                Text(pose.sanskrit).font(AppTheme.caption(11)).foregroundColor(AppTheme.inkLight)
            }
            Spacer()
            Text("\(pose.duration)分").font(AppTheme.caption(12)).foregroundColor(AppTheme.goldAccent)
            Image(systemName: "chevron.right").font(.caption).foregroundColor(AppTheme.inkLight)
        }
        .padding(12)
        .background(AppTheme.cardBackground())
    }
}

// MARK: - Moon Phase
enum MoonPhase {
    case newMoon, waxingCrescent, firstQuarter, waxingGibbous
    case fullMoon, waningGibbous, lastQuarter, waningCrescent

    var emoji: String {
        switch self {
        case .newMoon: return "🌑"
        case .waxingCrescent: return "🌒"
        case .firstQuarter: return "🌓"
        case .waxingGibbous: return "🌔"
        case .fullMoon: return "🌕"
        case .waningGibbous: return "🌖"
        case .lastQuarter: return "🌗"
        case .waningCrescent: return "🌘"
        }
    }

    var nameJa: String {
        switch self {
        case .newMoon: return "新月"
        case .waxingCrescent: return "三日月"
        case .firstQuarter: return "上弦の月"
        case .waxingGibbous: return "十日夜"
        case .fullMoon: return "満月"
        case .waningGibbous: return "十六夜"
        case .lastQuarter: return "下弦の月"
        case .waningCrescent: return "有明月"
        }
    }

    var description: String {
        switch self {
        case .newMoon: return "浄化とリセットの時。内省ヨガで新しいサイクルを始めましょう。"
        case .waxingCrescent: return "意図を育てる時。エネルギーを高めるポーズで意志を強化。"
        case .firstQuarter: return "行動の時。力強いポーズで決断力を高めましょう。"
        case .waxingGibbous: return "洗練の時。バランスポーズで調整と集中を。"
        case .fullMoon: return "エネルギー最大。感謝と解放のプラクティスを。"
        case .waningGibbous: return "分かち合いの時。回復系ポーズで身体を癒して。"
        case .lastQuarter: return "手放しの時。ツイストで不要なものを排出。"
        case .waningCrescent: return "休息と統合の時。深い瞑想とリストラティブヨガを。"
        }
    }

    var recommendedPoseIds: [String] {
        switch self {
        case .newMoon:      return ["childs_pose", "easy_pose", "corpse_pose"]
        case .waxingCrescent: return ["sun_salutation", "mountain_pose", "tree_pose"]
        case .firstQuarter: return ["warrior_i", "boat_pose", "triangle"]
        case .waxingGibbous: return ["tree_pose", "bound_angle", "seated_forward_bend"]
        case .fullMoon:     return ["upward_bow", "bridge_pose", "legs_up_wall"]
        case .waningGibbous: return ["downward_dog", "cobra_pose", "reclining_bound_angle"]
        case .lastQuarter:  return ["seated_twist", "standing_forward_bend", "cat_cow"]
        case .waningCrescent: return ["corpse_pose", "childs_pose", "easy_pose"]
        }
    }

    static func current() -> MoonPhase {
        // Simplified moon phase calculation based on known new moon date
        let known = DateComponents(calendar: .current, year: 2000, month: 1, day: 6).date!
        let days = Calendar.current.dateComponents([.day], from: known, to: Date()).day ?? 0
        let cycle = ((days % 30) + 30) % 30
        switch cycle {
        case 0...1:   return .newMoon
        case 2...6:   return .waxingCrescent
        case 7...8:   return .firstQuarter
        case 9...13:  return .waxingGibbous
        case 14...15: return .fullMoon
        case 16...21: return .waningGibbous
        case 22...23: return .lastQuarter
        default:      return .waningCrescent
        }
    }
}

enum WeekdayFocus {
    static func label(for weekday: Int) -> String {
        let focuses = ["", "☀️ 日曜: 活性・太陽礼拝", "🌙 月曜: 静寂・内省",
                       "🔥 火曜: 力強さ・戦士",  "💧 水曜: 柔軟性・フロー",
                       "🌿 木曜: 成長・バランス", "💎 金曜: 美・心臓開放",
                       "🌍 土曜: グラウンディング"]
        return weekday < focuses.count ? focuses[weekday] : ""
    }
}
