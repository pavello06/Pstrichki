Unit GameUnit;

Interface

Uses
    Winapi.Windows,
    System.Classes, System.SysUtils,
    Vcl.Controls, Vcl.ExtCtrls, Vcl.Forms, Vcl.Graphics, Vcl.Imaging.pngimage,
    Vcl.MPlayer, Vcl.StdCtrls,
    FrontEndGameUnit, BackEndGameUnit, CheckerListUnit,
    StartUnit, PauseUnit, WinUnit, FrontEndMenuUnit, Vcl.ExtDlgs, Vcl.Dialogs,
  Vcl.Menus;

Type
    TGameForm = Class(TForm)
        BackgroundImage: TImage;
        BoardImage: TImage;
        MovingTimer: TTimer;
        TurnTeamLabel: TLabel;
        PauseImage: TImage;
        LightCountLabel: TLabel;
        DarkCountLabel: TLabel;
        PowerImage: TImage;
        RotateImage: TImage;
        BackgroundMediaPlayer: TMediaPlayer;

        OpenTextFileDialog: TOpenTextFileDialog;
        SaveTextFileDialog: TSaveTextFileDialog;
        MainMenu: TMainMenu;
        FileMenuItem: TMenuItem;
        OpenMenuItem: TMenuItem;
        SaveMenuItem: TMenuItem;

        Procedure FormCreate(Sender: TObject);
        Procedure FormDestroy(Sender: TObject);
        Procedure FormShow(Sender: TObject);
        Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
        Function FormHelp(Command: Word; Data: NativeInt; Var CallHelp: Boolean): Boolean;

        Procedure BoardImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
        Procedure BoardImageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
        Procedure BoardImageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

        Procedure MovingTimerTimer(Sender: TObject);

        Procedure PauseImageClick(Sender: TObject);
        Procedure RotateImageClick(Sender: TObject);
        Procedure BackgroundMediaPlayerNotify(Sender: TObject);

        Procedure OpenMenuItemClick(Sender: TObject);
        Procedure SaveMenuItemClick(Sender: TObject);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    GameForm: TGameForm;
    TurnTeam: TTeam = Light;

Procedure StartGame();
Procedure FinishGame();

Implementation

{$R *.dfm}

Type
    TCheckerFile = File Of TParameters;

Var
    IsSave: Boolean = True;

Function CheckFilesExistence() : Boolean;
Begin
    Result := FileExists('Audio/Background.mp3') And
              FileExists('Images/AudioOn.png') And
              FileExists('Images/AudioOn.png');
End;


Procedure StartGame();
Begin
    CreateCheckers();
    DrawBoardAndCheckers();

    TurnTeam := Light;
    With GameForm Do
    Begin
        TurnTeamLabel.Font.Color := clWhite;
        TurnTeamLabel.Caption := '��� ������� �����';
        LightCountLabel.Caption := IntToStr(CheckerList.LightCount);
        DarkCountLabel.Caption := IntToStr(CheckerList.DarkCount);
    End;

    IsSave := True;
End;

Procedure FinishGame();
Begin
    WinForm.ShowModal;

    ClearCheckers();
    StartGame();
End;


Procedure TGameForm.FormCreate(Sender: TObject);
Begin
    If CheckFilesExistence() Then
    Begin
        GameForm.Visible := False;

        BackgroundMediaPlayer.FileName := 'Audio/Background.mp3';
        BackgroundMediaPlayer.Open;

        CheckerList.Initialize();
        CalculateSizes();
        DrawPower(0, 0, 0, 0);
    End
    Else
    Begin
        Application.MessageBox('�� ������� ����� ����, ���������� �������������� ����.', '������', MB_OK + MB_ICONERROR);
        Application.Terminate;
    End;
End;

Procedure TGameForm.FormDestroy(Sender: TObject);
Begin
    BackgroundMediaPlayer.Close;

    ClearCheckers();
End;

Procedure TGameForm.FormShow(Sender: TObject);
Begin
    IsSave := True;
    ShowStartForm();
End;

Procedure TGameForm.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Var
    Confirmation: Integer;
Begin
    If IsSave Then
    Begin
        Confirmation := Application.MessageBox('�� ������������� ������ �����?', '�����', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);
        CanClose := Confirmation = IDYES;
    End
    Else
    Begin
        Confirmation := Application.MessageBox('�� �� ��������� ����, ������ �� ��������� ����?', '�����', MB_YESNOCANCEl + MB_ICONQUESTION + MB_DEFBUTTON2);
        Case Confirmation Of
            mrYes:
            Begin
                SaveMenuItemClick(Sender);
                CanClose := IsSave;
            End;
            mrNo:
                CanClose := True;
            mrCancel:
                CanClose := False;
        End;
    End;
End;

Function TGameForm.FormHelp(Command: Word; Data: NativeInt; Var CallHelp: Boolean): Boolean;
Begin
    CallHelp := False;
    FormHelp := False;
End;


Procedure TGameForm.BoardImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
    ClickPosition: TPosition;
Begin
    If Button =TMouseButton.mbLeft Then
    Begin
        ClickPosition.X := X;
        ClickPosition.Y := Y;
        CheckerMouseDown(ClickPosition);

        DrawPower(0, 0, 0, 0);
    End;

    IsSave := False;
End;

