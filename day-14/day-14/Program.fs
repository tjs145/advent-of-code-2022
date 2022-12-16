let test_mode = false
let part = 2

type Location =
    struct
        val x: int
        val y: int
        new (x: int, y: int) = {x = x; y = y}
    end

type Rock_Line =
    struct
        val start_point: Location
        val end_point: Location
        new (start_point: Location, end_point: Location) = {start_point = start_point; end_point = end_point}
    end

let get_filename test_mode :string = if test_mode then "test_input.txt" else "input.txt"

let parse_location location_str :Location =
    let number_strings = $"%s{location_str}".Split ","
    Location(number_strings[0] |> int, number_strings[1] |> int)

let parse_input_line (rock_lines: seq<Rock_Line>) (input_line: string) :seq<Rock_Line> =
    let locations = Seq.toArray (Seq.map parse_location ($"%s{input_line}".Split " -> "))
    let new_rock_lines = Array.create (locations.Length - 1) (Rock_Line(Location(0,0), Location(0,0)))
    
    for i in 0 .. (locations.Length - 2) do
        Array.set new_rock_lines i (Rock_Line(locations[i], locations[i + 1]))
        
    Seq.append rock_lines (Array.toSeq new_rock_lines)

let parse_input_lines (input_lines: seq<string>) :seq<Rock_Line> =
    (Seq.fold parse_input_line Seq.empty input_lines)
    
let location_fingerprint x y :int =
    (1000 * x) + y
    
let get_correctly_signed_interval n1 n2 :int =
    if n2 > n1 then 1 else -1
    
let get_locations_for_rock_line (rock_line : Rock_Line) :Set<int> =
    if rock_line.start_point.x = rock_line.end_point.x then
        let interval = get_correctly_signed_interval rock_line.start_point.y rock_line.end_point.y
        (Set.ofArray ([| for y in rock_line.start_point.y .. interval .. rock_line.end_point.y -> (location_fingerprint rock_line.start_point.x y) |]))
    else
        let interval = get_correctly_signed_interval rock_line.start_point.x rock_line.end_point.x
        (Set.ofArray ([| for x in rock_line.start_point.x .. interval .. rock_line.end_point.x -> (location_fingerprint x rock_line.start_point.y) |]))
    
let get_rock_locations (rock_lines: seq<Rock_Line>) :Set<int> =
    Set.unionMany (Seq.map get_locations_for_rock_line rock_lines)

let get_next_sand_position (occupied_locations: Set<int>) (current_position: Location) :Location option =
    let x = current_position.x
    let y = current_position.y
    if not (Set.contains (location_fingerprint x (y + 1)) occupied_locations) then
        Some(Location(x, y+1))
    elif not (Set.contains (location_fingerprint (x - 1) (y + 1)) occupied_locations) then
        Some(Location(x-1, y+1))
    elif not (Set.contains (location_fingerprint (x + 1) (y + 1)) occupied_locations) then
        Some(Location(x+1, y+1))
    else
        None
    
let rec propagate_sand_until_full (occupied_locations: Set<int>) (lowest_point: int) (settled_sands: int) (sand_location: Location) (part: int) :int =
    if sand_location.y > lowest_point && part = 1 then
        settled_sands
    else
        let next_sand_position = get_next_sand_position occupied_locations sand_location 
        if next_sand_position.IsNone || next_sand_position.Value.y = lowest_point + 2 then
            //has settled
            let updated_occupied_locations = Set.add (location_fingerprint sand_location.x sand_location.y) occupied_locations
            if part = 2 && sand_location.y = 0 then
                settled_sands + 1
            else
                (propagate_sand_until_full updated_occupied_locations lowest_point (settled_sands + 1) (Location(500, 0)) part)
        else
            (propagate_sand_until_full occupied_locations lowest_point settled_sands next_sand_position.Value part)
    
    
let get_lowest_point (rock_lines: seq<Rock_Line>) :int =
    Seq.max (Seq.map (fun (rl: Rock_Line) -> List.max [rl.start_point.y; rl.end_point.y]) rock_lines)
    
let get_sand_capacity (test_mode: bool) (part: int) :int =
    let rock_lines = System.IO.File.ReadLines(get_filename test_mode) |> Seq.cast<string> |> parse_input_lines
    let lowest_point = get_lowest_point rock_lines
    let rock_locations = get_rock_locations rock_lines
    propagate_sand_until_full rock_locations lowest_point 0 (Location(500,0)) part

printfn  $"%i{get_sand_capacity test_mode part}"
