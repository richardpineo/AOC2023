
import AOCLib
import Foundation

class Solve3: PuzzleSolver {
	func solveAExamples() -> Bool {
		solveA("Example3") == 4361 &&
		solveA("Example3b") == 925
	}

	func solveBExamples() -> Bool {
		solveB("Example3") == 0
	}

	var answerA = "520135"
	var answerB = "0"

	func solveA() -> String {
		solveA("Input3").description
	}

	func solveB() -> String {
		solveB("Input3").description
	}

	struct Schematic {
		struct PossiblePart {
			var posStart: Position2D
			var posEnd: Position2D = .origin
		}

		var grid: Grid2D
		var possibleParts: [PossiblePart]
		
		func partNumber(part: PossiblePart) -> Int {
			var numberStr = ""
			for x in part.posStart.x ... part.posEnd.x {
				numberStr.append(grid.value(.init(x, part.posStart.y)))
			}
			return Int(numberStr) ?? 0
		}
	}

	func isSymbol(_ c: Character) -> Bool {
		let symbols = "!@#$%^&*()-+/="
		return symbols.contains(c)
	}
	
	func findParts(schematic: Schematic) -> [Schematic.PossiblePart] {
		return schematic.possibleParts.filter { part in
			var neighbors: Set<Position2D> = .init()
			
			for x in part.posStart.x ... part.posEnd.x {
				let posNeighbors = schematic.grid.neighbors(.init(x, part.posStart.y), includePos: false, includeDiagonals: true)
				posNeighbors.forEach {
					neighbors.insert($0)
				}
			}
			
			let isPart = neighbors.first {
				isSymbol(schematic.grid.value($0))
			} != nil

			return isPart
		}
	}

	func solveA(_ fileName: String) -> Int {
		let schematic = loadParts(fileName)

		// Find all the parts that are adjacent to a symbol
		let parts = findParts(schematic: schematic)
		
		// Convert parts into numbers
		let numbers = parts.compactMap {
			schematic.partNumber(part: $0)
		}
		
		return numbers.reduce(0,+)
	}

	func loadParts(_ fileName: String) -> Schematic {
		let grid = Grid2D(fileName: fileName)

		var parts: [Schematic.PossiblePart] = []

		// Find the positions of all the parts
		for y in 0 ..< grid.maxPos.y {
			// Find all the numbers
			var currentPart: Position2D?
			for x in 0 ..< grid.maxPos.x {
				let isNumber = grid.value(.init(x, y)).isNumber

				if let currentStartPos = currentPart {
					if !isNumber {
						// current number is done.
						parts.append(.init(posStart: currentStartPos, posEnd: .init(x - 1, y)))
						currentPart = nil
					}
				} else {
					if isNumber {
						currentPart = .init(x, y)
					}
				}
			}
			if let currentStartPos = currentPart {
				parts.append(.init(posStart: currentStartPos, posEnd: .init(grid.maxPos.x - 1, y)))
			}
		}
		
		// Sanity check.
		grid.allPositions.forEach {
			let value = grid.value($0)
			if value != "." && !value.isNumber && !isSymbol(value) {
				print("Uknown symbol: \(value)")
			}
		}

		return .init(grid: grid, possibleParts: parts)
	}

	func solveB(_: String) -> Int {
		0
	}
}
