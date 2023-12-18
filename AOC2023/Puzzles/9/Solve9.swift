
import AOCLib
import Foundation

class Solve9: PuzzleSolver {
	func solveAExamples() -> Bool {
		solveA("Example9") == 114
	}

	func solveBExamples() -> Bool {
		solveB("Example9") == 2
	}

	var answerA = "1904165718"
	var answerB = "964"

	func solveA() -> String {
		solveA("Input9").description
	}

	func solveB() -> String {
		solveB("Input9").description
	}

	func solveA(_ filename: String) -> Int {
		let report = load(filename)
		let changes = report.histories.map { $0.allChanges }
		let nextValues = changes.map(nextValue)
		return nextValues.reduce(0, +)
	}

	func solveB(_ filename: String) -> Int {
		let report = load(filename)
		let changes = report.histories.map { $0.allChanges }
		let prevValues = changes.map(prevValue)
		return prevValues.reduce(0, +)
	}
	
	func nextValue(histories: [Report.History]) -> Int {
		histories.reversed().reduce(0) {
			$0 + $1.values.last!
		}
	}
	
	func prevValue(histories: [Report.History]) -> Int {
		histories.reversed().reduce(0) {
			$1.values.first! - $0
		}
	}
	
	struct Report {
		struct History {
			var values: [Int]
			
			var isZeroes: Bool {
				values.allSatisfy { $0 == 0 }
			}
			
			var changes: History {
				var changeValues: [Int] = []
				for index in 0 ..< values.count - 1 {
					changeValues.append(values[index + 1] - values[index])
				}
				return .init(values: changeValues)
			}
			
			var allChanges: [History] {
				var result: [History] = []
				var current = self
				while !current.isZeroes {
					result.append(current)
					current = current.changes
				}
				return result
			}
		}
		
		var histories: [History]
	}
	
	func load(_ filename: String) -> Report {
		let lines = FileHelper.load(filename)!.filter { !$0.isEmpty }
		return .init(histories: lines.map {
			.init( values: $0.split(separator: " ").map { Int($0)! })
		})
	}
}
