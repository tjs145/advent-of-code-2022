import java.io.File
import java.lang.RuntimeException

val chosenShapeMatrix = arrayOf(
    arrayOf("Z", "X", "Y"),
    arrayOf("X", "Y", "Z"),
    arrayOf("Y", "Z", "X")
)

val part = 2;

fun main(args: Array<String>) {
    var totalScore = 0
    File("input.txt").forEachLine { line -> totalScore += getScore(line) }
    println(totalScore)
}

fun getScore(line: String) : Int {
    val shapes = line.split(" ")
    val opponentShape = shapes[0]
    var chosenShape = shapes[1]

    if (part == 2) {
        chosenShape = getChosenShape(chosenShape, opponentShape)
    }

    return getShapeScore(chosenShape) + getOutcomeScore(chosenShape, opponentShape)
}

fun getChosenShape(requiredOutcome: String, opponentShape: String): String {
    val requiredOutcomeId = getShapeId(requiredOutcome)
    val opponentShapeId = getShapeId(opponentShape)

    return chosenShapeMatrix[requiredOutcomeId][opponentShapeId]
}

fun getShapeScore(chosenShape: String): Int {
    return getShapeId(chosenShape) + 1
}

fun getShapeId(shape: String): Int {
    return when (shape) {
        "X", "A" -> {
            0 //Rock
        }
        "Y", "B" -> {
            1 //Paper
        }
        "Z", "C" -> {
            2 //Scissors
        }
        else -> {
            throw RuntimeException("Invalid shape: $shape")
        }
    }
}

fun getOutcomeScore(chosenShape: String, opponentShape: String): Int {
    val chosen = getShapeId(chosenShape)
    val opponent = getShapeId(opponentShape)

    return when (val idDifference = chosen - opponent) {
        0 -> {
            3
        }
        -1, 2 -> {
            0
        }
        -2, 1 -> {
            6
        }
        else -> {
            throw RuntimeException("Invalid ID difference result: $idDifference")
        }
    }
}