package main

import scala.io.Source

case class Point(x: Int, y: Int):
  def add(p: Point): Point =
    Point(x + p.x, y + p.y)

def nextPosition(elfPositions: Set[Point], elf: Point, round: Int): Point =
  def nextP(elfPositions: Set[Point], elf: Point): Point =
    val fixedDirections = List(
      List(Point(-1, -1), Point(0, -1), Point(1, -1)),
      List(Point(-1, 1), Point(0, 1), Point(1, 1)),
      List(Point(-1, -1), Point(-1, 0), Point(-1, 1)),
      List(Point(1, -1), Point(1, 0), Point(1, 1))
    ).map(_.map(_.add(elf)))

    val directions = (0 until fixedDirections.length)
      .map(i => fixedDirections((round + i) % fixedDirections.length))
      .toList

    val adjacent =
      directions.foldLeft(Set.empty[Point])((set, l) => l.toSet.concat(set))

    if (!adjacent.exists(elfPositions(_)))
      (elf)
    else
      directions
        .map(dir =>
          if (dir.exists(elfPositions(_))) None
          else Some(dir(1))
        )
        .find(_.nonEmpty)
        .flatten
        .getOrElse(elf)

  val nextPoint = nextP(elfPositions, elf)

  val otherElves = elfPositions.excl(elf)
  val hasConflict =
    otherElves.exists(p => nextP(otherElves, p) == nextPoint)

  if (hasConflict)
    (elf)
  else
    nextPoint

def nonElfCellCount(setOfElves: Set[Point]): Int =
  val maxX = setOfElves.maxBy(p => p.x).x
  val maxY = setOfElves.maxBy(p => p.y).y
  val minX = setOfElves.minBy(p => p.x).x
  val minY = setOfElves.minBy(p => p.y).y

  println("")
  (minY to maxY).foreach(y => {
    (minX to maxX).foreach(x => {
      // if (Point(x, y) == Point(2, 7))
      //   print("x")
      // else
      if (setOfElves(Point(x, y)))
        print("#")
      else
        print(".")
    })
    println("")
  })

  (maxX - minX + 1).abs * (maxY - minY + 1).abs - setOfElves.size

@main
def main: Unit =
  val setOfPoints =
    Source
      .fromFile("./input.txt")
      .getLines()
      .zipWithIndex
      .map(l =>
        l._1
          .chars()
          .toArray()
          .zipWithIndex
          .filter(ch => ch._1 == '#')
          .map(ch => Point(ch._2, l._2))
          .toSet
      )
      .reduce((a, b) => Set.concat(a, b))

  val finalSet = (0 until 10).foldLeft(setOfPoints)((setOfElves, round) =>
    setOfElves.map(nextPosition(setOfElves, _, round))
  )

  println(nonElfCellCount(finalSet))

// wii
