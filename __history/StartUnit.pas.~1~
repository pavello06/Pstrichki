unit StartUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, Vcl.XPMan, Vcl.Buttons, PlayUnit, RuleUnit, SettingsUnit;

type
  TStartForm = class(TForm)
    BackgroundImage: TImage;
    TitleLabel: TLabel;
    PlayButton: TButton;
    RuleButton: TButton;
    SettingsButton: TButton;
    DevelopersButton: TButton;

    procedure StartFormResize(Sender: TObject; var NewWidth, NewHeight: Integer; var Resize: Boolean);

    procedure ButtonMouseEnter(Sender: TObject);
    procedure ButtonMouseLeave(Sender: TObject);

    procedure PlayButtonClick(Sender: TObject);
    procedure RuleButtonClick(Sender: TObject);
    procedure SettingsButtonClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

Var
  StartForm: TStartForm;

Implementation

{$R *.dfm}

Procedure TStartForm.StartFormResize(Sender: TObject; Var NewWidth, NewHeight: Integer; Var Resize: Boolean);
Var
    MaxClientWidth, MaxClientHeight, MinClientWidth, MinClientHeight: Integer;
    TransformCoof: Real;
    WidthButton, HeightButton, FontSizeButton, LeftButton: Integer;
Begin
    MaxClientWidth := Screen.WorkAreaRect.Width;
    MaxClientHeight := Screen.WorkAreaRect.Height;
    MinClientWidth := MaxClientWidth Div 2;
    MinClientHeight := MaxClientHeight Div 2;

    If NewWidth < MinClientWidth Then
        NewWidth := MinClientWidth;
    If NewHeight < MinClientHeight Then
        NewHeight := MinClientHeight;

    If NewWidth = Width Then
        NewWidth := NewHeight * MaxClientWidth Div MaxClientHeight
    Else
        NewHeight := NewWidth * MaxClientHeight Div MaxClientWidth;

    TransformCoof := ClientWidth / MaxClientWidth;

    TitleLabel.Font.Size := Trunc(100 * TransformCoof);
    TitleLabel.Left := (ClientWidth - TitleLabel.Width) Div 2;
    TitleLabel.Top := Trunc(55 * TransformCoof);

    WidthButton := Trunc(600 * TransformCoof);
    HeightButton := Trunc(90 * TransformCoof);
    FontSizeButton := Trunc(35 * TransformCoof);
    LeftButton := (ClientWidth - WidthButton) Div 2;

    PlayButton.Width := WidthButton;
    PlayButton.Height := HeightButton;
    PlayButton.Font.Size := FontSizeButton;
    PlayButton.Left := LeftButton;
    PlayButton.Top := TitleLabel.Top + TitleLabel.Height + Trunc(100 * TransformCoof);

    RuleButton.Width := WidthButton;
    RuleButton.Height := HeightButton;
    RuleButton.Font.Size := FontSizeButton;
    RuleButton.Left := LeftButton;
    RuleButton.Top := PlayButton.Top + PlayButton.Height + Trunc(30 * TransformCoof);

    SettingsButton.Width := WidthButton;
    SettingsButton.Height := HeightButton;
    SettingsButton.Font.Size := FontSizeButton;
    SettingsButton.Left := LeftButton;
    SettingsButton.Top := RuleButton.Top + RuleButton.Height + Trunc(30 * TransformCoof);

    DevelopersButton.Width := WidthButton;
    DevelopersButton.Height := HeightButton;
    DevelopersButton.Font.Size := FontSizeButton;
    DevelopersButton.Left := LeftButton;
    DevelopersButton.Top := SettingsButton.Top + SettingsButton.Height + Trunc(30 * TransformCoof);
End;


procedure TStartForm.ButtonMouseEnter(Sender: TObject);
Var
    Button: TButton;
begin
    Button := TButton(Sender);
    Button.Font.Size := Button.Font.Size + 1;
    Button.Font.Style := [fsBold, fsItalic, fsUnderline];
end;

procedure TStartForm.ButtonMouseLeave(Sender: TObject);
Var
    Button: TButton;
begin
    Button := TButton(Sender);
    Button.Font.Size := Button.Font.Size - 1;
    Button.Font.Style := [fsBold, fsItalic];
end;


Procedure NewFormCreate(NewForm: TForm);
Begin
    NewForm.Icon := StartForm.Icon;
    If StartForm.WindowState = wsMaximized Then
        NewForm.WindowState := wsMaximized;
    NewForm.Width := StartForm.Width;
    NewForm.Height := StartForm.Height;
    NewForm.ShowModal;
    NewForm.Free;
End;

procedure TStartForm.PlayButtonClick(Sender: TObject);
Begin
    PlayForm := TPlayForm.Create(Self);
    NewFormCreate(PlayForm);
End;

procedure TStartForm.RuleButtonClick(Sender: TObject);
Begin
    RuleForm := TRuleForm.Create(Self);
    NewFormCreate(RuleForm);
End;

procedure TStartForm.SettingsButtonClick(Sender: TObject);
Begin
    SettingsForm := TSettingsForm.Create(Self);
    NewFormCreate(SettingsForm);
End;

End.
