import java.io.File

fun main() {
    val history = ArrayDeque<Int>(3)

    var increased = 0
    File("input/input").forEachLine {
        val depth = it.toIntOrNull() ?: return@forEachLine

        if (history.size >= 3) {
            if (depth > (history.firstOrNull() ?: 0)) {
                increased++
            }
            history.removeFirst()
        }
        history.addLast(depth)
    }

    println(increased)
}
