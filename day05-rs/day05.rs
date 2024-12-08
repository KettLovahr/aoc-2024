#!/usr/bin/env -S cargo +nightly -Zscript
// Alternatively compile with `rustc day05.rs --edition 2021`

use std::cmp::min;

fn main() {
    let input: Vec<&str> = include_str!("input").split("\n\n").collect();
    let (input_rules, input_manuals) = (input[0], input[1]);
    let mut rules: Vec<(i32, i32)> = vec![];
    let mut manuals: Vec<Vec<i32>> = vec![];
    let mut incorrect_manuals: Vec<Vec<i32>> = vec![];

    for line in input_rules.lines() {
        let args: Vec<&str> = line.split("|").collect();
        let lhs: i32 = args[0].parse().unwrap();
        let rhs: i32 = args[1].parse().unwrap();
        rules.push((lhs, rhs));
    }
    for line in input_manuals.lines() {
        let args: Vec<i32> = line.split(",").map(|x| x.parse::<i32>().unwrap()).collect();
        manuals.push(args);
    }

    let result: i32 = manuals
        .iter()
        .map(|x| {
            if validate(x.clone(), rules.clone()) { x[x.len() / 2] }
            else { incorrect_manuals.push(x.clone()); 0 }
        })
        .sum();

    println!("{}", result);

    let correction_result: i32 = incorrect_manuals
        .iter()
        .map(|x| correct(x.clone(), rules.clone()))
        .sum();

    println!("{}", correction_result);
}

fn correct(manual: Vec<i32>, ruleset: Vec<(i32, i32)>) -> i32 {
    let mut corrected: Vec<i32> = manual.clone();
    while !validate(corrected.clone(), ruleset.clone()) {
        for rule in ruleset.iter() {
            if !corrected.contains(&rule.0) || !corrected.contains(&rule.1) {
                continue;
            }
            let mut requirement_index = 0;
            let mut requiree_index = 0;
            for i in 0..corrected.len() {
                if corrected[i] == rule.0 {
                    requirement_index = i;
                }
                if corrected[i] == rule.1 {
                    requiree_index = i;
                }
            }
            let lowest_index = min(requirement_index, requiree_index);
            if requiree_index < requirement_index {
                let mut new_vec: Vec<i32> = corrected
                    .clone()
                    .into_iter()
                    .filter(|&x| (x != rule.0 && x != rule.1))
                    .collect();
                new_vec.splice(lowest_index..lowest_index, [rule.0, rule.1].into_iter());
                corrected = new_vec;
            }
        }
    }

    corrected[corrected.len() / 2]
}

fn validate(manual: Vec<i32>, ruleset: Vec<(i32, i32)>) -> bool {
    let rules = ruleset.clone();
    let mut fulfilled: Vec<bool> = rules.iter().map(|_| false).collect();
    for page in manual.clone() {
        for i in 0..rules.len() {
            if !fulfilled[i] {
                if page == rules[i].1 && manual.contains(&rules[i].0) {
                    return false;
                } else if page == rules[i].0 {
                    fulfilled[i] = true;
                }
            }
        }
    }
    true
}
