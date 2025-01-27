Unit RuleUnit;

Interface

Uses
    Winapi.Windows,
    System.Classes,
    Vcl.Controls, Vcl.ExtCtrls, Vcl.Forms, Vcl.Graphics, Vcl.StdCtrls,
    FrontEndMenuUnit;

Type
    TRuleForm = Class(TForm)
        BackgroundImage: TImage;
        TitleLabel: TLabel;
        RuleLabel: TLabel;
        BackImage: TImage;

        Procedure CreateParams(Var Params: TCreateParams); Override;
        Function FormHelp(Command: Word; Data: NativeInt; Var CallHelp: Boolean): Boolean;

        Procedure BackImageClick(Sender: TObject);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    RuleForm: TRuleForm;

Implementation

{$R *.dfm}

Uses
    StartUnit;

Procedure TRuleForm.CreateParams(Var Params: TCreateParams);
Begin
    Inherited;
    Params.ExStyle := Params.ExStyle Or WS_EX_APPWINDOW;
End;

Function TRuleForm.FormHelp(Command: Word; Data: NativeInt; Var CallHelp: Boolean): Boolean;
Begin
    CallHelp := False;
    FormHelp := False;
End;


Procedure TRuleForm.BackImageClick(Sender: TObject);
Begin
    Close;
End;

End.
