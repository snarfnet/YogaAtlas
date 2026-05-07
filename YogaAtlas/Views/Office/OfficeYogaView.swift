import SwiftUI

struct OfficeYogaView: View {
    private let routines: [(title: String, time: String, icon: String, detail: String)] = [
        ("首と肩をほどく", "2分", "person.fill", "耳と肩の距離を広げ、呼吸しながら首筋をゆるめます。"),
        ("背骨リセット", "3分", "arrow.up.and.down.and.arrow.left.and.right", "椅子に座ったまま、丸める・伸ばす動きで背中を起こします。"),
        ("目の疲れケア", "1分", "eye.fill", "視線を遠くへ移し、眉間とこめかみの力を抜きます。"),
        ("午後の集中", "4分", "bolt.fill", "胸を開き、呼吸を深めてもう一度集中へ戻ります。")
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                YogaScreenBackground()
                ScrollView {
                    VStack(spacing: 22) {
                        YogaHeroCard(imageName: "OfficeStretch", height: 285) {
                            VStack(alignment: .leading, spacing: 9) {
                                Pill(text: "Desk Yoga", color: .white)
                                Text("仕事中に、体を戻す。")
                                    .font(AppTheme.title(31))
                                    .foregroundColor(.white)
                                Text("椅子の上でもできる、短いリセット習慣。")
                                    .font(AppTheme.body(15))
                                    .foregroundColor(.white.opacity(0.92))
                            }
                        }

                        VStack(spacing: 14) {
                            SectionTitle(title: "デスクでできるケア", subtitle: "着替えず、汗をかかず、今すぐ始められます")
                            ForEach(routines, id: \.title) { routine in
                                YogaCard {
                                    HStack(spacing: 14) {
                                        Image(systemName: routine.icon)
                                            .font(.system(size: 22))
                                            .foregroundColor(.white)
                                            .frame(width: 50, height: 50)
                                            .background(AppTheme.sageDeep, in: Circle())
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text(routine.title)
                                                .font(AppTheme.title(20))
                                                .foregroundColor(AppTheme.ink)
                                            Text(routine.detail)
                                                .font(AppTheme.body(14))
                                                .foregroundColor(AppTheme.muted)
                                                .lineSpacing(3)
                                        }
                                        Spacer()
                                        Pill(text: routine.time, color: AppTheme.clay)
                                    }
                                }
                            }
                        }
                    }
                    .padding(18)
                }
            }
            .navigationTitle("仕事中ヨガ")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
