import Foundation

private var isJapanese: Bool {
    Locale.current.language.languageCode?.identifier == "ja"
}

struct Pose: Codable, Identifiable {
    let id: String
    let nameJa: String
    let nameEn: String
    let sanskrit: String
    let category: String
    let categoryEn: String
    let difficulty: Int
    let duration: Int
    let benefits: [String]
    let benefitsEn: [String]
    let instructions: [String]
    let instructionsEn: [String]
    let cautions: [String]
    let cautionsEn: [String]
    let chakra: String
    let imageFile: String

    var localName: String { isJapanese ? nameJa : nameEn }
    var localCategory: String { isJapanese ? category : categoryEn }
    var localBenefits: [String] { isJapanese ? benefits : benefitsEn }
    var localInstructions: [String] { isJapanese ? instructions : instructionsEn }
    var localCautions: [String] { isJapanese ? cautions : cautionsEn }
}

struct Symptom: Codable, Identifiable {
    let id: String
    let nameJa: String
    let nameEn: String
    let icon: String
    let description: String
    let descriptionEn: String
    let recommendedPoses: [SymptomPose]
    let avoidPoses: [String]
    let tips: [String]
    let tipsEn: [String]

    var localName: String { isJapanese ? nameJa : nameEn }
    var localDescription: String { isJapanese ? description : descriptionEn }
    var localTips: [String] { isJapanese ? tips : tipsEn }
}

struct SymptomPose: Codable {
    let poseId: String
    let reason: String
    let reasonEn: String
    let duration: Int

    var localReason: String { isJapanese ? reason : reasonEn }
}

struct Meditation: Codable, Identifiable {
    let id: String
    let nameJa: String
    let nameEn: String
    let icon: String
    let durationOptions: [Int]
    let defaultDuration: Int
    let description: String
    let descriptionEn: String
    let benefits: [String]
    let benefitsEn: [String]
    let instructions: [String]
    let instructionsEn: [String]
    let chakra: String?
    let backgroundMusic: String
    let difficulty: Int
    let tags: [String]
    let tagsEn: [String]
    let chakraSequence: [ChakraStep]?
    let mantra: String?
    let mantraPhonetic: String?

    var localName: String { isJapanese ? nameJa : nameEn }
    var localDescription: String { isJapanese ? description : descriptionEn }
    var localBenefits: [String] { isJapanese ? benefits : benefitsEn }
    var localInstructions: [String] { isJapanese ? instructions : instructionsEn }
    var localTags: [String] { isJapanese ? tags : tagsEn }
}

struct ChakraStep: Codable {
    let chakra: String
    let nameJa: String
    let nameEn: String
    let color: String
    let colorNameJa: String
    let location: String
    let affirmationJa: String
    let affirmationEn: String
}

struct Chakra: Identifiable {
    let id: String
    let number: Int
    let nameJa: String
    let nameEn: String
    let sanskritName: String
    let color: String
    let location: String
    let locationEn: String
    let element: String
    let elementEn: String
    let keywords: [String]
    let keywordsEn: [String]
    let poseIds: [String]
    let affirmation: String
    let affirmationEn: String

    var localName: String { isJapanese ? nameJa : nameEn }
    var localLocation: String { isJapanese ? location : locationEn }
    var localElement: String { isJapanese ? element : elementEn }
    var localKeywords: [String] { isJapanese ? keywords : keywordsEn }
    var localAffirmation: String { isJapanese ? affirmation : affirmationEn }
}

extension Chakra {
    static let all: [Chakra] = [
        Chakra(id: "muladhara", number: 1, nameJa: "ムーラダーラ", nameEn: "Root", sanskritName: "Muladhara", color: "#CE5D51", location: "骨盤底", locationEn: "Pelvic floor", element: "土", elementEn: "Earth", keywords: ["安定", "安心", "土台"], keywordsEn: ["Stability", "Safety", "Foundation"], poseIds: ["mountain_pose", "tree_pose"], affirmation: "私は大地に支えられ、安心してここにいます。", affirmationEn: "I am grounded and safe right where I am."),
        Chakra(id: "svadhisthana", number: 2, nameJa: "スヴァディシュターナ", nameEn: "Sacral", sanskritName: "Svadhisthana", color: "#D88A4A", location: "下腹部", locationEn: "Lower abdomen", element: "水", elementEn: "Water", keywords: ["創造性", "感情", "しなやかさ"], keywordsEn: ["Creativity", "Emotion", "Flow"], poseIds: ["bound_angle", "cat_cow"], affirmation: "私は感情の流れをやさしく受け止めます。", affirmationEn: "I gently accept the flow of my emotions."),
        Chakra(id: "manipura", number: 3, nameJa: "マニプーラ", nameEn: "Solar Plexus", sanskritName: "Manipura", color: "#DDB84F", location: "みぞおち", locationEn: "Solar plexus", element: "火", elementEn: "Fire", keywords: ["意志", "自信", "行動"], keywordsEn: ["Will", "Confidence", "Action"], poseIds: ["warrior_i", "boat_pose"], affirmation: "私は自分の力を信頼し、前へ進みます。", affirmationEn: "I trust my inner strength and move forward."),
        Chakra(id: "anahata", number: 4, nameJa: "アナーハタ", nameEn: "Heart", sanskritName: "Anahata", color: "#6EAA7A", location: "胸の中心", locationEn: "Center of chest", element: "風", elementEn: "Air", keywords: ["愛", "回復", "つながり"], keywordsEn: ["Love", "Healing", "Connection"], poseIds: ["cobra_pose", "bridge_pose"], affirmation: "私は心を開き、やさしさを受け取ります。", affirmationEn: "I open my heart and welcome kindness."),
        Chakra(id: "vishuddha", number: 5, nameJa: "ヴィシュッダ", nameEn: "Throat", sanskritName: "Vishuddha", color: "#5EA5B6", location: "喉", locationEn: "Throat", element: "空", elementEn: "Ether", keywords: ["表現", "真実", "声"], keywordsEn: ["Expression", "Truth", "Voice"], poseIds: ["seated_twist", "cat_cow"], affirmation: "私は本音を穏やかに表現できます。", affirmationEn: "I express my truth with calm honesty."),
        Chakra(id: "ajna", number: 6, nameJa: "アージュニャー", nameEn: "Third Eye", sanskritName: "Ajna", color: "#746AB0", location: "眉間", locationEn: "Between eyebrows", element: "光", elementEn: "Light", keywords: ["直感", "洞察", "集中"], keywordsEn: ["Intuition", "Insight", "Focus"], poseIds: ["childs_pose", "easy_pose"], affirmation: "私は内なる知恵を静かに信頼します。", affirmationEn: "I quietly trust my inner wisdom."),
        Chakra(id: "sahasrara", number: 7, nameJa: "サハスラーラ", nameEn: "Crown", sanskritName: "Sahasrara", color: "#B07AC3", location: "頭頂", locationEn: "Crown of head", element: "意識", elementEn: "Consciousness", keywords: ["静寂", "統合", "瞑想"], keywordsEn: ["Stillness", "Unity", "Meditation"], poseIds: ["corpse_pose", "easy_pose"], affirmation: "私は静けさの中で、全体とつながっています。", affirmationEn: "In stillness, I am connected to the whole.")
    ]
}
