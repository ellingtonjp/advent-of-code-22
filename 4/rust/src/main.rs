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
    let part = &part_2_compare;
    let cli = Cli::parse();
    let mut sum = 0;
    for assignment_pair in get_assignment_pairs(&cli.file) {
        if includes(&assignment_pair, part) {
            sum += 1;
        }
    }
    println!("sum: {sum}");
}

fn part_1_compare(set1: HashSet<u32>, set2: HashSet<u32>) -> bool {
    set1.is_subset(&set2) || set2.is_subset(&set1)
}

fn part_2_compare(set1: HashSet<u32>, set2: HashSet<u32>) -> bool {
    !set1.is_disjoint(&set2)
}

fn includes(assignment_pair: &str, compare: &dyn Fn(HashSet<u32>, HashSet<u32>) -> bool) -> bool {
    let assignment: Vec<&str> = assignment_pair.split(',').collect();
    let assignment1: Vec<_> = assignment[0]
        .split('-')
        .map(|s| s.parse::<u32>().unwrap())
        .collect();
    let assignment2: Vec<_> = assignment[1]
        .split('-')
        .map(|s| s.parse::<u32>().unwrap())
        .collect();

    let set1 = make_set(assignment1[0], assignment1[1]);
    let set2 = make_set(assignment2[0], assignment2[1]);

    compare(set1, set2)
}

fn make_set(start: u32, end: u32) -> HashSet<u32> {
    let mut set = HashSet::new();
    for i in start..=end {
        set.insert(i);
    }
    set
}

fn get_assignment_pairs(filename: &str) -> Vec<String> {
    let file = File::open(filename).expect("no such file");
    BufReader::new(file)
        .lines()
        .map(|pair| pair.unwrap())
        .collect()
}
