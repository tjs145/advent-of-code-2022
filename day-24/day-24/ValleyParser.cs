namespace day_24;

public class ValleyParser
{
    public static Valley FromString(String str)
    {
        String[] rows = str.Split(Environment.NewLine);
        
        
        int width = rows[0].Length - 2;
        int height = rows.Length - 2;
        List<Blizzard> blizzards = new List<Blizzard>();

        for (int y = 0; y < height; y++)
        {
            for (int x = 0; x < width; x++)
            {
                char c = rows[y + 1][x + 1];
                if (c != '.')
                {
                    blizzards.Add(new Blizzard(x, y, ParseDirection(c)));
                }
            }
        }

        return new Valley(width, height, blizzards);
    }

    private static Direction ParseDirection(char c)
    {
        return c switch
        {
            '^' => Direction.UP,
            'v' => Direction.DOWN,
            '<' => Direction.LEFT,
            '>' => Direction.RIGHT,
            _ => throw new Exception($"Unrecognized input character: {c}")
        };
    }
}