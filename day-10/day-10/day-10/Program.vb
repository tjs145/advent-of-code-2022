Imports System
Imports System.IO

Module Program
    
    Dim testMode As Boolean = False
    Dim filename As String
    
    Sub SetFilename() 
        If testMode Then
            filename = "test_input.txt"
        Else 
            filename = "input.txt"
        End If
    End Sub
    
    Sub Main(args As String())
        SetFilename()
        Dim lines = File.ReadAllLines(filename)
        
        Dim cpu As New CPU 
        
        For Each line As String In lines
            cpu.ProcessInstruction(line)
        Next
        
        Console.WriteLine(cpu.GetSignalStrength())
    End Sub
End Module
