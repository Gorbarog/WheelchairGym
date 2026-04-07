import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false
    @AppStorage("selectedActivityLevel") var selectedActivityLevel = ""
    @State private var selectedLevel: ActivityLevel? = nil
    @State private var showingHome = false
    @State private var animateHeader = false

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color(red: 0.07, green: 0.07, blue: 0.10), Color(red: 0.11, green: 0.11, blue: 0.18)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 16) {
                        Spacer().frame(height: 60)

                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color.blue.opacity(0.3), Color.blue.opacity(0.1)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 100, height: 100)
                                .blur(radius: animateHeader ? 0 : 20)

                            Image(systemName: "figure.strengthtraining.traditional")
                                .font(.system(size: 50))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.blue, .cyan],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                        }
                        .scaleEffect(animateHeader ? 1.0 : 0.5)
                        .opacity(animateHeader ? 1.0 : 0.0)
                        .animation(.spring(duration: 0.7), value: animateHeader)

                        VStack(spacing: 8) {
                            Text("WheelchairGym")
                                .font(.system(size: 34, weight: .bold, design: .rounded))
                                .foregroundColor(.white)

                            Text("Träning anpassad för dig")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(.gray)
                        }
                        .opacity(animateHeader ? 1.0 : 0.0)
                        .offset(y: animateHeader ? 0 : 20)
                        .animation(.easeOut(duration: 0.6).delay(0.2), value: animateHeader)

                        Spacer().frame(height: 20)
                    }

                    // Level selection
                    VStack(spacing: 12) {
                        Text("Välj din träningsnivå")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                            .opacity(animateHeader ? 1.0 : 0.0)
                            .animation(.easeOut(duration: 0.6).delay(0.4), value: animateHeader)

                        ForEach(Array(ActivityLevel.allCases.enumerated()), id: \.element) { index, level in
                            ActivityLevelCard(
                                level: level,
                                isSelected: selectedLevel == level
                            ) {
                                withAnimation(.spring(duration: 0.3)) {
                                    selectedLevel = level
                                }
                            }
                            .opacity(animateHeader ? 1.0 : 0.0)
                            .offset(y: animateHeader ? 0 : 30)
                            .animation(.easeOut(duration: 0.5).delay(0.5 + Double(index) * 0.1), value: animateHeader)
                        }
                    }

                    Spacer().frame(height: 30)

                    // Start button
                    Button {
                        guard let level = selectedLevel else { return }
                        selectedActivityLevel = level.rawValue
                        hasCompletedOnboarding = true
                    } label: {
                        HStack {
                            Text("Starta")
                                .font(.system(size: 18, weight: .bold))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .bold))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            selectedLevel != nil
                                ? LinearGradient(colors: [.blue, Color(red: 0.0, green: 0.5, blue: 1.0)], startPoint: .leading, endPoint: .trailing)
                                : LinearGradient(colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.3)], startPoint: .leading, endPoint: .trailing)
                        )
                        .foregroundColor(selectedLevel != nil ? .white : .gray)
                        .cornerRadius(16)
                        .padding(.horizontal, 20)
                    }
                    .disabled(selectedLevel == nil)
                    .opacity(animateHeader ? 1.0 : 0.0)
                    .animation(.easeOut(duration: 0.5).delay(0.9), value: animateHeader)

                    Spacer().frame(height: 50)
                }
            }
        }
        .onAppear {
            animateHeader = true
        }
    }
}

struct ActivityLevelCard: View {
    let level: ActivityLevel
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(level.accentColor.opacity(isSelected ? 0.3 : 0.15))
                        .frame(width: 52, height: 52)

                    Image(systemName: level.icon)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(level.accentColor)
                }

                // Text info
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(level.displayName)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)

                        if level == .nybörjare {
                            Text("Rekommenderat")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.green)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(Color.green.opacity(0.2))
                                .cornerRadius(6)
                        }
                    }

                    Text(level.description)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)

                    HStack(spacing: 12) {
                        Label("\(level.daysPerWeek) dagar/vecka", systemImage: "calendar")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(level.accentColor.opacity(0.9))

                        Label("\(level.restSeconds) sek vila", systemImage: "timer")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(level.accentColor.opacity(0.9))
                    }
                }

                Spacer()

                // Checkmark
                ZStack {
                    Circle()
                        .strokeBorder(isSelected ? level.accentColor : Color.gray.opacity(0.4), lineWidth: 2)
                        .frame(width: 24, height: 24)

                    if isSelected {
                        Circle()
                            .fill(level.accentColor)
                            .frame(width: 24, height: 24)
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(red: 0.13, green: 0.13, blue: 0.18))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(
                                isSelected ? level.accentColor.opacity(0.6) : Color.white.opacity(0.07),
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
            )
            .padding(.horizontal, 20)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    OnboardingView()
        .preferredColorScheme(.dark)
}
