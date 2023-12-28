
import AOCLib
import Foundation

class Solve18: PuzzleSolver {
	func solveAExamples() -> Bool {
		solveA("Example18") == 62
	}

	func solveBExamples() -> Bool {
		solveB("Example18") == 0
	}

	var answerA = "49578"
	var answerB = "0"

	func solveA() -> String {
		solveA("Input18").description
	}

	func solveB() -> String {
		solveB("Input18").description
	}

	func solveA(_ filename: String) -> Int {
		let steps = load(filename)
		
		// convert into positions
		var current = Position2D.origin
		var trench: [Position2D] = .init([current])
		var minPos: Position2D = .origin
		steps.forEach {
			for _ in 0 ..< $0.distance {
				current = current.offset($0.heading, 1)
				trench.append(current)
				if current.x < minPos.x {
					minPos.x = current.x
				}
				if current.y < minPos.y {
					minPos.y = current.y
				}
			}
		}
		
		// offset everything
		let trenchOffset: [Position2D] = trench.map {
			.init($0.x - minPos.x, $0.y - minPos.y)
		}
		
		var grid: Grid2D = .init(positions: trenchOffset, value: "#")
		grid.allPositions.forEach {
			if grid.value($0) != "#" {
				grid.setValue( $0, ".")
			}
		}
		print(grid.debugDisplay)
		
		let loop: Set<Position2D> = .init(trenchOffset)
		
		grid.allPositions.forEach {
			let v = grid.value($0)
			if v == "." {
				if pointInLoop(pos: $0, loop: loop, maxPos: grid.maxPos) {
					grid.setValue($0, "#")
				}
			}
		}
		print(grid.debugDisplay)
		let count = grid.allPositions.reduce(0) {
			if grid.value($1) == "#" {
				return $0 + 1
			}
			return $0
		}
		return count
	}

	func solveB(_: String) -> Int {
		return 0
	}
	
	struct Step {
		var heading: Heading
		var distance: Int
		var color: String
	}
	
	func pointInLoop(pos: Position2D, loop: Set<Position2D>, maxPos: Position2D) -> Bool {
		if loop.contains(pos) {
			return false
		}

		// ray-casting algorithm
		var crossCountHorizontal = 0
		
		var wasOnLoopFromNorth: Bool?
		
		for x in pos.x ... maxPos.x {
			let checkPoint: Position2D = .init(x, pos.y)
			
			var crossesLine = false
			
			let nowOnLoop = loop.contains(checkPoint)
			if nowOnLoop {
				if wasOnLoopFromNorth != nil {
					// Was on the loop, nothing to do.
				} else {
					// Now on the loop - is it a horizontal
					if loop.contains(checkPoint.offset(1,0)) {
						// Did we come from the north
						wasOnLoopFromNorth = loop.contains(checkPoint.offset(0, -1))
					} else {
						crossesLine = true
					}
				}
			} else {
				// No longer on loop
				if let fromNorth = wasOnLoopFromNorth {
					let wentSouth =	!loop.contains(checkPoint.offset(-1, 1))
					if fromNorth != wentSouth {
						crossesLine = true
					}
					wasOnLoopFromNorth = nil
				}
			}
			crossCountHorizontal = crossCountHorizontal + (crossesLine ? 1 : 0)
		
		}
		return crossCountHorizontal % 2 == 1
	}
	
	func load(_ filename: String) -> [Step] {
		let lines = FileHelper.load(filename)!.filter { !$0.isEmpty }
		return lines.map {
			let tokens = $0.split(separator: " ")
			let heading: Heading = switch tokens[0] {
			case "R": .east
			case "D":  .north
			case "L":  .west
			case "U":  .south
			default:
				 .west
			}
			return .init(
				heading: heading,
				distance: Int(tokens[1])!,
				color: String(tokens[2])
			)
		}
	}
}
