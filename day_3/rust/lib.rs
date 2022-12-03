use neon::prelude::*;
use std::{collections::HashSet, ops::Range};

fn get_priority(c: char) -> u8 {
    // The worst solution
    // (c as u8 + 20) % 58
    match c {
        'a'..='z' => c as u8 - 97 + 1,
        'A'..='Z' => c as u8 - 65 + 27,
        _ => panic!(),
    }
}

fn solve_1(mut cx: FunctionContext) -> JsResult<JsNumber> {
    let input = cx.argument::<JsArray>(0)?;
    let list = input.to_vec(&mut cx)?;

    let mut result: i32 = 0;
    for item in list {
        let tuple = item.downcast_or_throw::<JsArray, _>(&mut cx)?;
        let left = tuple.get::<JsString, _, _>(&mut cx, 0)?;
        let right = tuple.get::<JsString, _, _>(&mut cx, 1)?;

        let set_left = left.value(&mut cx).chars().collect::<HashSet<_>>();
        let set_right = right.value(&mut cx).chars().collect::<HashSet<_>>();

        let commoners = set_left.intersection(&set_right);
        for &c in commoners {
            let priority = get_priority(c);
            result += priority as i32;
        }
    }

    Ok(cx.number(result))
}

fn solve_2(mut cx: FunctionContext) -> JsResult<JsNumber> {
    let input = cx.argument::<JsArray>(0)?;
    let list = input.to_vec(&mut cx)?;

    let mut result: i32 = 0;
    let mut chunk = vec![];
    for (index, item) in (0..).zip(list) {
        let input = item
            .downcast_or_throw::<JsString, _>(&mut cx)?
            .value(&mut cx);

        chunk.push(input);
        if (index + 1) % 3 == 0 {
            let set = chunk
                .iter()
                .map(|s| s.chars().collect::<HashSet<char>>())
                .reduce(|acc, item| acc.intersection(&item).copied().collect::<HashSet<_>>())
                .unwrap();
            for c in set {
                let priority = get_priority(c);
                result += priority as i32;
            }
            chunk.clear();
        }
    }

    Ok(cx.number(result))
}

#[neon::main]
fn main(mut cx: ModuleContext) -> NeonResult<()> {
    cx.export_function("solve_1", solve_1)?;
    cx.export_function("solve_2", solve_2)?;
    Ok(())
}
