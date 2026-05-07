import Foundation

enum AppRuntime {
    static var isScreenshotMode: Bool {
        CommandLine.arguments.contains("-screenshots")
    }

    static var initialTab: Int {
        guard let index = CommandLine.arguments.firstIndex(of: "-screenshotScreen"),
              CommandLine.arguments.indices.contains(index + 1) else {
            return 0
        }
        switch CommandLine.arguments[index + 1] {
        case "prescription": return 1
        case "daily": return 2
        case "meditation": return 3
        case "chakra": return 4
        case "office": return 5
        default: return 0
        }
    }
}
