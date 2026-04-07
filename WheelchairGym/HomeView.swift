import SwiftUI

struct HomeView: View {
    @AppStorage("selectedActivityLevel") var selectedActivityLevel = ""
    @State private var workoutViewModel = WorkoutViewModel()
    @State private var timerViewModel = TimerViewModel()
    @State private var selectedTab = 0

    var currentLevel: ActivityLevel? {
        ActivityLevel(rawValue: selectedActivityLevel)
    }

    var body: some View {
        ZStack {
            Color(red: 0.11, green: 0.11, blue: 0.14)
                .ignoresSafeArea()

            TabView(selection: $selectedTab) {
                ProgramView(workoutViewModel: workoutViewModel)
                    .tabItem {
                        Label("Program", systemImage: "list.bullet.clipboard.fill")
                    }
                    .tag(0)

                ExerciseListView()
                    .tabItem {
                        Label("Övningar", systemImage: "dumbbell.fill")
                    }
                    .tag(1)

                TimerView(timerViewModel: timerViewModel)
                    .tabItem {
                        Label("Timer", systemImage: "timer")
                    }
                    .tag(2)
            }
            .tint(.blue)
        }
        .onAppear {
            if let level = currentLevel {
                workoutViewModel.loadProgram(for: level)
            }

            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.12, alpha: 1.0)
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Exercise List View

struct ExerciseListView: View {
    @State private var searchText = ""
    @State private var selectedEquipment: Equipment? = nil
    @State private var selectedExercise: Exercise? = nil

    var filteredExercises: [Exercise] {
        var exercises = ExerciseData.allExercises
        if let equipment = selectedEquipment {
            exercises = exercises.filter { $0.equipment == equipment }
        }
        if !searchText.isEmpty {
            exercises = exercises.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.muscleGroups.joined(separator: " ").localizedCaseInsensitiveContains(searchText)
            }
        }
        return exercises
    }

    var groupedExercises: [(Equipment, [Exercise])] {
        let grouped = Dictionary(grouping: filteredExercises, by: \.equipment)
        return Equipment.allCases.compactMap { equipment in
            guard let exercises = grouped[equipment], !exercises.isEmpty else { return nil }
            return (equipment, exercises)
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.11, green: 0.11, blue: 0.14).ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // Equipment filter chips
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                FilterChip(
                                    title: "Alla",
                                    icon: "square.grid.2x2.fill",
                                    isSelected: selectedEquipment == nil,
                                    color: .blue
                                ) {
                                    withAnimation { selectedEquipment = nil }
                                }

                                ForEach(Equipment.allCases, id: \.self) { equipment in
                                    FilterChip(
                                        title: equipment.rawValue,
                                        icon: equipment.icon,
                                        isSelected: selectedEquipment == equipment,
                                        color: equipment.color
                                    ) {
                                        withAnimation {
                                            selectedEquipment = selectedEquipment == equipment ? nil : equipment
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                        }

                        // Exercise groups
                        ForEach(groupedExercises, id: \.0) { equipment, exercises in
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Image(systemName: equipment.icon)
                                        .foregroundColor(equipment.color)
                                    Text(equipment.rawValue)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("\(exercises.count) övningar")
                                        .font(.system(size: 13))
                                        .foregroundColor(.gray)
                                }
                                .padding(.horizontal, 16)

                                ForEach(exercises) { exercise in
                                    Button {
                                        selectedExercise = exercise
                                    } label: {
                                        ExerciseRowView(exercise: exercise)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }

                        if filteredExercises.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray.opacity(0.5))
                                Text("Inga övningar hittades")
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 60)
                        }

                        Spacer().frame(height: 30)
                    }
                    .padding(.top, 8)
                }
            }
            .navigationTitle("Övningar")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Sök övning eller muskelgrupp")
            .sheet(item: $selectedExercise) { exercise in
                ExerciseDetailView(exercise: exercise)
            }
        }
    }
}

struct FilterChip: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let color: Color
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 13))
                Text(title)
                    .font(.system(size: 13, weight: .medium))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? color.opacity(0.25) : Color.white.opacity(0.07))
            .foregroundColor(isSelected ? color : .gray)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(isSelected ? color.opacity(0.5) : Color.clear, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }
}

struct ExerciseRowView: View {
    let exercise: Exercise

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(exercise.equipment.color.opacity(0.15))
                    .frame(width: 44, height: 44)

                Image(systemName: exercise.equipment.icon)
                    .font(.system(size: 20))
                    .foregroundColor(exercise.equipment.color)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(exercise.name)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)

                    if exercise.isWarmup {
                        Text("Uppvärmning")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.orange)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.orange.opacity(0.2))
                            .cornerRadius(4)
                    }
                }

                Text(exercise.muscleGroups.prefix(2).joined(separator: ", "))
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(exercise.setsDisplay)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.blue)
                Text(exercise.repsDisplay)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.gray.opacity(0.5))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(red: 0.15, green: 0.15, blue: 0.19))
                .padding(.horizontal, 16)
        )
    }
}

#Preview {
    HomeView()
        .preferredColorScheme(.dark)
}
