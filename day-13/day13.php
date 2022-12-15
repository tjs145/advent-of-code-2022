<?php
$test_mode = false;
$part = 2;

function get_filename($test_mode): string
{
    if ($test_mode)
    {
        return "test_input.txt";
    }
    return "input.txt";
}

function read_pairs($test_mode): array
{
    $filename = get_filename($test_mode);
    $file = fopen($filename, "r");
    $data = fread($file, filesize($filename));
    fclose($file);
    return preg_split("/\r\n\r\n/", $data);

}

function split_where_not_in_brackets($line): array
{
    $result = [];
    $current_word = "";
    $bracket_depth = 0;
    foreach (str_split($line) as $char)
    {
        if ($char == "," and $bracket_depth == 0)
        {
            $result[] = $current_word;
            $current_word = "";
        } elseif ($char == "[")
        {
            $bracket_depth++;
            $current_word .= $char;
        } elseif ($char == "]")
        {
            $bracket_depth--;
            $current_word .= $char;
        } else {
            $current_word .= $char;
        }
    }
    $result[] = $current_word;
    return $result;
}

function parse_packet($line): array
{
    $packet = [];
    $trimmed = trim($line, " \r\n");
    $without_brackets = substr($trimmed, 1, strlen($trimmed) - 2);
    foreach (split_where_not_in_brackets($without_brackets) as $element)
    {
        if (str_starts_with($element, "["))
        {
            $packet[] = parse_packet($element);
        } else
        {
            $packet[] = intval($element);
        }
    }
    return $packet;
}

function parse_packets($pair): array
{
    $lines = preg_split("/\r\n/", $pair);
    return array_map('parse_packet', $lines);
}

function compare_integers($left, $right): int
{
    return $left <=> $right;
}

function compare_lists($left, $right): int
{
    for ($i = 0; $i < min([count($left), count($right)]); $i++) {
        $comparison = compare_packets($left[$i], $right[$i]);
        if ($comparison != 0) {
            return $comparison;
        }
    }
    return compare_integers(count($left), count($right));
}

function compare_mixed($left, $right): int
{
    if (gettype($left) == "integer") {
        return compare_packets([$left], $right);
    } else {
        return compare_packets($left, [$right]);
    }
}

function compare_packets($left, $right): int
{
    if (gettype($left) == "integer" and gettype($right) == "integer")
    {
        return compare_integers($left, $right);
    } elseif (gettype($left) == "array" and gettype($right) == "array")
    {
        return compare_lists($left, $right);
    } else {
        return compare_mixed($left, $right);
    }
}

function packet_to_string($packet): string
{
    $str = "[";
    foreach ($packet as $element)
    {
        if (gettype($element) == "integer")
        {
            $str .= $element;
        } else
        {
            $str .= packet_to_string($element);
        }
    }
    return $str."]";
}

function get_index_value_if_ordered($pair, $index): int
{
    $packets = parse_packets($pair);

    $packet1 = $packets[0];
    $packet2 = $packets[1];

    echo packet_to_string($packet1) . "\n";
    echo packet_to_string($packet2) . "\n";

    if (compare_packets($packet1, $packet2) == -1) //spaceship operator rules of comparison
    {
        return $index + 1;
    }
    return 0;
}

function parse_and_sort_packets($lines): array
{
    $packets = array_map('parse_packet', $lines);
    usort($packets, 'compare_packets');
    return $packets;
}

function main($test_mode, $part): void
{
    $pairs = read_pairs($test_mode);

    if ($part == 1) {
        $index_sum = 0;
        for ($i = 0; $i < count($pairs); $i++)
        {
            $pair = $pairs[$i];
            $index_sum += get_index_value_if_ordered($pair, $i);
        }
        echo $index_sum;
    } else {
        $packets_strings = explode("\r\n", implode("\r\n", $pairs));
        $packets_strings[] = "[[2]]";
        $packets_strings[] = "[[6]]";

        $sorted_packets = parse_and_sort_packets($packets_strings);

        $divider1_index = array_search([[2]], $sorted_packets) + 1;
        $divider2_index = array_search([[6]], $sorted_packets) + 1;

        echo $divider1_index . "\n";
        echo $divider2_index . "\n";
        echo $divider1_index * $divider2_index . "\n";
    }
}

main($test_mode, $part);

