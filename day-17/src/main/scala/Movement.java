public enum Movement {
    LEFT(-1, 0),
    RIGHT(1, 0),
    DOWN(0, -1);

    public final int dx;
    public final int dy;

    Movement(int dx, int dy) {
        this.dx = dx;
        this.dy = dy;
    }
}
