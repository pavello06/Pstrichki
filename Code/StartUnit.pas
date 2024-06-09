Unit StartUnit;

Interface

Uses
    Winapi.Windows,
    System.Classes,
    Vcl.Controls, Vcl.ExtCtrls, Vcl.Forms, Vcl.Graphics, Vcl.StdCtrls,
    FrontEndMenuUnit,
    SettingsUnit, RuleUnit;

Type
    TStartForm = Class(TForm)
        BackgroundImage: TImage;
        TitleLabel: TLabel;
        GameImage: TImage;
        SettingsImage: TImage;
        RuleImage: TImage;
        ExitImage: TImage;

        Procedure CreateParams(Var Params: TCreateParams); Override;
        Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
        Procedure FormKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
        Function FormHelp(Command: Word; Data: NativeInt; Var CallHelp: Boolean): Boolean;

        Procedure GameImageClick(Sender: TObject);
        Procedure RuleImageClick(Sender: TObject);
        Procedure SettingsImageClick(Sender: TObject);
        Procedure ExitImageClick(Sender: TObject);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    StartForm: TStartForm;

Implementation

{$R *.dfm}

Uses
    GameUnit;

Var
    IsClose: Boolean = True;

Procedure TStartForm.CreateParams(Var Params: TCreateParams);
Begin
    Inherited;
    Params.ExStyle := Params.ExStyle Or WS_EX_APPWINDOW;
End;

Procedure TStartForm.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Begin
    If IsClose Then
    Begin
        CanClose := False;
        GameForm.Close;
    End;

    IsClose := True;
End;

Function TStartForm.FormHelp(Command: Word; Data: NativeInt; Var CallHelp: Boolean): Boolean;
Begin
    CallHelp := False;
    FormHelp := False;
End;

Procedure CreateModalForm(CaptionText, LabelText: String; ModalWidth, ModalHeight: Integer);
Var
    ModalForm: TForm;
    ModalLabel: TLabel;
Begin
    ModalForm := TForm.Create(Nil);
    Try
        ModalForm.BorderIcons := [BiSystemMenu];
        ModalForm.BorderStyle := BsSingle;
        ModalForm.Caption := CaptionText;
        ModalForm.Height := ModalHeight;
        ModalForm.Icon := StartForm.Icon;
        ModalForm.Position := PoScreenCenter;
        ModalForm.Width := ModalWidth;
        ModalForm.OnHelp := StartForm.FormHelp;

        ModalLabel := TLabel.Create(ModalForm);
        ModalLabel.Caption := LabelText;
        ModalLabel.Font.Size := 12;
        ModalLabel.Left := (ModalForm.ClientWidth - ModalLabel.Width) Div 2;
        ModalLabel.Parent := ModalForm;
        ModalLabel.Top := (ModalForm.ClientHeight - ModalLabel.Height) Div 2;

        ModalForm.ShowModal;
    Finally
        ModalForm.Free;
    End;
End;

procedure TStartForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    If Key = VK_F1 Then
        CreateModalForm('О разработчике', 'Группа: 351005'#13#10 +
                                      'Разработчик: Галуха Павел Александрович'#13#10 +
                                      'Телеграмм: @pavello06', 500, 150);
end;

Procedure TStartForm.GameImageClick(Sender: TObject);
Begin
    StartGame();
    GameForm.Visible := True;

    IsClose := False;
    Close;
End;

Procedure TStartForm.SettingsImageClick(Sender: TObject);
Begin
    Visible := False;
    ShowSettingsForm();
    Visible := True;
End;

Procedure TStartForm.RuleImageClick(Sender: TObject);
Begin
    Visible := False;
    ShowRuleForm();
    Visible := True;
End;

Procedure TStartForm.ExitImageClick(Sender: TObject);
Begin
    GameForm.Close;
End;

End.
