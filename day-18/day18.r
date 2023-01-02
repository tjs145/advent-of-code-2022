test_mode = FALSE
part = 2

if (test_mode) {
    scan_size = 20
    scan_offset = 10
} else {
    scan_size = 50
    scan_offset = 25
}

get_filename <- function() {
    if (test_mode) {
       "test_input.txt"
    } else {
        "input.txt"
    }
}

read_in_occupied_locations <- function(filename) {
    content = scan(filename, list(xs=0, ys=0, zs=0), sep=",")
    occupied_locations = array(FALSE, c(scan_size, scan_size, scan_size))

    for (i in 1:length(content$xs)) {
        occupied_locations[content$xs[i] + scan_offset, content$ys[i] + scan_offset, content$zs[i] + scan_offset] = TRUE
    }

    occupied_locations
}

get_neighbours <- function(location) {
    x = location[1]
    y = location[2]
    z = location[3]

    list(
        c(x + 1,y,z),
        c(x - 1,y,z),
        c(x,y + 1,z),
        c(x,y - 1,z),
        c(x,y,z + 1),
        c(x,y,z - 1)
    )
}

not_out_of_bounds <- function(location) {
    x = location[1]
    y = location[2]
    z = location[3]

    x > 0 && y > 0 && z > 0 && x <= scan_size && y <= scan_size && z <= scan_size
}

get_valid_neighbour_vectors <- function(locations) {
    valid_neighbours = list()
    for (location in locations) {
        neighbours = get_neighbours(location)
        for (neighbour in neighbours) {
            if (not_out_of_bounds(neighbour)) {
                valid_neighbours[length(valid_neighbours) + 1] = list(neighbour)
            }
        }
    }
    valid_neighbours
}

get_surface_at_location <- function(x, y, z, occupied_locations) {
    surface_area = 0
    neighbours = get_valid_neighbour_vectors(list(c(x, y, z)))
    for (n in neighbours) {
        if (!occupied_locations[n[1], n[2], n[3]]) {
            surface_area = surface_area + 1
        }
    }
    surface_area
}

total_surface <- function(occupied_locations) {
    surface_area = 0
    for (x in 1:scan_size) {
        for (y in 1:scan_size) {
            for (z in 1:scan_size) {
                if (occupied_locations[x, y, z]) {
                    surface_area = surface_area + get_surface_at_location(x, y, z, occupied_locations)
                }
            }
        }
    }
    surface_area
}

get_water_locations <- function(lava_array) {
    water_array = array(FALSE, c(scan_size, scan_size, scan_size))
    water_array[1, 1, 1] = TRUE
    edge_locations = list(c(1,1,1))

    while (length(edge_locations) != 0) {
        neighbours = get_valid_neighbour_vectors(edge_locations)
        edge_locations = list()
        for (n in neighbours) {
            if (!lava_array[n[1], n[2], n[3]]  && !water_array[n[1], n[2], n[3]]) {
                water_array[n[1], n[2], n[3]] = TRUE
                edge_locations[length(edge_locations)+1] = list(n)
            }
        }
    }

    water_array
}

total_exterior_surface <- function(lava_array) {
    water_array = get_water_locations(lava_array)
    exterior_surface = total_surface(water_array)
    exterior_surface
}

lava_array = read_in_occupied_locations(get_filename())

if (part == 1) {
    print(total_surface(lava_array))
} else {
    print(total_exterior_surface(lava_array))
}