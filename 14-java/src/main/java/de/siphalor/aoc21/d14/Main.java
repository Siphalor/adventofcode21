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

			switch (args[0]) {
				case "part01" -> {
					var insertionRules = new InsertionRules();
					insertionRules.parse(bufReader);

					for (int i = 0; i < 10; i++) {
						template = insertionRules.process(template);
					}
					var occurrences = analyze(template);
					var max = occurrences.values().stream().mapToLong(Long::longValue).max().getAsLong();
					var min = occurrences.values().stream().mapToLong(Long::longValue).min().getAsLong();
					System.out.println(max - min);
				}
				case "part02" -> {
					var insertionRules = new BetterInsertionRules();
					insertionRules.parse(bufReader);

					var repr = insertionRules.new Representation(template);

					for (int i = 0; i < 40; i++) {
						repr = insertionRules.process(repr);
					}
					Map<Byte, Long> occurrences = repr.getOccurrences();
					occurrences.compute(template.getBytes()[0], (b, cnt) -> (cnt == null ? 0 : cnt) + 1);

					var max = occurrences.values().stream().mapToLong(Long::longValue).max().getAsLong();
					var min = occurrences.values().stream().mapToLong(Long::longValue).min().getAsLong();
					System.out.println(max - min);
				}
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	private static Map<Byte, Long> analyze(String string) {
		var data = new TreeMap<Byte, Long>();
		for (byte aByte : string.getBytes()) {
			data.compute(aByte, (c, cnt) -> (cnt == null) ? 1 : cnt + 1);
		}
		return data;
	}
}
