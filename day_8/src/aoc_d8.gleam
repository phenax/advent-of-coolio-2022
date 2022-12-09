import gleam/io
import gleam/string
import gleam/int
import gleam/list
import gleam/result
import gleam/pair

pub external fn read_file(p: String, encoding: String) -> String =
  "fs" "readFileSync"

pub fn get_trees() {
  read_file("./input.txt", "utf8")
    |> string.trim
    |> string.split("\n")
    |> list.map(fn (line) {
      line
        |> string.to_graphemes
        |> list.map(fn (c) { int.parse(c) |> result.unwrap(0) })
    })
}

pub fn solve_1(trees: List(List(Int))) {
  trees |> indexed |> list.fold(0, fn (acc, r) {
    let row_index = pair.first(r)
    let row = pair.second(r)

    let count = row |> indexed |> list.fold(0, fn (acc, c) {
      let col_index = pair.first(c)
      let col = pair.second(c)

      let borders = get_borders(trees, row_index, col_index)
      let is_not_visible = borders |> list.any (fn (row) {
        row |> list.all(fn (item) { item < col })
      })

      case is_not_visible {
        False -> acc
        True -> acc + 1
      }
    })

    count + acc
  })
}

pub fn solve_2(trees: List(List(Int))) {
  trees |> indexed |> list.fold(0, fn (acc, r) {
    let row_index = pair.first(r)
    let row = pair.second(r)

    let scenic_score = row |> indexed |> list.fold(0, fn (acc, c) {
      let col_index = pair.first(c)
      let col = pair.second(c)

      let borders = get_borders(trees, row_index, col_index)
      let scenic_score = borders |> list.fold(1, fn (scenic_score, border_line) {
        let count = border_line |> fold_stop(0, fn (count, item) {
          case item >= col {
            True -> list.Stop(count + 1)
            False -> list.Continue(count + 1)
          }
        })

        scenic_score * count
      })

      int.max(acc, scenic_score)
    })

    int.max(acc, scenic_score)
  })
}

fn fold_stop(ls: List(a), def: b, func: fn(b, a) -> list.ContinueOrStop(b)) -> b {
  case ls {
    [] -> def
    [h, ..tl] -> case func(def, h) {
      list.Stop(acc) -> acc
      list.Continue(acc) -> fold_stop(tl, acc, func)
    }
  }
}

pub fn main() {
  let trees = get_trees()

  let result = solve_2(trees)

  // let result = list.range(1, 50) |> fold_stop(0, fn (acc, n) {
  //   case n {
  //     25 -> list.Stop(acc)
  //     _ -> list.Continue(acc + 1)
  //   }
  // })

  io.debug(result)
}

fn slice(ls: List(a), start: Int, end: Int) {
  indexed(ls) |> list.filter(fn (p) {
    let index = pair.first(p)
    index >= start && index < end
  }) |> unindex
}

fn unindex(ls: List(#(Int, a))) -> List(a) {
  ls |> list.map(pair.second)
}

fn indexed(ls: List(a)) -> List(#(Int, a)) {
  let range = list.range(0, list.length(ls))
  list.zip(range, ls)
}

fn get_borders(grid: List(List(Int)), row_index: Int, col_index: Int) -> List(List(Int)) {
  let rows = list.length(grid)
  let cols = list.at(grid, 0) |> result.map(list.length) |> result.unwrap(0)

  let indexed_grid = indexed(grid)

  let row = list.at(grid, row_index) |> result.unwrap([])
  let col = list.map(grid, fn (row) { list.at(row, col_index) |> result.unwrap(0) })

  [
    slice(col, 0, row_index) |> list.reverse,
    slice(col, row_index + 1, rows),
    slice(row, 0, col_index) |> list.reverse,
    slice(row, col_index + 1, cols),
  ]
}

