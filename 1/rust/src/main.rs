use clap::Parser;
use std::fs::File;
use std::io::{BufRead, BufReader};

#[derive(Parser)]
#[command(author, version, about, long_about = None)]
struct Cli {
    file: String,
}

fn main() {
    let cli = Cli::parse();
    let lines = get_lines(&cli.file);
    println!("part1 - max_calories: {}", solution1(&lines));
    println!("part2 - max_calories: {}", solution2(&lines));
}

fn solution1(lines: &Vec<String>) -> u32 {
    let mut most_calories: u32 = 0;
    let mut curr_calories: u32 = 0;

    for line in lines {
        if line.is_empty() {
            if curr_calories > most_calories {
                most_calories = curr_calories;
            }
            curr_calories = 0;
            continue;
        }

        curr_calories += line.parse::<u32>().expect("could not parse digit");
    }

    most_calories
}

fn solution2(lines: &Vec<String>) -> u32 {
    const LENGTH: usize = 4;
    let mut top_calories: [u32; LENGTH] = [0; LENGTH];
    let mut curr_calories: u32 = 0;

    for line in lines {
        if line.trim().is_empty() {
            top_calories[0] = curr_calories;
            top_calories.sort();
            curr_calories = 0;
            continue;
        }

        curr_calories += line.parse::<u32>().expect("could not parse digit");
    }

    let mut sum = 0;
    for i in 1..LENGTH {
        sum += top_calories[i];
    }
    sum
}

fn get_lines(filename: &String) -> Vec<String> {
    let file = File::open(filename).expect("no such file");
    let lines: Vec<String> = BufReader::new(file)
        .lines()
        .map(|line| line.unwrap())
        .collect();
    lines
}
