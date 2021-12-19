string.findNext <- function (input, needle, default) {
  needle <- strsplit(needle, "")[[1]]
  chars <- strsplit(input, "")[[1]]
  result <- default
  for (i in seq_along(chars)) {
    if (chars[i] %in% needle) {
      result <- i
      break
    }
  }
  result
}

list.push <- function (l, ele) {
  append(l, ele)
}

list.pop <- function (l) {
  l[-length(l)]
}
