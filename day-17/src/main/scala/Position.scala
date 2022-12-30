case class Position(x: Int, y: BigInt) {

    def add(p: Position): Position = {
        Position(p.x + x, p.y + y)
    }
}
