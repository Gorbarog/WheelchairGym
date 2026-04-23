import Foundation

struct WorkoutProgramData {
    private static let placeholderExercise = Exercise(
        name: "Saknad övning",
        muscleGroups: ["Okänd muskelgrupp"],
        description: "Övningen kunde inte laddas från träningsdatat.",
        steps: ["Kontrollera att övningsnamnet i WorkoutProgramData matchar ExerciseData."],
        tips: "Uppdatera övningslistan och försök igen.",
        equipment: .inget,
        setsMin: 1,
        setsMax: 1,
        repsMin: 1,
        repsMax: 1,
        levels: ActivityLevel.allCases
    )

    static func program(for level: ActivityLevel) -> WorkoutProgram {
        switch level {
        case .nybörjare: return nybörjareProgram
        case .mellannivå: return mellannivåProgram
        case .avancerad: return avanceradProgram
        }
    }

    // MARK: - Nybörjare Program

    static var nybörjareProgram: WorkoutProgram {
        let exercises = ExerciseData.allExercises
        let restSeconds = ActivityLevel.nybörjare.restSeconds
        let sets = ActivityLevel.nybörjare.setsPerExercise

        func find(_ name: String) -> Exercise {
            if let exercise = exercises.first(where: { $0.name == name }) {
                return exercise
            }
            assertionFailure("Missing exercise in program data: \(name)")
            return WorkoutProgramData.placeholderExercise
        }

        let workoutExercises: [WorkoutExercise] = [
            WorkoutExercise(
                exercise: find("Boxövning"),
                sets: 3,
                reps: "30-60 sek",
                restSeconds: 60
            ),
            WorkoutExercise(
                exercise: find("Bicepscurl"),
                sets: sets,
                reps: "10-15 reps",
                restSeconds: restSeconds
            ),
            WorkoutExercise(
                exercise: find("Tricepspress"),
                sets: sets,
                reps: "6-10 reps",
                restSeconds: restSeconds
            ),
            WorkoutExercise(
                exercise: find("Rygglyft"),
                sets: sets,
                reps: "10-15 reps",
                restSeconds: restSeconds
            ),
            WorkoutExercise(
                exercise: find("Axellyft"),
                sets: sets,
                reps: "10-15 reps",
                restSeconds: restSeconds
            ),
            WorkoutExercise(
                exercise: find("Töjningsövning"),
                sets: sets,
                reps: "20-30 reps",
                restSeconds: 30
            )
        ]

        return WorkoutProgram(
            name: "Nybörjarprogram",
            level: .nybörjare,
            exercises: workoutExercises,
            daysPerWeek: ActivityLevel.nybörjare.daysPerWeek
        )
    }

    // MARK: - Mellannivå Program

    static var mellannivåProgram: WorkoutProgram {
        let exercises = ExerciseData.allExercises
        let restSeconds = ActivityLevel.mellannivå.restSeconds
        let sets = ActivityLevel.mellannivå.setsPerExercise

        func find(_ name: String) -> Exercise {
            if let exercise = exercises.first(where: { $0.name == name }) {
                return exercise
            }
            assertionFailure("Missing exercise in program data: \(name)")
            return WorkoutProgramData.placeholderExercise
        }

        let workoutExercises: [WorkoutExercise] = [
            WorkoutExercise(
                exercise: find("Boxövning"),
                sets: 3,
                reps: "30-60 sek",
                restSeconds: 60
            ),
            WorkoutExercise(
                exercise: find("Bicepscurl"),
                sets: sets,
                reps: "10-15 reps",
                restSeconds: restSeconds
            ),
            WorkoutExercise(
                exercise: find("Tricepspress"),
                sets: sets,
                reps: "6-10 reps",
                restSeconds: restSeconds
            ),
            WorkoutExercise(
                exercise: find("Ryggflyes"),
                sets: sets,
                reps: "10-15 reps",
                restSeconds: restSeconds
            ),
            WorkoutExercise(
                exercise: find("Rygglyft"),
                sets: sets,
                reps: "10-15 reps",
                restSeconds: restSeconds
            ),
            WorkoutExercise(
                exercise: find("Axelpress"),
                sets: sets,
                reps: "20-30 reps",
                restSeconds: restSeconds
            ),
            WorkoutExercise(
                exercise: find("Flyes"),
                sets: sets,
                reps: "10-15 reps",
                restSeconds: restSeconds
            ),
            WorkoutExercise(
                exercise: find("Sittande bålrotation"),
                sets: sets,
                reps: "20-30 reps",
                restSeconds: restSeconds
            ),
            WorkoutExercise(
                exercise: find("Töjningsövning"),
                sets: sets,
                reps: "20-30 reps",
                restSeconds: 30
            )
        ]

        return WorkoutProgram(
            name: "Mellannivåprogram",
            level: .mellannivå,
            exercises: workoutExercises,
            daysPerWeek: ActivityLevel.mellannivå.daysPerWeek
        )
    }

