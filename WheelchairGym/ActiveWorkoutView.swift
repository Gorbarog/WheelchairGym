import SwiftUI

struct ActiveWorkoutView: View {
    @Bindable var workoutViewModel: WorkoutViewModel
    @Environment(\.dismiss) var dismiss
    @State private var restTimerViewModel = TimerViewModel()
    @State private var showRestTimer = false
    @State private var showExerciseDetail = false
    @State private var showFinishConfirm = false
    @State private var exerciseScale: CGFloat = 1.0

    var body: some View {
        ZStack {
            Color(red: 0.07, green: 0.07, blue: 0.10).ignoresSafeArea()

            VStack(spacing: 0) {
                // Top bar
                HStack {
                    Button {
                        showFinishConfirm = true
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 26))
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    Text("Aktiv träning")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)

                    Spacer()

                    // Timer display
                    WorkoutElapsedTimer(workoutViewModel: workoutViewModel)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 12)

                // Progress bar
                if let session = workoutViewModel.activeSession {
                    VStack(spacing: 6) {
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.white.opacity(0.1))
                                    .frame(height: 4)

                                RoundedRectangle(cornerRadius: 4)
                                    .fill(
                                        LinearGradient(colors: [.blue, .cyan], startPoint: .leading, endPoint: .trailing)
                                    )
                                    .frame(
                                        width: geo.size.width * workoutViewModel.progressFraction,
                                        height: 4
                                    )
                                    .animation(.easeInOut(duration: 0.5), value: workoutViewModel.progressFraction)
                            }
                        }
                        .frame(height: 4)
                        .padding(.horizontal, 20)

