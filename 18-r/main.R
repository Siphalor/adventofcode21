library(purrr)
if (!exists("snailfish.parse", mode = "function")) source("snailfish.R")

args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 2) {
  print("incorrect number of arguments")
  stop()
}

sns <- map(readLines(args[2]), ~ snailfish.parse(.))
res <- reduce(sns[-1], ~ snailfish.add(.x, .y), .init = sns[[1]])

print(snailfish.toString(res))
print(snailfish.magnitude(res))
