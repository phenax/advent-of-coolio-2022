module main

import std/os/path
import std/os/file
import utils

effect fun log(s: string): ()

fun real-input() {
  val instructions = read-text-file("./input.txt".path).parse-instructions
  (2000000, 4000000, instructions)
}

fun example-input() {
  val instructions = read-text-file("./example-input.txt".path).parse-instructions
  (10, 20, instructions)
}

fun solve1((target-y, _, instructions): (int, int, list<instruction>)): int {
  var points := []
  val xs = instructions.flatmap(fn(a) -> [a.beacon.fst, a.sensor.fst])
  for(xs.minimum - target-y, xs.maximum + target-y) fn(x) {
    val current = (x, target-y)
    val insM = find(instructions) fn(instruction) {
      val range = current.manhattan-distance(instruction.sensor)
      val is-on-beacon = current == instruction.beacon
      val is-on-sensor = current == instruction.sensor
      !is-on-beacon && !is-on-sensor && range <= instruction.manhattan-distance
    }
    if insM.is-just then
      points := Cons(current, points)
  }

  points.length
}

fun for-range(min: int, max: int, func: (i: int) -> e maybe<a>): e maybe<a> {
  if (min == max)
    return Nothing
  else
    val res = func(min)
    return match res
      Just(r) -> Just(r)
      Nothing -> for-range(min + 1, max, func)
}

fun solve2((_, search-space, instructions): (int, int, list<instruction>)): <div, console, log> maybe<(int, int)> {
  val xs = instructions.flatmap(fn(a) -> [a.beacon.fst, a.sensor.fst])

  val point = for-range(0, search-space) fn(x) {
    val point = for-range(0, search-space) fn(y) {
      val current = (x, y)
      val insM = find(instructions) fn(instruction) {
        val range = current.manhattan-distance(instruction.sensor)
        range <= instruction.manhattan-distance
      }

      if y % 100000 == 0 then
        println((x, y).show)

      /* if insM.is-just then */
      /*   log("#") */
      /* else */
      /*   log(".") */

      match insM
        Nothing -> Just(current)
        Just(_) -> Nothing
    }

    /* log("\n") */
    return point
  }

  println(point.map(show).show)

  /* log("\n") */

  point
}

fun tuning-frequency((x, y): (int, int)): int {
  x * 4000000 + y
}

fun get-solution(input: (int, int, list<instruction>)) {
  /* with fun log(s: string) print(s) */
  with fun log(s: string) ()

  /* val result1 = solve1(input) */
  /* println("Len: " ++ result1.show) */

  val result2 = solve2(input)

  result2.map(tuning-frequency)
}

pub fun main() {
  val input = real-input()
  /* val input = example-input() */

  val result2 = get-solution(input)

  println("Len: " ++ result2.map(show).show)
}
