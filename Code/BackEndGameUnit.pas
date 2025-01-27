Unit BackEndGameUnit;

Interface

Uses
    CheckerListUnit;

Var
    CheckerList: TCheckerList;
    IsMoving: Boolean = False;
    ClickedChecker: PChecker = Nil;
    MouseDownPosition, MouseUpPosition: TPosition;

Procedure CreateCheckers();
Procedure ClearCheckers();

Function CalculateMaxDistance() : Integer;

Procedure StartMoving();
Procedure StopMoving();

Procedure CheckerMouseDown(Const ClickPosition: TPosition);
Procedure CheckerMouseUp(Const ClickPosition: TPosition);

Procedure CalculateCheckersParametrs();
Procedure CalculateCollision();
Procedure CalculateOverlapping();
Procedure DeleteCheckers();

Function AreCheckersStopped(): Boolean;

Implementation

Uses
    Math,
    GameUnit, FrontEndGameUnit;

Const
    INITIAL_CHECKERS_AMOUNT : Integer = BOARD_CELLS_AMOUNT;
    DistanceIncrement : Integer = 6;
    Deceleration : Real = 0.94;

Procedure CreateCheckers();
Var
    Parameters: TParameters;
    LightY, DarkY, I: Integer;
Begin
    With Parameters Do
    Begin
        Position.X := BorderSize + CellSize Div 2;
        Velocity.X := 0;
        Velocity.Y := 0;
    End;

    LightY := BoardSize - (BorderSize + CellSize Div 2);
    DarkY := BorderSize + CellSize Div 2;

    For I := 1 To INITIAL_CHECKERS_AMOUNT Do
    Begin
        Parameters.Team := Light;
        Parameters.Position.Y := LightY;
        CheckerList.AddChecker(Parameters);

        Parameters.Team := Dark;
        Parameters.Position.Y := DarkY;
        CheckerList.AddChecker(Parameters);

        Parameters.Position.X := Parameters.Position.X + CellSize;
    End;
End;

Procedure ClearCheckers();
Begin
    CheckerList.Clear();
End;


Function CalculateMaxDistance() : Integer;
Begin
    Result := CheckerRadius * 4;
End;

Procedure CalculateClickedCheckerVelocity();
Var
    MaxDistance, XDistance, YDistance, Distance: Integer;
    RatioCoefficient: Real;
Begin
    MaxDistance := CalculateMaxDistance();
    XDistance := MouseDownPosition.X - MouseUpPosition.X;
    YDistance := MouseDownPosition.Y - MouseUpPosition.Y;
    Distance := Round(Sqrt(Sqr(XDistance) + Sqr(YDistance)));

    With ClickedChecker^.Parameters.Velocity Do
    Begin
        If Distance > MaxDistance Then
        Begin
            RatioCoefficient := MaxDistance / Distance;
            X := XDistance * RatioCoefficient;
            Y := YDistance * RatioCoefficient;
        End
        Else
        Begin
            X := XDistance;
            Y := YDistance;
        End;
    End;
End;

Procedure StartMoving();
Begin
    CalculateClickedCheckerVelocity();
    IsMoving := True;
    GameForm.MovingTimer.Enabled := True;
End;

Procedure StopMoving();
Begin
    ClickedChecker := Nil;
    IsMoving := False;
    GameForm.MovingTimer.Enabled := False;
End;


Function IsPositionInChecker(Const Checker: PChecker; Const Position: TPosition) : Boolean;
Begin
    Result := (Checker^.Parameters.Team = TurnTeam) And
              (Abs(Checker^.Parameters.Position.X - Position.X) <= CheckerRadius) And
              (Abs(Checker^.Parameters.Position.Y - Position.Y) <= CheckerRadius);
End;

Function FindCheckerByPosition(Const Position: TPosition) : PChecker;
Var
    CurrChecker: PChecker;
Begin
    CurrChecker := CheckerList.Head;
    While (CurrChecker <> Nil) And Not IsPositionInChecker(CurrChecker, Position) Do
        CurrChecker := CurrChecker^.Next;
    Result := CurrChecker;
