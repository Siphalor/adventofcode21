use std::io::{BufRead, BufReader};
use std::ops::{Range, RangeInclusive};

pub type Vent = (Pos, Pos);
pub type Pos = (usize, usize);

pub fn parse_vents(input: std::fs::File) -> Vec<Vent> {
    let mut vents = Vec::new();

    for line in BufReader::new(input).lines() {
        match line {
            Ok(line) => {
                if let Some(vent) = parse_line(line.as_str()) {
                    vents.push(vent);
                } else {
                    eprintln!("failed to parse line")
                }
            }
            Err(err) => {
                eprintln!("failed to read line (error): {}", err);
            }
        }
    }

    return vents;
}

fn parse_line(line: &str) -> Option<Vent> {
    if let Some((from, to)) = line.split_once("->") {
        if let Some(from) = parse_coords(from) {
            if let Some(to) = parse_coords(to) {
                return Some((from, to));
            }
        }
    } else {
        eprintln!("failed to read line: {}", line);
    }
    return None;
}

fn parse_coords(string: &str) -> Option<Pos> {
    if let Some((x, y)) = string.split_once(",") {
        match x.trim().parse() {
            Ok(x) => {
                match y.trim().parse() {
                    Ok(y) => {
                        return Some((x, y));
                    }
                    Err(err) => {
                        eprintln!("failed to parse coord number: {}", err);
                    }
                }
            }
            Err(err) => {
                eprintln!("failed to parse coord number: {}", err);
            }
        }
    } else {
        eprintln!("failed to split from coords: {}", string);
    }
    return None;
}

pub fn make_range<Idx: std::cmp::PartialOrd>(a: Idx, b: Idx) -> RangeInclusive<Idx> {
    if a < b {
        RangeInclusive::new(a, b)
    } else {
        RangeInclusive::new(b, a)
    }
}
