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
    var persistenceErrorMessage: String?

    private var sessionsKey = "workoutSessions"

    init() {
        loadSessions()
    }

    func loadProgram(for level: ActivityLevel) {
        selectedLevel = level
        currentProgram = WorkoutProgramData.program(for: level)
    }

    @discardableResult
    func startWorkout() -> Bool {
        guard let program = currentProgram else { return false }
        let session = WorkoutSession(program: program)
        activeSession = session
        currentExerciseIndex = 0
        currentSetNumber = 1
        isWorkoutActive = true
        workoutStartTime = Date()
        return true
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
        guard let session = activeSession,
              currentExerciseIndex >= 0,
              currentExerciseIndex < session.program.exercises.count else { return }
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
        guard let session = activeSession,
              currentExerciseIndex >= 0,
              currentExerciseIndex < session.program.exercises.count else { return }
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

    var workoutElapsedSeconds: Int {
        guard let startTime = workoutStartTime else { return 0 }
        return max(0, Int(Date().timeIntervalSince(startTime)))
    }

    // MARK: - Persistence

    private func saveSessions() {
        do {
            let encoded = try JSONEncoder().encode(sessions)
            UserDefaults.standard.set(encoded, forKey: sessionsKey)
            persistenceErrorMessage = nil
        } catch {
            persistenceErrorMessage = "Kunde inte spara träningshistorik."
            print("WorkoutViewModel saveSessions error: \(error)")
        }
    }

    private func loadSessions() {
        guard let data = UserDefaults.standard.data(forKey: sessionsKey) else {
            persistenceErrorMessage = nil
            return
        }

        do {
            sessions = try JSONDecoder().decode([WorkoutSession].self, from: data)
            persistenceErrorMessage = nil
        } catch {
            sessions = []
            UserDefaults.standard.removeObject(forKey: sessionsKey)
            persistenceErrorMessage = "Träningshistoriken var skadad och har återställts."
            print("WorkoutViewModel loadSessions error: \(error)")
        }
    }

    func clearSessions() {
        sessions = []
        UserDefaults.standard.removeObject(forKey: sessionsKey)
    }
}
