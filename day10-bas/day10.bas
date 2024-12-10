Open "input" For Input As #1

' I'm going to be lazy about it and hardcode the dimensions :(
Dim Shared W As Integer = 57
Dim Shared H As Integer = 57

Dim Shared Grid(H, W) As Integer
Dim Shared ResultMap(H, W) As Integer

Dim Result As Integer = 0
Dim Result2 As Integer = 0

Declare Function MountainStep(X As Integer, Y As Integer, From As Integer) As Integer
Declare Function CountPeaks() As Integer

For Y As Integer = 0 To H - 1
    Dim Reader As String
    Line Input #1, Reader
    For X As Integer = 0 To W - 1
        Grid(Y, X) = Reader[X] - 48
    Next X
Next Y

For Y As Integer = 0 To H - 1
    For X As Integer = 0 To W - 1
        If (Grid(Y, X) = 0) Then
            Result2 += MountainStep(X, Y, -1)
            Result += CountPeaks()
        End If
    Next X
Next Y

Print(Result)
Print(Result2)

Function MountainStep(X As Integer, Y As Integer, From As Integer) As Integer
    If X < 0 or X >= W or Y < 0 or Y >= H Then
        Return 0
    End If 
    If Grid(Y, X) <> From + 1 Then
        Return 0
    End If
    If Grid(Y, X) = 9 Then
        ResultMap(Y, X) = 1
        Return 1
    End If
    Return _
        MountainStep(X + 1, Y, Grid(Y, X)) + MountainStep(X - 1, Y, Grid(Y, X)) +_
        MountainStep(X, Y + 1, Grid(Y, X)) + MountainStep(X, Y - 1, Grid(Y, X))
End Function

Function CountPeaks() As Integer
    Dim Result As Integer = 0
    For Y As Integer = 0 To H
        For X As Integer = 0 To W
            If ResultMap(Y, X) <> 0 Then
                Result += 1
                ResultMap(Y, X) = 0
            End If
        Next X
    Next Y
    Return Result
End Function
