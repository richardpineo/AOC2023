
import AOCLib
import Foundation

class Solve12: PuzzleSolver {
	func solveAExamples() -> Bool {
		solveA("Example12") == 21
	}

	func solveBExamples() -> Bool {
		solveB("Example12") == 0
	}

	var answerA = "7221"
	var answerB = "0"

	func solveA() -> String {
		solveA("Input12").description
	}

	func solveB() -> String {
		solveB("Input12").description
	}

	func solveA(_ filename: String) -> Int {
		let records = load(filename)
		let counts = records.rows.map {
			rowArrangements($0)
		}
		return counts.reduce(0, +)
	}

	func solveB(_: String) -> Int {
		return 0
	}
	
	enum Condition {
		case operational
		case damaged
		case unknown
	}
	struct Records {
		struct Row {
			var springs: [Condition]
			var broken: [Int]
		}
		var rows: [Row]
	}
	
	func couldPass(springs: [Condition], broken: [Int]) -> Bool {
		let currentBroken = springs.split(whereSeparator: {$0 == .operational || $0 == .unknown })
		if currentBroken.isEmpty {
			return true
		}
		let brokenIndex = currentBroken.count - 1
		if brokenIndex >= broken.count {
			return false
		}
		if currentBroken.last!.count > broken[brokenIndex] {
			return false
		}

		return true
	}
	
	func doesPass(springs: [Condition], broken: [Int]) -> Bool {
		let actualBroken = springs.split(whereSeparator: {$0 == .operational || $0 == .unknown })
		let counts = actualBroken.map { $0.count }
		return counts == broken
	}
		
	func rowArrangements(_ row: Records.Row) -> Int {
		var possibilities: Queue<[Condition]> = .init(from: [row.springs])
		var complete: [[Condition]] = []
		while let next = possibilities.dequeue() {
			let index = next.firstIndex { $0 == .unknown }
			guard let index = index else {
				if doesPass(springs: next, broken: row.broken) {
					complete.append(next)
				}
				continue
			}
			
			var p1 = next
			var p2 = next
			p1[index] = .damaged
			p2[index] = .operational
			
			if couldPass(springs: Array( p1[0 ... index]), broken: row.broken) {
				possibilities.enqueue(p1)
			}
			
			if couldPass(springs: Array(p2[0 ... index]), broken: row.broken) {
				possibilities.enqueue(p2)
			}
		}
		
		return complete.count
	}
		
	func load(_ filename: String) -> Records {
		let lines = FileHelper.load(filename)!.filter { !$0.isEmpty }
		
		let rows: [Records.Row] = lines.map {
			let tokens = $0.split(separator: " ")
			let conditions: [Condition] = tokens[0].map {
				switch $0 {
				case "?":
					return .unknown
				case ".":
					return .operational
				case "#":
					return .damaged
				default:
					return .unknown
				}
			}
			let broken = tokens[1].split(separator: ",").map { Int($0)! }
			return .init(springs: conditions, broken: broken)
		}
		
		return .init(rows: rows)
	}
}
