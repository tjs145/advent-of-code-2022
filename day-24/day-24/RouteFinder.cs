namespace day_24;

public class RouteFinder
{
    
    public static int GetMinutesForOutBackAndOutAgain(Valley valley)
    {
        int timeOut = GetMinutesToTraverseValleyOnce(valley);
        int timeBack = GetMinutesForRoute(valley, new RouteState(valley.GetExitX(), valley.GetExitY(), timeOut),
            valley.GetStartX(), valley.GetStartY());
        int timeOutAgain = GetMinutesForRoute(valley, new RouteState(valley.GetStartX(), valley.GetStartY(), timeBack),
            valley.GetExitX(), valley.GetExitY());
        return timeOutAgain;
    }
        
    public static int GetMinutesToTraverseValleyOnce(Valley valley)
    {
        return GetMinutesForRoute(valley, new RouteState(valley.GetStartX(), valley.GetStartY(), 0), valley.GetExitX(),
            valley.GetExitY());
    }

    private static int GetMinutesForRoute(Valley valley, RouteState start, int endX, int endY)
    {
        List<RouteState> possibleStates = GetPossibleStates(start, valley);
        while (!possibleStates.Exists(rs => rs.X == endX && rs.Y == endY))
        {
            List<RouteState> nextPossibleStates = new List<RouteState>();
            foreach (var state in possibleStates)
            {
                nextPossibleStates.AddRange(GetPossibleStates(state, valley).Where(s => !nextPossibleStates.Contains(s)));
            }
            possibleStates = nextPossibleStates;
        }

        return possibleStates.Find(rs => rs.X == endX && rs.Y == endY).Time;
    }

    internal static List<RouteState> GetPossibleStates(RouteState currentState, Valley valley)
    {
        List<RouteState> newStates = new List<RouteState>();
        var x = currentState.X;
        var y = currentState.Y;
        var t = currentState.Time + 1;

        if (!valley.IsOccupied(x, y, t))
        {
            newStates.Add(new RouteState(x, y, t));
        }
        if (valley.IsAllowed(x, y - 1) && !valley.IsOccupied(x, y - 1, t))
        {
            newStates.Add(new RouteState(x, y - 1, t));
        }
        if (valley.IsAllowed(x, y + 1) && !valley.IsOccupied(x, y + 1, t))
        {
            newStates.Add(new RouteState(x, y + 1, t));
        }
        if (valley.IsAllowed(x - 1, y) && !valley.IsOccupied(x - 1, y, t))
        {
            newStates.Add(new RouteState(x - 1, y, t));
        }
        if (valley.IsAllowed(x + 1, y) && !valley.IsOccupied(x + 1, y, t))
        {
            newStates.Add(new RouteState(x + 1, y, t));
        }

        return newStates;
    }

    internal record struct RouteState(int X, int Y, int Time);
}