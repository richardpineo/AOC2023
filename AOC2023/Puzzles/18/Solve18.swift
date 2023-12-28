
import AOCLib
import Foundation

class Solve18: PuzzleSolver {
	func solveAExamples() -> Bool {
		solveA("Example18") == 62
	}

	func solveBExamples() -> Bool {
		solveB("Example18") == 952_408_144_115
	}

	var answerA = "49578"
	var answerB = "52885384955882"

	func solveA() -> String {
		solveA("Input18").description
	}

	func solveB() -> String {
		solveB("Input18").description
	}

	func solveA(_ filename: String) -> Int {
		solve(filename, isA: true)
	}

	func solveB(_ filename: String) -> Int {
		solve(filename, isA: false)
	}

	func solve(_ filename: String, isA: Bool) -> Int {
		let steps = load(filename, isA: isA)
		return area(steps: steps)
	}

	// Shoelace formula stolen from: https://github.com/mnvr/advent-of-code-2023/blob/main/18.swift
	func area(steps: [Step]) -> Int {
		var px = 0, py = 0, s = 0
		for step in steps {
			var x, y: Int
			switch step.heading {
			case .east: (x, y) = (px + step.distance, py)
			case .west: (x, y) = (px - step.distance, py)
			case .south: (x, y) = (px, py - step.distance)
			case .north: (x, y) = (px, py + step.distance)
			}
			s += (py + y) * (px - x)
			s += step.distance
			(px, py) = (x, y)
		}

		return abs(s) / 2 + 1
	}

	struct Step {
		var heading: Heading
		var distance: Int
	}

	func load(_ filename: String, isA: Bool) -> [Step] {
		let lines = FileHelper.load(filename)!.filter { !$0.isEmpty }
		return lines.map {
			let tokens = $0.split(separator: " ")
			if isA {
				let heading: Heading = switch tokens[0] {
				case "R": .east
				case "D": .north
				case "L": .west
				case "U": .south
				default:
					.west
				}
				return .init(
					heading: heading,
					distance: Int(tokens[1])!
				)
			} else {
				let hexDistance = String(tokens[2]).subString(start: 2, count: tokens[2].count - 4)
				let headingStr = String(tokens[2]).subString(start: tokens[2].count - 2, count: 1)
				let heading: Heading = switch headingStr {
				case "0": .east
				case "1": .north
				case "2": .west
				case "3": .south
				default:
					.west
				}
				return .init(
					heading: heading,
					distance: Int(hexDistance, radix: 16)!
				)
			}
		}
	}
}
