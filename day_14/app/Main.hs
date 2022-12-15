module Main where

import Control.Concurrent (threadDelay)
import Control.Monad (forM_, void)
import Data.List (intercalate)
import Data.List.Split (splitOn)
import Data.Maybe (fromMaybe)
import Debug.Trace (trace)
import GHC.IO.Handle (hFlush)
import GHC.IO.Handle.FD (stdout)

data Point = Point {getX :: Int, getY :: Int}
  deriving (Show, Eq)

newtype Grid = Grid [(PointState, Point)]
  deriving (Show, Eq)

data PointState = Air | Rock | Sand
  deriving (Show, Eq)

isStable :: (Point -> Grid -> PointState) -> Point -> Grid -> Bool
isStable getPointState p g = nextState getPointState p g == p

nextState :: (Point -> Grid -> PointState) -> Point -> Grid -> Point
nextState getPointState point@(Point x y) grid = fromMaybe point $ foldl go Nothing nextPoints
  where
    go Nothing p
      | getPointState p grid == Air = Just p
      | otherwise = Nothing
    go p@(Just _) _ = p
    nextPoints =
      [ Point x (y + 1),
        Point (x - 1) (y + 1),
        Point (x + 1) (y + 1)
      ]

toPoint :: [String] -> Point
toPoint [x, y] = Point (read x :: Int) (read y :: Int)
toPoint _ = undefined

interpolateList :: [Point] -> [Point]
interpolateList [] = []
interpolateList [_] = []
interpolateList (pp1 : pp2 : ps) = interpolate pp1 pp2 ++ interpolateList (pp2 : ps)
  where
    interpolate :: Point -> Point -> [Point]
    interpolate p1 p2
      | p1 == p2 = [p1]
      | otherwise =
          p1
            : interpolate
              ( Point
                  (step (getX p1) (getX p2))
                  (step (getY p1) (getY p2))
              )
              p2
      where
        step a b
          | a == b = a
          | a < b = a + 1
          | otherwise = a - 1

getInput :: IO [Point]
getInput = do
  contents <- readFile "./input.txt"
  let listOfLineDesc = map (toPoint . splitOn ",") . splitOn " -> " <$> lines contents
  pure $ concatMap interpolateList listOfLineDesc

maxY :: Grid -> Int
maxY (Grid []) = 0
maxY (Grid ((_, Point _ y) : ps))
  | y < nextMax = nextMax
  | otherwise = y
  where
    nextMax = maxY (Grid ps)

countSandGrains :: Grid -> Int
countSandGrains (Grid ps) = length $ filter ((== Sand) . fst) ps

solve1 :: Int -> Point -> Grid -> Grid
solve1 bottom point grid =
  case addSandGrain point grid of
    Just g -> solve1 bottom point g
    Nothing -> grid
  where
    addSandGrain :: Point -> Grid -> Maybe Grid
    addSandGrain p g@(Grid ps)
      | bottom < getY p = Nothing
      | isStable getPointState p grid = Just $ Grid ((Sand, p) : ps)
      | otherwise = addSandGrain (nextState getPointState p g) g

    getPointState :: Point -> Grid -> PointState
    getPointState _ (Grid []) = Air
    getPointState point' (Grid ((s, p) : ps))
      | p == point' = s
      | otherwise = getPointState point' (Grid ps)

solve2 :: Int -> Point -> Grid -> IO Grid
solve2 bottom sourcePoint grid = do
  -- drawGrid 0 0 grid
  -- threadDelay 300_000
  -- threadDelay 16_000
  if stablePoint == sourcePoint
    then pure finalGrid
    else solve2 bottom sourcePoint finalGrid
  where
    (stablePoint, finalGrid) = addSandGrain sourcePoint grid

    addSandGrain :: Point -> Grid -> (Point, Grid)
    addSandGrain p g@(Grid ps)
      | isStable getPointState p grid = (p, Grid ((Sand, p) : ps))
      | otherwise = addSandGrain (nextState getPointState p g) g

    getPointState :: Point -> Grid -> PointState
    getPointState _ (Grid []) = Air
    getPointState point' (Grid ((s, p) : ps))
      | getY point' >= bottom + 2 = Rock
      | p == point' = s
      | otherwise = getPointState point' (Grid ps)

    drawGrid :: Int -> Int -> Grid -> IO ()
    drawGrid rows cols g = do
      forM_
        [0 .. 20]
        ( \y -> do
            forM_
              [0 .. 80]
              ( \x ->
                  case getPointState (Point (x + 430) (y + 0)) g of
                    Air -> putChar '.'
                    Rock -> putChar '#'
                    Sand -> putChar 'o'
              )
            putStrLn ""
        )
      putStrLn ""

main :: IO ()
main = do
  let startingPoint = Point 500 0
  grid <- Grid . fmap (Rock,) <$> getInput
  let bottom = maxY grid
  res <- solve2 bottom startingPoint grid
  print $ countSandGrains res

----
----
----
----
----
