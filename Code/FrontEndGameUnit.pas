Unit FrontEndGameUnit;

Interface

Uses
    System.Classes, System.UITypes, System.Types,
    Vcl.Forms, Vcl.Graphics,
    CheckerListUnit;

Const
    BOARD_CELLS_AMOUNT = 8;

Var
    BoardSize, BorderSize, CellSize, CheckerRadius: Integer;

Procedure CalculateSizes();

Procedure DrawBoardAndCheckers();

Procedure DrawArrow(Const StartX, StartY: Integer; EndX, EndY: Integer);

Procedure DrawPower(Const StartX, StartY, EndX, EndY: Integer);

Procedure RotateBoardAndCheckers();

Implementation

Uses
    Math,
    GameUnit, BackEndGameUnit;

Const
    BASED_CLIENT_WIDTH: Integer = 1920;
    BASED_CLIENT_HEIGHT: Integer = 1080;

    BASED_CHECKER_SIZE: Integer = 35;

    BASED_BOARD_SIZE: Integer = 800;
    BASED_BOARD_MARGIN: Integer = 50;

    BASED_TURN_FONT_SIZE: Integer = 50;
    BASED_TURN_MARGIN: Integer = 20;

    BASED_PAUSE_SIZE: Integer = 100;
    BASED_PAUSE_MARGIN: Integer = 50;

    BASED_COUNT_FONT_SIZE: Integer = 80;
    BASED_COUNT_MARGIN: Integer = 350;

    BASED_POWER_WIDTH: Integer = 30;
    BASED_POWER_HEIGHT: Integer = 250;

    BASED_ROTATE_SIZE: Integer = 100;
    BASED_ROTATE_MARGIN: Integer = 15;

    ARROW_WIDTH: Integer = 8;
    ANGLE_DEVIATION = Pi / 6;
    LINE_LENGTH = 3;
    CENTER_LENGTH = 2;


    BORDER_COLOR: TColor = $14429C;
    BOARD_LIGHT_COLOR: TColor = $A4CAEC;
    BOARD_DARK_COLOR: TColor = $0C367C;

    CHECKER_LIGHT_COLOR: TColor = $FFFFFF;
    CHECKER_DARK_COLOR: TColor = $000000;

    ARROW_COLOR: TColor = $5880B4;

Procedure CalculateGameFormSizes();
Begin
    With GameForm Do
    Begin
        Width := Screen.Width;
        Height := Screen.Height;

        Constraints.MinWidth := Width;
        Constraints.MinHeight := Height;
        Constraints.MaxWidth := Width;
        Constraints.MaxHeight := Height;
    End;
End;

Function CalculateRatioCoefficient(): Real;
Var
    RatioCoefficient: Real;
Begin
    If (GameForm.ClientWidth / GameForm.ClientHeight) < (BASED_CLIENT_WIDTH / BASED_CLIENT_HEIGHT) Then
        RatioCoefficient := GameForm.ClientWidth / BASED_CLIENT_WIDTH
    Else
        RatioCoefficient := GameForm.ClientHeight / BASED_CLIENT_HEIGHT;
    Result := RatioCoefficient;
End;

Procedure CalculateCheckerSizes(Const RatioCoefficient: Real);
Begin
    CheckerRadius := Round(BASED_CHECKER_SIZE * RatioCoefficient);
End;

Procedure CalculateBoardSizes(Const RatioCoefficient: Real);
Begin
    BoardSize := Round(BASED_BOARD_SIZE * RatioCoefficient);
    BorderSize := CheckerRadius;
    CellSize := (BoardSize - 2 * BorderSize) Div BOARD_CELLS_AMOUNT;

    With GameForm.BoardImage Do
    Begin
        Width := BoardSize;
        Height := BoardSize;
        Left := (GameForm.ClientWidth - Width) Div 2;
        Top := (GameForm.ClientHeight - Height) Div 2;
    End;
End;

Procedure CalculateTurnTeamSizes(Const RatioCoefficient: Real);
Begin
    With GameForm.TurnTeamLabel Do
    Begin
        Font.Size := Round(BASED_TURN_FONT_SIZE * RatioCoefficient);
        Left := (GameForm.ClientWidth - Width) Div 2;
        Top := Round(BASED_TURN_MARGIN * RatioCoefficient);
    End;
End;

Procedure CalculatePauseSizes(Const RatioCoefficient: Real);
Var
    PauseSize: Integer;