End;

Procedure CheckerMouseDown(Const ClickPosition: TPosition);
Begin
    ClickedChecker := FindCheckerByPosition(ClickPosition);

    If Not IsMoving And (ClickedChecker <> Nil) Then
        MouseDownPosition := ClickedChecker^.Parameters.Position;
End;

Procedure CheckerMouseUp(Const ClickPosition: TPosition);
Begin
    If Not IsMoving And (ClickedChecker <> Nil) Then
    Begin
        MouseUpPosition := ClickPosition;
        StartMoving();
    End;
End;


Procedure CalculateCheckersParametrs();
Var
    CurrChecker: PChecker;
Begin
    CurrChecker := CheckerList.Head;
    While CurrChecker <> Nil Do
    Begin
        With CurrChecker^.Parameters Do
        Begin
            If Abs(Velocity.X) > 1 Then
            Begin
                Position.X := Position.X + Round(Velocity.X * GameForm.MovingTimer.Interval) Div DistanceIncrement;
                Velocity.X := Velocity.X * Deceleration;
            End
            Else
                Velocity.X := 0;
            If Abs(Velocity.Y) > 1 Then
            Begin
                Position.Y := Position.Y + Round(Velocity.Y * GameForm.MovingTimer.Interval) Div DistanceIncrement;
                Velocity.Y := Velocity.Y * Deceleration;
            End
            Else
                Velocity.Y := 0;
        End;
        CurrChecker := CurrChecker^.Next;
    End;
End;

Function CheckCollision(Const Checker1, Checker2: PChecker) : Boolean;
Var
    XDistance, YDistance, Distance: Integer;
Begin
    XDistance := Abs(Checker1^.Parameters.Position.X - Checker2^.Parameters.Position.X);
    YDistance := Abs(Checker1^.Parameters.Position.Y - Checker2^.Parameters.Position.Y);
    Distance := Round(Sqrt(Sqr(XDistance) + Sqr(YDistance)));
    Result := Distance <= CheckerRadius * 2;
End;

Procedure CalculateCollisionSpeed(Const Checker1, Checker2: PChecker);
Var
    XSpeed1, YSpeed1, XSpeed2, YSpeed2, PXSpeed1, PYSpeed1, PXSpeed2, PYSpeed2, Angle: Real;
Begin
    XSpeed1 := Checker1^.Parameters.Velocity.X;
    YSpeed1 := Checker1^.Parameters.Velocity.Y;
    XSpeed2 := Checker2^.Parameters.Velocity.X;
    YSpeed2 := Checker2^.Parameters.Velocity.Y;

    Angle := arctan2(Checker2^.Parameters.Position.Y - Checker1^.Parameters.Position.Y, Checker2^.Parameters.Position.X - Checker1^.Parameters.Position.X);
    PXSpeed1 := XSpeed1 * cos(-Angle) - YSpeed1 * sin(-Angle);
    PYSpeed1 := XSpeed1 * sin(-Angle) + YSpeed1 * cos(-Angle);
    PXSpeed2 := XSpeed2 * cos(-Angle) - YSpeed2 * sin(-Angle);
    PYSpeed2 := XSpeed2 * sin(-Angle) + YSpeed2 * cos(-Angle);

    Checker1^.Parameters.Velocity.X := (PXSpeed2 * cos(Angle) - PYSpeed1 * sin(Angle)) * Deceleration;
    Checker1^.Parameters.Velocity.Y := (PXSpeed2 * sin(Angle) + PYSpeed1 * cos(Angle)) * Deceleration;
    Checker2^.Parameters.Velocity.X := (PXSpeed1 * cos(Angle) - PYSpeed2 * sin(Angle)) * Deceleration;
    Checker2^.Parameters.Velocity.Y := (PXSpeed1 * sin(Angle) + PYSpeed2 * cos(Angle)) * Deceleration;
End;

Procedure CalculateCollision();
Var
    CurrChecker1, CurrChecker2: PChecker;
