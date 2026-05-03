import Foundation

// MARK: - Pose
struct Pose: Codable, Identifiable {
    let id: String
    let nameJa: String
    let nameEn: String
    let sanskrit: String
    let category: String
    let difficulty: Int
    let duration: Int
    let benefits: [String]
    let instructions: [String]
    let cautions: [String]
    let chakra: String
    let imageFile: String
}

// MARK: - Symptom
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
}

struct SymptomPose: Codable {
    let poseId: String
    let reason: String
    let reasonEn: String
    let duration: Int
}

// MARK: - Meditation
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
    let chakraSequence: [ChakraStep]?
    let mantra: String?
    let mantraPhonetic: String?
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

// MARK: - Chakra
struct Chakra: Identifiable {
    let id: String
    let number: Int
    let nameJa: String
    let nameEn: String
    let sanskritName: String
    let color: String
    let location: String
    let element: String
    let keywords: [String]
    let poseIds: [String]
    let affirmation: String
}

extension Chakra {
    static let all: [Chakra] = [
        Chakra(id: "muladhara", number: 1,
               nameJa: "ムーラーダーラ", nameEn: "Root", sanskritName: "Mūlādhāra",
               color: "#CC0000", location: "尾てい骨・会陰", element: "土",
               keywords: ["安定", "安全", "グラウンディング", "生存"],
               poseIds: ["mountain_pose", "tree_pose", "standing_forward_bend"],
               affirmation: "私は大地に根を張り、安全で安心です"),
        Chakra(id: "svadhisthana", number: 2,
               nameJa: "スヴァディシュターナ", nameEn: "Sacral", sanskritName: "Svādhiṣṭhāna",
               color: "#FF6600", location: "下腹部・仙骨", element: "水",
               keywords: ["創造性", "感情", "官能性", "喜び"],
               poseIds: ["bound_angle", "reclining_bound_angle", "wide_angle_forward_bend"],
               affirmation: "私は感情と創造性の流れを受け入れます"),
        Chakra(id: "manipura", number: 3,
               nameJa: "マニプーラ", nameEn: "Solar Plexus", sanskritName: "Maṇipūra",
               color: "#FFCC00", location: "みぞおち", element: "火",
               keywords: ["意志力", "自信", "変容", "力"],
               poseIds: ["boat_pose", "cobra_pose", "triangle"],
               affirmation: "私は自信を持ち、自分の力を信頼します"),
        Chakra(id: "anahata", number: 4,
               nameJa: "アナーハタ", nameEn: "Heart", sanskritName: "Anāhata",
               color: "#00AA44", location: "胸の中央", element: "風",
               keywords: ["愛", "慈悲", "癒し", "繋がり"],
               poseIds: ["upward_bow", "cobra_pose", "bridge_pose"],
               affirmation: "私は愛を与え、受け取ります"),
        Chakra(id: "vishuddha", number: 5,
               nameJa: "ヴィシュッダ", nameEn: "Throat", sanskritName: "Viśuddha",
               color: "#0088CC", location: "喉", element: "空",
               keywords: ["表現", "真実", "コミュニケーション", "創造"],
               poseIds: ["cat_cow", "seated_twist", "bridge_pose"],
               affirmation: "私は真実を穏やかに表現します"),
        Chakra(id: "ajna", number: 6,
               nameJa: "アージュニャー", nameEn: "Third Eye", sanskritName: "Ājñā",
               color: "#3300AA", location: "眉間", element: "光",
               keywords: ["直感", "洞察", "想像力", "智慧"],
               poseIds: ["childs_pose", "easy_pose", "seated_forward_bend"],
               affirmation: "私は直感を信じ、内なる叡智を見ます"),
        Chakra(id: "sahasrara", number: 7,
               nameJa: "サハスラーラ", nameEn: "Crown", sanskritName: "Sahasrāra",
               color: "#8800CC", location: "頭頂", element: "宇宙",
               keywords: ["悟り", "宇宙意識", "統合", "至高"],
               poseIds: ["headstand", "corpse_pose", "easy_pose"],
               affirmation: "私は宇宙意識と繋がっています"),
    ]
}
