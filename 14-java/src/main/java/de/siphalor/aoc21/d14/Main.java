package de.siphalor.aoc21.d14;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.Map;
import java.util.TreeMap;

public class Main {
	public static void main(String[] args) {
		if (args.length != 2) {
			System.out.println("incorrect number of arguments");
			return;
		}

		try (var reader = new FileReader(args[1])) {
			var bufReader = new BufferedReader(reader);
			var template = bufReader.readLine();

			var insertionRules = new InsertionRules();
			insertionRules.parse(bufReader);

			switch (args[0]) {
				case "part01":
					for (int i = 0; i < 10; i++) {
						template = insertionRules.process(template);
					}
					var occurrences = analyze(template);
					var max = occurrences.values().stream().mapToInt(Integer::intValue).max().getAsInt();
					var min = occurrences.values().stream().mapToInt(Integer::intValue).min().getAsInt();
					System.out.println(max - min);
					break;
				case "part02":
					break;
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	private static Map<Byte, Integer> analyze(String string) {
		var data = new TreeMap<Byte, Integer>();
		for (byte aByte : string.getBytes()) {
			data.compute(aByte, (c, cnt) -> (cnt == null) ? 1 : cnt + 1);
		}
		return data;
	}
}
