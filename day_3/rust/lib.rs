use neon::prelude::*;
use std::collections::HashSet;

fn get_priority(c: char) -> u8 {
    // The worst solution
    // (c as u8 + 20) % 58
    match c {
        'a'..='z' => c as u8 - 97 + 1,
        'A'..='Z' => c as u8 - 65 + 27,
        _ => panic!(),
    }
}

fn solve(mut cx: FunctionContext) -> JsResult<JsNumber> {
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

#[neon::main]
fn main(mut cx: ModuleContext) -> NeonResult<()> {
    cx.export_function("solve", solve)?;
    Ok(())
}
