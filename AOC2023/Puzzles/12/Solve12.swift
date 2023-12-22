
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
		let counts = records.rows.map {
			count(springs: $0.springs, broken: $0.broken)
		}
		return counts.reduce(0,+)
	}
	
	func solveB(_ filename: String) -> Int {
		let records = load(filename)
		let expandedRows: [Records.Row] = records.rows.map {
			let springs = $0.springs + "?" + $0.springs + "?" + $0.springs + "?" + $0.springs + "?" + $0.springs
			let broken = $0.broken + $0.broken + $0.broken + $0.broken + $0.broken
			return .init(springs: springs, broken: broken)
		}
		
		let counts = expandedRows.map {
			count(springs: $0.springs, broken: $0.broken)
		}
		return counts.reduce(0,+)
	}
	
	struct CacheKey: Hashable {
		var springs: String
		var broken: [Int]
	}
	var cache: [CacheKey: Int] = [:]
	
	func count(springs: String, broken: [Int]) -> Int {
		if springs.isEmpty {
			return broken.isEmpty ? 1 : 0
		}
		if broken.isEmpty {
			return springs.contains("#") ? 0 : 1
		}
		
		let cacheKey = CacheKey(springs: springs, broken: broken)
		if let cachedVal = cache[cacheKey] {
			return cachedVal
		}
		
		var result = 0

		if ".?".contains( springs.character(at: 0)) {
			result = result + count(springs: String(springs.dropFirst()), broken: broken)
		}
		
		if "#?".contains(springs.character(at: 0)) {
			if broken[0] <= springs.count && 
				!springs.subString(start: 0, count: broken[0]).contains(".") &&
				(broken[0] == springs.count || springs.character(at: broken[0]) != "#") {
				let recurseCount = count(springs: String(springs.dropFirst(broken[0] + 1)), broken: Array(broken.dropFirst()))
				result = result + recurseCount
			}
		}

		cache[cacheKey] = result
		return result
	}

	func load(_ filename: String) -> Records {
		let lines = FileHelper.load(filename)!.filter { !$0.isEmpty }
		
		let rows: [Records.Row] = lines.map {
			let tokens = $0.split(separator: " ")
			let broken = tokens[1].split(separator: ",").map { Int($0)! }
			return .init(springs: String(tokens[0]), broken: broken )
		}
		return .init(rows: rows)
	}
	
	struct Records {
		struct Row {
			var springs: String
			var broken: [Int]
		}
		
		var rows: [Row]
	}
}
	
