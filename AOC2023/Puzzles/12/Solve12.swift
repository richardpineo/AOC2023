
import AOCLib
import Foundation

class Solve12: PuzzleSolver {
	func solveAExamples() -> Bool {
		solveA("Example12") == 21
	}

	func solveBExamples() -> Bool {
		solveB("Example12") == 0
	}

	var answerA = "0"
	var answerB = "0"

	func solveA() -> String {
		solveA("Input12").description
	}

	func solveB() -> String {
		solveB("Input12").description
	}

	func solveA(_ filename: String) -> Int {
		let records = load(filename)
		return 0
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
