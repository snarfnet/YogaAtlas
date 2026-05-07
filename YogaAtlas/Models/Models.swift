import Foundation

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
        Chakra(id: "muladhara", number: 1, nameJa: "ムーラダーラ", nameEn: "Root", sanskritName: "Muladhara", color: "#CE5D51", location: "骨盤底", element: "土", keywords: ["安定", "安心", "土台"], poseIds: ["easy_pose", "tree_pose"], affirmation: "私は大地に支えられ、安心してここにいます。"),
        Chakra(id: "svadhisthana", number: 2, nameJa: "スヴァディシュターナ", nameEn: "Sacral", sanskritName: "Svadhisthana", color: "#D88A4A", location: "下腹部", element: "水", keywords: ["創造性", "感情", "しなやか"], poseIds: ["cat_cow"], affirmation: "私は感情の流れをやさしく受け止めます。"),
        Chakra(id: "manipura", number: 3, nameJa: "マニプーラ", nameEn: "Solar Plexus", sanskritName: "Manipura", color: "#DDB84F", location: "みぞおち", element: "火", keywords: ["意志", "自信", "行動"], poseIds: ["warrior_i"], affirmation: "私は自分の力を信頼し、前へ進みます。"),
        Chakra(id: "anahata", number: 4, nameJa: "アナーハタ", nameEn: "Heart", sanskritName: "Anahata", color: "#6EAA7A", location: "胸の中心", element: "風", keywords: ["愛", "回復", "つながり"], poseIds: ["bridge_pose"], affirmation: "私は心を開き、やさしさを受け取ります。"),
        Chakra(id: "vishuddha", number: 5, nameJa: "ヴィシュッダ", nameEn: "Throat", sanskritName: "Vishuddha", color: "#5EA5B6", location: "喉", element: "空", keywords: ["表現", "真実", "声"], poseIds: ["downward_dog"], affirmation: "私は本音を穏やかに表現できます。"),
        Chakra(id: "ajna", number: 6, nameJa: "アージュニャー", nameEn: "Third Eye", sanskritName: "Ajna", color: "#746AB0", location: "眉間", element: "光", keywords: ["直感", "洞察", "集中"], poseIds: ["childs_pose"], affirmation: "私は内なる知恵を静かに信頼します。"),
        Chakra(id: "sahasrara", number: 7, nameJa: "サハスラーラ", nameEn: "Crown", sanskritName: "Sahasrara", color: "#B07AC3", location: "頭頂", element: "意識", keywords: ["静寂", "統合", "瞑想"], poseIds: ["corpse_pose"], affirmation: "私は静けさの中で、全体とつながっています。")
    ]
}
