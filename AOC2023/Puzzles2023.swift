
import AOCLib
import SwiftUI

class Puzzles2023: PuzzlesRepo {
	init() {
		let year = 2023

		puzzles = Puzzles(puzzles: [
			Puzzle(year: year, id: 1, name: "Trebuchet?!") { Solve1() },
			Puzzle(year: year, id: 2, name: "Cube Conundrum") { Solve2() },
			Puzzle(year: year, id: 3, name: "Gear Ratios") { Solve3() },
			Puzzle(year: year, id: 4, name: "Scratchcards") { Solve4() },
			Puzzle(year: year, id: 5, name: "If You Give A Seed A Fertilizer") { Solve5() },
			Puzzle(year: year, id: 6, name: "Wait For It") { Solve6() },
			Puzzle(year: year, id: 7, name: "Camel Cards") { Solve7() },
			Puzzle(year: year, id: 8, name: "Haunted Wasteland") { Solve8() },
			Puzzle(year: year, id: 9, name: "Mirage Maintenance") { Solve9() },
			Puzzle(year: year, id: 10, name: "Pipe Maze") { Solve10() },
			Puzzle(year: year, id: 11, name: "Cosmic Expansion") { Solve11() },
			Puzzle(year: year, id: 12, name: "Hot Springs") { Solve12() },
			Puzzle(year: year, id: 13, name: "Point of Incidence") { Solve13() },
			Puzzle(year: year, id: 14, name: "Parabolic Reflector Dish") { Solve14() },
			Puzzle(year: year, id: 15, name: "Lens Library") { Solve15() },
			Puzzle(year: year, id: 16, name: "The Floor Will Be Lava") { Solve16() },
			Puzzle(year: year, id: 17, name: "Clumsy Crucible") { Solve17() },
			Puzzle(year: year, id: 18, name: "Lavaduct Lagoon") { Solve18() },
			Puzzle(year: year, id: 19, name: "Aplenty") { Solve19() },
			Puzzle(year: year, id: 20, name: "Pulse Propagation") { Solve20() },
			Puzzle(year: year, id: 21, name: "Step Counter") { Solve21() },
			Puzzle(year: year, id: 22, name: "Sand Slabs") { Solve22() },
			Puzzle(year: year, id: 23, name: "A Long Walk") { Solve23() },
			Puzzle(year: year, id: 24, name: "Never Tell Me The Odds") { Solve24() },
			Puzzle(year: year, id: 25, name: "Snowverload") { Solve25() },
		])
	}

	var title: String {
		"Advent of Code 2023"
	}

	var puzzles: Puzzles

	func hasDetails(id _: Int) -> Bool {
		false
	}

	@ViewBuilder
	func details(id _: Int) -> some View {
		EmptyView()
	}
}
