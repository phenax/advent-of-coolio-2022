module Main where

-- current dir, tree

data File = File String Int | Dir String [File]
  deriving (Show)

addToDir :: File -> [String] -> String -> String -> File
addToDir f@(File _ _) _ _ _ = f
addToDir (Dir dir fs) path "dir" name = Dir dir (fs ++ [Dir name []])
addToDir (Dir dir fs) path sizeInfo name = Dir dir (fs ++ [File name (read sizeInfo :: Int)])

main :: IO ()
main = do
  contents <- readFile "./input.txt"
  print $ foldl go (Dir "/" [], []) $ lines contents
  where
    go :: (File, [String]) -> String -> (File, [String])
    go (file, path) ('$' : ' ' : 'c' : 'd' : ' ' : dir) = (file, resolveDir path dir)
    go acc ('$' : ' ' : 'l' : 's' : ' ' : _) = acc
    go (file, path) output = undefined
      where
        (bytes : filename : _) = words output

resolveDir :: [String] -> String -> [String]
resolveDir _ "/" = []
resolveDir path ".." = init path
resolveDir base dir = base ++ [dir]
