from direction_checkers import DIRECTION_CHECKERS

DIRECTIONS = ['N', 'S', 'W', 'E']


def parse_input(input_file):
    elfs = []

    file = open(input_file, 'r')
    lines = file.readlines()
    for y, line in enumerate(lines):
        for x, char in enumerate(line):
            if char == '#':
                elfs.append((x, y))

    return elfs


def get_proposed_direction(adjacent_positions, rounds):
    if DIRECTION_CHECKERS[rounds % 4](adjacent_positions):
        return DIRECTIONS[rounds % 4]
    if DIRECTION_CHECKERS[(rounds + 1) % 4](adjacent_positions):
        return DIRECTIONS[(rounds + 1) % 4]
    if DIRECTION_CHECKERS[(rounds + 2) % 4](adjacent_positions):
        return DIRECTIONS[(rounds + 2) % 4]
    if DIRECTION_CHECKERS[(rounds + 3) % 4](adjacent_positions):
        return DIRECTIONS[(rounds + 3) % 4]
    return 'None'


def get_adjacent_positions(position, all_positions):
    adjacent_positions = []
    for dy in range(-1, 2):
        for dx in range(-1, 2):
            if dx == 0 and dy == 0:
                continue
            adjacent_positions.append((position[0] + dx, position[1] + dy) in all_positions)
    return adjacent_positions


def get_proposed_position(current, all_current, rounds):
    adjacent_positions = get_adjacent_positions(current, all_current)

    if True not in adjacent_positions:
        return None

    proposed_direction = get_proposed_direction(adjacent_positions, rounds)
    if proposed_direction == 'N':
        return current[0], current[1] - 1
    elif proposed_direction == 'S':
        return current[0], current[1] + 1
    elif proposed_direction == 'E':
        return current[0] + 1, current[1]
    elif proposed_direction == 'W':
        return current[0] - 1, current[1]
    else:
        return None


def get_proposed_positions(elfs, rounds):
    proposed_positions = []
    position_set = set(elfs)
    for elf in elfs:
        proposed_positions.append(get_proposed_position(elf, position_set, rounds))
    return proposed_positions


def get_new_elf_positions(current, proposed):
    new_positions = []
    proposed_movements = list(filter(lambda x: x is not None, proposed))
    for i, p in enumerate(proposed):
        if p is None:
            new_positions.append(current[i])
        elif proposed_movements.count(p) > 1:
            new_positions.append(current[i])
        else:
            new_positions.append(p)
    return new_positions


def count_empty_ground_tiles(elf_positions):
    min_x = elf_positions[0][0]
    max_x = elf_positions[0][0]
    min_y = elf_positions[0][1]
    max_y = elf_positions[0][1]
    for p in elf_positions:
        if p[0] > max_x:
            max_x = p[0]
        elif p[0] < min_x:
            min_x = p[0]

        if p[1] > max_y:
            max_y = p[1]
        elif p[1] < min_y:
            min_y = p[1]

    return ((max_x - min_x + 1) * (max_y - min_y + 1)) - len(elf_positions)


def get_empty_ground_tiles_after_10_rounds(input_file):
    positions = parse_input(input_file)
    rounds = 0

    while rounds < 10:
        proposed_positions = get_proposed_positions(positions, rounds)
        positions = get_new_elf_positions(positions, proposed_positions)
        rounds += 1

    return count_empty_ground_tiles(positions)


def get_first_round_with_no_movement(input_file):
    positions = parse_input(input_file)
    rounds = 0

    while True:
        print(rounds + 1)
        proposed_positions = get_proposed_positions(positions, rounds)

        if len(list(filter(lambda x: x is not None, proposed_positions))) == 0:
            return rounds + 1

        positions = get_new_elf_positions(positions, proposed_positions)
        rounds += 1


if __name__ == '__main__':
    print(get_empty_ground_tiles_after_10_rounds("input.txt"))
    print(get_first_round_with_no_movement("input.txt"))
