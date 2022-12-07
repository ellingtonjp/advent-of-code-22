use clap::Parser;
use std::collections::HashSet;

#[derive(Parser)]
#[command(author, version, about, long_about = None)]
struct Cli {
    file: String,
}

fn main() {
    let data = parse_input(&Cli::parse().file);
    println!("part 1: {}", find_message_start(&data, 4));
    println!("part 2: {}", find_message_start(&data, 14));
}

fn find_message_start(data: &String, start_of_packet_length: usize) -> i32 {
    let mut set: HashSet<char> = HashSet::new();
    let length = data.len() - start_of_packet_length;
    'buffer: for i in 0..length {
        let chars: Vec<char> = data[i..i + start_of_packet_length].chars().collect();
        for c in chars {
            // character already in set, increment and try again
            if !set.insert(c) {
                set.clear();
                continue 'buffer;
            }
        }
        return (i + start_of_packet_length).try_into().unwrap();
    }
    -1
}

fn parse_input(filename: &str) -> String {
    std::fs::read_to_string(filename)
        .unwrap()
        .trim_end()
        .to_string()
}
