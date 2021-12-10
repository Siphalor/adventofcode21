module Part02 where

type Pos = (Int, Int)

part02 :: [String] -> IO String
part02 [inputFile] = do
  input <- readFile inputFile
  return (format (calculatePos (lines input)))
    where
      format :: Pos -> String
      format (horizontal, depth) = "(" ++ show horizontal ++ ", " ++ show depth ++ ") = " ++ show (horizontal * depth)
part02 _ = return "incorrect arguments"

calculatePos :: [String] -> Pos
calculatePos inLines = fst (foldl process ((0,0), 0) inLines)
  where
    process :: (Pos, Int) -> String -> (Pos, Int)
    process (pos, aim) line = parse (words line)
      where
        parse :: [String] -> (Pos, Int)
        parse ["down", amount] = (pos, aim + read amount)
        parse ["up", amount] = (pos, aim - read amount)
        parse ["forward", amount] = ((fst pos + read amount, snd pos + read amount * aim), aim)
        parse parts = error ("failed to read line: " ++ unwords parts)

add :: Pos -> Pos -> Pos
add (x1, y1) (x2, y2) = (x1 + x2, y1 + y2)
