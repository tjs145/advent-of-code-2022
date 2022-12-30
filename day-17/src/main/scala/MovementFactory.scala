class MovementFactory(input: String) {

    var n = 0
    var isNextDown = false

    def setNextMovementAsSideways(): Unit = {
        isNextDown = false
    }

    def getNextMovement: Movement = {
        var nextMove: Movement = Movement.DOWN
        if (!isNextDown) {
            nextMove = getNextSideMovement
            n += 1
        }
        isNextDown = !isNextDown
        nextMove
    }

    def getMovementNumber: Int = n

    private def getNextSideMovement: Movement = {
        n = if (n >= input.length) n - input.length else n
        if (input(n) == '<') Movement.LEFT else Movement.RIGHT
    }
}
