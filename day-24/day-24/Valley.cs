namespace day_24;

public class Valley
{
    private readonly int _width;
    private readonly int _height;
    private readonly List<BlizzardPredictor>[,] _blizzardPredictors;

    public Valley(int width, int height, List<Blizzard> blizzards)
    {
        _width = width;
        _height = height;
        _blizzardPredictors = new List<BlizzardPredictor>[height, width];
        for (int x = 0; x < width; x++)
        {
            for (int y = 0; y < height; y++)
            {
                _blizzardPredictors[y, x] = new List<BlizzardPredictor>();
            }
        }
        AssignBlizzardPredictors(blizzards);
    }

    public bool IsOccupied(int x, int y, int t)
    {
        if ((x == 0 && y == -1) || IsExit(x, y))
        {
            return false;
        }
        return _blizzardPredictors[y, x].Exists(bp => bp.IsBlizzard(t));
    }

    public bool IsExit(int x, int y)
    {
        return x == _width - 1 && y == _height;
    }

    public int GetStartX()
    {
        return 0;
    }

    public int GetStartY()
    {
        return -1;
    }

    public int GetExitX()
    {
        return _width - 1;
    }
    
    public int GetExitY()
    {
        return _height;
    }

    internal List<BlizzardPredictor> GetBlizzardPredictorsForLocation(int x, int y)
    {
        return _blizzardPredictors[y, x];
    }

    private void AssignBlizzardPredictors(List<Blizzard> blizzards)
    {
        foreach (var blizzard in blizzards)
        {
            AssignBlizzardPredictors(blizzard);
        }
    }

    private void AssignBlizzardPredictors(Blizzard blizzard)
    {
        //todo add the other directions
        if (blizzard.Direction == Direction.RIGHT)
        {
            for (int x = blizzard.X; x < _width; x++)
            {
                _blizzardPredictors[blizzard.Y, x].Add(new BlizzardPredictor(_width, x - blizzard.X));
            }
            for (int x = 0; x < blizzard.X; x++)
            {
                _blizzardPredictors[blizzard.Y, x].Add(new BlizzardPredictor(_width, (x - blizzard.X) + _width));
            }
        } else if (blizzard.Direction == Direction.DOWN)
        {
            for (int y = blizzard.Y; y < _height; y++)
            {
                _blizzardPredictors[y, blizzard.X].Add(new BlizzardPredictor(_height, y - blizzard.Y));
            }
            for (int y = 0; y < blizzard.Y; y++)
            {
                _blizzardPredictors[y, blizzard.X].Add(new BlizzardPredictor(_height, (y - blizzard.Y) + _height));
            }
        } else if (blizzard.Direction == Direction.LEFT)
        {
            for (int x = blizzard.X; x >= 0; x--)
            {
                _blizzardPredictors[blizzard.Y, x].Add(new BlizzardPredictor(_width, blizzard.X - x));
            }
            for (int x = _width - 1; x > blizzard.X; x--)
            {
                _blizzardPredictors[blizzard.Y, x].Add(new BlizzardPredictor(_width, (blizzard.X - x) + _width));
            }
        } else if (blizzard.Direction == Direction.UP)
        {
            for (int y = blizzard.Y; y >= 0; y--)
            {
                _blizzardPredictors[y, blizzard.X].Add(new BlizzardPredictor(_height, blizzard.Y - y));
            }
            for (int y = _height - 1; y > blizzard.Y; y--)
            {
                _blizzardPredictors[y, blizzard.X].Add(new BlizzardPredictor(_height, (blizzard.Y - y) + _height));
            }
        }
    }

    public bool IsAllowed(int x, int y)
    {
        if ((x == 0 && y == -1) || IsExit(x, y))
        {
            return true;
        }
        return x >= 0 && x < _width && y >= 0 && y < _height;
    }
}