import io
import os
import math.big

fn main() {
	if os.args.len != 3 {
		println("incorrect number of arguments")
		return
	}

	mut ssdisplays := []SSDisplay{ cap: 200 }
	file := os.open(os.args[2]) or {
		panic("failed to open file: $err")
	}
	mut buf_reader := io.new_buffered_reader(reader: file)
	for !buf_reader.end_of_stream() {
		line := buf_reader.read_line() or {
			break
		}
		ssdisplays << read_ssdisplay(line) or {
			println("failed to read display: $err")
			continue
		}
	}

	match os.args[1] {
		"part01" {
			part01(ssdisplays)
		}
		"part02" {
			part02(mut ssdisplays)
		}
		else {}
	}
}

struct SSDisplay {
	records []string
	output_records []string
mut:
	possibilities []byte
}

fn read_ssdisplay(line string) ?SSDisplay {
	parts := line.split(" | ")
	if parts.len != 2 {
		return error("incorrect line")
	}
	return SSDisplay {
		records: parts[0].split(" ")
		output_records: parts[1].split(" ")
		possibilities: []byte{ len: 7, init: 0b1111111 }
	}
}

fn (mut ssdisplay SSDisplay) find_possibilities() {
	mut fives := []byte{ len: 8 }
	mut sixes := []byte{ len: 8 }
	for record in ssdisplay.records {
		indices := record.bytes().map(it - 'a'[0])
		mut bit_mask := byte(0)
		match record.len {
			2 { bit_mask = 0b1011011 }
			3 { bit_mask = 0b1011010 }
			4 { bit_mask = 0b1010001 }
			5 {
				fives[7]++
				for i in indices {
					fives[i]++
				}
				continue
			}
			6 {
				sixes[7]++
				for i in indices {
					sixes[i]++
				}
				continue
			}
			else { continue }
		}
		for i in 0..7 {
			if i in indices {
				ssdisplay.possibilities[i] &= ~bit_mask
			} else {
				ssdisplay.possibilities[i] &= bit_mask
			}
		}
	}
	if fives[7] >= 3 {
		for i in 0..7 {
			if fives[i] >= 3 {
				ssdisplay.possibilities[i] &= 0b1001001
			} else {
				ssdisplay.possibilities[i] &= 0b0110110
			}
		}
	}
	if sixes[7] >= 3 {
		for i in 0..7 {
			if sixes[i] >= 3 {
				ssdisplay.possibilities[i] &= 0b1100011
			} else {
				ssdisplay.possibilities[i] &= 0b0011100
			}
		}
	}
}

fn (ssdisplay &SSDisplay) str() string {
	return "records: ${ssdisplay.records.join(', ')}\n" +
		"output: ${ssdisplay.output_records.join(', ')}\n" + 
		"poss: ${ssdisplay.possibilities.map(big.integer_from_int(it).binary_str()).join(', ')}\n"
}

fn part01(ssdisplays []SSDisplay) {
	mut occurences := 0
	for ssdisplay in ssdisplays {
		for output_record in ssdisplay.output_records {
			if output_record.len in [2, 3, 4, 7] {
				occurences++
			}
		}
	}
	println("occurences: $occurences")
}

fn part02(mut ssdisplays []SSDisplay) {
	mut output := 0
	for mut ssdisplay in ssdisplays {
		ssdisplay.find_possibilities()
		mut value := 0
		for output_record in ssdisplay.output_records {
			mut bits := 0
			for o in output_record {
				bits |= ssdisplay.possibilities[o - 'a'[0]]
			}

			val := match bits {
				0b1110111 { 0 }
				0b0100100 { 1 }
				0b1011101 { 2 }
				0b1101101 { 3 }
				0b0101110 { 4 }
				0b1101011 { 5 }
				0b1111011 { 6 }
				0b0100101 { 7 }
				0b1111111 { 8 }
				0b1101111 { 9 }
				else { -1 }
			}
			if val == -1 {
				println("warn")
				println("record: $output_record\n" + 
				        "bits: " + big.integer_from_int(bits).binary_str() + "\n" +
				        "ssdisplay: " + ssdisplay.str())
			} else {
				value = val + 10 * value
			}
		}
		output += value
	}
	println(output)
}
