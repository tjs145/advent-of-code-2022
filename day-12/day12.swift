import Foundation

struct Node: Hashable {
    var neighbours: [[Int]] = []
    var height = 0
    var is_start = false
    var is_end = false
    var location = [0,0]
    var hashValue: Int {
        return location.hashValue
    }
}

func get_filename(test_mode: Bool) -> String {
    if (test_mode) {
        return "test_input.txt"
    } else {
        return "input.txt"
    }
}

func get_height(character: Character) -> Int {
    return Int(character.asciiValue ?? 0)
}

func get_node(character: Character, location: [Int]) -> Node {
    // actually going backwards so start/end are reversed
    if character == "S" {
        return Node(height: get_height(character: "a"), is_end: true, location: location)
    } else if character == "E" {
        return Node(height: get_height(character: "z"), is_start: true, location: location)
    } else {
        return Node(height: get_height(character: character), location: location)
    }
}

func generate_height_map_row(input_line: String, row_number: Int) -> [Node] {
    var row: [Node] = []
    var col = 0
    for c in Array(input_line) {
        row += [get_node(character: c, location: [row_number, col])]
        col += 1
    }
    return row
}

func generate_height_map(input_lines: [Substring]) -> [[Node]] {
    var height_map: [[Node]] = []
    var row = 0
    for line in input_lines {
        height_map += [generate_height_map_row(input_line: String(line), row_number: row)]
        row += 1
    }
    return height_map
}

func assign_neighbours(graph: [[Node]]) -> [[Node]] {
    var linked_graph = Array(repeating: Array(repeating: Node(), count: graph[0].count), count: graph.count)
    for row in 0...(graph.count - 1) {
        for col in 0...(graph[row].count - 1) {
            linked_graph[row][col] = graph[row][col]
            let neighbour_indexes = [[row+1, col], [row-1, col], [row, col+1], [row, col-1]]
            for neighbour_index in neighbour_indexes {
                if ((neighbour_index[0] >= 0) && (neighbour_index[1] >= 0) && (neighbour_index[0] < graph.count) && (neighbour_index[1] < graph[row].count)) {
                    let neighbour = graph[neighbour_index[0]][neighbour_index[1]]
                    if neighbour.height - graph[row][col].height >= -1 {
                        linked_graph[row][col].neighbours += [neighbour_index]
                    }
                }
            }
        }
    }
    return linked_graph;
}

func get_start_node(graph: [[Node]]) -> Node {
    for row in graph {
        for node in row {
            if node.is_start {
                return node
            }
        }
    }
    return Node()
}

func get_end_distance(graph: [[Node]], part: Int) -> Int {
    var visited_nodes: Set<Node> = [get_start_node(graph: graph)]
    var edge_nodes: Set<Node> = [get_start_node(graph: graph)]

    var distance = 1

    while true {
        print(distance)
        var nodes_to_add: Set<Node> = []
        var nodes_to_remove: Set<Node> = []
        for node in edge_nodes {
            nodes_to_remove.insert(node)
            let neighbours = node.neighbours.filter {!visited_nodes.contains(graph[$0[0]][$0[1]])}

            if neighbours.count == 0 {
                nodes_to_remove.insert(node)
            } else {
                for neighbour_index in neighbours {
                    let new_node = graph[neighbour_index[0]][neighbour_index[1]]
                    if new_node.is_end && part == 1 {
                        return distance
                    } else if part == 2 && new_node.height == get_height(character: "a") {
                        return distance //Going backwards, so first 'a' encountered is shortest route
                    }
                    visited_nodes.insert(new_node)
                    nodes_to_add.insert(new_node)
                }
            }
        }

        for node in nodes_to_remove {
            edge_nodes.remove(node)
        }
        edge_nodes = edge_nodes.union(nodes_to_add)

        if edge_nodes.count == 0 {
            return 0;
        }

        print("Distance \(distance):")
        for edge in edge_nodes {
            print(edge.location)
        }

        distance += 1
    }
}

func main(test_mode: Bool, part: Int) -> Void {
    let filename = get_filename(test_mode: test_mode)
    let input = try! String(contentsOfFile: filename)
    let lines = input.split(separator: "\r\n")
    var graph = generate_height_map(input_lines: lines)
    graph = assign_neighbours(graph: graph)
    print(get_end_distance(graph: graph, part: part))
}

main(test_mode: false, part: 2)