
import AOCLib
import Foundation

class Solve10: PuzzleSolver {
	func solveAExamples() -> Bool {
		solveA("Example10a") == 4 &&
			solveA("Example10a-2") == 8
	}

	func solveBExamples() -> Bool {
		solveB("Example10b") == 4 &&
			solveB("Example10b-2") == 8 &&
			solveB("Example10b-3") == 10
	}

	var answerA = "7066"
	var answerB = "401"

	func solveA() -> String {
		solveA("Input10").description
	}

	func solveB() -> String {
		solveB("Input10").description
	}

	func solveA(_ filename: String) -> Int {
		let field = load(filename)
		return field.loop.count / 2
	}

	func solveB(_ filename: String) -> Int {
		let field = load(filename)
		let loop = field.loop
		let pointsInLoop = field.pipes.allPositions.filter {
			field.pointInLoop(pos: $0, loop: loop)
		}
		return pointsInLoop.count
	}

	struct Field {
		var pipes: Grid2D
		var startLoc: Position2D {
			pipes.allPositions.first { pipes.value($0) == "S" }!
		}

		var loop: Set<Position2D> {
			let startLoc = startLoc
			var exits = exits(for: startLoc)
			var prevs = [startLoc, startLoc]
			var loop: Set<Position2D> = .init(exits + [startLoc])
			while exits[0] != exits[1] {
				let temp = exits
				exits = [
					exit(for: exits[0], from: prevs[0]),
					exit(for: exits[1], from: prevs[1]),
				]
				prevs = temp
				loop.insert(exits[0])
				loop.insert(exits[1])
			}
			return loop
		}

		func pointInLoop(pos: Position2D, loop: Set<Position2D>) -> Bool {
			if loop.contains(pos) {
				return false
			}

			// ray-casting algorithm
			var crossCountHorizontal = 0
			for x in pos.x ... pipes.maxPos.x {
				let checkPoint: Position2D = .init(x, pos.y)
				if loop.contains(checkPoint),
				   crosses(pos: checkPoint, horizontal: true)
				{
					crossCountHorizontal = crossCountHorizontal + 1
				}
			}
			return crossCountHorizontal % 2 == 1
		}

		func crosses(pos: Position2D, horizontal: Bool) -> Bool {
			switch pipes.value(pos) {
			case "F", "7", "S":
				return true
			case "J", "L":
				return false
			case "|": return horizontal
			case "-": return !horizontal
			default:
				return false
			}
		}

		func exits(for pos: Position2D) -> [Position2D] {
			switch pipes.value(pos) {
			case "|":
				return [pos.offset(0, 1), pos.offset(0, -1)]
			case "-":
				return [pos.offset(1, 0), pos.offset(-1, 0)]
			case "L":
				return [pos.offset(1, 0), pos.offset(0, -1)]
			case "J":
				return [pos.offset(-1, 0), pos.offset(0, -1)]
			case "7":
				return [pos.offset(-1, 0), pos.offset(0, 1)]
			case "F":
				return [pos.offset(1, 0), pos.offset(0, 1)]
			case ".":
				return []
			case "S":
				let possibilities = pipes.neighbors(pos, includePos: false)
				return possibilities.filter { exits(for: $0).contains(pos) }
			default:
				return []
			}
		}

		func exit(for pos: Position2D, from source: Position2D) -> Position2D {
			return exits(for: pos).filter { $0 != source }.first!
		}
	}

	func load(_ filename: String) -> Field {
		.init(pipes: .init(fileName: filename))
	}
}
