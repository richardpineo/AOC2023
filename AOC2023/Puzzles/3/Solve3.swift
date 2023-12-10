
import AOCLib
import Foundation

class Solve3: PuzzleSolver {
	func solveAExamples() -> Bool {
		solveA("Example3") == 4361
	}

	func solveBExamples() -> Bool {
		solveB("Example3") == 0
	}

	var answerA = "0"
	var answerB = "0"

	func solveA() -> String {
		solveA("Input3").description
	}

	func solveB() -> String {
		solveB("Input3").description
	}

	struct Part {
		var posStart: Position2D
		var posEnd: Position2D = .origin
	}

	func solveA(_ fileName: String) -> Int {
		let parts = loadParts(fileName)

		return 4
	}

	func loadParts(_ fileName: String) -> [Part] {
		let grid = Grid2D(fileName: fileName)

		var parts: [Part] = []

		// Find the positions of all the parts
		for y in 0 ..< grid.maxPos.y {
			// Find all the numbers
			var currentPart: Position2D?
			for x in 0 ..< grid.maxPos.x {
				let isNumber = grid.value(.init(x, y)).isNumber

				if let currentStartPos = currentPart {
					if !isNumber {
						// current number is done.
						parts.append(.init(posStart: currentStartPos, posEnd: .init(x - 1, y)))
						currentPart = nil
					}
				} else {
					if isNumber {
						currentPart = .init(x, y)
					}
				}
			}
		}

		return parts
	}

	func solveB(_: String) -> Int {
		0
	}
}
