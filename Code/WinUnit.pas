Unit WinUnit;

Interface

Uses
    Winapi.Windows,
    System.Classes,
    Vcl.Controls, Vcl.ExtCtrls, Vcl.Forms, Vcl.Graphics, Vcl.Imaging.GIFImg,
    Vcl.StdCtrls,
    FrontEndMenuUnit;

Type
    TWinForm = Class(TForm)
        BackgroundImage: TImage;
        TitleLabel: TLabel;
        WinImage: TImage;
        ContinueImage: TImage;

        Procedure CreateParams(Var Params: TCreateParams); Override;
        Procedure FormCreate(Sender: TObject);
        Procedure FormShow(Sender: TObject);
        Function FormHelp(Command: Word; Data: NativeInt; Var CallHelp: Boolean): Boolean;

        Procedure ContinueImageClick(Sender: TObject);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    WinForm: TWinForm;

Implementation

{$R *.dfm}

Uses
    GameUnit, BackEndGameUnit;

Procedure TWinForm.CreateParams(Var Params: TCreateParams);
Begin
    Inherited;
    Params.ExStyle := Params.ExStyle Or WS_EX_APPWINDOW;
End;

Procedure TWinForm.FormCreate(Sender: TObject);
Begin
    (WinImage.Picture.Graphic As TGIFImage).Animate := True;
End;

Procedure TWinForm.FormShow(Sender: TObject);
Begin
    If (CheckerList.LightCount = 0) And (CheckerList.DarkCount = 0) Then
    Begin
        TitleLabel.Font.Color := clGray;
        TitleLabel.Caption := '�����!';
    End
    Else If CheckerList.LightCount = 0 Then
    Begin
        TitleLabel.Font.Color := clBlack;
        TitleLabel.Caption := '������ ��������!';
    End
    Else
    Begin
        TitleLabel.Font.Color := clWhite;
        TitleLabel.Caption := '����� ��������!';
    End;

    ShowWinForm();
End;

Function TWinForm.FormHelp(Command: Word; Data: NativeInt; Var CallHelp: Boolean): Boolean;
Begin
    CallHelp := False;
    FormHelp := False;
End;


Procedure TWinForm.ContinueImageClick(Sender: TObject);
Begin
    Close;
End;

End.
