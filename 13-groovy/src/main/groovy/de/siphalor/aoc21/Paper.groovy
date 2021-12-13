package de.siphalor.aoc21

class Paper {
	int width
	int height
	BitSet data
	List<Fold> folds = new ArrayList<>()

	void parse(File file) {
		def dots = new ArrayList<Dot>()

		file.eachLine {
			if (it.isEmpty()) {
				return
			}

			def parts = it.split(",")
			if (parts.length == 2) {
				dots.add(new Dot(Integer.parseInt(parts[0]), Integer.parseInt(parts[1])))
			} else {
				parts = it.split("[ =]")
				this.folds.add(new Fold(
						Fold.Direction.valueOf(parts[2].toUpperCase(Locale.ROOT)),
						Integer.parseInt(parts[3])
				))
			}
			return
		}

		this.width = dots.max { it.x }.x + 1
		this.height = dots.max { it.y }.y + 1
		this.data = new BitSet(width * height)
		dots.forEach {
			data.set(it.y * width + it.x)
		}

		println("w: $width, h: $height")
	}

	void print() {
		for (y in 0..<height) {
			for (x in 0..<width) {
				if (data.get(y * width + x)) {
					print("#")
				} else {
					print(".")
				}
			}
			println()
		}
	}

	private static class Dot {
		int x
		int y

		Dot(int x, int y) {
			this.x = x
			this.y = y
		}
	}

	class Fold {
		Direction direction
		int pos

		Fold(Direction direction, int pos) {
			this.direction = direction
			this.pos = pos
		}

		void apply() {
			switch (direction) {
				case Direction.X:
					def newWidth = pos
					for (def i = 0; i < newWidth * height; i++) {
						def line = i / newWidth as int
						def x = i % newWidth
						data.set(i, data.get(line * width + x as int) || data.get(line * width + (2 * newWidth - x) as int))
					}
					width = newWidth
					break
				case Direction.Y:
					def newHeight = pos
					for (def i = 0; i < width * newHeight; i++) {
						def line = i / width as int
						def x = i % width
						data.set(i, data.get(i) || data.get((2 * newHeight - line) * width + x as int))
					}
					height = newHeight
					break
			}
		}

		enum Direction {
			X, Y
		}
	}
}
