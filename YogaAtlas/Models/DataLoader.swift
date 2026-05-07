import Foundation

final class DataStore: ObservableObject {
    @Published var poses: [Pose] = []
    @Published var symptoms: [Symptom] = []
    @Published var meditations: [Meditation] = []

    static let shared = DataStore()

    private init() {
        poses = Self.curatedPoses
        symptoms = Self.curatedSymptoms
        meditations = Self.curatedMeditations
    }

    func pose(for id: String) -> Pose? {
        poses.first { $0.id == id }
    }
}

private extension DataStore {
    static let curatedPoses: [Pose] = [
        Pose(id: "easy_pose", nameJa: "安楽座", nameEn: "Easy Pose", sanskrit: "Sukhasana", category: "座位", difficulty: 1, duration: 3, benefits: ["呼吸が深まり、心が落ち着く", "骨盤と背骨の感覚を整える", "瞑想の準備に向いている"], instructions: ["坐骨を床に根づかせ、背骨を長く保つ", "肩を下げ、胸の奥に空間を作る", "鼻から吸って、長く吐く呼吸を続ける"], cautions: ["膝や股関節がつらい場合はブランケットを敷く"], chakra: "muladhara", imageFile: "YogaHero"),
        Pose(id: "tree_pose", nameJa: "木のポーズ", nameEn: "Tree Pose", sanskrit: "Vrksasana", category: "バランス", difficulty: 2, duration: 2, benefits: ["集中力と体幹を育てる", "足裏の安定感を高める", "姿勢を美しく整える"], instructions: ["片足に重心を乗せ、足裏で床を押す", "反対の足を内ももかふくらはぎに添える", "胸の前で手を合わせ、視線を一点に置く"], cautions: ["膝の横に足裏を強く押しつけない"], chakra: "muladhara", imageFile: "PoseTree"),
        Pose(id: "cat_cow", nameJa: "キャット＆カウ", nameEn: "Cat Cow", sanskrit: "Marjaryasana Bitilasana", category: "背骨", difficulty: 1, duration: 4, benefits: ["背中と肩のこわばりをゆるめる", "呼吸と動きを合わせやすい", "朝のウォームアップに最適"], instructions: ["四つ這いになり、手首を肩の下へ置く", "吸う息で胸を前へ、吐く息で背中を丸める", "ゆっくり波のように背骨を動かす"], cautions: ["手首が痛い場合は拳か前腕で支える"], chakra: "svadhisthana", imageFile: "RestorativeProps"),
        Pose(id: "downward_dog", nameJa: "下向きの犬のポーズ", nameEn: "Downward Dog", sanskrit: "Adho Mukha Svanasana", category: "全身", difficulty: 2, duration: 3, benefits: ["肩、背中、脚裏を伸ばす", "血流を促し、頭をすっきりさせる", "全身の巡りを整える"], instructions: ["手のひらを広げ、坐骨を斜め上へ引く", "膝は曲がっていてよいので背中を長くする", "首の力を抜き、呼吸を広げる"], cautions: ["高血圧や手首の痛みがある場合は無理をしない"], chakra: "vishuddha", imageFile: "YogaHero"),
        Pose(id: "warrior_i", nameJa: "戦士のポーズ I", nameEn: "Warrior I", sanskrit: "Virabhadrasana I", category: "立位", difficulty: 3, duration: 2, benefits: ["脚力と意志を育てる", "胸と股関節を開く", "前向きなエネルギーを作る"], instructions: ["前足を踏み込み、後ろ足で床を押す", "骨盤を正面へ向け、両腕を上げる", "下半身は強く、呼吸はやわらかく保つ"], cautions: ["腰を反らせすぎず、肋骨を軽くしまう"], chakra: "manipura", imageFile: "PoseTree"),
        Pose(id: "childs_pose", nameJa: "チャイルドポーズ", nameEn: "Child's Pose", sanskrit: "Balasana", category: "休息", difficulty: 1, duration: 5, benefits: ["背中と腰を休める", "安心感を取り戻す", "疲れた日にも行いやすい"], instructions: ["正座から上体を前へ倒す", "額を床かクッションに預ける", "背中に呼吸を送るようにゆっくり吐く"], cautions: ["膝が痛い場合は太ももとふくらはぎの間にタオルを入れる"], chakra: "ajna", imageFile: "RestorativeProps"),
        Pose(id: "bridge_pose", nameJa: "橋のポーズ", nameEn: "Bridge Pose", sanskrit: "Setu Bandha Sarvangasana", category: "胸を開く", difficulty: 2, duration: 3, benefits: ["胸を開き、呼吸を広げる", "お尻と背中をやさしく強化する", "気分を前向きにする"], instructions: ["仰向けで膝を立て、足を腰幅に置く", "息を吐きながら骨盤を持ち上げる", "胸をあごへ近づけ、首は動かさない"], cautions: ["首に違和感がある場合は高さを下げる"], chakra: "anahata", imageFile: "YogaHero"),
        Pose(id: "corpse_pose", nameJa: "シャヴァーサナ", nameEn: "Corpse Pose", sanskrit: "Savasana", category: "瞑想", difficulty: 1, duration: 8, benefits: ["緊張をほどき、回復を促す", "練習の効果を体に馴染ませる", "睡眠前にもおすすめ"], instructions: ["仰向けになり、手足を自然に開く", "全身の重さを床に預ける", "呼吸を操作せず、静けさを味わう"], cautions: ["腰が浮く場合は膝下にクッションを置く"], chakra: "sahasrara", imageFile: "MeditationCorner")
    ]

