package de.siphalor.aoc21

class Main {
	static void main(String[] args) {

		def paper = new Paper()
		paper.parse(new File(args[1]))
		switch (args[0]) {
			case "part01":
				paper.folds.get(0).apply()
				int dots = 0
				for (def i = 0; i < paper.width * paper.height; i++) {
					if (paper.data.get(i)) {
						dots++
					}
				}
				println(dots)
				break
			case "part02":

				break
			default:
				println("hi")
		}
	}
}
