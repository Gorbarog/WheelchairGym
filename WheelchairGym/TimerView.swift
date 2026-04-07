import SwiftUI

struct TimerView: View {
    @State var timerViewModel: TimerViewModel
    @State private var customMinutes: Int = 0
    @State private var customSeconds: Int = 30
    @State private var showCustomPicker = false

    init(timerViewModel: TimerViewModel = TimerViewModel()) {
        _timerViewModel = State(initialValue: timerViewModel)
    }

    let presets: [(Int, String)] = [
        (30, "30s"),
        (45, "45s"),
        (60, "1m"),
        (90, "1m 30s"),
        (120, "2m"),
        (180, "3m"),
        (300, "5m")
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.07, green: 0.07, blue: 0.10).ignoresSafeArea()

                VStack(spacing: 0) {
                    // Mode picker
                    Picker("Läge", selection: Binding(
                        get: { timerViewModel.mode },
                        set: { timerViewModel.switchMode($0) }
                    )) {
                        ForEach(TimerMode.allCases, id: \.self) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 24)

                    // Timer display
                    ZStack {
                        // Background ring
                        Circle()
                            .stroke(Color.white.opacity(0.05), lineWidth: 16)
                            .frame(width: 240, height: 240)

                        // Progress ring (countdown only)
                        if timerViewModel.mode == .countdown {
                            Circle()
                                .trim(from: 0, to: 1 - timerViewModel.progressFraction)
                                .stroke(
                                    timerViewModel.state == .finished
                                        ? LinearGradient(colors: [.green, .mint], startPoint: .leading, endPoint: .trailing)
                                        : LinearGradient(colors: [.blue, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing),
                                    style: StrokeStyle(lineWidth: 16, lineCap: .round)
                                )
                                .frame(width: 240, height: 240)
                                .rotationEffect(.degrees(-90))
                                .animation(.linear(duration: 1), value: timerViewModel.progressFraction)
                        } else {
                            // Stopwatch - just a decorative ring
                            Circle()
                                .stroke(
                                    LinearGradient(colors: [.blue.opacity(0.6), .cyan.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing),
                                    style: StrokeStyle(lineWidth: 16, lineCap: .round)
                                )
                                .frame(width: 240, height: 240)
                                .opacity(timerViewModel.state == .running ? 1.0 : 0.3)
                                .animation(.easeInOut(duration: 0.5), value: timerViewModel.state == .running)
                        }

                        // Time text
                        VStack(spacing: 4) {
                            Text(timerViewModel.displayTime)
                                .font(.system(size: 52, weight: .bold, design: .monospaced))
                                .foregroundColor(timerViewModel.state == .finished ? .green : .white)
                                .contentTransition(.numericText())
                                .animation(.easeInOut(duration: 0.2), value: timerViewModel.displayTime)

                            if timerViewModel.mode == .countdown && timerViewModel.state != .idle {
                                Text(timerViewModel.state == .finished ? "Klar!" : "kvar")
                                    .font(.system(size: 14))
                                    .foregroundColor(timerViewModel.state == .finished ? .green : .gray)
                            } else if timerViewModel.mode == .stopwatch && timerViewModel.state != .idle {
                                Text("förfluten tid")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.bottom, 32)

                    // Countdown presets
                    if timerViewModel.mode == .countdown && timerViewModel.state == .idle {
                        VStack(spacing: 12) {
                            Text("Välj tid")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(presets, id: \.0) { seconds, label in
                                        PresetButton(
                                            label: label,
                                            isSelected: timerViewModel.targetSeconds == seconds && timerViewModel.state == .idle
                                        ) {
                                            timerViewModel.setCountdown(seconds: seconds)
                                        }
                                    }

                                    // Custom
                                    PresetButton(
                                        label: "Anpassa",
                                        isSelected: false,
                                        icon: "slider.horizontal.3"
                                    ) {
                                        showCustomPicker = true
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        .padding(.bottom, 24)
                    }

                    Spacer()

                    // Controls
                    VStack(spacing: 16) {
                        HStack(spacing: 20) {
                            // Reset
                            CircleButton(
                                icon: "arrow.counterclockwise",
                                color: .gray,
                                size: 56
                            ) {
                                timerViewModel.reset()
                            }
                            .disabled(timerViewModel.state == .idle)
                            .opacity(timerViewModel.state == .idle ? 0.3 : 1.0)

                            // Main Start/Pause/Resume button
                            Button {
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()

                                switch timerViewModel.state {
                                case .idle:
                                    timerViewModel.start()
                                case .running:
                                    timerViewModel.pause()
                                case .paused:
                                    timerViewModel.resume()
                                case .finished:
                                    timerViewModel.reset()
                                }
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(
                                            timerViewModel.state == .finished
                                                ? LinearGradient(colors: [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing)
                                                : LinearGradient(colors: [.blue, Color(red: 0.0, green: 0.5, blue: 1.0)], startPoint: .topLeading, endPoint: .bottomTrailing)
                                        )
                                        .frame(width: 80, height: 80)
                                        .shadow(color: timerViewModel.state == .finished ? .green.opacity(0.5) : .blue.opacity(0.4), radius: 16, x: 0, y: 4)

                                    Image(systemName: mainButtonIcon)
                                        .font(.system(size: 30, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                            }

                            // Stop
                            CircleButton(
                                icon: "stop.fill",
                                color: .red,
                                size: 56
                            ) {
                                timerViewModel.stop()
                            }
                            .disabled(timerViewModel.state == .idle)
                            .opacity(timerViewModel.state == .idle ? 0.3 : 1.0)
                        }

                        // Status text
                        Text(statusText)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Timer")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showCustomPicker) {
                CustomTimePicker(
                    minutes: $customMinutes,
                    seconds: $customSeconds
                ) {
                    let total = customMinutes * 60 + customSeconds
                    if total > 0 {
                        timerViewModel.setCountdown(seconds: total)
                    }
                }
            }
        }
    }

    var mainButtonIcon: String {
        switch timerViewModel.state {
        case .idle: return "play.fill"
        case .running: return "pause.fill"
        case .paused: return "play.fill"
        case .finished: return "arrow.counterclockwise"
        }
    }

    var statusText: String {
        switch timerViewModel.state {
        case .idle:
            if timerViewModel.mode == .countdown {
                let mins = timerViewModel.targetSeconds / 60
                let secs = timerViewModel.targetSeconds % 60
                if mins > 0 && secs > 0 {
                    return "Inställd på \(mins) min \(secs) sek"
                } else if mins > 0 {
                    return "Inställd på \(mins) min"
                } else {
                    return "Inställd på \(secs) sek"
                }
            }
            return "Tryck play för att starta"
        case .running:
            return timerViewModel.mode == .countdown ? "Nedräkning pågår..." : "Tidtagning pågår..."
        case .paused:
            return "Pausad"
        case .finished:
            return "Tid är ute!"
        }
    }
}

// MARK: - Preset Button

struct PresetButton: View {
    let label: String
    let isSelected: Bool
    var icon: String? = nil
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 5) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 12))
                }
                Text(label)
                    .font(.system(size: 14, weight: .semibold))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(isSelected ? Color.blue.opacity(0.3) : Color.white.opacity(0.08))
            .foregroundColor(isSelected ? .blue : .white)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(isSelected ? Color.blue : Color.clear, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Circle Button

struct CircleButton: View {
    let icon: String
    let color: Color
    let size: CGFloat
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: size, height: size)
                Image(systemName: icon)
                    .font(.system(size: size * 0.35, weight: .semibold))
                    .foregroundColor(color)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Custom Time Picker

struct CustomTimePicker: View {
    @Binding var minutes: Int
    @Binding var seconds: Int
    let onConfirm: () -> Void
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.11, green: 0.11, blue: 0.14).ignoresSafeArea()

                VStack(spacing: 30) {
                    Text("Välj anpassad tid")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 20)

                    HStack(spacing: 0) {
                        VStack {
                            Text("Minuter")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            Picker("Minuter", selection: $minutes) {
                                ForEach(0..<60) { min in
                                    Text("\(min)").tag(min)
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(width: 100)
                        }

                        Text(":")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.top, 20)

                        VStack {
                            Text("Sekunder")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            Picker("Sekunder", selection: $seconds) {
                                ForEach(0..<60) { sec in
                                    Text("\(sec < 10 ? "0" : "")\(sec)").tag(sec)
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(width: 100)
                        }
                    }

                    let total = minutes * 60 + seconds
                    Text(total > 0 ? "Total: \(minutes > 0 ? "\(minutes) min " : "")\(seconds > 0 ? "\(seconds) sek" : "")" : "Välj en tid")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(total > 0 ? .blue : .gray)

                    Button {
                        onConfirm()
                        dismiss()
                    } label: {
                        Text("Bekräfta")
                            .font(.system(size: 17, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(total > 0 ? Color.blue : Color.gray.opacity(0.3))
                            .foregroundColor(.white)
                            .cornerRadius(14)
                            .padding(.horizontal, 20)
                    }
                    .disabled(total == 0)

                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Avbryt") { dismiss() }
                        .foregroundColor(.blue)
                }
            }
        }
        .presentationDetents([.medium])
        .preferredColorScheme(.dark)
    }
}

#Preview {
    TimerView()
        .preferredColorScheme(.dark)
}
