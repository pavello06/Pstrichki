Unit PauseUnit;

Interface

Uses
    Winapi.Windows,
    System.Classes,
    Vcl.Controls, Vcl.ExtCtrls, Vcl.Forms, Vcl.Graphics, Vcl.StdCtrls,
    FrontEndMenuUnit,
    StartUnit;

Type
    TPauseForm = Class(TForm)
        BackgroundImage: TImage;
        TitleLabel: TLabel;
        ContinueImage: TImage;
        RestartImage: TImage;
        BackImage: TImage;

        Procedure CreateParams(Var Params: TCreateParams); Override;
        Function FormHelp(Command: Word; Data: NativeInt; Var CallHelp: Boolean): Boolean;

        Procedure ContinueImageClick(Sender: TObject);
        Procedure RestartImageClick(Sender: TObject);
        Procedure BackImageClick(Sender: TObject);

    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    PauseForm: TPauseForm;

Implementation

{$R *.dfm}

Uses
    GameUnit, BackEndGameUnit;

Procedure TPauseForm.CreateParams(Var Params: TCreateParams);
Begin
    Inherited;
    Params.ExStyle := Params.ExStyle Or WS_EX_APPWINDOW;
End;

Function TPauseForm.FormHelp(Command: Word; Data: NativeInt; Var CallHelp: Boolean): Boolean;
Begin
    CallHelp := False;
    FormHelp := False;
End;


Procedure TPauseForm.ContinueImageClick(Sender: TObject);
Begin
    Close;
End;

Procedure TPauseForm.RestartImageClick(Sender: TObject);
Begin
    ClearCheckers();
    StartGame();
    Close;
End;

Procedure TPauseForm.BackImageClick(Sender: TObject);
Begin
    ClearCheckers();
    Visible := False;
    GameForm.Visible := False;
    GameForm.Show;
    Close;
End;

End.
