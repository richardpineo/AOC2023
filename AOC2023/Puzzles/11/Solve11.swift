
import AOCLib
import Foundation
import Combinatorics

class Solve11: PuzzleSolver {
	func solveAExamples() -> Bool {
		solveA("Example11") == 374
	}

	func solveBExamples() -> Bool {
		solveB("Example11") == 0
	}

	var answerA = "9370588"
	var answerB = "0"

	func solveA() -> String {
		solveA("Input11").description
	}

	func solveB() -> String {
		solveB("Input11").description
	}

	func solveA(_ filename: String) -> Int {
		let space = load(filename)
		let emptyRows = (0 ..< space.maxPos.y).filter { y in
			!space.galaxies.contains { galaxy in
				galaxy.y == y
			}
		}
		let emptyCols = (0 ..< space.maxPos.x).filter { x in
			!space.galaxies.contains { galaxy in
				galaxy.x == x
			}
		}
		
		// Shift the galaxies appropriately.
		let shifted = space.shift(expandRows: emptyCols, expandCols: emptyRows)

		let pairs =  Combination(of: 0 ..< shifted.galaxies.count, size: 2)
		let distances = pairs.map {
			let g1 = shifted.galaxies[$0[0]]
			let g2 = shifted.galaxies[$0[1]]
			return g1.cityDistance(g2)
		}
		return distances.reduce(0, +)
	}

	func solveB(_: String) -> Int {
		return 0
	}
	
	struct Space {
		var galaxies: [Position2D]
		var maxPos: Position2D
		
		func shift(pos: Position2D, expandRows: [Int], expandCols: [Int]) -> Position2D {
			let colShift = expandRows.filter { $0 < pos.x }.count
			let rowShift = expandCols.filter { $0 < pos.y }.count
			return pos.offset(colShift, rowShift)
		}
		
		func shift(expandRows: [Int], expandCols: [Int]) -> Space {
			let shiftedGalaxy = galaxies.map { shift(pos: $0, expandRows: expandRows, expandCols: expandCols)}
			return .init(galaxies: shiftedGalaxy, maxPos: shift(pos: maxPos,expandRows: expandRows, expandCols: expandCols))
		}
	}
	
	func load(_ filename: String) -> Space {
		let lines = FileHelper.load(filename)!.filter { !$0.isEmpty }
		let grid = Grid2D(fileName: filename)
		let galaxies = grid.allPositions.filter { grid.value($0) == "#" }
		return .init(galaxies: galaxies, maxPos: grid.maxPos)
	}
}