    static let curatedSymptoms: [Symptom] = [
        Symptom(id: "stress", nameJa: "ストレス", nameEn: "Stress", icon: "leaf.fill", description: "呼吸を長くし、背中と胸をゆるめて神経を落ち着かせます。", descriptionEn: "Calm the nervous system with breath and gentle opening.", recommendedPoses: [SymptomPose(poseId: "childs_pose", reason: "安心感を作る休息姿勢", reasonEn: "Grounding rest", duration: 5), SymptomPose(poseId: "easy_pose", reason: "呼吸を整える", reasonEn: "Breath focus", duration: 3)], avoidPoses: ["強い逆転"], tips: ["吐く息を吸う息より少し長くする", "部屋の明かりを落として行う"], tipsEn: ["Lengthen the exhale", "Lower the lights"]),
        Symptom(id: "stiff_shoulders", nameJa: "肩こり", nameEn: "Stiff Shoulders", icon: "figure.walk", description: "肩甲骨と胸まわりを動かし、デスクワークの緊張をほどきます。", descriptionEn: "Release desk tension around the shoulders.", recommendedPoses: [SymptomPose(poseId: "cat_cow", reason: "背骨と肩甲骨を動かす", reasonEn: "Mobilizes spine", duration: 4), SymptomPose(poseId: "bridge_pose", reason: "胸を開く", reasonEn: "Opens chest", duration: 3)], avoidPoses: ["痛みを伴う腕上げ"], tips: ["肩をすくめず首を長く保つ", "痛気持ちいい範囲に留める"], tipsEn: ["Keep the neck long", "Stay gentle"]),
        Symptom(id: "sleep", nameJa: "眠りの質", nameEn: "Sleep", icon: "moon.stars.fill", description: "副交感神経に切り替える、夜向けの静かな組み合わせです。", descriptionEn: "A quiet evening sequence for better rest.", recommendedPoses: [SymptomPose(poseId: "corpse_pose", reason: "全身を休める", reasonEn: "Deep rest", duration: 8), SymptomPose(poseId: "childs_pose", reason: "安心感を高める", reasonEn: "Safety cue", duration: 5)], avoidPoses: ["寝る直前の強い後屈"], tips: ["スマホを伏せてから始める", "最後は照明を暗くする"], tipsEn: ["Put the phone down", "Dim the room"])
    ]

    static let curatedMeditations: [Meditation] = [
        Meditation(id: "breath", nameJa: "呼吸を整える瞑想", nameEn: "Breath Reset", icon: "wind", durationOptions: [3, 5, 10], defaultDuration: 5, description: "吸う、吐く。その単純なリズムに戻るための短い瞑想です。", descriptionEn: "Return to a simple breathing rhythm.", benefits: ["頭が静かになる", "緊張がゆるむ", "練習前の集中が高まる"], benefitsEn: ["Clearer mind", "Less tension"], instructions: ["背骨を長く座る", "4拍で吸い、6拍で吐く", "考えが浮かんだら呼吸へ戻る"], instructionsEn: ["Sit tall", "Inhale 4, exhale 6"], chakra: nil, backgroundMusic: "silent", difficulty: 1, tags: ["朝", "夜", "初心者"], chakraSequence: nil, mantra: nil, mantraPhonetic: nil),
        Meditation(id: "chakra", nameJa: "チャクラを巡る瞑想", nameEn: "Chakra Flow", icon: "sparkles", durationOptions: [7, 14], defaultDuration: 7, description: "7つのチャクラを下から順に感じ、心身のバランスを整えます。", descriptionEn: "Move awareness through seven chakras.", benefits: ["自己観察が深まる", "心身のバランスを感じやすい"], benefitsEn: ["Body awareness"], instructions: ["骨盤底から頭頂へ意識を移す", "各場所に色の光をイメージする", "最後は全身を一つの呼吸で包む"], instructionsEn: ["Move from root to crown"], chakra: "sahasrara", backgroundMusic: "silent", difficulty: 2, tags: ["チャクラ", "集中"], chakraSequence: nil, mantra: "Om Shanti", mantraPhonetic: "オーム シャンティ")
    ]
}
