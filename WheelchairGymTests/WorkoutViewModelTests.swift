import XCTest
@testable import WheelchairGym

final class WorkoutViewModelTests: XCTestCase {
    func testStartWorkoutReturnsFalseWhenProgramMissing() {
        let viewModel = WorkoutViewModel()

        let didStart = viewModel.startWorkout()

        XCTAssertFalse(didStart)
        XCTAssertFalse(viewModel.isWorkoutActive)
        XCTAssertNil(viewModel.activeSession)
    }

    func testStartWorkoutReturnsTrueWhenProgramExists() {
        let viewModel = WorkoutViewModel()
        viewModel.loadProgram(for: .nybörjare)

        let didStart = viewModel.startWorkout()

        XCTAssertTrue(didStart)
        XCTAssertTrue(viewModel.isWorkoutActive)
        XCTAssertNotNil(viewModel.activeSession)
    }

    func testWorkoutElapsedAndDurationUseInjectedClock() {
        var now = Date(timeIntervalSince1970: 1_000)
        let viewModel = WorkoutViewModel(nowProvider: { now })
        viewModel.loadProgram(for: .nybörjare)
        XCTAssertTrue(viewModel.startWorkout())

        now = Date(timeIntervalSince1970: 1_090)
        XCTAssertEqual(viewModel.workoutElapsedSeconds, 90)

        viewModel.finishWorkout()
        XCTAssertEqual(viewModel.sessions.count, 1)
        XCTAssertEqual(viewModel.sessions.first?.durationMinutes, 1)
    }
}