    // MARK: - Avancerad Program

    static var avanceradProgram: WorkoutProgram {
        let exercises = ExerciseData.allExercises
        let restSeconds = ActivityLevel.avancerad.restSeconds
        let sets = ActivityLevel.avancerad.setsPerExercise

        func find(_ name: String) -> Exercise {
            if let exercise = exercises.first(where: { $0.name == name }) {
                return exercise
            }
            assertionFailure("Missing exercise in program data: \(name)")
            return WorkoutProgramData.placeholderExercise
        }

        let workoutExercises: [WorkoutExercise] = [
            WorkoutExercise(
                exercise: find("Boxövning"),
                sets: 4,
                reps: "30-60 sek",
                restSeconds: 60
            ),
            WorkoutExercise(
                exercise: find("Bicepscurl"),
                sets: sets,
                reps: "10-15 reps",
                restSeconds: restSeconds
            ),
            WorkoutExercise(
                exercise: find("Tricepspress"),
                sets: sets,
                reps: "6-10 reps",
                restSeconds: restSeconds
            ),
            WorkoutExercise(
                exercise: find("Ryggflyes"),
                sets: sets,
                reps: "10-15 reps",
                restSeconds: restSeconds
            ),
            WorkoutExercise(
                exercise: find("Rygglyft"),
                sets: sets,
                reps: "10-15 reps",
                restSeconds: restSeconds
            ),
            WorkoutExercise(
                exercise: find("Ryggövning med hantel"),
                sets: sets,
                reps: "10-15 reps",
                restSeconds: restSeconds
            ),
            WorkoutExercise(
                exercise: find("Axelpress"),
                sets: sets,
                reps: "20-30 reps",
                restSeconds: restSeconds
            ),
            WorkoutExercise(
                exercise: find("Hantelpress bakom nacke"),
                sets: sets,
                reps: "15-20 reps",
                restSeconds: restSeconds
            ),
            WorkoutExercise(
                exercise: find("Flyes"),
                sets: sets,
                reps: "10-15 reps",
                restSeconds: restSeconds
            ),
            WorkoutExercise(
                exercise: find("Drag upp till hakan"),
                sets: sets,
                reps: "20-30 reps",
                restSeconds: restSeconds
            ),
            WorkoutExercise(
                exercise: find("Sittande bålrotation"),
                sets: sets,
                reps: "20-30 reps",
                restSeconds: restSeconds
            ),
            WorkoutExercise(
                exercise: find("Paddel"),
                sets: sets,
                reps: "20-30 reps",
                restSeconds: restSeconds
            ),
            WorkoutExercise(
                exercise: find("Propeller"),
                sets: sets,
                reps: "20-30 reps",
                restSeconds: restSeconds
            ),
            WorkoutExercise(
                exercise: find("Töjningsövning"),
                sets: sets,
                reps: "20-30 reps",
                restSeconds: 30
            )
        ]

        return WorkoutProgram(
            name: "Avanceratprogram",
            level: .avancerad,
            exercises: workoutExercises,
            daysPerWeek: ActivityLevel.avancerad.daysPerWeek
        )
    }
}
