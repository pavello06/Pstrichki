Unit CheckerListUnit;

Interface

Type
    TTeam = (Light, Dark);
    TPosition = Record
        X, Y: Integer;
    End;
    TVelocity = Record
        X, Y: Real;
    End;
    TParameters = Record
        Team: TTeam;
        Position: TPosition;
        Velocity: TVelocity;
    End;

    PChecker = ^TChecker;
    TChecker = Record
        Parameters: TParameters;
        Next: PChecker;
    End;

    TCheckerList = Record
        Head: PChecker;
        LightCount: Integer;
        DarkCount: Integer;
        Procedure Initialize();
        Function IsEqualCheckers(Const Parameters1, Parameters2: TParameters): Boolean;
        Function CreateChecker(Const Parameters: TParameters): PChecker;
        Procedure AddChecker(Const Parameters: TParameters);
        Procedure DeleteChecker(Const Parameters: TParameters);
        Procedure Clear();
    End;

Implementation

Const
    EPS = 1E-6;

Procedure TCheckerList.Initialize();
Begin
    Head := Nil;
    LightCount := 0;
    DarkCount := 0;
End;

Function TCheckerList.IsEqualCheckers(Const Parameters1, Parameters2: TParameters): Boolean;
Begin
    Result := (Parameters1.Team = Parameters2.Team) And
              (Parameters1.Position.X = Parameters2.Position.X) And
              (Parameters1.Position.Y = Parameters2.Position.Y) And
              (Abs(Parameters1.Velocity.X - Parameters2.Velocity.X) < EPS) And
              (Abs(Parameters1.Velocity.Y - Parameters2.Velocity.Y) < EPS);
End;

Function TCheckerList.CreateChecker(Const Parameters: TParameters): PChecker;
Var
    NewChecker: PChecker;
Begin
    New(NewChecker);
    NewChecker^.Parameters := Parameters;
    NewChecker^.Next := Nil;
    Result := NewChecker;
End;

Procedure TCheckerList.AddChecker(Const Parameters: TParameters);
Var
    NewChecker, CurrChecker: PChecker;
Begin
    NewChecker := CreateChecker(Parameters);
    If Head = Nil Then
        Head := NewChecker
    Else
    Begin
        CurrChecker := Head;
        While CurrChecker^.Next <> Nil Do
            CurrChecker := CurrChecker^.Next;
        CurrChecker^.Next := NewChecker;
    End;
    If NewChecker^.Parameters.Team = Light Then
        Inc(LightCount)
    Else
        Inc(DarkCount);
End;

Procedure TCheckerList.DeleteChecker(Const Parameters: TParameters);
Var
    TempChecker, CurrChecker: PChecker;
Begin
    If IsEqualCheckers(Head^.Parameters, Parameters) Then
    Begin
        TempChecker := Head;
        Head := Head^.Next;
    End
    Else
    Begin
        CurrChecker := Head;
        While Not IsEqualCheckers(CurrChecker^.Next^.Parameters, Parameters) Do
            CurrChecker := CurrChecker^.Next;
        TempChecker := CurrChecker^.Next;
        CurrChecker^.Next := CurrChecker^.Next^.Next;
    End;
    If TempChecker^.Parameters.Team = Light Then
        Dec(LightCount)
    Else
        Dec(DarkCount);
    Dispose(TempChecker);
End;

Procedure TCheckerList.Clear();
Var
    CurrChecker, TempChecker: PChecker;
Begin
    CurrChecker := Head;
    While CurrChecker <> Nil Do
    Begin
        TempChecker := CurrChecker;
        CurrChecker := CurrChecker^.Next;
        Dispose(TempChecker);
    End;
    Head := Nil;
    LightCount := 0;
    DarkCount := 0;
End;

End.
