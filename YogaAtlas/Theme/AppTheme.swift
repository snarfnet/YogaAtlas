import SwiftUI

enum AppTheme {
    // MARK: - Colors
    static let parchment     = Color(hex: "#F5ECD7")
    static let parchmentDark = Color(hex: "#E8D5B0")
    static let inkBrown      = Color(hex: "#3B2A1A")
    static let inkLight      = Color(hex: "#6B4E2A")
    static let dustyRose     = Color(hex: "#C9847A")
    static let sage          = Color(hex: "#7A9E7E")
    static let lavender      = Color(hex: "#9B8EC4")
    static let goldAccent    = Color(hex: "#C5973A")
    static let mutedBlue     = Color(hex: "#7A9BB5")

    // Chakra colors
    static let chakraRoot    = Color(hex: "#CC0000")
    static let chakraSacral  = Color(hex: "#FF6600")
    static let chakraSolar   = Color(hex: "#FFCC00")
    static let chakraHeart   = Color(hex: "#00AA44")
    static let chakraThroat  = Color(hex: "#0088CC")
    static let chakraThird   = Color(hex: "#3300AA")
    static let chakraCrown   = Color(hex: "#8800CC")

    // MARK: - Fonts
    static func serif(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .custom("Georgia", size: size).weight(weight)
    }
    static func title(_ size: CGFloat = 24) -> Font { serif(size, weight: .semibold) }
    static func body(_ size: CGFloat = 16)  -> Font { serif(size) }
    static func caption(_ size: CGFloat = 12) -> Font { serif(size) }

    // MARK: - Decorative
    static let borderStyle = RoundedRectangle(cornerRadius: 12)

    static func cardBackground() -> some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(parchment)
            .shadow(color: inkBrown.opacity(0.15), radius: 4, x: 0, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(goldAccent.opacity(0.4), lineWidth: 1)
            )
    }

    static func sectionHeader(_ title: String, icon: String) -> some View {
        HStack(spacing: 8) {
            Text(icon)
                .font(.system(size: 18))
            Text(title)
                .font(AppTheme.title(18))
                .foregroundColor(inkBrown)
            Spacer()
            Rectangle()
                .fill(goldAccent.opacity(0.5))
                .frame(height: 1)
                .frame(maxWidth: 60)
        }
        .padding(.horizontal)
    }
}

// MARK: - Color hex init
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB,
                  red: Double(r) / 255,
                  green: Double(g) / 255,
                  blue: Double(b) / 255,
                  opacity: Double(a) / 255)
    }
}
