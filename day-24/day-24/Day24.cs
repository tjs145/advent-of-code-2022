using day_24;

bool testMode = false;

String filename = testMode ? "test_input.txt" : "input.txt";

String input = File.ReadAllText(filename);
Valley valley = ValleyParser.FromString(input);

Console.WriteLine(RouteFinder.GetMinutesToTraverseValleyOnce(valley));
Console.WriteLine(RouteFinder.GetMinutesForOutBackAndOutAgain(valley));