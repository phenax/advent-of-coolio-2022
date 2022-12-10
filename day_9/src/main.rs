use std::collections::hash_set::HashSet;
use std::fs;

fn main() {}

fn parse_input() -> Vec<String> {
    let input_contents = fs::read_to_string("./input.txt").unwrap();
    input_contents
        .lines()
        .map(|s| s.to_string())
        .collect::<Vec<_>>()
}

pub fn solve_1() -> usize {
    let lines = parse_input();

    let mut move_set: HashSet<(i32, i32)> = HashSet::new();

    let mut head = (0, 0);
    let mut tail = (0, 0);

    for instruction in lines {
        let ins_type = &instruction[0..1];
        let count = &instruction[2..].parse::<i32>().unwrap_or(0);

        for _ in 0..*count {
            match ins_type {
                "R" => head = (head.0 + 1, head.1),
                "L" => head = (head.0 - 1, head.1),
                "U" => head = (head.0, head.1 + 1),
                "D" => head = (head.0, head.1 - 1),
                _ => {}
            }

            tail = move_tail(head, tail);
            move_set.insert(tail);
        }
    }

    move_set.len()
}

pub fn solve_2() -> usize {
    let lines = parse_input();

    let mut move_set: HashSet<(i32, i32)> = HashSet::new();

    let origin = (5, 10);

    let mut head = origin;
    let mut tail: Vec<(i32, i32)> = vec![origin; 9];

    draw_grid(head, tail.clone());

    for instruction in lines {
        let ins_type = &instruction[0..1];
        let count = &instruction[2..].parse::<i32>().unwrap_or(0);

        for _ in 0..*count {
            match ins_type {
                "R" => head = (head.0 + 1, head.1),
                "L" => head = (head.0 - 1, head.1),
                "U" => head = (head.0, head.1 + 1),
                "D" => head = (head.0, head.1 - 1),
                _ => {}
            }

            let (last_node, tl) = move_snek(head, tail);
            tail = tl;
            move_set.insert(last_node);
        }

        println!("{:?}", tail);
        draw_grid(head, tail.clone());
    }

    move_set.len()
}

pub fn move_snek(head: (i32, i32), tail: Vec<(i32, i32)>) -> ((i32, i32), Vec<(i32, i32)>) {
    let tl: Vec<(i32, i32)> = vec![];
    tail.iter().fold((head, tl), |(last_node, tl), cur_node| {
        let n = move_tail(last_node, cur_node.clone());
        (n, [tl, vec![n]].concat())
    })
}

pub fn move_tail(head: (i32, i32), tail: (i32, i32)) -> (i32, i32) {
    let diff = (head.0 - tail.0, head.1 - tail.1);
    let signs = (i32::signum(diff.0), i32::signum(diff.1));

    match diff {
        (0, 0) => tail,
        (x, y) if i32::abs(x) == 1 && i32::abs(y) == 1 => tail,
        (1 | -1, 0) | (0, 1 | -1) => tail,
        (_, 0) => (tail.0 + signs.0, tail.1),
        (0, _) => (tail.0, tail.1 + signs.1),
        _ => (tail.0 + signs.0, tail.1 + signs.1),
    }
}

pub fn draw_grid(head: (i32, i32), tail: Vec<(i32, i32)>) {
    println!("---------------------------------------");
    let grid_size = 20;

    for i in 0..=grid_size {
        for j in 0..=grid_size {
            let point = (j, grid_size - i);
            if point == head {
                print!("H")
            } else {
                let mut done = false;
                for (index, tl) in (0..).zip(tail.clone()) {
                    if point == tl {
                        print!("{}", index);
                        done = true;
                        break;
                    }
                }
                if !done {
                    print!(".")
                }
            }
        }

        println!();
    }

    println!("---------------------------------------");
}

#[cfg(test)]
mod tests {
    use crate::*;

    #[test]
    fn test_solve1() {
        println!("======== {:?}", solve_2());
        panic!();
    }

    #[test]
    fn test_move_tail() {
        assert_eq!(move_tail((1, 3), (1, 1)), (1, 2));
        assert_eq!(move_tail((3, 1), (1, 1)), (2, 1));
        assert_eq!(move_tail((3, 1), (1, 1)), (2, 1));
        assert_eq!(move_tail((2, 0), (3, 3)), (2, 1));
    }
}
