import SwiftUI

struct MeditationTimerView: View {
    let meditation: Meditation

    @State private var selectedDuration: Int
    @State private var secondsRemaining: Int = 0
    @State private var isRunning = false
    @State private var isComplete = false
    @State private var currentStep = 0
    @State private var showInstructions = true
    @State private var timer: Timer? = nil

    init(meditation: Meditation) {
        self.meditation = meditation
        _selectedDuration = State(initialValue: meditation.defaultDuration)
    }

    private var totalSeconds: Int { selectedDuration * 60 }
    private var progress: Double {
        guard totalSeconds > 0 else { return 0 }
        return 1.0 - Double(secondsRemaining) / Double(totalSeconds)
    }
    private var chakraColor: Color {
        guard let id = meditation.chakra,
              let c = Chakra.all.first(where: { $0.id == id }) else { return AppTheme.lavender }
        return Color(hex: c.color)
    }
    private var timeString: String {
        let m = secondsRemaining / 60
        let s = secondsRemaining % 60
        return String(format: "%d:%02d", m, s)
    }

    var body: some View {
        ZStack {
            AppTheme.parchment.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 24) {
                    // Timer circle
                    ZStack {
                        Circle()
                            .stroke(chakraColor.opacity(0.15), lineWidth: 14)
                            .frame(width: 220, height: 220)
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(chakraColor, style: StrokeStyle(lineWidth: 14, lineCap: .round))
                            .frame(width: 220, height: 220)
                            .rotationEffect(.degrees(-90))
                            .animation(.linear(duration: 1), value: progress)
                        VStack(spacing: 6) {
                            Text(meditation.icon).font(.system(size: 36))
                            if isComplete {
                                Text("完了 ✨")
                                    .font(AppTheme.title(22))
                                    .foregroundColor(chakraColor)
                            } else if isRunning || secondsRemaining > 0 {
                                Text(timeString)
                                    .font(.custom("Georgia", size: 38))
                                    .foregroundColor(AppTheme.inkBrown)
                            } else {
                                Text("\(selectedDuration)分")
                                    .font(.custom("Georgia", size: 38))
                                    .foregroundColor(AppTheme.inkBrown)
                            }
                        }
                    }
                    .padding(.top, 16)

                    // Duration picker (only before start)
                    if !isRunning && secondsRemaining == 0 && !isComplete {
                        HStack(spacing: 10) {
                            ForEach(meditation.durationOptions, id: \.self) { d in
                                Button("\(d)分") {
                                    selectedDuration = d
                                }
                                .font(AppTheme.caption(14))
                                .foregroundColor(selectedDuration == d ? .white : AppTheme.inkBrown)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 7)
                                .background(selectedDuration == d ? chakraColor : AppTheme.parchmentDark)
                                .clipShape(Capsule())
                            }
                        }
                    }

                    // Control buttons
                    HStack(spacing: 20) {
                        if isComplete {
                            Button("もう一度") { reset() }
                                .timerButton(color: AppTheme.sage)
                        } else if isRunning {
                            Button("一時停止") { pause() }
                                .timerButton(color: AppTheme.dustyRose)
                        } else if secondsRemaining > 0 {
                            Button("再開") { start() }
                                .timerButton(color: chakraColor)
                            Button("リセット") { reset() }
                                .timerButton(color: AppTheme.inkLight)
                        } else {
                            Button("開始") { start() }
                                .timerButton(color: chakraColor)
                        }
                    }

                    Divider().background(AppTheme.goldAccent.opacity(0.3)).padding(.horizontal)

                    // Instructions toggle
                    VStack(alignment: .leading, spacing: 10) {
                        Button {
                            withAnimation { showInstructions.toggle() }
                        } label: {
                            HStack {
                                Text("📋 手順")
                                    .font(AppTheme.title(15))
                                    .foregroundColor(AppTheme.inkBrown)
                                Spacer()
                                Image(systemName: showInstructions ? "chevron.up" : "chevron.down")
                                    .font(.caption)
                                    .foregroundColor(AppTheme.goldAccent)
                            }
                        }

                        if showInstructions {
                            ForEach(Array(meditation.instructions.enumerated()), id: \.offset) { i, step in
                                HStack(alignment: .top, spacing: 10) {
                                    ZStack {
                                        Circle()
                                            .fill(i == currentStep && isRunning ? chakraColor : AppTheme.parchmentDark)
                                            .frame(width: 24, height: 24)
                                        Text("\(i + 1)")
                                            .font(AppTheme.caption(12))
                                            .foregroundColor(i == currentStep && isRunning ? .white : AppTheme.inkLight)
                                    }
                                    Text(step)
                                        .font(AppTheme.body(14))
                                        .foregroundColor(AppTheme.inkBrown)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)

                    // Benefits
                    VStack(alignment: .leading, spacing: 8) {
                        Text("✨ 効果")
                            .font(AppTheme.title(15))
                            .foregroundColor(AppTheme.inkBrown)
                        ForEach(meditation.benefits, id: \.self) { b in
                            HStack(alignment: .top, spacing: 8) {
                                Circle().fill(chakraColor).frame(width: 5, height: 5).padding(.top, 7)
                                Text(b).font(AppTheme.body(14)).foregroundColor(AppTheme.inkBrown)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                    .padding(.horizontal)

                    Spacer(minLength: 32)
                }
            }
        }
        .navigationTitle(meditation.nameJa)
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear { pause() }
    }

    // MARK: - Timer logic
    private func start() {
        if secondsRemaining == 0 { secondsRemaining = totalSeconds }
        isRunning = true
        isComplete = false
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if secondsRemaining > 0 {
                secondsRemaining -= 1
                currentStep = min(
                    Int(Double(meditation.instructions.count) * (1.0 - Double(secondsRemaining) / Double(totalSeconds))),
                    meditation.instructions.count - 1
                )
            } else {
                complete()
            }
        }
    }

    private func pause() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }

    private func reset() {
        pause()
        secondsRemaining = 0
        isComplete = false
        currentStep = 0
    }

    private func complete() {
        pause()
        isComplete = true
        currentStep = meditation.instructions.count - 1
    }
}

// MARK: - Button style helper
extension Button {
    func timerButton(color: Color) -> some View {
        self
            .font(AppTheme.body(16))
            .foregroundColor(.white)
            .padding(.horizontal, 28)
            .padding(.vertical, 12)
            .background(color)
            .clipShape(Capsule())
            .shadow(color: color.opacity(0.3), radius: 6, x: 0, y: 3)
    }
}
