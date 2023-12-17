
import AOCLib
import Foundation
import RegexBuilder

class Solve8: PuzzleSolver {
	func solveAExamples() -> Bool {
		solveA("Example8") == 6
	}

	func solveBExamples() -> Bool {
		solveB("Example8") == 0
	}

	var answerA = "17287"
	var answerB = "0"

	func solveA() -> String {
		solveA("Input8").description
	}

	func solveB() -> String {
		solveB("Input8").description
	}

	func solveA(_ filename: String) -> Int {
		let network = load(filename)
		return network.walk()
	}

	func solveB(_: String) -> Int {
		return 0
	}
	
	struct Network {
		enum Instruction {
			case left
			case right
		}
		var instructions: [Instruction]
		
		func instruction(for step: Int) -> Instruction {
			return instructions[step % instructions.count]
		}
		
		struct Node {
			var left: String
			var right: String
		}
		var nodes: [String: Node]
		
		func walk() -> Int {
			var step = 0
			var node = "AAA"
			while node != "ZZZ" {
				let found = nodes[node]!
				if instruction(for: step) == .left {
					node = found.left
				} else {
					node = found.right
				}
				step = step + 1
			}
			return step
		}
	}
	
	func load(_ filename: String) -> Network {
		let lines = FileHelper.load(filename)!.filter { !$0.isEmpty }
		let instructions: [Network.Instruction] = lines[0].map {
			$0 == "R" ? .right : .left
		}
		
		// BBB = (DDD, EEE)
		let nodeEx = Regex {
			Capture { OneOrMore(.word) }
			One(" = (")
			Capture { OneOrMore(.word) }
			One(", ")
			Capture { OneOrMore(.word) }
			One(")")
		}
		
		var nodes: [String: Network.Node] = [:]
		lines.dropFirst().forEach {
			let nodeMatch = $0.firstMatch(of: nodeEx)!
			nodes[String(nodeMatch.1)] = .init(left: String(nodeMatch.2), right: String(nodeMatch.3))
		}
		return .init(instructions: instructions, nodes: nodes)
	}
}
