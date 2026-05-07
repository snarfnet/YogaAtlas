import SwiftUI

enum AppTheme {
    static let canvas = Color(hex: "#F7F2E8")
    static let canvasDeep = Color(hex: "#ECE0CF")
    static let sage = Color(hex: "#6E8F79")
    static let sageDeep = Color(hex: "#2F5144")
    static let moss = Color(hex: "#A9B79A")
    static let clay = Color(hex: "#C98562")
    static let blush = Color(hex: "#E8BFAE")
    static let gold = Color(hex: "#D7A84F")
    static let lavender = Color(hex: "#9283B8")
    static let ink = Color(hex: "#26362F")
    static let muted = Color(hex: "#6A756C")

    static let root = Color(hex: "#CE5D51")
    static let sacral = Color(hex: "#D88A4A")
    static let solar = Color(hex: "#DDB84F")
    static let heart = Color(hex: "#6EAA7A")
    static let throat = Color(hex: "#5EA5B6")
    static let thirdEye = Color(hex: "#746AB0")
    static let crown = Color(hex: "#B07AC3")

    static func title(_ size: CGFloat = 28, weight: Font.Weight = .semibold) -> Font {
        .system(size: size, weight: weight, design: .serif)
    }

    static func body(_ size: CGFloat = 16, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }

    static func caption(_ size: CGFloat = 13, weight: Font.Weight = .medium) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }
}

struct YogaScreenBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [AppTheme.canvas, Color(hex: "#F9EADB"), Color(hex: "#EDF3E9")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            RadialGradient(
                colors: [AppTheme.gold.opacity(0.22), .clear],
                center: .topTrailing,
                startRadius: 40,
                endRadius: 360
            )
            RadialGradient(
                colors: [AppTheme.sage.opacity(0.20), .clear],
                center: .bottomLeading,
                startRadius: 60,
                endRadius: 420
            )
        }
        .ignoresSafeArea()
    }
}

struct YogaHeroCard<Overlay: View>: View {
    let imageName: String
    let height: CGFloat
    let overlay: Overlay

    init(imageName: String, height: CGFloat, @ViewBuilder overlay: () -> Overlay) {
        self.imageName = imageName
        self.height = height
        self.overlay = overlay()
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .clipped()
                .overlay(
                    LinearGradient(
                        colors: [.black.opacity(0.05), .black.opacity(0.56)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            overlay
                .padding(20)
        }
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        .shadow(color: AppTheme.sageDeep.opacity(0.22), radius: 18, x: 0, y: 12)
    }
}

struct YogaCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(.white.opacity(0.78))
                    .overlay(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .stroke(.white.opacity(0.86), lineWidth: 1)
                    )
                    .shadow(color: AppTheme.sageDeep.opacity(0.10), radius: 14, x: 0, y: 8)
            )
    }
}

struct SectionTitle: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(AppTheme.title(22))
                .foregroundColor(AppTheme.ink)
            Text(subtitle)
                .font(AppTheme.body(14))
                .foregroundColor(AppTheme.muted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct Pill: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(AppTheme.caption(12, weight: .semibold))
            .foregroundColor(color)
            .padding(.horizontal, 11)
            .padding(.vertical, 7)
            .background(color.opacity(0.13), in: Capsule())
    }
}

extension Color {
    init(hex: String) {
        let clean = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: clean).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch clean.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}
