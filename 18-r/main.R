library(purrr)
if (!exists("snailfish.parse", mode = "function")) source("snailfish.R")

args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 2) {
  print("incorrect number of arguments")
  stop()
}

sns <- map(readLines(args[2]), ~ snailfish.parse(.))

if (args[[1]] == "part01") {
  res <- reduce(sns[-1], ~ snailfish.add(.x, .y), .init = sns[[1]])
  print(snailfish.toString(res))
  print(snailfish.magnitude(res))
} else if (args[[1]] == "part02") {
  max <- 0
  for (i in seq_along(sns)) {
    for (j in i:length(sns)) {
      val <- snailfish.magnitude(snailfish.add(sns[[i]], sns[[j]]))
      if (val > max) {
        max <- val
      }
      val <- snailfish.magnitude(snailfish.add(sns[[j]], sns[[i]]))
      if (val > max) {
        max <- val
      }
    }
  }
  print(max)
} else {
  print("unknown subcommand")
}
