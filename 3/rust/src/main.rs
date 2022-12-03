use clap::Parser;
use std::collections::HashSet;
use std::fs::File;
use std::io::{BufRead, BufReader};

#[derive(Parser)]
#[command(author, version, about, long_about = None)]
struct Cli {
    file: String,
}

fn main() {
    let cli = Cli::parse();
    let sacks = get_sacks(&cli.file);
    println!("part 1: {}", solution1(&sacks));
    println!("part 2: {}", solution2(&sacks));
}

fn solution1(sacks: &Vec<String>) -> u32 {
    let mut sum: u32 = 0;
    for sack in sacks {
        let chars: Vec<char> = sack.chars().collect();
        let mut first_compartment: HashSet<char> = HashSet::new();
        let mut second_compartment: HashSet<char> = HashSet::new();
        for char in &chars[..sack.len() / 2] {
            first_compartment.insert(*char);
        }
        for char in &chars[sack.len() / 2..] {
            second_compartment.insert(*char);
        }
        let common = first_compartment
            .intersection(&second_compartment)
            .next()
            .expect("could not get char");
        sum += get_priority(*common)
    }
    sum
}

fn solution2(sacks: &Vec<String>) -> u32 {
    let groups = sacks.chunks(3);
    let mut sum: u32 = 0;
    for group in groups {
        let mut sets = group
            .iter()
            .map(|sack| sack.chars().collect::<HashSet<char>>());

        let mut s = sets.next().unwrap();
        for set in sets {
            s = s.intersection(&set).copied().collect();
        }
        sum += get_priority(s.drain().next().unwrap());
    }
    sum
}

fn get_priority(letter: char) -> u32 {
    let str = String::from(letter);
    let mut priority: u8;
    if letter.is_uppercase() {
        priority = str.bytes().next().unwrap();
        priority = priority - String::from('A').bytes().next().unwrap();
        priority += 26 + 1;
    } else {
        priority = str.bytes().next().unwrap();
        priority = priority - String::from('a').bytes().next().unwrap();
        priority += 1;
    }
    priority as u32
}

fn get_sacks(filename: &String) -> Vec<String> {
    let file = File::open(filename).expect("no such file");
    BufReader::new(file)
        .lines()
        .map(|sack| sack.unwrap())
        .collect()
}
