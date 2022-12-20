import strutils
import sequtils
import sets
import std/enumerate

type Position = tuple[x: int, y: int, z: int]

func distance(a: Position, b: Position): int =
  (a.x - b.x).abs() + (a.y - b.y).abs() + (a.z - b.z).abs()

func parsePosition(line: string): Position =
  let p = line.split(",").mapIt(it.parseInt())
  return (x: p[0], y: p[1], z: p[2])

proc getSurfaceArea(cubes: seq[Position]): int =
  var totalSides = 0

  for index, cubea in enumerate(cubes):
    var sides = 6

    for cubeb in items(cubes):
      if cubea.distance(cubeb) == 1:
        sides -= 1
      if sides <= 0:
        break

    totalSides += sides

  return totalSides

proc solve1(cubes: seq[Position]): int =
  getSurfaceArea(cubes)

let cubes: seq[Position] =
  readFile("./input.txt")
    .strip()
    .split("\n")
    .map(parsePosition)

echo "-------------------"

echo "Part 1: "
echo solve1(cubes)

echo "-------------------"

echo "Part 2: "
echo solve2(cubes)

echo "-------------------"
