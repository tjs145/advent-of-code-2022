def can_move_north(adjacent_positions):
    return not (adjacent_positions[0] or adjacent_positions[1] or adjacent_positions[2])


def can_move_south(adjacent_positions):
    return not (adjacent_positions[5] or adjacent_positions[6] or adjacent_positions[7])


def can_move_east(adjacent_positions):
    return not (adjacent_positions[2] or adjacent_positions[4] or adjacent_positions[7])


def can_move_west(adjacent_positions):
    return not (adjacent_positions[0] or adjacent_positions[3] or adjacent_positions[5])


DIRECTION_CHECKERS = [can_move_north, can_move_south, can_move_west, can_move_east]
