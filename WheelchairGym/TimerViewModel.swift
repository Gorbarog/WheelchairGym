import SwiftUI
import Observation

@Observable
class TimerViewModel {
    var mode: TimerMode = .stopwatch
    var state: TimerState = .idle
    var elapsedSeconds: Int = 0
    var targetSeconds: Int = 60

    private var timer: Timer?
    private var startDate: Date?
    private var pausedElapsed: Int = 0

    deinit {
        timer?.invalidate()
    }

    var displayTime: String {
        let seconds: Int
        if mode == .countdown {
            seconds = max(0, targetSeconds - elapsedSeconds)
        } else {
            seconds = elapsedSeconds
        }
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", minutes, secs)
    }

    var progressFraction: Double {
        guard mode == .countdown, targetSeconds > 0 else {
            return mode == .stopwatch ? 0 : 0
        }
        return Double(elapsedSeconds) / Double(targetSeconds)
    }

    var remainingSeconds: Int {
        guard mode == .countdown else { return 0 }
        return max(0, targetSeconds - elapsedSeconds)
    }

    var isFinished: Bool {
        return state == .finished
    }

    func start() {
        guard state == .idle else { return }
        state = .running
        startDate = Date()
        pausedElapsed = 0
        startTimerInternal()
    }

    func pause() {
        guard state == .running else { return }
        state = .paused
        pausedElapsed = elapsedSeconds
        timer?.invalidate()
        timer = nil
    }

    func resume() {
        guard state == .paused else { return }
        state = .running
        startDate = Date().addingTimeInterval(-Double(pausedElapsed))
        startTimerInternal()
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        state = .idle
        elapsedSeconds = 0
        pausedElapsed = 0
        startDate = nil
    }

    func reset() {
        stop()
    }

    func setCountdown(seconds: Int) {
        stop()
        targetSeconds = seconds
        mode = .countdown
    }

    func switchMode(_ newMode: TimerMode) {
        stop()
        mode = newMode
    }

    private func startTimerInternal() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.tick()
        }
        RunLoop.main.add(timer!, forMode: .common)
    }

    private func tick() {
        guard state == .running else { return }

        if let startDate = startDate {
            elapsedSeconds = Int(Date().timeIntervalSince(startDate))
        } else {
            elapsedSeconds += 1
        }

        if mode == .countdown && elapsedSeconds >= targetSeconds {
            elapsedSeconds = targetSeconds
            state = .finished
            timer?.invalidate()
            timer = nil
            triggerHapticFeedback()
        }
    }

    private func triggerHapticFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
