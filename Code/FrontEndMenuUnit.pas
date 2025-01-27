Unit FrontEndMenuUnit;

Interface

Uses
    Vcl.ExtCtrls, Vcl.Forms, Vcl.Graphics, Vcl.StdCtrls;

Procedure ShowStartForm();

Procedure ShowSettingsForm();

Procedure ShowRuleForm();

Procedure ShowPauseForm();

Procedure ShowWinForm();

Implementation

Uses
    StartUnit, SettingsUnit, RuleUnit, PauseUnit, WinUnit;

Const
    BASED_CLIENT_WIDTH : Integer = 1920;
    BASED_CLIENT_HEIGHT : Integer = 1080;

    BASED_TITLE_FONT_SIZE : Integer = 120;
    BASED_TITLE_MARGIN : Integer = 40;

    BASED_BUTTON_WIDTH : Integer = 540;
    BASED_BUTTON_HEIGHT : Integer = 130;
    BASED_BUTTON_FONT_SIZE : Integer = 38;
    BASED_BUTTON_MARGIN : Integer = 35;
    BASED_BUTTON_PEN_WIDTH : Integer = 20;

    BASED_AUDIO_SIZE : Integer = 400;
    BASED_AUDIO_MARGIN : Integer = 50;

    BASED_RULE_WIDTH : Integer = 1200;
    BASED_RULE_FONT_SIZE : Integer = 25;
    BASED_RULE_MARGIN : Integer = 50;

    BASED_WIN_WIDTH : Integer = 972;
    BASED_WIN_HEIGHT : Integer = 450;
    BASED_WIN_MARGIN : Integer = 50;


    BUTTON_BORDER_COLOR : TColor = $14429C;
    BUTTON_LIGHT_COLOR : TColor = $A4CAEC;
    BUTTON_DARK_COLOR : TColor = $0C367C;

Procedure CalculateFormSizes(Const Form: TForm);
Begin
    With Form, Form.Constraints Do
    Begin
        Width := Screen.Width;
        Height := Screen.Height;

        MinWidth := Width;
        MinHeight := Height;
        MaxWidth := Width;
        MaxHeight := Height;
    End;
End;

Function CalculateRatioCoefficient(Const Form: TForm) : Real;
Var
    RatioCoefficient: Real;
Begin
    If (Form.ClientWidth / Form.ClientHeight) > (BASED_CLIENT_WIDTH / BASED_CLIENT_HEIGHT) Then
        RatioCoefficient := Form.ClientHeight / BASED_CLIENT_HEIGHT
    Else
        RatioCoefficient := Form.ClientWidth / BASED_CLIENT_WIDTH;
    Result := RatioCoefficient;
End;

Procedure CalculateTitleSizes(Const Form: TForm; TitleLabel: TLabel; Const RatioCoefficient: Real);
Begin
    With TitleLabel Do
    Begin
        Font.Size := Round(BASED_TITLE_FONT_SIZE * RatioCoefficient);
        Left := (Form.ClientWidth - Width) Div 2;
        Top := Round(BASED_TITLE_MARGIN * RatioCoefficient);
    End;
End;

Procedure CalculateButtonSizes(Const Form: TForm; Button: TImage; Const RatioCoefficient: Real; Const ButtonTop: Integer);
Begin
    With Button Do
    Begin
        Width := Round(BASED_BUTTON_WIDTH * RatioCoefficient);
        Height := Round(BASED_BUTTON_HEIGHT * RatioCoefficient);
        Left := (Form.ClientWidth - Width) Div 2;
        Top := ButtonTop;
    End;
End;

Procedure DrawButton(Button: TImage; Const RatioCoefficient: Real; Const Text: String);
Begin
    With Button.Canvas, Button Do
    Begin
        Brush.Color := BUTTON_LIGHT_COLOR;

        Pen.Width := Round(BASED_BUTTON_PEN_WIDTH * RatioCoefficient);
        Pen.Color := BUTTON_BORDER_COLOR;

        Font.Size := Round(BASED_BUTTON_FONT_SIZE * RatioCoefficient);;
        Font.Color := BUTTON_DARK_COLOR;
        Font.Style := [fsBold];

        Rectangle(0, 0, Width, Height);
        TextOut((Width - TextWidth(Text)) Div 2, (Height - TextHeight(Text)) Div 2, Text);
    End;
