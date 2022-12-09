test_mode = false
input_filename = "input.txt"

if test_mode
    input_filename = "test_input.txt"
end

struct Tree_info
    is_visible
    height
    scenic_score
end

function initialise_tree_grid(lines)
    row_length = length(lines[1])
    column_height = length(lines)
    grid = Matrix{Tree_info}(undef, row_length, column_height)
    for r = 1:row_length
        for c = 1:column_height
            grid[c, r] = Tree_info(false, parse(Int, string(lines[c][r])), 1)
        end
    end
    return grid
end

function scan_array_for_visible_trees(arr, indexes)
    index_of_last_tree_by_height = map(x->indexes[1]*x, ones(10))
    max_height = -1;
    for n = indexes
        tree = arr[n]
        scenic_score_multiplier = minimum(x -> abs(n - x), index_of_last_tree_by_height[(tree.height + 1):10])
        if tree.height > max_height
            arr[n] = Tree_info(true, tree.height, tree.scenic_score * scenic_score_multiplier)
            max_height = tree.height
        else
            arr[n] = Tree_info(tree.is_visible, tree.height, tree.scenic_score * scenic_score_multiplier)
        end
        index_of_last_tree_by_height[tree.height + 1] = n
    end
end


function scan_for_visible_trees(grid)
    for row = eachrow(grid)
        scan_array_for_visible_trees(row, eachindex(row))
        scan_array_for_visible_trees(row, reverse(eachindex(row)))
    end
    for column = eachcol(grid)
        scan_array_for_visible_trees(column, eachindex(column))
        scan_array_for_visible_trees(column, reverse(eachindex(column)))
    end
end

function main(input_filename)
    lines = readlines(input_filename)
    tree_grid = initialise_tree_grid(lines)
    scan_for_visible_trees(tree_grid)
    if test_mode
        println(tree_grid)
    end
    visible_trees = mapreduce(t -> t.is_visible, +, tree_grid)
    println(visible_trees)
    max_scenic_score = maximum(tree -> tree.scenic_score, tree_grid)
    println(max_scenic_score)
end

main(input_filename)