Procedure TGameForm.BoardImageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
Begin
    If Not IsMoving And (ClickedChecker <> Nil) Then
    Begin
        DrawBoardAndCheckers();
        DrawArrow(MouseDownPosition.X, MouseDownPosition.Y, X, Y);
        DrawPower(MouseDownPosition.X, MouseDownPosition.Y, X, Y);
    End;
End;

Procedure TGameForm.BoardImageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
    ClickPosition: TPosition;
Begin
    If Button =TMouseButton.mbLeft Then
    Begin
        ClickPosition.X := X;
        ClickPosition.Y := Y;
        CheckerMouseUp(ClickPosition);

        DrawPower(0, 0, 0, 0);
    End;
End;


Procedure ChangeTurnTeam();
Begin
    If TurnTeam = Light Then
    Begin
        TurnTeam := Dark;
        GameForm.TurnTeamLabel.Caption := '��� ������� ������';
        GameForm.TurnTeamLabel.Font.Color := clBlack;
    End
    Else
    Begin
        TurnTeam := Light;
        GameForm.TurnTeamLabel.Caption := '��� ������� �����';
        GameForm.TurnTeamLabel.Font.Color := clWhite;
    End;
End;

Procedure TGameForm.MovingTimerTimer(Sender: TObject);
Begin
    CalculateCheckersParametrs();
    CalculateCollision();
    CalculateOverlapping();
    DeleteCheckers();
    DrawBoardAndCheckers();

    LightCountLabel.Caption := IntToStr(CheckerList.LightCount);
    DarkCountLabel.Caption := IntToStr(CheckerList.DarkCount);

    If AreCheckersStopped() Then
    Begin
        StopMoving();

        ChangeTurnTeam();

        If (CheckerList.LightCount = 0) Or (CheckerList.DarkCount = 0) Then
            FinishGame();
    End;
End;


Procedure TGameForm.PauseImageClick(Sender: TObject);
Begin
    ShowPauseForm();
End;

Procedure TGameForm.RotateImageClick(Sender: TObject);
Begin
    If Not IsMoving And (ClickedChecker = Nil) Then
    Begin
        RotateBoardAndCheckers();
        DrawBoardAndCheckers();
    End;
End;


Procedure TGameForm.BackgroundMediaPlayerNotify(Sender: TObject);
Begin
    If (BackgroundMediaPlayer.NotifyValue = nvSuccessful) And
       (BackgroundMediaPlayer.Position = BackgroundMediaPlayer.Length) Then
        BackgroundMediaPlayer.Play;
End;


Function ReadFileData(Var InputFile: TCheckerFile): Boolean;
Var
    IsCorrect: Boolean;
    TempParameters: TParameters;
Begin
    Reset(InputFile);
    IsCorrect := True;
    While IsCorrect And Not EOF(InputFile) Do
    Begin
        Try
            Read(InputFile, TempParameters);
        Except
            IsCorrect := False;
        End;
        If IsCorrect And Not EOF(InputFile) Then
            CheckerList.AddChecker(TempParameters);
    End;
    If IsCorrect Then
        TurnTeam := TempParameters.Team;
    CloseFile(InputFile);
    ReadFileData := IsCorrect;
End;

Procedure TGameForm.OpenMenuItemClick(Sender: TObject);
Var
    InputFile: TCheckerFile;
    IsCorrect: Boolean;
Begin
    If OpenTextFileDialog.Execute Then
    Begin
        AssignFile(InputFile, OpenTextFileDialog.FileName);
        ClearCheckers();
        IsCorrect := ReadFileData(InputFile);
        If IsCorrect Then
        Begin
            LightCountLabel.Caption := IntToStr(CheckerList.LightCount);
            DarkCountLabel.Caption := IntToStr(CheckerList.DarkCount);
            If TurnTeam = Light Then
            Begin
                TurnTeamLabel.Caption := '��� ������� �����';
                TurnTeamLabel.Font.Color := clWhite;
            End
            Else
            Begin
                TurnTeamLabel.Caption := '��� ������� ������';
                TurnTeamLabel.Font.Color := clBlack;
            End;
        End
        Else
        Begin
            ClearCheckers();
            StartGame();
            Application.MessageBox('���������� ����� ����������!', '������', MB_OK + MB_ICONERROR);
        End;
        DrawBoardAndCheckers();
    End;
End;

Procedure WriteFileData(Var OutputFile: TCheckerFile);
Var
    CurrChecker: PChecker;
    TempParameters: TParameters;
Begin
    Rewrite(OutputFile);
    CurrChecker := CheckerList.Head;
    While CurrChecker <> Nil Do
    Begin
        Write(OutputFile, CurrChecker^.Parameters);
        CurrChecker := CurrChecker^.Next;
    End;
    If TurnTeam = Light Then
        TempParameters.Team := Light
    Else
        TempParameters.Team := Dark;
    Write(OutputFile, TempParameters);
    CloseFile(OutputFile);
End;

Procedure TGameForm.SaveMenuItemClick(Sender: TObject);
Var
    OutputFile: TCheckerFile;
Begin
    If SaveTextFileDialog.Execute Then
    Begin
        AssignFile(OutputFile, SaveTextFileDialog.FileName);
        WriteFileData(OutputFile);
        IsSave := True;
    End;
end;

End.
