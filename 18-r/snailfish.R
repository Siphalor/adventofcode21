if (!exists("string.findNext", mode = "function")) source("util.R")

snailfish.parse.helper <- function (input) {
  char <- substr(input, 1, 1)
  if (char == "[") {
    first_res <- snailfish.parse.helper(substr(input, 2, nchar(input)))
    first <- first_res[[1]]
    input <- substr(first_res[[2]], 2, nchar(first_res[[2]]))
    second_res <- snailfish.parse.helper(input)
    second <- second_res[[1]]
    input <- substr(second_res[[2]], 2, nchar(second_res[[2]]))
    list(list(first, second), input)
  } else {
    end <- string.findNext(input, ",]", nchar(input) + 1)
    list(as.numeric(substr(input, 1, end - 1)), substr(input, end, nchar(input)))
  }
}

snailfish.parse <- function (input) {
  snailfish.parse.helper(input)[[1]]
}

snailfish.reduce.helper.explode.add.left <- function (sn, value) {
  if (class(sn) == "numeric") {
    sn + value
  } else {
    list(snailfish.reduce.helper.explode.add.left(sn[[1]], value), sn[[2]])
  }
}

snailfish.reduce.helper.explode.add.right <- function (sn, value) {
  if (class(sn) == "numeric") {
    sn + value
  } else {
    list(sn[[1]], snailfish.reduce.helper.explode.add.right(sn[[2]], value))
  }
}

snailfish.reduce.helper.explode <- function (sn, depth) {
  if (class(sn) == "numeric") {
    list(sn, list())
  } else {
    depth <- depth + 1
    if (depth == 5) {
      list(0, sn)
    } else {
      left.res <- snailfish.reduce.helper.explode(sn[[1]], depth)
      left <- left.res[[1]]
      if (length(left.res[[2]]) == 2) {
        if (left.res[[2]][[2]] != 0) {
          right <- snailfish.reduce.helper.explode.add.left(sn[[2]], left.res[[2]][[2]])
        } else {
          right <- sn[[2]]
        }
        list(list(left, right), list(left.res[[2]][[1]], 0))
      } else {
        right.res <- snailfish.reduce.helper.explode(sn[[2]], depth)
        right <- right.res[[1]]
        if (length(right.res[[2]]) == 2) {
          if (right.res[[2]][[1]] != 0) {
            left <- snailfish.reduce.helper.explode.add.right(left, right.res[[2]][[1]])
          }
          list(list(left, right), list(0, right.res[[2]][[2]]))
        } else {
          list(sn, list())
        }
      }
    }
  }
}

snailfish.reduce.helper.split <- function (sn) {
  if (class(sn) == "numeric") {
    if (sn >= 10) {
      list(list(floor(sn/2), ceiling(sn/2)), TRUE)
    } else {
      list(sn, FALSE)
    }
  } else {
    left.res <- snailfish.reduce.helper.split(sn[[1]])
    if (left.res[[2]]) {
      list(list(left.res[[1]], sn[[2]]), TRUE)
    } else {
      right.res <- snailfish.reduce.helper.split(sn[[2]])
      if (right.res[[2]]) {
        list(list(sn[[1]], right.res[[1]]), TRUE)
      } else {
        list(sn, FALSE)
      }
    }
  }
}

snailfish.reduce <- function (sn) {
  while (TRUE) {
    explode.res <- snailfish.reduce.helper.explode(sn, 0)
    sn <- explode.res[[1]]
    if (length(explode.res[[2]]) == 2) {
      next
    }
    split.res <- snailfish.reduce.helper.split(sn)
    sn <- split.res[[1]]
    if (split.res[[2]]) {
      next
    }
    break
  }
  sn
}

snailfish.add <- function (sn1, sn2) {
  snailfish.reduce(list(sn1, sn2))
}

snailfish.toString <- function (sn) {
  if (class(sn) == "numeric") {
    format(sn)
  } else {
    paste0("[", snailfish.toString(sn[[1]]), ",", snailfish.toString(sn[[2]]), "]")
  }
}

snailfish.magnitude <- function (sn) {
  if (class(sn) == "numeric") {
    sn
  } else {
    3 * snailfish.magnitude(sn[[1]]) + 2 * snailfish.magnitude(sn[[2]])
  }
}
