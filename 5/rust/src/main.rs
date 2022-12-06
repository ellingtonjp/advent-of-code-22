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
    let (stack_lines, num_stacks, instructions) = parse_input(&cli.file);
    let mut stacks = to_stacks(stack_lines, num_stacks);

    for instruction in instructions {
        let (from, to, num) = instruction;
        move_crate_part_2(&mut stacks, from - 1, to - 1, num);
    }
}

fn move_crate_part_2(stacks: &mut Vec<Vec<char>>, from: usize, to: usize, num: usize) {
    let start_index = stacks[from].len() - num;
    let to_move = stacks[from][start_index..].to_vec();

    for c in to_move {
        stacks[to].push(c);
    }
    let num_to_keep = stacks[from].len() - num;
    stacks[from].truncate(num_to_keep);
}

fn move_crate_part_1(stacks: &mut Vec<Vec<char>>, from: usize, to: usize, num: usize) {
    let to_move = &stacks[from][..];
    for n in 0..num {
        let crate_char = stacks[from].pop().unwrap();
        stacks[to].push(crate_char);
    }
}

fn to_stacks(stack_lines: Vec<String>, num_stacks: usize) -> Vec<Vec<char>> {
    let mut stacks: Vec<Vec<char>> = vec![Vec::new(); num_stacks];

    for i in 0..stack_lines.len() {
        for j in 0..num_stacks {
            let idx = j * 4 + 1;
            let element = stack_lines[i].chars().nth(idx);
            if element.is_none() {
                continue;
            } else {
                let element = element.unwrap();
                if element == ' ' {
                    continue;
                } else {
                    stacks[j].insert(0, element);
                }
            }
        }
    }
    stacks
}

fn parse_input(filename: &String) -> (Vec<String>, usize, Vec<(usize, usize, usize)>) {
    let file = File::open(filename).expect("no such file");
    let mut stack_lines: Vec<String> = Vec::new();
    let mut stack_cols: String = String::new();
    let mut instructions: Vec<(usize, usize, usize)> = Vec::new();
    for line in BufReader::new(file).lines() {
        let line = line.unwrap();
        if line.starts_with('[') {
            stack_lines.push(line);
        } else if line.starts_with('m') {
            let split: Vec<&str> = line.split_whitespace().collect();
            let num = split[1].parse().unwrap();
            let from = split[3].parse().unwrap();
            let to = split[5].parse().unwrap();
            instructions.push((from, to, num));
        } else if line.starts_with(' ') {
            stack_cols = line;
        }
    }
    let num_stacks = stack_cols.split_whitespace().collect::<Vec<&str>>().len();

    (stack_lines, num_stacks, instructions)
}
