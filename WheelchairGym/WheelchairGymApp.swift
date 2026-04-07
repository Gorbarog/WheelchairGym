import SwiftUI

@main
struct WheelchairGymApp: App {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false
    @AppStorage("selectedActivityLevel") var selectedActivityLevel = ""

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding && !selectedActivityLevel.isEmpty {
                HomeView()
                    .preferredColorScheme(.dark)
            } else {
                OnboardingView()
                    .preferredColorScheme(.dark)
            }
        }
    }
}
