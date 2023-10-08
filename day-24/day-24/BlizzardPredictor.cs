namespace day_24;

public class BlizzardPredictor
{
    private readonly int _period;
    private readonly int _offset;

    public BlizzardPredictor(int period, int offset)
    {
        _period = period;
        _offset = offset;
    }

    public bool IsBlizzard(int t)
    {
        return t % _period == _offset;
    }
}