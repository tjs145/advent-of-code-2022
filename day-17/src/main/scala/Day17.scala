import scala.collection.mutable
import scala.io.Source
import scala.util.Using

object Day17 {

    val testMode = false
    val part = 2
    private val filename = if (testMode) "test_input.txt" else "input.txt"
    private val totalRocks = if (part == 1) BigInt(2022) else BigInt(1000000) * 1000000 //1000000000000

    private val rockFactory = new RockFactory
    private val movementFactory = new MovementFactory(
        Using(Source.fromFile(filename)) { source => source.mkString }.get
    )
    private val cave = new Cave
    private var currentRock: Rock = null
    private var nRocks = BigInt(0)
    private var totalSkippedHeight = BigInt(0)

    private val previousStates = new mutable.HashMap[Int, Array[BigInt]]()

    def main(args: Array[String]): Unit = {
        while (nRocks <= totalRocks) {
            if (currentRock == null) {
                resetRock()
            }

            val movement = movementFactory.getNextMovement
            val nextPositions = currentRock.getNextPositions(movement)
            if (cave.arePositionsOccupied(nextPositions)) {
                if (movement == Movement.DOWN) {
                    tryToFastForward()
                    cave.addOccupiedPositions(currentRock.getCurrentPositions)
                    currentRock = null
                }
            } else {
                currentRock.move(movement)
            }
        }
        println(cave.getRockHeight + totalSkippedHeight)
    }

    def resetRock(): Unit = {
        currentRock = rockFactory.getNextRock(cave.getRockHeight)
        nRocks += 1
        movementFactory.setNextMovementAsSideways()
    }

    def tryToFastForward(): Unit = {
        val currentStateFingerprint = rockFactory.getRockNumber + (movementFactory.getMovementNumber * 5)
        var heightChange = BigInt(-1)
        var nRocksChange = BigInt(-1)
        if (previousStates.contains(currentStateFingerprint)) {
            val previousState = previousStates(currentStateFingerprint)
            heightChange = cave.getRockHeight - previousState(0)
            nRocksChange = nRocks - previousState(2)
            if (heightChange == previousState(1) && nRocksChange == previousState(3)) {
                println("repeating pattern of " + nRocksChange + " rocks (height " + heightChange + ") for rock #" + rockFactory.getRockNumber + " movement #" + movementFactory.getMovementNumber)
                val rocksLeft = totalRocks - nRocks
                val jumps  = rocksLeft / nRocksChange
                val skippedRocks = jumps * nRocksChange
                val skippedHeight = jumps * heightChange
                println("skipping ahead " + skippedRocks + " rocks and " + skippedHeight + " height")
                nRocks += skippedRocks
                totalSkippedHeight += skippedHeight
            }
        }
        previousStates.put(currentStateFingerprint, Array(cave.getRockHeight, heightChange, nRocks, nRocksChange))
    }
}
