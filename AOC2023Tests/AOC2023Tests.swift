
@testable import AOC2023
import AOCLib
import XCTest

final class Test2023: XCTestCase {
	func testOne() throws {
		testOne(Solve9())
	}

	func testAll() throws {
		let totalTime = Stopwatch()

		let puzzles = Puzzles2023()

		puzzles.puzzles.puzzles.forEach { puzzle in
			print("Testing \(puzzle.id): \(puzzle.name)")
			testOne(puzzle.solver)
		}

		print("⌚ Total time elapsed: \(totalTime.elapsed)")
	}

	func testOne(_ solver: PuzzleSolver) {
		let totalTime = Stopwatch()

		if solver.shouldTestExamplesA ?? true {
			let stopwatch = Stopwatch()
			XCTAssertTrue(solver.solveAExamples(), "🔴 Example A failed")
			print("  ⌚ Examples A took \(stopwatch.elapsed)")
		}
		if solver.shouldTestExamplesB ?? true {
			let stopwatch = Stopwatch()
			XCTAssertTrue(solver.solveBExamples(), "🔴 Example B failed")
			print("  ⌚ Examples B took \(stopwatch.elapsed)")
		}

		if solver.shouldTestA ?? true {
			let stopwatch = Stopwatch()
			let a = solver.solveA()
			XCTAssertEqual(a, solver.answerA, "🔴 Part A failed. Expected: \(solver.answerA), Got: \(a)")
			print("  ⌚ Part A took \(stopwatch.elapsed)")
		}
		if solver.shouldTestB ?? true {
			let stopwatch = Stopwatch()
			let b = solver.solveB()
			XCTAssertEqual(b, solver.answerB, "🔴 Part B failed. Expected: \(solver.answerB), Got: \(b)")
			print("  ⌚ Part B took \(stopwatch.elapsed)")
		}

		print("  ⌚ Total: \(totalTime.elapsed)")
	}
}
