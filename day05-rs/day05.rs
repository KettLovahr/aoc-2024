#!/usr/bin/env -S cargo +nightly -Zscript
//! ```cargo
//! [package]
//! edition = "2021"
//! ```

// Cargo seems to ignore the edition specified here, but should default to 2021
// anyways when running this file directly. (./day05.rs)

// Alternatively compile with `rustc day05.rs --edition 2021`

use std::cmp::min;

enum InputParsePhase {
    Rules,
    Manuals,
}

fn main() {
    let input = include_str!("input");
    let mut current_phase = InputParsePhase::Rules;
    let mut rules: Vec<Rule> = vec![];
    let mut manuals: Vec<Vec<i32>> = vec![];
    let mut incorrect_manuals: Vec<Vec<i32>> = vec![];
    let mut result: i32 = 0;
    let mut correction_result: i32 = 0;

    for line in input.lines() {
        match current_phase {
            InputParsePhase::Rules => {
                if line == "" {
                    current_phase = InputParsePhase::Manuals;
                } else {
                    let args: Vec<&str> = line.split("|").collect();
                    let lhs: i32 = args[0].parse().unwrap();
                    let rhs: i32 = args[1].parse().unwrap();
                    rules.push(Rule {
                        requirement: lhs,
                        required_by: rhs,
                        fulfilled: false,
                    });
                }
            }
            InputParsePhase::Manuals => {
                let args: Vec<i32> = line.split(",").map(|x| x.parse::<i32>().unwrap()).collect();
                manuals.push(args);
            }
        }
    }

    for manual in manuals {
        let rules = rules.clone();

        if validate(manual.clone(), rules) {
            result += manual[manual.len() / 2];
        } else {
            incorrect_manuals.push(manual.clone());
        }
    }

    for manual in incorrect_manuals {
        let rules = rules.clone();
        let mut corrected: Vec<i32> = manual.clone();
        let mut valid = false;
        while !valid {
            for rule in rules.iter() {
                if manual.contains(&rule.requirement) && manual.contains(&rule.required_by) {
                    if corrected.contains(&rule.requirement)
                        && corrected.contains(&rule.required_by)
                    {
                        let mut requirement_index = 0;
                        let mut requiree_index = 0;
                        for i in 0..corrected.len() {
                            if corrected[i] == rule.requirement
                            {
                                requirement_index = i;
                            }
                            if corrected[i] == rule.required_by
                            {
                                requiree_index = i;
                            }
                        }
                        let lowest_index = min(requirement_index, requiree_index);
                        if requiree_index < requirement_index {
                            let mut new_vec: Vec<i32> = corrected
                                .iter()
                                .map(|x| *x)
                                .filter(|x| (*x != rule.requirement && *x != rule.required_by))
                                .collect();
                            new_vec.splice(lowest_index..lowest_index, [rule.requirement, rule.required_by].into_iter());

                            corrected = new_vec;
                        }
                    }
                }
            }
            valid = validate(corrected.clone(), rules.clone());
        }

        correction_result += corrected[corrected.len() / 2]
    }

    println!("{}", result);
    println!("{}", correction_result);
}

fn validate(manual: Vec<i32>, ruleset: Vec<Rule>) -> bool {
    let mut valid = true;
    let mut rules = ruleset.clone();
    'manual: for page in manual.clone() {
        for i in 0..rules.len() {
            if !rules[i].fulfilled {
                if page == rules[i].required_by && manual.contains(&rules[i].requirement) {
                    valid = false;
                    break 'manual;
                } else if page == rules[i].requirement {
                    rules[i].fulfilled = true;
                }
            }
        }
    }
    valid
}

#[derive(Clone, Debug)]
struct Rule {
    requirement: i32,
    required_by: i32,
    fulfilled: bool,
}
