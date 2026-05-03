import Foundation

class DataStore: ObservableObject {
    @Published var poses: [Pose] = []
    @Published var symptoms: [Symptom] = []
    @Published var meditations: [Meditation] = []

    static let shared = DataStore()

    private init() { load() }

    private func load() {
        poses      = loadJSON("poses",      key: "poses")
        symptoms   = loadJSON("symptoms",   key: "symptoms")
        meditations = loadJSON("meditations", key: "meditations")
    }

    private func loadJSON<T: Decodable>(_ filename: String, key: String) -> [T] {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("⚠️ \(filename).json not found")
            return []
        }
        do {
            let dict = try JSONDecoder().decode([String: [T]].self, from: data)
            return dict[key] ?? []
        } catch {
            print("⚠️ decode error \(filename): \(error)")
            return []
        }
    }

    func pose(for id: String) -> Pose? {
        poses.first { $0.id == id }
    }
}
