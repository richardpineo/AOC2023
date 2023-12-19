
import AOCLib
import Combinatorics
import Foundation

class Solve11: PuzzleSolver {
	func solveAExamples() -> Bool {
		solve("Example11", factor: 1) == 374
	}

	func solveBExamples() -> Bool {
		solve("Example11", factor: 9) == 1030 &&
			solve("Example11", factor: 99) == 8410
	}

	var answerA = "9370588"
	var answerB = "746207878188"

	var shouldTestA: Bool = false
	var shouldTestB: Bool = false

	func solveA() -> String {
		solve("Input11", factor: 1).description
	}

	func solveB() -> String {
		solve("Input11", factor: 999_999).description
	}

	func solve(_ filename: String, factor: Int) -> Int {
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
		let shifted = space.shift(expandRows: emptyCols, expandCols: emptyRows, factor: factor)

		let pairs = Combination(of: 0 ..< shifted.galaxies.count, size: 2)
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

		func shift(pos: Position2D, expandRows: [Int], expandCols: [Int], factor: Int) -> Position2D {
			let colShift = expandRows.filter { $0 < pos.x }.count
			let rowShift = expandCols.filter { $0 < pos.y }.count
			return pos.offset(colShift * factor, rowShift * factor)
		}

		func shift(expandRows: [Int], expandCols: [Int], factor: Int) -> Space {
			let shiftedGalaxy = galaxies.map { shift(pos: $0, expandRows: expandRows, expandCols: expandCols, factor: factor) }
			return .init(galaxies: shiftedGalaxy, maxPos: shift(pos: maxPos, expandRows: expandRows, expandCols: expandCols, factor: factor))
		}
	}

	func load(_ filename: String) -> Space {
		let lines = FileHelper.load(filename)!.filter { !$0.isEmpty }
		let grid = Grid2D(fileName: filename)
		let galaxies = grid.allPositions.filter { grid.value($0) == "#" }
		return .init(galaxies: galaxies, maxPos: grid.maxPos)
	}
}
