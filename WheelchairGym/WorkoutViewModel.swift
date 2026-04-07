import SwiftUI
import Observation

@Observable
class WorkoutViewModel {
    var allExercises: [Exercise] = ExerciseData.allExercises
    var currentProgram: WorkoutProgram?
    var selectedLevel: ActivityLevel?
    var sessions: [WorkoutSession] = []
    var activeSession: WorkoutSession?
    var currentExerciseIndex: Int = 0
    var currentSetNumber: Int = 1
    var isWorkoutActive: Bool = false
    var workoutStartTime: Date?

    private var sessionsKey = "workoutSessions"

    init() {
        loadSessions()
    }

    func loadProgram(for level: ActivityLevel) {
        selectedLevel = level
        currentProgram = WorkoutProgramData.program(for: level)
    }

    func startWorkout() {
        guard let program = currentProgram else { return }
        let session = WorkoutSession(program: program)
        activeSession = session
        currentExerciseIndex = 0
        currentSetNumber = 1
        isWorkoutActive = true
        workoutStartTime = Date()
    }

    func nextSet() {
        guard let session = activeSession,
              currentExerciseIndex < session.program.exercises.count else { return }

        let currentExercise = session.program.exercises[currentExerciseIndex]
        if currentSetNumber < currentExercise.sets {
            currentSetNumber += 1
        } else {
            nextExercise()
        }
    }

    func nextExercise() {
        guard let session = activeSession else { return }
        var updatedSession = session
        let exerciseId = session.program.exercises[currentExerciseIndex].id
        if !updatedSession.completedExercises.contains(exerciseId) {
            updatedSession.completedExercises.append(exerciseId)
        }
        activeSession = updatedSession

        if currentExerciseIndex < session.program.exercises.count - 1 {
            currentExerciseIndex += 1
            currentSetNumber = 1
        } else {
            finishWorkout()
        }
    }

    func completeExercise() {
        guard let session = activeSession else { return }
        var updatedSession = session
        let exerciseId = session.program.exercises[currentExerciseIndex].id
        if !updatedSession.completedExercises.contains(exerciseId) {
            updatedSession.completedExercises.append(exerciseId)
        }
        activeSession = updatedSession
    }

    func finishWorkout() {
        guard var session = activeSession,
              let startTime = workoutStartTime else { return }

        let duration = Int(Date().timeIntervalSince(startTime) / 60)
        session.durationMinutes = max(1, duration)
        sessions.append(session)
        saveSessions()

        activeSession = nil
        isWorkoutActive = false
        currentExerciseIndex = 0
        currentSetNumber = 1
        workoutStartTime = nil
    }

    func cancelWorkout() {
        activeSession = nil
        isWorkoutActive = false
        currentExerciseIndex = 0
        currentSetNumber = 1
        workoutStartTime = nil
    }

    var currentWorkoutExercise: WorkoutExercise? {
        guard let session = activeSession,
              currentExerciseIndex < session.program.exercises.count else { return nil }
        return session.program.exercises[currentExerciseIndex]
    }

    var progressFraction: Double {
        guard let session = activeSession,
              !session.program.exercises.isEmpty else { return 0 }
        return Double(currentExerciseIndex) / Double(session.program.exercises.count)
    }

    var isLastExercise: Bool {
        guard let session = activeSession else { return false }
        return currentExerciseIndex >= session.program.exercises.count - 1
    }

    var isLastSet: Bool {
        guard let exercise = currentWorkoutExercise else { return false }
        return currentSetNumber >= exercise.sets
    }

    var totalSessions: Int {
        sessions.count
    }

    var totalMinutes: Int {
        sessions.reduce(0) { $0 + $1.durationMinutes }
    }

    // MARK: - Persistence

    private func saveSessions() {
        if let encoded = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(encoded, forKey: sessionsKey)
        }
    }

    private func loadSessions() {
        if let data = UserDefaults.standard.data(forKey: sessionsKey),
           let decoded = try? JSONDecoder().decode([WorkoutSession].self, from: data) {
            sessions = decoded
        }
    }

    func clearSessions() {
        sessions = []
        UserDefaults.standard.removeObject(forKey: sessionsKey)
    }
}