Begin
    PauseSize := Round(BASED_PAUSE_SIZE * RatioCoefficient);

    With GameForm.PauseImage Do
    Begin
        Width := PauseSize;
        Height := PauseSize;
        Left := Round(BASED_PAUSE_MARGIN * RatioCoefficient);
        Top := Left;
    End;
End;

Procedure CalculateCountSizes(Const RatioCoefficient: Real);
Var
    CountFontSize, CountMargin: Integer;
Begin
    CountFontSize := Round(BASED_COUNT_FONT_SIZE * RatioCoefficient);
    CountMargin := Round(BASED_COUNT_MARGIN * GameForm.ClientWidth / BASED_CLIENT_WIDTH);

    With GameForm.LightCountLabel Do
    Begin
        Font.Size := CountFontSize;
        Left := CountMargin;
        Top := (GameForm.ClientHeight - Height) Div 2;
    End;
    With GameForm.DarkCountLabel Do
    Begin
        Font.Size := CountFontSize;
        Left := GameForm.ClientWidth - CountMargin;
        Top := (GameForm.ClientHeight - Height) Div 2;
    End;
End;

Procedure CalculatePowerSizes(Const RatioCoefficient: Real);
Begin
    With GameForm.PowerImage Do
    Begin
        Width := Round(BASED_POWER_WIDTH * RatioCoefficient);
        Height := Round(BASED_POWER_HEIGHT * RatioCoefficient);
        Left := GameForm.BoardImage.Left + BoardSize + Round(BASED_BOARD_MARGIN * RatioCoefficient);
        Top := (GameForm.ClientHeight - Height) Div 2;;
    End;
End;

Procedure CalculateRotateSizes(Const RatioCoefficient: Real);
Var
    RotateSize: Integer;
Begin
    RotateSize := Round(BASED_ROTATE_SIZE * RatioCoefficient);

    With GameForm.RotateImage Do
    Begin
        Width := RotateSize;
        Height := RotateSize;
        Left := (GameForm.ClientWidth - Width) Div 2;
        Top := GameForm.BoardImage.Top + GameForm.BoardImage.Height + Round(BASED_ROTATE_MARGIN * RatioCoefficient);
    End;
End;

Procedure CalculateSizes();
Var
    RatioCoefficient: Real;
Begin
    CalculateGameFormSizes();

    RatioCoefficient := CalculateRatioCoefficient();

    CalculateCheckerSizes(RatioCoefficient);
    CalculateBoardSizes(RatioCoefficient);

    CalculateTurnTeamSizes(RatioCoefficient);
    CalculatePauseSizes(RatioCoefficient);
    CalculateCountSizes(RatioCoefficient);
    CalculatePowerSizes(RatioCoefficient);
    CalculateRotateSizes(RatioCoefficient);
End;


Procedure ChangeBoardColor();
Begin
    With GameForm.BoardImage.Canvas.Brush Do
    Begin
        If Color = BOARD_LIGHT_COLOR Then
            Color := BOARD_DARK_COLOR
        Else
            Color := BOARD_LIGHT_COLOR;
    End;
End;

Procedure DrawBoard();
Var
    Col, X, Row, Y: Integer;
Begin
    With GameForm.BoardImage.Canvas Do
    Begin
        Pen.Width := 1;
        Pen.Color := clBlack;

        Brush.Color := BORDER_COLOR;
        Rectangle(0, 0, BoardSize, BoardSize);

        Brush.Color := BOARD_LIGHT_COLOR;
        For Col := 0 To BOARD_CELLS_AMOUNT - 1 Do
        Begin
            X := Col * CellSize + BorderSize;
            For Row := 0 To BOARD_CELLS_AMOUNT - 1 Do
            Begin
                Y := Row * CellSize + BorderSize;
                Rectangle(X, Y, X + CellSize, Y + CellSize);
                ChangeBoardColor();
            End;
            ChangeBoardColor();
        End;
    End;
End;

Procedure ChangeCheckerColor(Const CurrChecker: PChecker);
Begin
    With GameForm.BoardImage.Canvas Do
    Begin
        If CurrChecker^.Parameters.Team = Light Then
        Begin
            Brush.Color := CHECKER_LIGHT_COLOR;
            Pen.Color := CHECKER_DARK_COLOR;
        End
        Else
        Begin
            Brush.Color := CHECKER_DARK_COLOR;
            Pen.Color := CHECKER_LIGHT_COLOR;
        End
    End;
