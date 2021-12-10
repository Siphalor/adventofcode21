use std::cmp::{max, min};
use std::io::{BufRead, BufReader};
use crate::util::{make_range, parse_vents, Vent};

pub fn run(input: std::fs::File) {
    let vents = parse_vents(input);
    let size = vents.iter().map(|vent| vent.1).reduce(|v1, v2| (max(v1.0, v2.0), max(v1.1, v2.1))).unwrap();
    let mut map = vec![vec![0u64; size.0+1 as usize]; size.1+1 as usize];

    let mut overlaps: u64 = 0;
    for vent in vents {
        if vent.0.0 == vent.1.0 { // equal x; y change
            for row in make_range(vent.0.1, vent.1.1) {
                let row = map.get_mut(row).unwrap();
                let ele = row.get_mut(vent.0.0).unwrap();
                *ele += 1;
                if *ele == 2 {
                    overlaps += 1;
                }
            }
        } else if vent.0.1 == vent.1.1 { // equal y; x change
            let row = map.get_mut(vent.0.1).unwrap();
            let elements = row.get_mut(make_range(vent.0.0, vent.1.0)).unwrap();
            for ele in elements {
                *ele += 1;
                if *ele == 2 {
                    overlaps += 1;
                }
            }
        } else { // diagonal at 45 degrees
            let mut pos = vent.0;
            loop {
                let ele = map.get_mut(pos.1).unwrap().get_mut(pos.0).unwrap();
                *ele += 1;
                if *ele == 2 {
                    overlaps += 1;
                }

                if pos == vent.1 {
                    break;
                }

                if pos.0 < vent.1.0 {
                    pos.0 += 1;
                } else {
                    pos.0 -= 1;
                }
                if pos.1 < vent.1.1 {
                    pos.1 += 1;
                } else {
                    pos.1 -= 1;
                }
            }
        }
    }

    println!("overlaps: {}", overlaps);
}