                        HStack {
                            Text("\(workoutViewModel.currentExerciseIndex + 1) av \(session.program.exercises.count) övningar")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                            Spacer()
                            Text("\(Int(workoutViewModel.progressFraction * 100))% klart")
                                .font(.system(size: 12))
                                .foregroundColor(.blue)
                        }
                        .padding(.horizontal, 20)
                    }
                }

                Spacer()

                // Main content
                if let workoutExercise = workoutViewModel.currentWorkoutExercise {
                    VStack(spacing: 24) {
                        // Exercise card
                        VStack(spacing: 16) {
                            // Equipment icon
                            ZStack {
                                Circle()
                                    .fill(workoutExercise.exercise.equipment.color.opacity(0.15))
                                    .frame(width: 90, height: 90)
                                Image(systemName: workoutExercise.exercise.equipment.icon)
                                    .font(.system(size: 40))
                                    .foregroundColor(workoutExercise.exercise.equipment.color)
                            }
                            .scaleEffect(exerciseScale)

                            if workoutExercise.exercise.isWarmup {
                                Label("Uppvärmning", systemImage: "flame.fill")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.orange)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 5)
                                    .background(Color.orange.opacity(0.15))
                                    .cornerRadius(12)
                            }

                            Text(workoutExercise.exercise.name)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)

                            Text(workoutExercise.exercise.muscleGroups.prefix(3).joined(separator: " · "))
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }

                        // Set tracker
                        VStack(spacing: 12) {
                            HStack(spacing: 8) {
                                ForEach(1...workoutExercise.sets, id: \.self) { setNum in
                                    Circle()
                                        .fill(setNum < workoutViewModel.currentSetNumber ? Color.blue : (setNum == workoutViewModel.currentSetNumber ? Color.blue.opacity(0.4) : Color.white.opacity(0.1)))
                                        .frame(width: 12, height: 12)
                                        .overlay(
                                            Circle()
                                                .strokeBorder(setNum == workoutViewModel.currentSetNumber ? Color.blue : Color.clear, lineWidth: 2)
                                                .frame(width: 16, height: 16)
                                        )
                                }
                            }

                            Text("Set \(workoutViewModel.currentSetNumber) av \(workoutExercise.sets)")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)

                            Text(workoutExercise.reps)
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(.blue)
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(red: 0.15, green: 0.15, blue: 0.20))
                        )
                        .padding(.horizontal, 20)

                        // Quick tips
                        if !workoutExercise.exercise.tips.isEmpty {
                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: "lightbulb.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(.yellow)
                                    .padding(.top, 1)
                                Text(workoutExercise.exercise.tips)
                                    .font(.system(size: 13))
                                    .foregroundColor(.gray)
                                    .lineLimit(2)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(14)
                            .background(Color.yellow.opacity(0.05))
                            .cornerRadius(12)
                            .padding(.horizontal, 20)
                        }
                    }
                }

                Spacer()

                // Rest timer if active
                if showRestTimer {
                    RestTimerCard(timerVM: restTimerViewModel) {
                        showRestTimer = false
                        restTimerViewModel.stop()
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.horizontal, 20)
                    .padding(.bottom, 12)
                }

                // Action buttons
                VStack(spacing: 12) {
                    // Info button
                    Button {
                        showExerciseDetail = true
                    } label: {
                        Label("Visa övningsinstruktioner", systemImage: "info.circle")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                    }

                    // Main action
                    HStack(spacing: 12) {
                        // Rest timer
                        Button {
                            if let exercise = workoutViewModel.currentWorkoutExercise {
                                restTimerViewModel.setCountdown(seconds: exercise.restSeconds)
                                showRestTimer = true
                                withAnimation {
                                    restTimerViewModel.start()
                                }
                            }
                        } label: {
                            HStack {
                                Image(systemName: "timer")
                                Text("Vila \(workoutViewModel.currentWorkoutExercise?.restSeconds ?? 60)s")
                            }
                            .font(.system(size: 15, weight: .semibold))
                            .frame(height: 54)
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.08))
                            .foregroundColor(.white)
                            .cornerRadius(14)
                        }

                        // Next set / next exercise
                        Button {
                            withAnimation(.spring(duration: 0.4)) {
                                exerciseScale = 0.9
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                withAnimation(.spring(duration: 0.4)) {
                                    exerciseScale = 1.0
                                }
                            }

                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()

                            if workoutViewModel.isLastSet && workoutViewModel.isLastExercise {
                                workoutViewModel.finishWorkout()
                                dismiss()
                            } else if workoutViewModel.isLastSet {
                                workoutViewModel.nextExercise()
                            } else {
                                workoutViewModel.nextSet()
                            }

                            showRestTimer = false
                            restTimerViewModel.stop()
                        } label: {
                            HStack {
                                if workoutViewModel.isLastSet && workoutViewModel.isLastExercise {
                                    Image(systemName: "checkmark.circle.fill")
                                    Text("Avsluta pass")
                                } else if workoutViewModel.isLastSet {
                                    Image(systemName: "forward.end.fill")
                                    Text("Nästa övning")
                                } else {
                                    Image(systemName: "arrow.right.circle.fill")
                                    Text("Nästa set")
                                }
                            }
                            .font(.system(size: 15, weight: .bold))
                            .frame(height: 54)
                            .frame(maxWidth: .infinity)
                            .background(
                                LinearGradient(
                                    colors: workoutViewModel.isLastSet && workoutViewModel.isLastExercise
                                        ? [.green, .mint]
                                        : [.blue, Color(red: 0.0, green: 0.5, blue: 1.0)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(14)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 34)
            }
        }
        .sheet(isPresented: $showExerciseDetail) {
            if let exercise = workoutViewModel.currentWorkoutExercise?.exercise {
                ExerciseDetailView(exercise: exercise)
            }
        }
        .alert("Avsluta träningspasset?", isPresented: $showFinishConfirm) {
            Button("Avbryt", role: .cancel) {}
            Button("Avsluta", role: .destructive) {
                workoutViewModel.cancelWorkout()
                dismiss()
            }
        } message: {
            Text("Ditt träningspass kommer att avbrytas. Framsteg sparas inte.")
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Rest Timer Card

struct RestTimerCard: View {
    @Bindable var timerVM: TimerViewModel
    let onDismiss: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .stroke(Color.blue.opacity(0.2), lineWidth: 4)
                    .frame(width: 52, height: 52)

                Circle()
                    .trim(from: 0, to: 1 - timerVM.progressFraction)
                    .stroke(Color.blue, lineWidth: 4)
                    .frame(width: 52, height: 52)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 1), value: timerVM.progressFraction)

                Text(timerVM.displayTime)
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .foregroundColor(timerVM.state == .finished ? .green : .white)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(timerVM.state == .finished ? "Vilotid slut!" : "Vilotid")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(timerVM.state == .finished ? .green : .white)
                Text(timerVM.state == .finished ? "Dags för nästa set" : "Nästa set börjar snart")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }

            Spacer()

            Button(action: onDismiss) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.gray)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(red: 0.15, green: 0.15, blue: 0.22))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .strokeBorder(
                            timerVM.state == .finished ? Color.green.opacity(0.5) : Color.blue.opacity(0.3),
                            lineWidth: 1.5
                        )
                )
        )
    }
}

// MARK: - Elapsed Timer

struct WorkoutElapsedTimer: View {
    let workoutViewModel: WorkoutViewModel
    @State private var tick = 0

    var displayTime: String {
        _ = tick
        let elapsedSeconds = workoutViewModel.workoutElapsedSeconds
        let minutes = elapsedSeconds / 60
        let seconds = elapsedSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var body: some View {
        Text(displayTime)
            .font(.system(size: 15, weight: .semibold, design: .monospaced))
            .foregroundColor(.blue)
            .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
                tick += 1
            }
    }
}

#Preview {
    let vm = WorkoutViewModel()
    vm.loadProgram(for: .mellannivå)
    vm.startWorkout()
    return ActiveWorkoutView(workoutViewModel: vm)
        .preferredColorScheme(.dark)
}
