import strutils
import intsets

const test_mode = false
const part = 2

type 
    Position = tuple
        x: int
        y: int

proc get_filename(test_mode: bool, part: int): string =
    result = "input.txt"
    if test_mode:
        if part == 1:
            result = "test_input.txt"
        else:
            result = "test_input2.txt"

proc parse_command(line: string): seq[string] =
    let line_parts = line.split(' ')
    let distance = parseInt(line_parts[1])

    for i in 0..(distance - 1):
        result.add(line_parts[0])

proc parse_commands(lines: seq[string]): seq[string] =
    for line in lines:
        result.add(parse_command(line))

proc get_new_position(command: string, previous_position: Position): Position =
    case command:
        of "U":
            return (x: previous_position.x, y: previous_position.y + 1)
        of "D":
            return (x: previous_position.x, y: previous_position.y - 1)
        of "L":
            return (x: previous_position.x - 1, y: previous_position.y)
        of "R":
            return (x: previous_position.x + 1, y: previous_position.y)

proc get_head_positions(commands: seq[string]): seq[Position] =
    result = @[(x: 0, y: 0)]

    for command in commands:
        let previous_position = result[high(result)]
        result.add(get_new_position(command, previous_position))

proc too_far_apart(p1: Position, p2: Position): bool =
    let dx = abs(p1.x - p2.x)
    let dy = abs(p1.y - p2.y)
    return ((dx + dy) > 2) or dx == 2 or dy == 2

proc get_next_position(head: Position, tail: Position): Position =
    let dx = head.x - tail.x
    let dy = head.y - tail.y

    if dx > 0:
        if dy > 0:
            result = (tail.x + 1, tail.y + 1)
        elif dy == 0:
            result = (tail.x + 1, tail.y)
        else:
            result = (tail.x + 1, tail.y - 1)
    elif dx == 0:
        if dy > 0:
            result = (tail.x, tail.y + 1)
        elif dy == 0:
            result = (tail.x, tail.y) #shouldn't be possible but whatever
        else:
            result = (tail.x, tail.y - 1)
    else:
        if dy > 0:
            result = (tail.x - 1, tail.y + 1)
        elif dy == 0:
            result = (tail.x - 1, tail.y)
        else:
            result = (tail.x - 1, tail.y - 1)
    
proc get_tail_positions(head_positions: seq[Position]): seq[Position] =
    result = @[(x: 0, y: 0)]

    for i, head_position in head_positions:
        let tail_position = result[high(result)]

        if too_far_apart(head_position, tail_position):
            result.add(get_next_position(head_position, tail_position))

proc convert_to_fingerprint_set(positions: seq[Position]): IntSet =
    for p in positions:
        let fingerprint = (p.x * 1000 + p.y) #Hopefuly large enough to map positions to ints 1:1
        incl(result, fingerprint)

proc main(test_mode: bool, part: int): void =
    let data = readFile(get_filename(test_mode, part))

    let lines = data.split("\r\n")
    let commands = parse_commands(lines)
    var tail_positions: seq[Position]
    let head_positions = get_head_positions(commands)

    if part == 1:
        tail_positions = get_tail_positions(head_positions)
    else:
        const n_knots = 10
        var knot_positions: array[n_knots, seq[Position]]
        knot_positions[0] = head_positions
        for i in 1..high(knot_positions):
            knot_positions[i] = get_tail_positions(knot_positions[i - 1])
        tail_positions = knot_positions[n_knots - 1]

    if test_mode:
        echo commands
        echo head_positions
        echo tail_positions

    echo len(tail_positions)

    let position_fingerprints = convert_to_fingerprint_set(tail_positions)
    echo len(position_fingerprints)

main(test_mode, part)