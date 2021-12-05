mod part01;
mod util;

fn main() {
    let mut args = std::env::args();
    if args.len() != 3 {
        eprintln!("incorrect number of arguments");
        return;
    }

    args.next();

    let part = args.next().unwrap();
    match std::fs::File::open(args.next().unwrap()) {
        Ok(file) => {
            match part.as_str() {
                "part01" => {
                    part01::run(file);
                }
                "part02" => {}
                _ => {
                    eprintln!("unknown part argument");
                }
            }
        }
        Err(err) => {
            eprintln!("failed to open file: {}", err);
        }
    }
}
