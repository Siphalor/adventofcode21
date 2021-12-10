module Part01 where

type Pos = (Int, Int)

part01 :: [String] -> IO String
part01 [inputFile] = do
  input <- readFile inputFile
  return (format (calculatePos (lines input)))
    where
      format :: Pos -> String
      format (horizontal, depth) = "(" ++ show horizontal ++ ", " ++ show depth ++ ") = " ++ show (horizontal * depth)
part01 _ = return "incorrect arguments"

calculatePos :: [String] -> Pos
calculatePos = foldl (\pos line -> add pos (getOffset line)) (0,0)
  where
    getOffset :: String -> Pos
    getOffset line = parse (words line)
      where
        parse :: [String] -> Pos
        parse ["forward", amount] = (read amount, 0)
        parse ["down", amount] = (0, read amount)
        parse ["up", amount] = (0, -read amount)
        parse parts = error ("failed to read line: " ++ unwords parts)

add :: Pos -> Pos -> Pos
add (x1, y1) (x2, y2) = (x1 + x2, y1 + y2)
