module Main where

import System.Environment.Blank (getArgs)
import Part01 (part01)
import Part02 (part02)

main :: IO ()
main = do
  args <- getArgs
  result <- run args
  putStrLn result
  
run :: [String] -> IO String
run ("part01" : args) = part01 args
run ("part02" : args) = part02 args
run _ = return "unknown subcommand"