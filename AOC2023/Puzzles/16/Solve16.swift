
import AOCLib
import Foundation

class Solve16: PuzzleSolver {
	func solveAExamples() -> Bool {
		solveA("Example16") == 46
	}

	func solveBExamples() -> Bool {
		solveB("Example16") == 0
	}

	var answerA = "0"
	var answerB = "0"

	func solveA() -> String {
		solveA("Input16").description
	}

	func solveB() -> String {
		solveB("Input16").description
	}

	struct Cells {
		let grid: Grid2D
		var visited: Set<Beam> = .init()
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
		case "/":
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

		case "\\":
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

	func solveA(_ filename: String) -> Int {
		let grid: Grid2D = .init(fileName: filename)

		// Each cell has light in up to 4 directions
		var cells: Cells = .init(grid: grid)

		let start: Beam = .init(pos: .origin, heading: .east)
		var beams: [Beam] = [start]
		cells.visited.insert(start)

		return 0
	}

	func solveB(_: String) -> Int {
		return 0
	}
}
