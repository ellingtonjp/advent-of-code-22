use clap::Parser;
use std::collections::HashMap;
use std::fs::File;
use std::io::{BufRead, BufReader};

#[derive(Parser)]
#[command(author, version, about, long_about = None)]
struct Cli {
    file: String,
}

fn main() {
    let cli = Cli::parse();
    let games = get_games(&cli.file);
    println!("part 1: {}", solution1(&games));
    println!("part 2: {}", solution2(&games));
}

fn solution1(games: &Vec<String>) -> i32 {
    let game_scores = HashMap::from([
        ("A X".to_string(), 3 + 1), // win/lose/draw points + choice (rock/paper/scissor) points
        ("A Y".to_string(), 6 + 2),
        ("A Z".to_string(), 0 + 3),
        ("B X".to_string(), 0 + 1),
        ("B Y".to_string(), 3 + 2),
        ("B Z".to_string(), 6 + 3),
        ("C X".to_string(), 6 + 1),
        ("C Y".to_string(), 0 + 2),
        ("C Z".to_string(), 3 + 3),
    ]);

    games.iter().map(|game| game_scores[game]).sum()
}

fn solution2(games: &Vec<String>) -> i32 {
    let result_scores = HashMap::from([
        ("X".to_string(), 0),
        ("Y".to_string(), 3),
        ("Z".to_string(), 6),
    ]);
    let choice_scores = HashMap::from([
        ("A".to_string(), 1),
        ("B".to_string(), 2),
        ("C".to_string(), 3),
    ]);
    let result_choices = HashMap::from([
        ("A X".to_string(), "C"),
        ("A Y".to_string(), "A"),
        ("A Z".to_string(), "B"),
        ("B X".to_string(), "A"),
        ("B Y".to_string(), "B"),
        ("B Z".to_string(), "C"),
        ("C X".to_string(), "B"),
        ("C Y".to_string(), "C"),
        ("C Z".to_string(), "A"),
    ]);

    games
        .iter()
        .map(|game| {
            let result = game.split(" ").collect::<Vec<&str>>()[1];
            let result_score = result_scores[result];
            let choice = result_choices[game];
            let choice_score = choice_scores[choice];

            result_score + choice_score
        })
        .sum()
}

fn get_games(filename: &String) -> Vec<String> {
    let file = File::open(filename).expect("no such file");
    let games: Vec<String> = BufReader::new(file)
        .lines()
        .map(|line| line.unwrap())
        .collect();
    games
}
