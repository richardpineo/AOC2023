
import AOCLib
import Foundation

class Solve10: PuzzleSolver {
	func solveAExamples() -> Bool {
		solveA("Example10") == 4 &&
		solveA("Example10-2") == 8
	}

	func solveBExamples() -> Bool {
		solveB("Example10") == 0
	}

	var answerA = "7066"
	var answerB = "0"

	func solveA() -> String {
		solveA("Input10").description
	}

	func solveB() -> String {
		solveB("Input10").description
	}

	func solveA(_ filename: String) -> Int {
		let field = load(filename)
		let startLoc = field.startLoc
		var exits = field.exits(for: startLoc)
		var prevs = [startLoc, startLoc]
		var steps = 1
		while exits[0] != exits[1] {
			let temp = exits
			exits = [
				field.exit(for: exits[0], from: prevs[0]),
				field.exit(for: exits[1], from: prevs[1])
			]
			prevs = temp
			steps = steps + 1
		}
		return steps
	}

	func solveB(_: String) -> Int {
		return 0
	}
	
	struct Field {
		var pipes: Grid2D
		var startLoc: Position2D {
			pipes.allPositions.first { pipes.value($0) == "S" }!
		}
		
		func exits(for pos: Position2D) -> [Position2D] {
			switch  pipes.value(pos) {
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
