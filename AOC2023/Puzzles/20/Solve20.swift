
import AOCLib
import Foundation

class Solve20: PuzzleSolver {
	func solveAExamples() -> Bool {
		solveA("Example20") == 32000000 &&
		solveA("Example20-2") == 11687500
	}

	func solveBExamples() -> Bool {
		solveB("Example20") == 0
	}

	var answerA = "0"
	var answerB = "0"

	func solveA() -> String {
		solveA("Input20").description
	}

	func solveB() -> String {
		solveB("Input20").description
	}

	func solveA(_: String) -> Int {
		return 0
	}

	func solveB(_: String) -> Int {
		return 0
	}
}
