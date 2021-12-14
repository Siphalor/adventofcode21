package de.siphalor.aoc21.d14;

import java.io.BufferedReader;
import java.util.TreeMap;

public class InsertionRules {
	private TreeMap<Byte, TreeMap<Byte, Byte>> rules;

	public InsertionRules() {
		rules = new TreeMap<>();
	}

	public void parse(BufferedReader reader) {
		reader.lines().forEach(line -> {
			var parts = line.split(" -> ");
			if (parts.length != 2) {
				return;
			}

			var firstMap = rules.computeIfAbsent(parts[0].getBytes()[0], c -> new TreeMap<>());
			firstMap.put(parts[0].getBytes()[1], parts[1].getBytes()[0]);
		});
	}

	public String process(String template) {
		var target = new byte[template.length() * 2 - 1];
		var bytes = template.getBytes();
		var last = bytes[0];
		target[0] = last;
		int targetI = 1;
		for (int i = 1; i < bytes.length; i++) {
			var secMap = rules.get(last);
			if (secMap != null) {
				var insertion = secMap.get(bytes[i]);
				if (insertion != null) {
					target[targetI++] = insertion;
				}
			}
			last = bytes[i];
			target[targetI++] = last;
		}
		return new String(target, 0, targetI);
	}
}
