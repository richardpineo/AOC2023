
import AOCLib
import Foundation

class Solve12: PuzzleSolver {
	func solveAExamples() -> Bool {
		solveA("Example12") == 21
	}

	func solveBExamples() -> Bool {
		solveB("Example12") == 525_152
	}

	var answerA = "7221"
	var answerB = "7139671893722"

	func solveA() -> String {
		solveA("Input12").description
	}

	func solveB() -> String {
		solveB("Input12").description
	}

	func solveA(_ filename: String) -> Int {
		let records = load(filename)
		let counts = records.map {
			count(.init(springs: $0.springs, broken: $0.broken))
		}
		return counts.reduce(0,+)
	}

	func solveB(_ filename: String) -> Int {
		let records = load(filename)
		let expandedRows: [State] = records.map {
			let springs = $0.springs + "?" + $0.springs + "?" + $0.springs + "?" + $0.springs + "?" + $0.springs
			let broken = $0.broken + $0.broken + $0.broken + $0.broken + $0.broken
			return .init(springs: springs, broken: broken)
		}

		let counts = expandedRows.map {
			count(.init(springs: $0.springs, broken: $0.broken))
		}
		return counts.reduce(0,+)
	}

	struct State: Hashable {
		var springs: String
		var broken: [Int]
	}

	var cache: [State: Int] = [:]

	func count(_ state: State) -> Int {
		if state.springs.isEmpty {
			return state.broken.isEmpty ? 1 : 0
		}
		if state.broken.isEmpty {
			return state.springs.contains("#") ? 0 : 1
		}

		if let cachedVal = cache[state] {
			return cachedVal
		}

		var result = 0

		if ".?".contains(state.springs.character(at: 0)) {
			let next: State = .init(springs: String(state.springs.dropFirst()), broken: state.broken)
			result = result + count(next)
		}

		if "#?".contains(state.springs.character(at: 0)) {
			let groupSize = state.broken[0]
			if groupSize <= state.springs.count,
			   !state.springs.subString(start: 0, count: groupSize).contains("."),
			   groupSize == state.springs.count || state.springs.character(at: groupSize) != "#"
			{
				let next: State = .init(springs: String(state.springs.dropFirst(groupSize + 1)),
				                        broken: Array(state.broken.dropFirst()))
				result = result + count(next)
			}
		}

		cache[state] = result
		return result
	}

	func load(_ filename: String) -> [State] {
		let lines = FileHelper.load(filename)!.filter { !$0.isEmpty }

		let rows: [State] = lines.map {
			let tokens = $0.split(separator: " ")
			let broken = tokens[1].split(separator: ",").map { Int($0)! }
			return .init(springs: String(tokens[0]), broken: broken)
		}
		return rows
	}
}
