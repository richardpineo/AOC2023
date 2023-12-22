
import AOCLib
import Foundation

class Solve14: PuzzleSolver {
	func solveAExamples() -> Bool {
		solveA("Example14") == 136
	}

	func solveBExamples() -> Bool {
		solveB("Example14") == 64
	}

	var answerA = "113525"
	var answerB = "101292"

	func solveA() -> String {
		solveA("Input14").description
	}

	func solveB() -> String {
		solveB("Input14").description
	}

	func findTarget(pos: Position2D, grid: inout Grid2D, direction: Heading) -> Position2D? {
		switch direction {
		case .north:
			if pos.y < 1 {
				return nil
			}
			return pos.offset(0, -1)

		case .south:
			if pos.y >= grid.maxPos.y - 1 {
				return nil
			}
			return pos.offset(0, 1)

		case .west:
			if pos.x < 1 {
				return nil
			}
			return pos.offset(-1, 0)

		case .east:
			if pos.x >= grid.maxPos.x - 1 {
				return nil
			}
			return pos.offset(1, 0)
		}
	}

	func roll(pos: Position2D, grid: inout Grid2D, direction: Heading) {
		guard let target = findTarget(pos: pos, grid: &grid, direction: direction) else {
			return
		}

		if grid.value(pos) == "O", grid.value(target) == "." {
			grid.setValue(target, "O")
			grid.setValue(pos, ".")
			roll(pos: target, grid: &grid, direction: direction)
		}
	}

	func load(on grid: Grid2D) -> Int {
		grid.allPositions.reduce(0) {
			var score = 0
			if grid.value($1) == "O" {
				score = grid.maxPos.y - $1.y
			}
			return $0 + score
		}
	}

	func evalOrder(grid: Grid2D, direction: Heading) -> [Position2D] {
		grid.allPositions.sorted { p1, p2 in
			switch direction {
			case .north:
				return p1.y < p2.y
			case .south:
				return p1.y > p2.y
			case .west:
				return p1.x < p2.x
			case .east:
				return p1.x > p2.x
			}
		}
	}

	func roll(grid: inout Grid2D, direction: Heading) {
		evalOrder(grid: grid, direction: direction).forEach {
			roll(pos: $0, grid: &grid, direction: direction)
		}
	}

	func solveA(_ filename: String) -> Int {
		var grid = Grid2D(fileName: filename)
		roll(grid: &grid, direction: .north)
		return load(on: grid)
	}

	struct Instance {
		var grid: Grid2D
		var count: Int
	}

	var cache: [Grid2D: Instance] = [:]

	func cycle(grid: inout Grid2D, count: Int) -> Int? {
		if let found = cache[grid] {
			grid = found.grid
			return found.count
		}
		let initialGrid = grid.clone()

		roll(grid: &grid, direction: .north)
		roll(grid: &grid, direction: .west)
		roll(grid: &grid, direction: .south)
		roll(grid: &grid, direction: .east)

		cache[initialGrid] = .init(grid: grid, count: count)
		// print("Load: \(load(on: grid))")
		return nil
	}

	func solveB(_ filename: String) -> Int {
		var grid = Grid2D(fileName: filename)

		let count = 1_000_000_000
		var repeatsAt = 0
		var repeatsSourceIndex = 0
		for c in 0 ... count {
			if let repeatGrid = cycle(grid: &grid, count: c) {
				repeatsSourceIndex = repeatGrid
				repeatsAt = c
				break
			}
		}
		// print("index \(repeatsAt) repeats. First seen at \(repeatsSourceIndex)")

		let completeCount = (count - repeatsSourceIndex - 1) % (repeatsAt - repeatsSourceIndex) + repeatsSourceIndex
		let foundInCache = cache.first {
			$0.value.count == completeCount
		}!
		return load(on: foundInCache.value.grid)
	}
}
