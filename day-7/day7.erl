-module(day7).
-export([main/2]).
-record(item, {name = "", size = 0, parent_index = 0}).
-record(parsing_context, {selected_item_index = 0, items = []}).

main(Testing, Part) ->
    Filename = get_input_filename(Testing),
    {ok, Data} = file:read_file(Filename),
    Terminal_Lines = split_to_lines(binary:bin_to_list(Data)),
    End_Parsing_Context = get_linked_items(Terminal_Lines),
    Items = End_Parsing_Context#parsing_context.items,
    Total_Sizes = get_total_dir_sizes(Items),
    if 
        Part == 1 ->
            Sizes_Under_Limit = lists:filter(fun(Size) -> Size =< 100000 end, Total_Sizes),
            lists:sum(Sizes_Under_Limit);
        true ->
            Total_Used_Space = lists:nth(1, Total_Sizes),
            Free_Space = 70000000 - Total_Used_Space,
            Space_Required = 30000000 - Free_Space,
            Potential_Deletees = lists:filter(fun(Size) -> Size >= Space_Required end, Total_Sizes),
            lists:min(Potential_Deletees)
    end.
            

get_input_filename(Testing) ->
    if
        Testing ->
            "test_input.txt";
        true ->
            "input.txt"
    end.

split_to_lines(Blob) ->
    string:split(Blob, "\r\n", all).
    
get_linked_items(Terminal_Lines) ->
    lists:foldl(fun(Line, Parsing_Context) -> parse_line(Line, Parsing_Context) end, #parsing_context{}, Terminal_Lines).

parse_line(Line, Parsing_Context) ->
    case is_command(Line) of
        true ->
            parse_command(Line, Parsing_Context);
        false ->
            parse_output(Line, Parsing_Context)
    end.

is_command(Line) -> 
    string:sub_word(Line, 1) == "$".

parse_command(Line, Parsing_Context) -> 
    case string:sub_word(Line, 2) of
        "cd" -> 
            process_cd(string:sub_word(Line, 3), Parsing_Context);
        "ls" ->
            Parsing_Context
    end.

process_cd(New_Directory, Parsing_Context) ->
    if 
        New_Directory == ".." ->
            process_moving_out(Parsing_Context);
        true -> 
            process_moving_in(Parsing_Context, New_Directory)
    end.

process_moving_out(Parsing_Context) ->
    Current_Selected_Item_Index = Parsing_Context#parsing_context.selected_item_index,
    Current_Selected_Item = lists:nth(Current_Selected_Item_Index, Parsing_Context#parsing_context.items),

    #parsing_context{selected_item_index = Current_Selected_Item#item.parent_index, items = Parsing_Context#parsing_context.items}.

process_moving_in(Parsing_Context, New_Directory) -> 
    %assume never CD'ing into the same dir twice
    Updated_Items = lists:append(Parsing_Context#parsing_context.items, [#item{name = New_Directory, size = 0, parent_index = Parsing_Context#parsing_context.selected_item_index}]),
    #parsing_context{selected_item_index = length(Updated_Items), items = Updated_Items}.

parse_output(Line, Parsing_Context) ->
    First_Word = string:sub_word(Line, 1),
    if 
        First_Word == "dir" ->
            Parsing_Context;
        true ->
            add_child_file(Line, Parsing_Context)
    end.

add_child_file(Line, Parsing_Context) ->
    Size = list_to_integer(string:sub_word(Line, 1)),
    Current_Selected_Item_Index = Parsing_Context#parsing_context.selected_item_index,
    Current_Selected_Item = lists:nth(Current_Selected_Item_Index, Parsing_Context#parsing_context.items),
    Updated_Item = Current_Selected_Item#item{size = Current_Selected_Item#item.size + Size},
    Items_Without_Current_Item = lists:delete(Current_Selected_Item, Parsing_Context#parsing_context.items),
    Updated_Items = lists:append(Items_Without_Current_Item, [Updated_Item]),
    Parsing_Context#parsing_context{selected_item_index = length(Updated_Items), items = Updated_Items}.

get_total_dir_sizes(Items) ->
    Items_With_Updated_sizes = add_dir_sizes_to_parents(length(Items), Items),
    lists:map(fun(Item) -> Item#item.size end, Items_With_Updated_sizes).
    
add_dir_sizes_to_parents(Item_Index, Items) ->
    Item = lists:nth(Item_Index, Items),
    Parent_Index = Item#item.parent_index,
    if 
        Item_Index == 0 ->
            Items;
        Parent_Index == 0 ->
            Items;
        true -> 
            add_dir_sizes_to_parents(Item_Index - 1, increase_size_at_index(Items, Item#item.size, Parent_Index))
    end.

increase_size_at_index(Items, Size, Index) ->
    Item_To_Update = lists:nth(Index, Items),
    Updated_Item = Item_To_Update#item{size = Item_To_Update#item.size + Size},
    Items_Before_Updated_Item = lists:sublist(Items, Index - 1),
    Items_After_Updated_Item = lists:nthtail(Index, Items),
    Updated_Items = lists:append([Items_Before_Updated_Item, [Updated_Item], Items_After_Updated_Item]),
    Updated_Items.