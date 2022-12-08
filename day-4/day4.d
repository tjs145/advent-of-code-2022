module day4;

import std.stdio;
import std.file;
import std.string;
import std.conv;

int part = 2;
string filename = "input.txt";

struct SectionAsignment 
{
    int lowerBound;
    int upperBound;
}

struct Pair 
{
    SectionAsignment section1;
    SectionAsignment section2;
}

SectionAsignment parseSectionAssignment(string section) 
{
    string[] range = split(section, "-");
    return SectionAsignment(parse!(int, string)(range[0]), parse!(int, string)(range[1]));
}

Pair parsePair(string line) 
{
    string[] sections = split(line, ",");
    SectionAsignment elf1 = parseSectionAssignment(sections[0]);
    SectionAsignment elf2 = parseSectionAssignment(sections[1]);
    return Pair(elf1, elf2);
}

bool sectionIsFullyContained(Pair pair)
{
    SectionAsignment section1 = pair.section1;
    SectionAsignment section2 = pair.section2;

    if (section1.lowerBound > section2.lowerBound)
    {
        return section1.upperBound <= section2.upperBound;
    } else if (section1.lowerBound < section2.lowerBound)
    {
        return section1.upperBound >= section2.upperBound;
    } else 
    {
        return true;
    }
}

bool isOverlapping(Pair pair) 
{
    SectionAsignment section1 = pair.section1;
    SectionAsignment section2 = pair.section2;

    int uppestBound;
    if (section1.upperBound >= section2.upperBound)
    {
        uppestBound = section1.upperBound;
    } else 
    {
        uppestBound = section2.upperBound;
    }

    int lowestBound;
    if (section1.lowerBound <= section2.lowerBound)
    {
        lowestBound = section1.lowerBound;
    } else 
    {
        lowestBound = section2.lowerBound;
    }

    int maxCoverage = uppestBound - lowestBound;
    int totalIndividualCoverages = (section2.upperBound - section2.lowerBound) 
                                    + (section1.upperBound - section1.lowerBound);

    return maxCoverage <= totalIndividualCoverages;
}

bool isRelevant(string line) 
{
    Pair pair = parsePair(line);
    if (part == 1) 
    {
        return sectionIsFullyContained(pair);
    }
    return isOverlapping(pair);
}

void main() 
{
    int pairsOfInterest = 0;

    string[] lines = splitLines(cast(string)read(filename));
    foreach(l; lines) {
        if (isRelevant(l))
        {
            pairsOfInterest += 1;
        } 
    }

    writefln(to!string(pairsOfInterest));
}