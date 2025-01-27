Unit SettingsUnit;

Interface

Uses
    Winapi.Windows,
    System.Classes,
    Vcl.Controls, Vcl.ExtCtrls, Vcl.Forms, Vcl.Graphics, Vcl.Imaging.pngimage,
    Vcl.MPlayer, Vcl.StdCtrls,
    FrontEndMenuUnit;

Type
    TSettingsForm = Class(TForm)
        BackgroundImage: TImage;
        TitleLabel: TLabel;
        AudioImage: TImage;
        BackImage: TImage;

        Procedure CreateParams(Var Params: TCreateParams); Override;
        Procedure FormShow(Sender: TObject);
        Function FormHelp(Command: Word; Data: NativeInt; Var CallHelp: Boolean): Boolean;

        Procedure AudioImageClick(Sender: TObject);
        Procedure BackImageClick(Sender: TObject);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    SettingsForm: TSettingsForm;

Implementation

{$R *.dfm}

Uses
    GameUnit, StartUnit;

Procedure TSettingsForm.CreateParams(Var Params: TCreateParams);
Begin
    Inherited;
    Params.ExStyle := Params.ExStyle Or WS_EX_APPWINDOW;
End;

Procedure TSettingsForm.FormShow(Sender: TObject);
Begin
    If GameForm.BackgroundMediaPlayer.Mode = mpPlaying Then
        AudioImage.Picture.LoadFromFile('Images/AudioOn.png')
    Else
        AudioImage.Picture.LoadFromFile('Images/AudioOff.png');
End;

Function TSettingsForm.FormHelp(Command: Word; Data: NativeInt; Var CallHelp: Boolean): Boolean;
Begin
    CallHelp := False;
    FormHelp := False;
End;


Procedure TSettingsForm.AudioImageClick(Sender: TObject);
Begin
    If GameForm.BackgroundMediaPlayer.Mode = mpPlaying Then
    Begin
        AudioImage.Picture.LoadFromFile('Images/AudioOff.png');
        GameForm.BackgroundMediaPlayer.Stop;
    End
    Else
    Begin
        AudioImage.Picture.LoadFromFile('Images/AudioOn.png');
        GameForm.BackgroundMediaPlayer.Play;
    End;
End;

Procedure TSettingsForm.BackImageClick(Sender: TObject);
Begin
    Close;
End;

End.
