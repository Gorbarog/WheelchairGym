import SwiftUI

struct ExerciseDetailView: View {
    let exercise: Exercise
    @Environment(\.dismiss) var dismiss
    @State private var timerViewModel = TimerViewModel()
    @State private var showTimer = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.11, green: 0.11, blue: 0.14).ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 0) {
                        // Hero header
                        ZStack {
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        colors: [exercise.equipment.color.opacity(0.3), Color(red: 0.11, green: 0.11, blue: 0.14)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(height: 160)

                            VStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(exercise.equipment.color.opacity(0.2))
                                        .frame(width: 80, height: 80)
                                    Image(systemName: exercise.equipment.icon)
                                        .font(.system(size: 36))
                                        .foregroundColor(exercise.equipment.color)
                                }

                                Text(exercise.name)
                                    .font(.system(size: 26, weight: .bold))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                            }
                        }

                        VStack(spacing: 20) {
                            // Info chips row
                            HStack(spacing: 10) {
                                InfoBadge(
                                    icon: "dumbbell.fill",
                                    text: exercise.equipment.rawValue,
                                    color: exercise.equipment.color
                                )
                                InfoBadge(
                                    icon: "repeat",
                                    text: exercise.setsDisplay,
                                    color: .blue
                                )
                                InfoBadge(
                                    icon: exercise.isTimed ? "timer" : "number",
                                    text: exercise.repsDisplay,
                                    color: .blue
                                )
                                if exercise.isWarmup {
                                    InfoBadge(
                                        icon: "flame.fill",
                                        text: "Uppvärmning",
                                        color: .orange
                                    )
                                }
                            }
                            .padding(.horizontal, 16)

                            // Muscle groups
                            SectionCard(title: "Muskelgrupper", icon: "figure.arms.open") {
                                FlowLayout(spacing: 8) {
                                    ForEach(exercise.muscleGroups, id: \.self) { muscle in
                                        Text(muscle)
                                            .font(.system(size: 13, weight: .medium))
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(exercise.equipment.color.opacity(0.2))
                                            .cornerRadius(20)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .strokeBorder(exercise.equipment.color.opacity(0.4), lineWidth: 1)
                                            )
                                    }
                                }
                            }

                            // Steps
                            SectionCard(title: "Utförande", icon: "list.number") {
                                VStack(spacing: 14) {
                                    ForEach(Array(exercise.steps.enumerated()), id: \.offset) { index, step in
                                        HStack(alignment: .top, spacing: 12) {
                                            ZStack {
                                                Circle()
                                                    .fill(Color.blue.opacity(0.2))
                                                    .frame(width: 28, height: 28)
                                                Text("\(index + 1)")
                                                    .font(.system(size: 13, weight: .bold))
                                                    .foregroundColor(.blue)
                                            }
                                            .flexibleFrame(minWidth: 28)

                                            Text(step)
                                                .font(.system(size: 15))
                                                .foregroundColor(Color(white: 0.85))
                                                .fixedSize(horizontal: false, vertical: true)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    }
                                }
                            }

                            // Tips
                            SectionCard(title: "Tips", icon: "lightbulb.fill", iconColor: .yellow) {
                                HStack(alignment: .top, spacing: 12) {
                                    Image(systemName: "lightbulb.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(.yellow)
                                        .padding(.top, 2)

                                    Text(exercise.tips)
                                        .font(.system(size: 15))
                                        .foregroundColor(Color(white: 0.85))
                                        .fixedSize(horizontal: false, vertical: true)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(14)
                                .background(Color.yellow.opacity(0.08))
                                .cornerRadius(12)
                            }

                            // Levels
                            SectionCard(title: "Träningsnivåer", icon: "chart.bar.fill") {
                                HStack(spacing: 10) {
                                    ForEach(ActivityLevel.allCases, id: \.self) { level in
                                        let isIncluded = exercise.levels.contains(level)
                                        HStack(spacing: 6) {
                                            Image(systemName: isIncluded ? "checkmark.circle.fill" : "circle")
                                                .foregroundColor(isIncluded ? level.accentColor : .gray.opacity(0.4))
                                                .font(.system(size: 14))
                                            Text(level.displayName)
                                                .font(.system(size: 13, weight: .medium))
                                                .foregroundColor(isIncluded ? .white : .gray.opacity(0.4))
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 8)
                                        .background(isIncluded ? level.accentColor.opacity(0.1) : Color.clear)
                                        .cornerRadius(10)
                                    }
                                }
                            }

                            // Timer button
                            if exercise.isTimed {
                                Button {
                                    timerViewModel.setCountdown(seconds: exercise.durationSeconds ?? 60)
                                    showTimer = true
                                } label: {
                                    HStack {
                                        Image(systemName: "timer")
                                            .font(.system(size: 16, weight: .semibold))
                                        Text("Starta timer för övningen")
                                            .font(.system(size: 16, weight: .semibold))
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(Color.blue.opacity(0.2))
                                    .foregroundColor(.blue)
                                    .cornerRadius(14)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .strokeBorder(Color.blue.opacity(0.4), lineWidth: 1.5)
                                    )
                                }
                                .padding(.horizontal, 16)
                            }

                            Spacer().frame(height: 40)
                        }
                        .padding(.top, 16)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Stäng") {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }
            }
            .sheet(isPresented: $showTimer) {
                TimerView(timerViewModel: timerViewModel)
            }
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Supporting Views

struct InfoBadge: View {
    let icon: String
    let text: String
    let color: Color

    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 11))
            Text(text)
                .font(.system(size: 12, weight: .medium))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(color.opacity(0.15))
        .foregroundColor(color)
        .cornerRadius(20)
    }
}

struct SectionCard<Content: View>: View {
    let title: String
    let icon: String
    var iconColor: Color = .blue
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(iconColor)
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
            }

            content()
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(red: 0.15, green: 0.15, blue: 0.19))
        )
        .padding(.horizontal, 16)
    }
}

// MARK: - FlowLayout

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? 0
        var height: CGFloat = 0
        var currentX: CGFloat = 0
        var currentRowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentX + size.width > maxWidth, currentX > 0 {
                height += currentRowHeight + spacing
                currentX = 0
                currentRowHeight = 0
            }
            currentX += size.width + spacing
            currentRowHeight = max(currentRowHeight, size.height)
        }
        height += currentRowHeight
        return CGSize(width: maxWidth, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var currentX: CGFloat = bounds.minX
        var currentY: CGFloat = bounds.minY
        var currentRowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentX + size.width > bounds.maxX, currentX > bounds.minX {
                currentY += currentRowHeight + spacing
                currentX = bounds.minX
                currentRowHeight = 0
            }
            subview.place(at: CGPoint(x: currentX, y: currentY), proposal: ProposedViewSize(size))
            currentX += size.width + spacing
            currentRowHeight = max(currentRowHeight, size.height)
        }
    }
}

// MARK: - View extension helper

extension View {
    func flexibleFrame(minWidth: CGFloat? = nil) -> some View {
        self.frame(minWidth: minWidth)
    }
}

#Preview {
    ExerciseDetailView(exercise: ExerciseData.allExercises[0])
        .preferredColorScheme(.dark)
}
