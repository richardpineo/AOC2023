
import AOCLib
import Foundation
import RegexBuilder

class Solve5: PuzzleSolver {
	func solveAExamples() -> Bool {
		solveA("Example5") == 35
	}

	func solveBExamples() -> Bool {
		solveB("Example5") == 0
	}

	var answerA = "424490994"
	var answerB = "0"

	func solveA() -> String {
		solveA("Input5").description
	}

	func solveB() -> String {
		solveB("Input5").description
	}

	func solveA(_ filename: String) -> Int {
		let almanac = load(filename)
		
		let mappedSeeds = almanac.seeds.map {
			almanac.map($0)
		}
		
		return mappedSeeds.min()!
	}

	func solveB(_: String) -> Int {
		return 0
	}

	struct Almanac {
		var seeds: [Int]

		struct Map {
			var sourceName: String
			var destName: String

			struct Entry {
				var source: Int
				var dest: Int
				var length: Int
				
				func map(_ value: Int) -> Int? {
					if value >= source && value < source + length {
						return value - source + dest
					}
					return nil
				}
			}

			var entries: [Entry]

			func map( _ value: Int) -> Int {
				let mapped = entries.compactMap {
					if let mappedValue = $0.map(value) {
						return mappedValue
					}
					return nil
				}
				return mapped.first ?? value
			}
		}
		
		func map( _ value: Int) -> Int {
			maps.reduce(value) {
				return $1.map($0)
			}
		}

		var maps: [Map]
	}

	func load(_ filename: String) -> Almanac {
		let lines = FileHelper.load(filename)!.filter { !$0.isEmpty }
		// seeds: 79 14 55 13
		let seeds: [Int] = lines[0]
			.subString(start: 7, count: lines[0].count - 7)
			.split(separator: " ")
			.map { Int($0)! }

		let mapDescription = Regex {
			Capture {
				OneOrMore(.word)
			}
			One("-to-")
			Capture {
				OneOrMore(.word)
			}
		}

		var index = 1
		var maps: [Almanac.Map] = []
		while index < lines.count {
			guard let mapNames = lines[index].firstMatch(of: mapDescription) else {
				break
			}
			index += 1
			var entries: [Almanac.Map.Entry] = []
			while index < lines.count {
				let values: [Int] = lines[index].split(separator: " ").compactMap { Int($0) }
				if values.count != 3 {
					break
				}
				entries.append(.init(source: values[1], dest: values[0], length: values[2]))
				index += 1
			}
			maps.append(.init(sourceName: String(mapNames.output.1), destName: String(mapNames.output.2), entries: entries))
		}

		return .init(seeds: seeds, maps: maps)
	}
}
