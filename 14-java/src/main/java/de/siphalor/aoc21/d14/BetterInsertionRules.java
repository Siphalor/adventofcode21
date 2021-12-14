package de.siphalor.aoc21.d14;

import java.io.BufferedReader;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

public class BetterInsertionRules {
	private final List<Rule> rules;
	private final Map<String, Rule> ruleByInput;

	public BetterInsertionRules() {
		rules = new ArrayList<>();
		ruleByInput = new TreeMap<>();
	}

	public void parse(BufferedReader reader) {
		reader.lines().forEach(line -> {
			var parts = line.split(" -> ");
			if (parts.length != 2) {
				return;
			}

			Rule rule = new Rule(parts[0].toCharArray(), parts[1].charAt(0));
			rules.add(rule);
			ruleByInput.put(parts[0], rule);
		});

		for (Rule rule : rules) {
			var outRule1 = rules.indexOf(ruleByInput.get(new String(new char[] { rule.ownChars[0], rule.out })));
			var outRule2 = rules.indexOf(ruleByInput.get(new String(new char[] { rule.out, rule.ownChars[1] })));
			rule.outRules = new int[] { outRule1, outRule2 };
		}
	}
	
	public Representation process(Representation representation) {
		var newCounts = new TreeMap<Integer, Long>();
		var resRepre = new Representation(newCounts);

		for (Map.Entry<Integer, Long> entry : representation.ruleCounts.entrySet()) {
			for (int outRule : rules.get(entry.getKey()).outRules) {
				newCounts.compute(outRule, (r, cnt) -> cnt == null ? entry.getValue() : cnt + entry.getValue());
			}
		}
		return resRepre;
	}	
	
	public class Representation {
		protected final TreeMap<Integer, Long> ruleCounts;

		public Representation(TreeMap<Integer, Long> ruleCounts) {
			this.ruleCounts = ruleCounts;
		}
		
		public Representation(String some) {
			this.ruleCounts = new TreeMap<>();
			char last = 0;
			for (char c : some.toCharArray()) {
				if (last != 0) {
					var rule = rules.indexOf(ruleByInput.get(new String(new char[] { last, c })));
					if (rule >= 0) {
						ruleCounts.compute(rule, (r, cnt) -> cnt == null ? 1 : cnt + 1);
					}
				}
				last = c;
			}
		}

		public Map<Byte, Long> getOccurrences() {
			var occ = new TreeMap<Byte, Long>();
			for (Map.Entry<Integer, Long> entry : ruleCounts.entrySet()) {
				var rout = rules.get(entry.getKey()).ownChars[1];
				occ.compute((byte) rout, (r, cnt) -> (cnt == null ? 0 : cnt) + entry.getValue());
			}
			return occ;
		}
	}

	public static class Rule {
		protected final char[] ownChars;
		protected final char out;
		protected int[] outRules;

		public Rule(char[] ownChars, char out) {
			this.ownChars = ownChars;
			this.out = out;
		}

		public char[] getOwnChars() {
			return ownChars;
		}
	}
}
