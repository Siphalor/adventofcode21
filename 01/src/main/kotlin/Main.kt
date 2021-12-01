import java.io.File

fun main() {
    var lastDepth: Int? = null
    var increases = 0
    File("input/input").forEachLine {
        val depth = it.toIntOrNull() ?: return@forEachLine

        if (lastDepth != null) {
            if (depth > lastDepth!!) {
                increases++
            }
        }
        lastDepth = depth
    }

    println(increases)
}
