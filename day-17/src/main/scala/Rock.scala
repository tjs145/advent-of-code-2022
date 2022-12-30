class Rock(relativePositions: Array[Position], startPosition: Position) {
    private var bottomLeftPosition = startPosition

    def getNextPositions(movement: Movement): Set[Position] = {
        val nextBottomLeftPosition = bottomLeftPosition.add(Position(movement.dx, movement.dy))
        relativePositions.map(rp => rp.add(nextBottomLeftPosition)).toSet
    }

    def move(movement: Movement): Unit = {
        bottomLeftPosition = bottomLeftPosition.add(Position(movement.dx, movement.dy))
    }

    def getCurrentPositions: Set[Position] = {
        relativePositions.map(rp => rp.add(bottomLeftPosition)).toSet
    }
}
