import SwiftUI

struct OfficeYogaView: View {
    @State private var selectedRoutine: OfficeRoutine? = nil

    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.parchment.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 16) {
                        // Banner
                        HStack(spacing: 12) {
                            Text("💻")
                                .font(.system(size: 36))
                            VStack(alignment: .leading, spacing: 2) {
                                Text("デスクワーカーのためのヨガ")
                                    .font(AppTheme.title(16))
                                    .foregroundColor(AppTheme.inkBrown)
                                Text("椅子に座ったまま・立ち上がって5分")
                                    .font(AppTheme.caption(13))
                                    .foregroundColor(AppTheme.inkLight)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(AppTheme.parchmentDark)
                        .cornerRadius(12)
                        .padding(.horizontal)

                        // Routines
                        ForEach(OfficeRoutine.all) { routine in
                            OfficeRoutineCard(routine: routine)
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        selectedRoutine = selectedRoutine?.id == routine.id ? nil : routine
                                    }
                                }
                                .padding(.horizontal)

                            if selectedRoutine?.id == routine.id {
                                OfficeRoutineDetail(routine: routine)
                                    .padding(.horizontal)
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                        }
                        Spacer(minLength: 32)
                    }
                    .padding(.top, 8)
                }
            }
            .navigationTitle("💻 オフィスヨガ")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Models
struct OfficeRoutine: Identifiable {
    let id: String
    let emoji: String
    let nameJa: String
    let duration: Int
    let target: String
    let steps: [OfficeStep]
}

struct OfficeStep: Identifiable {
    let id = UUID()
    let nameJa: String
    let instruction: String
    let duration: Int
    let isChairBased: Bool
}

extension OfficeRoutine {
    static let all: [OfficeRoutine] = [
        OfficeRoutine(id: "neck_shoulder", emoji: "💆", nameJa: "首・肩リセット", duration: 5, target: "首・肩こり",
            steps: [
                OfficeStep(nameJa: "首横倒し", instruction: "右耳を右肩に近づけ、左腕を下に伸ばす。10秒×両側。", duration: 20, isChairBased: true),
                OfficeStep(nameJa: "肩甲骨寄せ", instruction: "両肩を後ろに引いて肩甲骨を寄せ、3秒キープ×5回。", duration: 30, isChairBased: true),
                OfficeStep(nameJa: "胸開き", instruction: "指を後頭部で組み、肘を開いて深呼吸3回。", duration: 30, isChairBased: true),
                OfficeStep(nameJa: "肩回し", instruction: "両肩を前→上→後→下と大きく10回回す。", duration: 30, isChairBased: true),
                OfficeStep(nameJa: "椅子ツイスト", instruction: "背もたれを右手でつかみ上半身を右にひねる。10秒×両側。", duration: 30, isChairBased: true),
            ]),
        OfficeRoutine(id: "back_core", emoji: "🦴", nameJa: "腰・背中リリース", duration: 5, target: "腰痛・姿勢改善",
            steps: [
                OfficeStep(nameJa: "猫牛（椅子版）", instruction: "椅子に浅く座り、息を吸って背中を反らし、吐いて丸める。10回。", duration: 40, isChairBased: true),
                OfficeStep(nameJa: "前屈（椅子版）", instruction: "椅子に座ったまま上体を前に倒し、腕をだらりと下げる。20秒。", duration: 25, isChairBased: true),
                OfficeStep(nameJa: "立ち前屈", instruction: "立ち上がり、膝を軽く曲げて上体を前に倒す。30秒。", duration: 35, isChairBased: false),
                OfficeStep(nameJa: "ランジ（片脚前後）", instruction: "右足を前に踏み出し、左膝を床に近づける。20秒×両側。", duration: 45, isChairBased: false),
                OfficeStep(nameJa: "立位ツイスト", instruction: "足を腰幅に開き、腕を横に広げて上半身を左右にひねる。15回。", duration: 35, isChairBased: false),
            ]),
        OfficeRoutine(id: "eye_brain", emoji: "👁", nameJa: "目と脳のリセット", duration: 3, target: "眼精疲労・集中力回復",
            steps: [
                OfficeStep(nameJa: "掌温め", instruction: "手のひらを温めてから目の上にそっと当てる。10秒。", duration: 15, isChairBased: true),
                OfficeStep(nameJa: "眼球8の字", instruction: "目を閉じたまま眼球で横向き8の字を描く。5回。", duration: 30, isChairBased: true),
                OfficeStep(nameJa: "遠近交互", instruction: "3m先の点→画面→を繰り返す。10往復。", duration: 30, isChairBased: true),
                OfficeStep(nameJa: "鼻先呼吸", instruction: "鼻先を見ながら4カウント吸い、8カウント吐く。3回。", duration: 45, isChairBased: true),
            ]),
        OfficeRoutine(id: "energy_boost", emoji: "⚡️", nameJa: "午後の眠気退治", duration: 5, target: "眠気・倦怠感",
            steps: [
                OfficeStep(nameJa: "太陽礼拝（簡易）", instruction: "立ち上がり、手を上に伸ばして吸い、前屈して吐く。5回。", duration: 60, isChairBased: false),
                OfficeStep(nameJa: "戦士I（椅子なし）", instruction: "右足を前に出し、両手を天井へ。5呼吸×両側。", duration: 60, isChairBased: false),
                OfficeStep(nameJa: "カラス歩き", instruction: "つま先立ちで10歩前進→10歩後退。血行促進。", duration: 30, isChairBased: false),
                OfficeStep(nameJa: "ドルフィン呼吸", instruction: "鼻から勢いよく吸って、口から「ハッ」と短く吐く。20回。", duration: 30, isChairBased: false),
                OfficeStep(nameJa: "山のポーズ", instruction: "正しい姿勢で立ち、全身に意識を向けて3深呼吸。", duration: 20, isChairBased: false),
            ]),
    ]
}

