program Pstrichki;

uses
  Vcl.Forms,
  GameUnit in 'GameUnit.pas' {GameForm},
  FrontEndGameUnit in 'FrontEndGameUnit.pas',
  CheckerListUnit in 'CheckerListUnit.pas',
  BackEndGameUnit in 'BackEndGameUnit.pas',
  StartUnit in 'StartUnit.pas' {StartForm},
  FrontEndMenuUnit in 'FrontEndMenuUnit.pas',
  RuleUnit in 'RuleUnit.pas' {RuleForm},
  SettingsUnit in 'SettingsUnit.pas' {SettingsForm},
  PauseUnit in 'PauseUnit.pas' {PauseForm},
  WinUnit in 'WinUnit.pas' {WinForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TGameForm, GameForm);
  Application.CreateForm(TStartForm, StartForm);
  Application.CreateForm(TRuleForm, RuleForm);
  Application.CreateForm(TSettingsForm, SettingsForm);
  Application.CreateForm(TPauseForm, PauseForm);
  Application.CreateForm(TWinForm, WinForm);
  Application.Run;
end.
