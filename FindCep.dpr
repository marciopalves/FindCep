program FindCep;

uses
  Vcl.Forms,
  System.SysUtils,
  System.Classes,
  superobject,
  view.Principal in 'view\view.Principal.pas' {frmPrincipal},
  model.Endereco in 'model\model.Endereco.pas',
  control.ICepSeralization in 'control\control.ICepSeralization.pas',
  control.IViaCep in 'control\control.IViaCep.pas',
  control.Conexao in 'control\control.Conexao.pas' {DMConexao: TDataModule},
  control.Endereco in 'control\control.Endereco.pas',
  dao.Endereco in 'dao\dao.Endereco.pas',
  dao.Sequencia in 'dao\dao.Sequencia.pas',
  control.Utils in 'control\control.Utils.pas',
  Control.Helpers.DBGridHelper in 'control\Helpers\Control.Helpers.DBGridHelper.pas';

{$R *.res}

procedure InitializeFormatSettings;
begin
  FormatSettings := TFormatSettings.Create;
  FormatSettings.DecimalSeparator := '.';
end;

begin
  InitializeFormatSettings;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDMConexao, DMConexao);
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