End;

Procedure DrawCheckers();
Var
    CurrChecker: PChecker;
Begin
    CurrChecker := CheckerList.Head;
    While CurrChecker <> Nil Do
    Begin
        ChangeCheckerColor(CurrChecker);
        With CurrChecker^.Parameters.Position Do
            GameForm.BoardImage.Canvas.Ellipse(Trunc(X - CheckerRadius),
                                               Trunc(Y - CheckerRadius),
                                               Trunc(X + CheckerRadius),
                                               Trunc(Y + CheckerRadius));
        CurrChecker := CurrChecker^.Next;
    End;
End;

Procedure DrawBoardAndCheckers();
Begin
    DrawBoard();
    DrawCheckers();
End;


Procedure DrawArrowHead(EndX, EndY: Integer; Angle, LineWidth: Real);
Var
    Angle1, Angle2: Real;
    Arrow: Array [0 .. 3] Of TPoint;
Begin
    Angle := Pi + Angle;
    Arrow[0] := Point(EndX, EndY);
    Angle1 := Angle - ANGLE_DEVIATION;
    Angle2 := Angle + ANGLE_DEVIATION;
    Arrow[1] := Point(EndX + Round(LINE_LENGTH * LineWidth * Cos(Angle1)), EndY - Round(LINE_LENGTH * LineWidth * Sin(Angle1)));
    Arrow[2] := Point(EndX + Round(CENTER_LENGTH * LineWidth * Cos(Angle)), EndY - Round(CENTER_LENGTH * LineWidth * Sin(Angle)));
    Arrow[3] := Point(EndX + Round(LINE_LENGTH * LineWidth * Cos(Angle2)), EndY - Round(LINE_LENGTH * LineWidth * Sin(Angle2)));
    With GameForm.BoardImage.Canvas Do
    Begin
        Pen.Width := 1;
        Polygon(Arrow);
    End;
End;

Procedure DrawArrow(Const StartX, StartY: Integer; EndX, EndY: Integer);
Var
    MaxLength, Length: Integer;
    Angle: Real;
Begin
    With GameForm.BoardImage.Canvas Do
    Begin
        Brush.Color := ARROW_COLOR;
        Pen.Width := ARROW_WIDTH;
        Pen.Color := ARROW_COLOR;
        MaxLength := CalculateMaxDistance();
        Length := Round(Sqrt(Sqr(EndX - StartX) + Sqr(EndY - StartY)));
        If Length > MaxLength Then
        Begin
            EndX := (EndX - StartX) * MaxLength Div Length + StartX;
            EndY := (EndY - StartY) * MaxLength Div Length + StartY;
        End;
        EndX := 2 * StartX - EndX;
        EndY := 2 * StartY - EndY;
        Angle := Arctan2(StartY - EndY, EndX - StartX);
        MoveTo(StartX, StartY);
        LineTo(EndX - Round(2 * 10 * Cos(Angle)), EndY + Round(2 * 10 * Sin(Angle)));

        DrawArrowHead(EndX, EndY, Angle, 10);
    End;
End;


Procedure DrawPower(Const StartX, StartY, EndX, EndY: Integer);
Var
    MaxPower, Power: Integer;
Begin
    With GameForm.PowerImage.Canvas, GameForm.PowerImage Do
    Begin
        Brush.Color := BORDER_COLOR;
        Rectangle(0, 0, Width, Height);

        Brush.Color := BOARD_LIGHT_COLOR;
        MaxPower := Height - 10;
        Power := Trunc(Height * Sqrt(Sqr(StartX - EndX) + Sqr(StartY - EndY)) /
                CalculateMaxDistance());
        If Power > MaxPower Then
            Power := MaxPower;
        Rectangle(GameForm.PowerImage.Width - 5, GameForm.PowerImage.Height - 5,
            5, GameForm.PowerImage.Height - Power - 5);
    End;
End;


Procedure RotateBoardAndCheckers();
Var
    CurrChecker: PChecker;
Begin
    CurrChecker := CheckerList.Head;
    While CurrChecker <> Nil Do
    Begin
        With CurrChecker.Parameters.Position Do
        Begin
            X := BoardSize - X;
            Y := BoardSize - Y;
        End;
        CurrChecker := CurrChecker^.Next;
    End;
End;

End.
