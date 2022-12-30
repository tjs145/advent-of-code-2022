import scala.collection.mutable

class Cave {

    private val occupiedPositions: mutable.HashSet[Position] = mutable.HashSet()
    private var height = BigInt(0)

    def arePositionsOccupied(positions: Set[Position]): Boolean = {
        positions.foreach(p => {
            if (p.x <= 0 || p.x > 7 || p.y == 0 || occupiedPositions.contains(p)) {
                return true
            }
        })
        false
    }

    def addOccupiedPositions(positions: Set[Position]): Unit = {
        positions.foreach(p => {
            height = if (p.y > height) p.y else height
        })
        occupiedPositions.addAll(positions)
    }

    def getRockHeight: BigInt = height
}