End;


Procedure CalculateStartFormSizes(Const RatioCoefficient: Real);
Var
    ButtonMargin, ButtonTop: Integer;
Begin
    CalculateFormSizes(StartForm);

    With StartForm Do
    Begin
        CalculateTitleSizes(StartForm, TitleLabel, RatioCoefficient);

        ButtonMargin := Round(BASED_BUTTON_MARGIN * RatioCoefficient);
        ButtonTop := TitleLabel.Top + TitleLabel.Height + Round(BASED_TITLE_MARGIN * RatioCoefficient);
        CalculateButtonSizes(StartForm, GameImage, RatioCoefficient, ButtonTop);
        ButtonTop := ButtonTop + GameImage.Height + ButtonMargin;
        CalculateButtonSizes(StartForm, SettingsImage, RatioCoefficient, ButtonTop);
        ButtonTop := ButtonTop + SettingsImage.Height + ButtonMargin;
        CalculateButtonSizes(StartForm, RuleImage, RatioCoefficient, ButtonTop);
        ButtonTop := ButtonTop + RuleImage.Height + ButtonMargin;
        CalculateButtonSizes(StartForm, ExitImage, RatioCoefficient, ButtonTop);
    End;
End;

Procedure ShowStartForm();
Var
    RatioCoefficient: Real;
Begin
    CalculateFormSizes(StartForm);

    RatioCoefficient := CalculateRatioCoefficient(StartForm);

    CalculateStartFormSizes(RatioCoefficient);

    With StartForm Do
    Begin
        DrawButton(GameImage, RatioCoefficient, '������');
        DrawButton(SettingsImage, RatioCoefficient, '���������');
        DrawButton(RuleImage, RatioCoefficient, '�������');
        DrawButton(ExitImage, RatioCoefficient, '�����');
    End;

    StartForm.ShowModal;
End;


Procedure CalculateAudioSizes(Const RatioCoefficient: Real);
Var
    AudioSize: Integer;
Begin
    AudioSize := Round(BASED_AUDIO_SIZE * RatioCoefficient);

    With SettingsForm.AudioImage Do
    Begin
        Width := AudioSize;
        Height := AudioSize;
        Left := (SettingsForm.ClientWidth - Width) Div 2;
        Top := (SettingsForm.ClientHeight - Height) Div 2;
    End;
End;

Procedure CalculateSettingsFormSizes(Const RatioCoefficient: Real);
Var
    ButtonTop: Integer;
Begin
    CalculateFormSizes(SettingsForm);

    With SettingsForm Do
    Begin
        CalculateTitleSizes(SettingsForm, TitleLabel, RatioCoefficient);

        CalculateAudioSizes(RatioCoefficient);

        ButtonTop := AudioImage.Top + AudioImage.Height + Round(BASED_AUDIO_MARGIN * RatioCoefficient);
        CalculateButtonSizes(SettingsForm, BackImage, RatioCoefficient, ButtonTop);
    End;
End;

Procedure ShowSettingsForm();
Var
    RatioCoefficient: Real;
Begin
    CalculateFormSizes(SettingsForm);

    RatioCoefficient := CalculateRatioCoefficient(SettingsForm);

    CalculateSettingsFormSizes(RatioCoefficient);

    DrawButton(SettingsForm.BackImage, RatioCoefficient, '�����');

    SettingsForm.ShowModal;
End;


Procedure CalculateRuleSizes(Const RatioCoefficient: Real);
Begin
    With RuleForm.RuleLabel Do
    Begin
        Width := Round(BASED_RULE_WIDTH * RatioCoefficient);
        Font.Size := Round(BASED_RULE_FONT_SIZE * RatioCoefficient);
        Left := (RuleForm.ClientWidth - Width) Div 2;
        Top := RuleForm.TitleLabel.Top + RuleForm.TitleLabel.Height + Round(BASED_TITLE_MARGIN * RatioCoefficient);
    End;
