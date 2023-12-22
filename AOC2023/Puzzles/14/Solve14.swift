
import AOCLib
import Foundation

class Solve14: PuzzleSolver {
	func solveAExamples() -> Bool {
		solveA("Example14") == 136
	}

	func solveBExamples() -> Bool {
		solveB("Example14") == 0
	}

	var answerA = "113525"
	var answerB = "0"

	func solveA() -> String {
		solveA("Input14").description
	}

	func solveB() -> String {
		solveB("Input14").description
	}
	
	func roll(pos: Position2D, grid: inout Grid2D) {
		if pos.y < 1 {
			return
		}
		let above: Position2D = pos.offset(0, -1)
		if grid.value(above) == "." {
			grid.setValue(above, "O")
			grid.setValue(pos, ".")
			roll(pos: above, grid: &grid)
		}
	}

	func solveA(_ filename: String) -> Int {
		var grid = Grid2D(fileName: filename)
		for y in 1 ..< grid.maxPos.y {
			for x in 0 ..< grid.maxPos.x {
				if grid.value(.init(x, y)) == "O" {
					roll(pos: .init(x, y), grid: &grid)
				}
			}
		}
		// print("\(grid.debugDisplay)")
		let score = grid.allPositions.reduce(0) {
			var score = 0
			if grid.value($1) == "O" {
				score = grid.maxPos.y - $1.y
			}
			return $0 + score
		}
		
		return score
	}

	func solveB(_: String) -> Int {
		return 0
	}
}
