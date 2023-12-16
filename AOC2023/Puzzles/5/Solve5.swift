
import AOCLib
import Foundation
import RegexBuilder

class Solve5: PuzzleSolver {
	func solveAExamples() -> Bool {
		solveA("Example5") == 35
	}

	func solveBExamples() -> Bool {
		solveB("Example5") == 46
	}

	var answerA = "424490994"
	var answerB = "15290096"

	func solveA() -> String {
		solveA("Input5").description
	}

	func solveB() -> String {
		solveB("Input5").description
	}

	var shouldTestB = false

	func solveA(_ filename: String) -> Int {
		let almanac = load(filename)

		let mappedSeeds = almanac.seeds.map {
			almanac.map($0)
		}

		return mappedSeeds.min()!
	}

	// Super slow impl butit wokrs after 3-4 minutes.
	func solveB(_ filename: String) -> Int {
		let almanac = load(filename)

		let rangeSeeds = almanac.seedsUsingRanges

		func validSeed(_ seed: Int) -> Bool {
			rangeSeeds.first { seed >= $0.start && seed < $0.start + $0.count } != nil
		}

		for answer in 0 ..< Int.max {
			let reverseMapped = almanac.reverseMap(answer)

			if validSeed(reverseMapped) {
				return answer
			}
		}
		return -666
	}

	struct Almanac {
		var seeds: [Int]

		struct SeedRange {
			var start: Int
			var count: Int
		}

		var seedsUsingRanges: [SeedRange] {
			var rangeSeeds: [SeedRange] = []
			for index in 0 ..< seeds.count / 2 {
				rangeSeeds.append(.init(start: seeds[index * 2], count: seeds[index * 2 + 1]))
			}
			return rangeSeeds
		}

		struct Map {
			var sourceName: String
			var destName: String

			struct Entry {
				var source: Int
				var dest: Int
				var length: Int

				func map(_ value: Int) -> Int? {
					if value >= source, value < source + length {
						return value - source + dest
					}
					return nil
				}

				func reverseMap(_ value: Int) -> Int? {
					let sourceValue = value + source - dest
					if sourceValue >= source, sourceValue < source + length {
						return sourceValue
					}
					return nil
				}
			}

			var entries: [Entry]

			func map(_ value: Int) -> Int {
				let found = entries.first { $0.map(value) != nil }
				if let found = found {
					return found.map(value)!
				}
				return value
			}

			func reverseMap(_ value: Int) -> Int {
				let found = entries.first { $0.reverseMap(value) != nil }
				if let found = found {
					return found.reverseMap(value)!
				}
				return value
			}
		}

		func map(_ value: Int) -> Int {
			maps.reduce(value) {
				$1.map($0)
			}
		}

		func reverseMap(_ value: Int) -> Int {
			var chain: Int = value
			for map in maps.reversed() {
				chain = map.reverseMap(chain)
			}
			return chain
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
