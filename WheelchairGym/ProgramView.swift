import SwiftUI

struct ProgramView: View {
    @Bindable var workoutViewModel: WorkoutViewModel
    @AppStorage("selectedActivityLevel") var selectedActivityLevel = ""
    @State private var showingActiveWorkout = false
    @State private var showingLevelPicker = false
    @State private var showStartWorkoutError = false

    var currentLevel: ActivityLevel? {
        ActivityLevel(rawValue: selectedActivityLevel)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.11, green: 0.11, blue: 0.14).ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // Header card
                        if let level = currentLevel, let program = workoutViewModel.currentProgram {
                            ProgramHeaderCard(level: level, program: program)
                        }

                        // Stats row
                        if !workoutViewModel.sessions.isEmpty {
                            StatsRow(viewModel: workoutViewModel)
                        }

                        // Exercise list header
                        HStack {
                            Text("Övningar i programmet")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                            Spacer()
                            if let program = workoutViewModel.currentProgram {
                                Text("\(program.exercises.count) övningar")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal, 16)

                        // Exercise list
                        if let program = workoutViewModel.currentProgram {
                            ForEach(Array(program.exercises.enumerated()), id: \.element.id) { index, workoutExercise in
                                ProgramExerciseRow(
                                    index: index + 1,
                                    workoutExercise: workoutExercise
                                )
                            }
                        }

                        // Start workout button
                        Button {
                            if workoutViewModel.startWorkout() {
                                showingActiveWorkout = true
                            } else {
                                showStartWorkoutError = true
                            }
                        } label: {
                            HStack {
                                Image(systemName: "play.fill")
                                    .font(.system(size: 16, weight: .bold))
                                Text("Starta träning")
                                    .font(.system(size: 18, weight: .bold))
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                LinearGradient(
                                    colors: [.blue, Color(red: 0.0, green: 0.5, blue: 1.0)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(16)
                            .padding(.horizontal, 16)
                        }
                        .padding(.top, 8)

                        Spacer().frame(height: 30)
                    }
                    .padding(.top, 8)
                }
            }
            .navigationTitle("Program")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingLevelPicker = true
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundColor(.blue)
                    }
                }
            }
            .fullScreenCover(isPresented: $showingActiveWorkout) {
                ActiveWorkoutView(workoutViewModel: workoutViewModel)
            }
            .sheet(isPresented: $showingLevelPicker) {
                LevelPickerSheet(currentLevel: currentLevel) { newLevel in
                    selectedActivityLevel = newLevel.rawValue
                    workoutViewModel.loadProgram(for: newLevel)
                }
            }
            .alert("Kunde inte starta träningen", isPresented: $showStartWorkoutError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Välj en träningsnivå och försök igen.")
            }
        }
    }
}

struct ProgramHeaderCard: View {
    let level: ActivityLevel
    let program: WorkoutProgram

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: level.icon)
                            .foregroundColor(level.accentColor)
                        Text(level.displayName)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(level.accentColor)
                    }

                    Text(program.name)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)

                    Text(level.description)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .lineLimit(2)
                }

                Spacer()

                ZStack {
                    Circle()
                        .fill(level.accentColor.opacity(0.15))
                        .frame(width: 60, height: 60)
                    Image(systemName: "figure.strengthtraining.traditional")
                        .font(.system(size: 28))
                        .foregroundColor(level.accentColor)
                }
            }
            .padding(16)

            Divider()
                .background(Color.white.opacity(0.08))

            HStack(spacing: 0) {
                StatPill(value: "\(program.daysPerWeek)", label: "Dagar/vecka", icon: "calendar")
                Divider().frame(height: 30).background(Color.white.opacity(0.08))
                StatPill(value: "\(level.setsPerExercise)", label: "Set/övning", icon: "repeat")
                Divider().frame(height: 30).background(Color.white.opacity(0.08))
                StatPill(value: "\(level.restSeconds)s", label: "Vilotid", icon: "timer")
            }
            .padding(.vertical, 12)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(red: 0.15, green: 0.15, blue: 0.19))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(level.accentColor.opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }
}

struct StatPill: View {
    let value: String
    let label: String
    let icon: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(.blue)
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}

struct StatsRow: View {
    let viewModel: WorkoutViewModel

    var body: some View {
        HStack(spacing: 12) {
            StatsCard(
                value: "\(viewModel.totalSessions)",
                label: "Pass genomförda",
                icon: "checkmark.seal.fill",
                color: .green
            )
            StatsCard(
                value: "\(viewModel.totalMinutes)",
                label: "Minuter tränat",
                icon: "clock.fill",
                color: .blue
            )
        }
        .padding(.horizontal, 16)
    }
}

struct StatsCard: View {
    let value: String
    let label: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 14))
                Spacer()
            }
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(red: 0.15, green: 0.15, blue: 0.19))
        )
    }
}

struct ProgramExerciseRow: View {
    let index: Int
    let workoutExercise: WorkoutExercise
    @State private var showDetail = false

    var body: some View {
        Button {
            showDetail = true
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(workoutExercise.exercise.isWarmup ? Color.orange.opacity(0.2) : Color.blue.opacity(0.15))
                        .frame(width: 36, height: 36)
                    if workoutExercise.exercise.isWarmup {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.orange)
                    } else {
                        Text("\(index)")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.blue)
                    }
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(workoutExercise.exercise.name)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                    Text(workoutExercise.exercise.muscleGroups.prefix(2).joined(separator: " · "))
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(workoutExercise.sets) set")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.blue)
                    Text(workoutExercise.reps)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }

                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(.gray.opacity(0.4))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(red: 0.15, green: 0.15, blue: 0.19))
                    .padding(.horizontal, 16)
            )
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showDetail) {
            ExerciseDetailView(exercise: workoutExercise.exercise)
        }
    }
}

struct LevelPickerSheet: View {
    let currentLevel: ActivityLevel?
    let onSelect: (ActivityLevel) -> Void
    @Environment(\.dismiss) var dismiss
    @State private var selected: ActivityLevel?

    init(currentLevel: ActivityLevel?, onSelect: @escaping (ActivityLevel) -> Void) {
        self.currentLevel = currentLevel
        self.onSelect = onSelect
        _selected = State(initialValue: currentLevel)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.11, green: 0.11, blue: 0.14).ignoresSafeArea()

                VStack(spacing: 16) {
                    Text("Byt träningsnivå")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 8)

                    ForEach(ActivityLevel.allCases, id: \.self) { level in
                        ActivityLevelCard(level: level, isSelected: selected == level) {
                            selected = level
                        }
                    }

                    Spacer()

                    Button {
                        if let level = selected {
                            onSelect(level)
                        }
                        dismiss()
                    } label: {
                        Text("Spara")
                            .font(.system(size: 17, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(14)
                            .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Stäng") { dismiss() }
                        .foregroundColor(.blue)
                }
            }
        }
        .presentationDetents([.large])
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ProgramView(workoutViewModel: WorkoutViewModel())
        .preferredColorScheme(.dark)
}