End;

Procedure CalculateRuleFormSizes(Const RatioCoefficient: Real);
Var
    ButtonTop: Integer;
Begin
    CalculateFormSizes(RuleForm);

    With RuleForm Do
    Begin
        CalculateTitleSizes(RuleForm, TitleLabel, RatioCoefficient);

        CalculateRuleSizes(RatioCoefficient);

        ButtonTop := RuleLabel.Top + RuleLabel.Height + Round(BASED_RULE_MARGIN * RatioCoefficient);
        CalculateButtonSizes(RuleForm, BackImage, RatioCoefficient, ButtonTop);
    End;
End;

Procedure ShowRuleForm();
Var
    RatioCoefficient: Real;
Begin
    CalculateFormSizes(RuleForm);

    RatioCoefficient := CalculateRatioCoefficient(RuleForm);

    CalculateRuleFormSizes(RatioCoefficient);

    DrawButton(RuleForm.BackImage, RatioCoefficient, '�����');

    RuleForm.ShowModal;
End;


Procedure CalculatePauseFormSizes(Const RatioCoefficient: Real);
Var
    ButtonMargin, ButtonTop: Integer;
Begin
    CalculateFormSizes(PauseForm);

    With PauseForm Do
    Begin
        CalculateTitleSizes(PauseForm, TitleLabel, RatioCoefficient);

        ButtonMargin := Round(BASED_BUTTON_MARGIN * RatioCoefficient);
        ButtonTop := TitleLabel.Top + TitleLabel.Height + Round(BASED_TITLE_MARGIN * RatioCoefficient);
        CalculateButtonSizes(PauseForm, ContinueImage, RatioCoefficient, ButtonTop);
        ButtonTop := ContinueImage.Top + ContinueImage.Height + ButtonMargin;
        CalculateButtonSizes(PauseForm, RestartImage, RatioCoefficient, ButtonTop);
        ButtonTop := RestartImage.Top + RestartImage.Height + ButtonMargin;
        CalculateButtonSizes(PauseForm, BackImage, RatioCoefficient, ButtonTop);
    End;
End;

Procedure ShowPauseForm();
Var
    RatioCoefficient: Real;
Begin
    CalculateFormSizes(PauseForm);

    RatioCoefficient := CalculateRatioCoefficient(PauseForm);

    CalculatePauseFormSizes(RatioCoefficient);

    With PauseForm Do
    Begin
        DrawButton(ContinueImage, RatioCoefficient, '����������');
        DrawButton(RestartImage, RatioCoefficient, '����� ����');
        DrawButton(BackImage, RatioCoefficient, '� ������� ����');
    End;

    PauseForm.ShowModal;
End;


Procedure CalculateWinSizes(Const RatioCoefficient: Real);
Begin
    With WinForm.WinImage Do
    Begin
        Width := Round(BASED_WIN_WIDTH * RatioCoefficient);
        Height := Round(BASED_WIN_HEIGHT * RatioCoefficient);
        Left := (WinForm.ClientWidth - Width) Div 2;
        Top := (WinForm.ClientHeight - Height) Div 2;
    End;
End;

Procedure CalculateWinFormSizes(Const RatioCoefficient: Real);
Var
    ButtonTop: Integer;
Begin
    CalculateFormSizes(WinForm);

    With WinForm Do
    Begin
        CalculateTitleSizes(WinForm, TitleLabel, RatioCoefficient);

        CalculateWinSizes(RatioCoefficient);

        ButtonTop := WinImage.Top + WinImage.Height + Round(BASED_WIN_MARGIN * RatioCoefficient);
        CalculateButtonSizes(WinForm, ContinueImage, RatioCoefficient, ButtonTop);
    End;
End;

Procedure ShowWinForm();
Var
    RatioCoefficient: Real;
Begin
    CalculateFormSizes(WinForm);

    RatioCoefficient := CalculateRatioCoefficient(WinForm);

    CalculateWinFormSizes(RatioCoefficient);

    DrawButton(WinForm.ContinueImage, RatioCoefficient, '����������');
End;

End.
