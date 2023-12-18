
import AOCLib
import Foundation

class Solve10: PuzzleSolver {
	func solveAExamples() -> Bool {
		solveA("Example10") == 4 &&
		solveA("Example10-2") == 8

	}

	func solveBExamples() -> Bool {
		solveB("Example10") == 0
	}

	var answerA = "0"
	var answerB = "0"

	func solveA() -> String {
		solveA("Input10").description
	}

	func solveB() -> String {
		solveB("Input10").description
	}

	func solveA(_: String) -> Int {
		return 0
	}

	func solveB(_: String) -> Int {
		return 0
	}
}
