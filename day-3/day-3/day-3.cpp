
#include <fstream>
#include <iostream>
#include <list>
#include <string>

std::string filename = "input.txt";
int part = 2;

char get_common_item(const std::string& line)
{
    const size_t compartment_size = line.size() / 2;

    const std::string compartment1 = line.substr(0, compartment_size);

    for (const char item : compartment1)
    {
        const size_t pos = line.find(item, compartment_size);
        if (pos != std::string::npos)
        {
            return item;
        }
    }
    
    return '0';
}

int get_item_priority(const char common_item)
{
    if (common_item == '0')
    {
        return 0;
    }
    if (common_item <= 90)
    {
        return common_item - 38;
    }
    return common_item - 96;
}

int get_priority(const std::string& line)
{
    const char common_item = get_common_item(line);
    return get_item_priority(common_item);
}

int get_part1_priority(std::ifstream file)
{
    int total_priority = 0;
    
    std::string line;
    while (std::getline(file, line))
    {
        total_priority += get_priority(line);
    }
    file.close();

    return total_priority;
}

char get_badge(std::list<std::string>& group)
{
    const std::string elf1 = group.front();
    group.pop_front();
    const std::string elf2 = group.front();
    group.pop_front();
    const std::string elf3 = group.front();

    for (const char item : elf1)
    {
        if (elf2.find(item) != std::string::npos)
        {
            if (elf3.find(item) != std::string::npos)
            {
                return item;
            }
        }
    }
    return '0';
}

int get_group_badge_priority(std::list<std::string>& group)
{
    const char badge = get_badge(group);
    return get_item_priority(badge);
}

int get_part2_priority(std::ifstream file)
{
    int total_priority = 0;
    std::list<std::string> group;
    
    std::string line;
    while (std::getline(file, line))
    {
        if (group.size() < 3)
        {
            group.push_back(line);
        }

        if (group.size() == 3)
        {
            total_priority += get_group_badge_priority(group);
            group.clear();
        }
    }
    file.close();

    return total_priority;
}

int main(int argc, char* argv[])
{
    std::ifstream file (filename);

    if (part == 1)
    {
        std::cout << get_part1_priority(std::move(file));
    } else if (part == 2)
    {
        std::cout << get_part2_priority(std::move(file));
    }

    
    return 0;
}
