Public Class CPU
    
    Dim x As Integer = 1
    Dim cycles As Integer = 0
    Dim signalStrength = 0
    Dim pixelRow As String = ""
    
    Public Sub ProcessInstruction(instruction As String)
        If "noop".Equals(instruction) Then
            ProcessNoop()
        Else 
            ProcessAdd(instruction)
        End If
    End Sub

    Public Function GetSignalStrength() As Integer
        Return signalStrength
    End Function

    Private Sub ProcessNoop()
        IncrementCyclesAndSignalStrength()
    End Sub

    Private Sub ProcessAdd(instruction As String)
        Dim arg As Integer = Integer.Parse(instruction.Split(" "c)(1))
        IncrementCyclesAndSignalStrength()
        IncrementCyclesAndSignalStrength()
        x += arg
    End Sub
    
    Private Sub IncrementCyclesAndSignalStrength()
        AddPixel()
        cycles += 1
        If ((cycles - 20) Mod 40 = 0) Then
            signalStrength += cycles * x
        End If     
    End Sub

    Private Sub AddPixel()
        Dim crtPosition = cycles Mod 40
        
        If (crtPosition - x) ^ 2 <= 1 Then
            pixelRow += "#"
        Else 
            pixelRow += "."
        End If
        
        If pixelRow.Length = 40 Then
            Console.WriteLine(pixelRow)
            pixelRow = ""
        End If
    End Sub
End Class