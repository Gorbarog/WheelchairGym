import SwiftUI

// MARK: - Activity Level

enum ActivityLevel: String, CaseIterable, Codable {
    case nybörjare = "nybörjare"
    case mellannivå = "mellannivå"
    case avancerad = "avancerad"

    var displayName: String {
        switch self {
        case .nybörjare: return "Nybörjare"
        case .mellannivå: return "Mellannivå"
        case .avancerad: return "Avancerad"
        }
    }

    var description: String {
        switch self {
        case .nybörjare:
            return "Perfekt för dig som precis börjat träna. Fokus på grundläggande rörelser och teknik."
        case .mellannivå:
            return "För dig som tränat ett tag och vill ta nästa steg med mer variation och intensitet."
        case .avancerad:
            return "Utmanande program för erfarna träningsentusiaster med full övningsrepertoar."
        }
    }

    var daysPerWeek: Int {
        switch self {
        case .nybörjare: return 2
        case .mellannivå: return 3
        case .avancerad: return 4
        }
    }

    var setsPerExercise: Int {
        switch self {
        case .nybörjare: return 2
        case .mellannivå: return 3
        case .avancerad: return 4
        }
    }

    var restSeconds: Int {
        switch self {
        case .nybörjare: return 90
        case .mellannivå: return 60
        case .avancerad: return 45
        }
    }

    var colorName: String {
        switch self {
        case .nybörjare: return "green"
        case .mellannivå: return "blue"
        case .avancerad: return "orange"
        }
    }

    var accentColor: Color {
        switch self {
        case .nybörjare: return .green
        case .mellannivå: return .blue
        case .avancerad: return .orange
        }
    }

    var icon: String {
        switch self {
        case .nybörjare: return "1.circle.fill"
        case .mellannivå: return "2.circle.fill"
        case .avancerad: return "3.circle.fill"
        }
    }
}

// MARK: - Equipment

enum Equipment: String, CaseIterable, Codable {
    case hantel = "Hantel"
    case stång = "Stång"
    case kroppsvikt = "Kroppsvikt"
    case inget = "Inget"

    var icon: String {
        switch self {
        case .hantel: return "dumbbell.fill"
        case .stång: return "minus.circle.fill"
        case .kroppsvikt: return "figure.strengthtraining.traditional"
        case .inget: return "hand.raised.fill"
        }
    }

    var color: Color {
        switch self {
        case .hantel: return .blue
        case .stång: return .purple
        case .kroppsvikt: return .orange
        case .inget: return .gray
        }
    }
}

// MARK: - Exercise

struct Exercise: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var muscleGroups: [String]
    var description: String
    var steps: [String]
    var tips: String
    var equipment: Equipment
    var setsMin: Int
    var setsMax: Int
    var repsMin: Int
    var repsMax: Int
    var durationSeconds: Int?
    var levels: [ActivityLevel]
    var isWarmup: Bool

    init(
        id: UUID = UUID(),
        name: String,
        muscleGroups: [String],
        description: String,
        steps: [String],
        tips: String,
        equipment: Equipment,
        setsMin: Int,
        setsMax: Int,
        repsMin: Int,
        repsMax: Int,
        durationSeconds: Int? = nil,
        levels: [ActivityLevel],
        isWarmup: Bool = false
    ) {
        self.id = id
        self.name = name
        self.muscleGroups = muscleGroups
        self.description = description
        self.steps = steps
        self.tips = tips
        self.equipment = equipment
        self.setsMin = setsMin
        self.setsMax = setsMax
        self.repsMin = repsMin
        self.repsMax = repsMax
        self.durationSeconds = durationSeconds
        self.levels = levels
        self.isWarmup = isWarmup
    }

    var setsDisplay: String {
        if setsMin == setsMax {
            return "\(setsMin) set"
        }
        return "\(setsMin)-\(setsMax) set"
    }

    var repsDisplay: String {
        if let duration = durationSeconds {
            return "\(duration / 60 > 0 ? "\(duration / 60) min " : "")\(duration % 60 > 0 ? "\(duration % 60) sek" : "")"
        }
        if repsMin == repsMax {
            return "\(repsMin) reps"
        }
        return "\(repsMin)-\(repsMax) reps"
    }

    var isTimed: Bool {
        return durationSeconds != nil
    }
}

// MARK: - Workout Exercise

struct WorkoutExercise: Identifiable, Codable {
    let id: UUID
    var exercise: Exercise
    var sets: Int
    var reps: String
    var restSeconds: Int

    init(id: UUID = UUID(), exercise: Exercise, sets: Int, reps: String, restSeconds: Int) {
        self.id = id
        self.exercise = exercise
        self.sets = sets
        self.reps = reps
        self.restSeconds = restSeconds
    }
}

// MARK: - Workout Program

struct WorkoutProgram: Identifiable, Codable {
    let id: UUID
    var name: String
    var level: ActivityLevel
    var exercises: [WorkoutExercise]
    var daysPerWeek: Int

    init(id: UUID = UUID(), name: String, level: ActivityLevel, exercises: [WorkoutExercise], daysPerWeek: Int) {
        self.id = id
        self.name = name
        self.level = level
        self.exercises = exercises
        self.daysPerWeek = daysPerWeek
    }
}

// MARK: - Workout Session

struct WorkoutSession: Identifiable, Codable {
    let id: UUID
    var date: Date
    var program: WorkoutProgram
    var completedExercises: [UUID]
    var durationMinutes: Int

    init(id: UUID = UUID(), date: Date = Date(), program: WorkoutProgram, completedExercises: [UUID] = [], durationMinutes: Int = 0) {
        self.id = id
        self.date = date
        self.program = program
        self.completedExercises = completedExercises
        self.durationMinutes = durationMinutes
    }
}

// MARK: - Timer Mode

enum TimerMode: String, CaseIterable {
    case stopwatch = "Tidtagning"
    case countdown = "Nedräkning"
}

// MARK: - Timer State

enum TimerState {
    case idle
    case running
    case paused
    case finished
}