Begin
    CurrChecker1 := CheckerList.Head;
    While CurrChecker1 <> Nil Do
    Begin
        CurrChecker2 := CurrChecker1^.Next;
        While CurrChecker2 <> Nil Do
        Begin
            If CheckCollision(CurrChecker1, CurrChecker2) Then
                CalculateCollisionSpeed(CurrChecker1, CurrChecker2);
            CurrChecker2 := CurrChecker2^.Next;
        End;
        CurrChecker1 := CurrChecker1^.Next;
    End;
End;

Procedure CalculateOverlappingPosition(Const Checker1, Checker2: PChecker);
Var
    XDistance, YDistance, Distance, Overlapping: Integer;
    Angle: Real;
Begin
    XDistance := Checker1^.Parameters.Position.X - Checker2^.Parameters.Position.X;
    YDistance := Checker1^.Parameters.Position.Y - Checker2^.Parameters.Position.Y;
    Distance := Round(Sqrt(Sqr(XDistance) + Sqr(YDistance)));

    Overlapping := (CheckerRadius * 2 - Distance) Div 2;
    Angle := arctan2(Abs(YDistance), Abs(XDistance));

    If XDistance > 0 Then
    Begin
        Checker1^.Parameters.Position.X := Checker1^.Parameters.Position.X + Round(Overlapping * Cos(Angle));
        Checker2^.Parameters.Position.X := Checker2^.Parameters.Position.X - Round(Overlapping * Cos(Angle));
    End
    Else
    BEgin
        Checker1^.Parameters.Position.X := Checker1^.Parameters.Position.X - Round(Overlapping * Cos(Angle));
        Checker2^.Parameters.Position.X := Checker2^.Parameters.Position.X + Round(Overlapping * Cos(Angle));
    End;
    If YDistance > 0 Then
    Begin
        Checker1^.Parameters.Position.Y := Checker1^.Parameters.Position.Y + Round(Overlapping * Sin(Angle));
        Checker2^.Parameters.Position.Y := Checker2^.Parameters.Position.Y - Round(Overlapping * Sin(Angle));
    End
    Else
    BEgin
        Checker1^.Parameters.Position.Y := Checker1^.Parameters.Position.Y - Round(Overlapping * Sin(Angle));
        Checker2^.Parameters.Position.Y := Checker2^.Parameters.Position.Y + Round(Overlapping * Sin(Angle));
    End;
End;

Procedure CalculateOverlapping();
Var
    CurrChecker1, CurrChecker2: PChecker;
Begin
    CurrChecker1 := CheckerList.Head;
    While CurrChecker1 <> Nil Do
    Begin
        CurrChecker2 := CurrChecker1^.Next;
        While CurrChecker2 <> Nil Do
        Begin
            If CheckCollision(CurrChecker1, CurrChecker2) Then
                CalculateOverlappingPosition(CurrChecker1, CurrChecker2);
            CurrChecker2 := CurrChecker2^.Next;
        End;
        CurrChecker1 := CurrChecker1^.Next;
    End;
End;


Procedure DeleteCheckers();
Var
    CurrChecker: PChecker;
Begin
    CurrChecker := CheckerList.Head;
    While CurrChecker <> Nil Do
    Begin
        With CurrChecker.Parameters Do
            If (Position.X < BorderSize) Or (Position.X > BoardSize - BorderSize) Or (Position.Y < BorderSize) Or (Position.Y > BoardSize - BorderSize) Then
                CheckerList.DeleteChecker(CurrChecker.Parameters);
        CurrChecker := CurrChecker^.Next;
    End;
End;


Function AreCheckersStopped(): Boolean;
Var
    CurrentChecker: PChecker;
    AreStopped: Boolean;
Begin
    CurrentChecker := CheckerList.Head;
    AreStopped := True;
    While (CurrentChecker <> Nil) And AreStopped Do
    Begin
        With CurrentChecker.Parameters.Velocity Do
            AreStopped := (Abs(X) < 1) And (Abs(Y) < 1);
        CurrentChecker := CurrentChecker^.Next;
    End;
    Result := AreStopped;
End;

End.
