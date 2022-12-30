class RockFactory {

    private val type1 = Array(Position(0,0), Position(1,0), Position(2,0), Position(3,0))
    private val type2 = Array(Position(1,0), Position(1,1), Position(1,2), Position(0,1), Position(2,1))
    private val type3 = Array(Position(0,0), Position(1,0), Position(2,0), Position(2,1), Position(2,2))
    private val type4 = Array(Position(0,0), Position(0,1), Position(0,2), Position(0,3))
    private val type5 = Array(Position(0,0), Position(1,0), Position(0,1), Position(1,1))
    private val rockTypes = Array(type1, type2, type3, type4, type5)

    private var n = 0

    def getNextRock(totalRockHeight: BigInt): Rock = {
        n = if (n >= rockTypes.length) n - rockTypes.length else n
        val newRock = new Rock(rockTypes(n), Position(3, totalRockHeight + 4))
        n += 1
        newRock
    }

    def getRockNumber: Int = n
}
