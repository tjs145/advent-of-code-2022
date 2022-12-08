part = 2
test_mode = false

filename = "input.txt"
$marker_size = 14

if test_mode
    filename = "test_input.txt"
end

if part == 1
    $marker_size = 4
end

def get_repeated_chars(str)
    repeated_chars = Array.new
    for i in 0..3 do
        for j in (i+1)..3 do
            if str[i] == str[j]
                repeated_chars.push str[i]
            end
        end
    end
    return repeated_chars
end

def all_different(str)
    return get_repeated_chars(str).length == 0
end

def init_marker_queue(init_str)
    marker = Array.new
    for i in 0..($marker_size - 1) do 
        marker.push init_str[i]
    end
    return marker
end

def remove_one_if_exists(arr, element)
    index = arr.find_index(element)
    if index != nil
        arr.delete_at(index)
    end
    return arr
end

def find_packet_marker(data)

    data_start = data[0, $marker_size]

    if all_different(data_start)
        return $marker_size
    end

    marker = init_marker_queue(data_start)
    repeated_chars = get_repeated_chars(data_start)
    marker_end = $marker_size

    while repeated_chars.length > 0
        repeated_chars = remove_one_if_exists(repeated_chars, marker.shift)

        new_marker_char = data[marker_end]
        if marker.include?(new_marker_char)
            repeated_chars.push new_marker_char
        end
        marker.push new_marker_char

        marker_end += 1

        puts "Marker: " + marker.join + " Repeated characters: " + repeated_chars.join

    end
    return marker_end

end

def main (filename)
    input = File.read(filename)
    puts find_packet_marker(input)
end

main(filename)