
import AOCLib
import Foundation

class Solve16: PuzzleSolver {
	func solveAExamples() -> Bool {
		solveA("Example16") == 46
	}

	func solveBExamples() -> Bool {
		solveB("Example16") == 51
	}

	var answerA = "8539"
	var answerB = "8674"

	var shouldTestB = false

	func solveA() -> String {
		solveA("Input16").description
	}

	func solveB() -> String {
		solveB("Input16").description
	}

	struct Cells {
		let grid: Grid2D
		var visited: Set<Beam> = .init()

		func numVisited(pos: Position2D) -> Int {
			visited.filter { $0.pos == pos }.count
		}

		var numVisited: Int {
			grid.allPositions.reduce(0) {
				$0 + (numVisited(pos: $1) > 0 ? 1 : 0)
			}
		}

		func debugDisplay() {
			var s = ""
			for y in 0 ..< grid.maxPos.y {
				for x in 0 ..< grid.maxPos.x {
					let num = numVisited(pos: .init(x, y))
					s += "\(num > 0 ? "#" : ".")"
				}
				s += "\n"
			}
			print("\(s)")
		}
	}

	struct Beam: Hashable {
		var pos: Position2D
		var heading: Heading
	}

	func stepBeam(beam: Beam, cells: inout Cells) -> [Beam] {
		let nextPos = beam.pos.offset(beam.heading)
		if !cells.grid.valid(nextPos) {
			return []
		}
		let nextBeam: Beam = .init(pos: nextPos, heading: beam.heading)
		if cells.visited.contains(nextBeam) {
			return []
		}
		cells.visited.insert(nextBeam)

		switch cells.grid.value(nextBeam.pos) {
		case ".":
			return [nextBeam]
		case "|":
			if beam.heading == .east || beam.heading == .west {
				return [
					.init(pos: nextPos, heading: .north),
					.init(pos: nextPos, heading: .south),
				]
			} else {
				return [nextBeam]
			}
		case "-":
			if beam.heading == .north || beam.heading == .south {
				return [
					.init(pos: nextPos, heading: .east),
					.init(pos: nextPos, heading: .west),
				]
			} else {
				return [nextBeam]
			}
		case "\\":
			switch beam.heading {
			case .east:
				return [.init(pos: nextPos, heading: .north)]
			case .west:
				return [.init(pos: nextPos, heading: .south)]
			case .north:
				return [.init(pos: nextPos, heading: .east)]
			case .south:
				return [.init(pos: nextPos, heading: .west)]
			}

		case "/":
			switch beam.heading {
			case .east:
				return [.init(pos: nextPos, heading: .south)]
			case .west:
				return [.init(pos: nextPos, heading: .north)]
			case .north:
				return [.init(pos: nextPos, heading: .west)]
			case .south:
				return [.init(pos: nextPos, heading: .east)]
			}
		default:
			print("ERROR ERROR BEEP BEEP")
			return []
		}
	}

	func solve(grid: Grid2D, starting: Beam) -> Int {
		var cells: Cells = .init(grid: grid)

		var beams: Queue<Beam> = .init()
		beams.enqueue(starting)
		while let beam = beams.dequeue() {
			let newBeams = stepBeam(beam: beam, cells: &cells)
			newBeams.forEach {
				beams.enqueue($0)
			}
		}

		return cells.numVisited
	}

	func solveA(_ filename: String) -> Int {
		let grid: Grid2D = .init(fileName: filename)
		return solve(grid: grid, starting: .init(pos: .init(-1, 0), heading: .east))
	}

	func solveB(_ filename: String) -> Int {
		let grid: Grid2D = .init(fileName: filename)

		var startingPositions: [Beam] = []
		for x in 0 ..< grid.maxPos.x {
			startingPositions.append(.init(pos: .init(x, -1), heading: .north))
			startingPositions.append(.init(pos: .init(x, grid.maxPos.y), heading: .south))
		}
		for y in 0 ..< grid.maxPos.y {
			startingPositions.append(.init(pos: .init(-1, y), heading: .east))
			startingPositions.append(.init(pos: .init(grid.maxPos.x, y), heading: .west))
		}

		var max = 0
		startingPositions.forEach {
			let visited = solve(grid: grid, starting: $0)
			if visited > max {
				max = visited
			}
		}
		return max
	}
}