// MARK: - Sub-views
struct OfficeRoutineCard: View {
    let routine: OfficeRoutine

    var body: some View {
        HStack(spacing: 14) {
            Text(routine.emoji)
                .font(.system(size: 28))
                .frame(width: 48, height: 48)
                .background(AppTheme.parchmentDark)
                .cornerRadius(10)
            VStack(alignment: .leading, spacing: 2) {
                Text(routine.nameJa)
                    .font(AppTheme.body(16))
                    .foregroundColor(AppTheme.inkBrown)
                Text("対象: \(routine.target)")
                    .font(AppTheme.caption(12))
                    .foregroundColor(AppTheme.inkLight)
            }
            Spacer()
            Text("\(routine.duration)分")
                .font(AppTheme.caption(13))
                .foregroundColor(AppTheme.goldAccent)
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(AppTheme.inkLight)
        }
        .padding(12)
        .background(AppTheme.cardBackground())
    }
}

struct OfficeRoutineDetail: View {
    let routine: OfficeRoutine

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(routine.steps) { step in
                HStack(alignment: .top, spacing: 10) {
                    Text(step.isChairBased ? "🪑" : "🧍")
                        .font(.system(size: 16))
                        .frame(width: 24)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(step.nameJa)
                            .font(AppTheme.body(14))
                            .foregroundColor(AppTheme.inkBrown)
                        Text(step.instruction)
                            .font(AppTheme.caption(13))
                            .foregroundColor(AppTheme.inkLight)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    Spacer()
                    Text("\(step.duration)秒")
                        .font(AppTheme.caption(12))
                        .foregroundColor(AppTheme.goldAccent)
                }
                .padding(.vertical, 4)
                Divider().background(AppTheme.parchmentDark)
            }
        }
        .padding(14)
        .background(AppTheme.parchmentDark.opacity(0.5))
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppTheme.goldAccent.opacity(0.3)))
    }
}
