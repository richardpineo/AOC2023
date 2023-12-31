
import AOCLib
import Foundation

class Solve13: PuzzleSolver {
	func solveAExamples() -> Bool {
		problematicA() &&
			solveA("Example13") == 405
	}

	func solveBExamples() -> Bool {
		problematicB() &&
			solveB("Example13") == 400
	}

	var answerA = "30158"
	var answerB = "36474"

	func solveA() -> String {
		solveA("Input13").description
	}

	func solveB() -> String {
		solveB("Input13").description
	}

	let verbose = false

	func gridScore(_ grid: Grid2D, ignore: Int?) -> Int {
		if verbose {
			print("")
			print(grid.debugDisplay)
		}

		let horz = horizScore(grid: grid, ignore: ignore)
		let vert = vertScore(grid: grid, ignore: ignore)

		if verbose {
			if horz > 0 {
				print("Horizontal divide: \(horz)")
			}
			if vert > 0 {
				print("Vertical divide: \(vert)")
			}
			if horz == 0, vert == 0 {
				print("NO DIVIDE")
			}
		}

		return horz + vert
	}

	func divides(row: Int, grid: Grid2D) -> Bool {
		if row < 1 || row >= grid.maxPos.y {
			return false
		}
		for check in 1 ... row {
			let r1 = grid.row(row - check)
			let r2 = grid.row(row + check - 1)
			if r1.isEmpty || r2.isEmpty {
				break
			}
			if verbose {
				print("check \(r1) vs \(r2): \(r1 == r2 ? "OK" : "NOPE")")
			}
			if r1 != r2 {
				return false
			}
		}
		return true
	}

	func divides(col: Int, grid: Grid2D) -> Bool {
		if col < 1 || col >= grid.maxPos.x {
			return false
		}

		for check in 1 ... col {
			let c1 = grid.col(col - check)
			let c2 = grid.col(col + check - 1)
			if c1.isEmpty || c2.isEmpty {
				break
			}
			if verbose {
				print("check \(c1) vs \(c2): \(c1 == c2 ? "OK" : "NOPE")")
			}
			if c1 != c2 {
				return false
			}
		}
		return true
	}

	func horizScore(grid: Grid2D, ignore: Int?) -> Int {
		for x in 1 ..< grid.maxPos.y {
			let score = x * 100
			if score == ignore {
				continue
			}
			if divides(row: x, grid: grid) {
				return score
			}
		}
		return 0
	}

	func vertScore(grid: Grid2D, ignore: Int?) -> Int {
		for y in 1 ..< grid.maxPos.x {
			if y == ignore {
				continue
			}
			if divides(col: y, grid: grid) {
				return y
			}
		}
		return 0
	}

	func solveA(_ filename: String) -> Int {
		let grids = load(filename)
		let scores = grids.map { gridScore($0, ignore: nil) }
		return scores.reduce(0, +)
	}

	func smudge(_ grid: Grid2D, _ position: Position2D) -> Grid2D {
		var smudged = grid.clone()
		let smudgeValue = grid.value(position) == "#" ? ":" : "#"
		smudged.setValue(position, Character(smudgeValue))
		return smudged
	}

	func smudgeScore(_ grid: Grid2D) -> Int {
		let originalScore = gridScore(grid, ignore: nil)
		let smudgePos = grid.allPositions.first {
			let smudged = smudge(grid, $0)
			let smudgeScore = gridScore(smudged, ignore: originalScore)
			return smudgeScore > 0
		}
		guard let smudged = smudgePos else {
			print("FAIL")
			print(grid.debugDisplay)
			return -666
		}
		return gridScore(smudge(grid, smudged), ignore: originalScore)
	}

	func solveB(_ filename: String) -> Int {
		let grids = load(filename)
		let scores = grids.map(smudgeScore)
		return scores.reduce(0, +)
	}

	func load(_ filename: String) -> [Grid2D] {
		let lines = FileHelper.load(filename)!
		let gridSrc = lines.split(separator: "")
		return gridSrc.map {
			.init(lines: Array($0))
		}
	}

	func problematicA() -> Bool {
		let problematic = """
		########.....
		...##.....##.
		.........####
		#.#..#.#####.
		#.#######..#.
		#.####.#.#..#
		###..#####.#.
		#.#..#.#..##.
		..####....#.#
		..####...#...
		#.#..#.#.#..#
		#.####.#.....
		#.####.#.....
		"""
		let grid = Grid2D(lines: problematic.split(separator: "\n").map { String($0) })
		//	print (grid.debugDisplay)
		return gridScore(grid, ignore: nil) == 1200
	}

	func problematicB() -> Bool {
		let problematic = """
		.###...#.....
		.###...#.....
		..####.#####.
		...#.##.##.##
		#.###...###..
		####.#.#.###.
		#.#.#.##...##
		#.#.#.##...##
		####.###.###.
		#.###...###..
		...#.##.##.##
		..####.#####.
		.###...#.....
		"""
		let grid = Grid2D(lines: problematic.split(separator: "\n").map { String($0) })
		//	print (grid.debugDisplay)
		return smudgeScore(grid) == 700
	}
}
