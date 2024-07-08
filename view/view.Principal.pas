unit view.Principal;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.ExtCtrls,
  Data.DB,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  Vcl.Grids,
  Vcl.DBGrids,
  model.Endereco,
  control.Conexao, FireDAC.Stan.StorageBin, Vcl.Buttons, System.Actions,
  Vcl.ActnList;

type
  TfrmPrincipal = class(TForm)
    pnlFiltro: TPanel;
    pnlBody: TPanel;
    btnPesquisar: TButton;
    pgDados: TPageControl;
    tsDados: TTabSheet;
    pnlMemo: TPanel;
    mmObjeto: TMemo;
    pnlGrid: TPanel;
    rbtnJson: TRadioButton;
    rbtnXml: TRadioButton;
    ds: TDataSource;
    dbgEnderecos: TDBGrid;
    mmTable: TFDMemTable;
    mmTableID: TIntegerField;
    mmTableCep: TStringField;
    mmTableComplemento: TStringField;
    mmTableBairro: TStringField;
    mmTableLocalidade: TStringField;
    mmTableUF: TStringField;
    tsEdits: TTabSheet;
    pnlEdits: TPanel;
    Label6: TLabel;
    edtEdicaoCep: TEdit;
    Label7: TLabel;
    edtEdicaoLogradouro: TEdit;
    Label8: TLabel;
    edtEdicaoBairro: TEdit;
    Label9: TLabel;
    edtEdicaoLocalidade: TEdit;
    Label10: TLabel;
    edtEdicaoUF: TEdit;
    pnlBotoesEdicao: TPanel;
    pnlEspacamento: TPanel;
    pnlCancelar: TPanel;
    Shape: TShape;
    btnCancelar: TSpeedButton;
    pnlEspacamentoTop: TPanel;
    pnlEspacamentoBotton: TPanel;
    pnlGravar: TPanel;
    Shape1: TShape;
    btnGravar: TSpeedButton;
    pnlEspacamentoBotoes: TPanel;
    ActionList: TActionList;
    actPesquisar: TAction;
    actEditar: TAction;
    actDeletar: TAction;
    gbFiltro: TGroupBox;
    Label1: TLabel;
    edtCep: TEdit;
    Label2: TLabel;
    edtLogradouro: TEdit;
    Label11: TLabel;
    edtComplemento: TEdit;
    edtUF: TEdit;
    Label5: TLabel;
    edtLocalidade: TEdit;
    Label4: TLabel;
    edtBairro: TEdit;
    Label3: TLabel;
    pnlFooter: TPanel;
    edtEdicaoComplemento: TEdit;
    Label12: TLabel;
    actCancelar: TAction;
    actSalvar: TAction;
    mmTableLogradouro: TStringField;
    procedure btnPesquisarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actPesquisarExecute(Sender: TObject);
    procedure dbgEnderecosDblClick(Sender: TObject);
    procedure actEditarExecute(Sender: TObject);
    procedure actCancelarExecute(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure actSalvarExecute(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure actDeletarExecute(Sender: TObject);
  private
    { Private declarations }
    procedure BuscaRegistros;
    procedure FiltrarId(const pId: Integer);
    procedure CarregarRegistroEdicao(const pId: Integer = 0);
    function PesquisarBd(const pModel: TEnderecoModel): boolean;
    function PesquisarCepApi(const pCep: String; const pEdicao: boolean = false): boolean;
    procedure HabilitarDesabilitarEdicao(const pEdicao: Boolean; const pId: Integer = 0);
    procedure LimparCampos;
  public
    { Public declarations }
  end;

Const
  MSG_SAVE = 'Registro gravado com sucesso!';
  MSG_NOT_FOUND = 'Registro não encontrado!';

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

uses
  control.Endereco,
  control.Helpers.DBGridHelper;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  dbgEnderecos.EnableSorting;
  HabilitarDesabilitarEdicao(false, 0);
  BuscaRegistros;
end;

procedure TfrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  mmTable.Close;
end;

procedure TfrmPrincipal.BuscaRegistros;
Var
  qry: TFDQuery;
  control: TEnderecoControl;
begin
  control := TEnderecoControl.Create;
  try
    qry:= nil;
    mmTable.Close;
    qry:= control.RetornaTodos;
    if Not (qry.IsEmpty) then
    begin
      mmTable.Data := qry.Data;
    end;
  finally
    FreeAndNil(Control);
    qry.Close;
  end;
end;

function TfrmPrincipal.PesquisarBd(const pModel: TEnderecoModel): boolean;
Var
  vControl: TEnderecoControl;
  vId: Integer;
  vEditar: Boolean;
  vQry: TFDQuery;
begin
  vControl:= TEnderecoControl.Create;
  vId:= 0;
  vEditar:= false;
  try
    if pModel.Cep <> '' then
    begin
      if Not vControl.Validate(pModel.CEP) then
        raise Exception.Create('Cep informado inválido!');

      vId := vControl.VerificaExistencia(pModel);
      if (vId > 0) then
      begin
        vEditar := Application.MessageBox('Já existe este cep em nossa base de dados!'+
                                          sLineBreak+
                                          'Deseja atualizar',
                                          'Atenção',
                                          mb_yesno + mb_iconquestion) = id_yes;
        if vEditar then
        begin
          HabilitarDesabilitarEdicao(true, vId);
        end
        else
        begin
          HabilitarDesabilitarEdicao(false, vId);
          FiltrarId(vId);
        end;
      end;
    end
    else
    begin
      vQry:= Nil;
      vQry:= vControl.BuscaEndereco(pModel);
      try
        mmTable.Close;
        mmTable.Data := vQry.Data;
      finally
        vQry.Close;
        FreeAndNil(vQry);
      end;
    end;
  finally
    FreeAndNil(vControl);
  end;
end;

function TfrmPrincipal.PesquisarCepApi(const pCep: String; const pEdicao:boolean=false): boolean;
Var
  vControl: TEnderecoControl;
  vEndereo: TEnderecoModel;
begin
  vControl:= TEnderecoControl.Create;
  mmObjeto.Lines.Clear;
  try
    if rbtnJson.Checked then
      mmObjeto.Lines.Text:= vControl.GetAddress(pCep, 'json', pEdicao)
    else if rbtnXml.Checked then
      mmObjeto.Lines.Text:= vControl.GetAddress(pCep, 'xml', pEdicao);
  except
    on e:exception do
      raise Exception.Create('Erro Pesquisar Cep');
  end;
end;

procedure TfrmPrincipal.actPesquisarExecute(Sender: TObject);
Var
  vModel: TEnderecoModel;
begin
  vModel := TEnderecoModel.Create;
  try
    vModel.CEP := edtCep.Text;
    vModel.Logradouro := edtLogradouro.Text;
    vModel.Complemento := edtComplemento.Text;
    vModel.Bairro := edtBairro.Text;
    vModel.Localidade := edtLocalidade.Text;
    vModel.UF := edtUF.Text;
    if not(PesquisarBd(vModel)) then
    begin
      if vModel.CEP <> '' then
        if PesquisarCepApi(vModel.CEP)then
          Application.MessageBox(PWideChar(MSG_SAVE),
                                 PWideChar('Atenção'),
                                 MB_OK);

      HabilitarDesabilitarEdicao(False, 0);
      LimparCampos;
      BuscaRegistros;
    end;

  finally
    FreeAndNil(vModel);
  end;
end;

procedure TfrmPrincipal.btnPesquisarClick(Sender: TObject);
begin
  actPesquisarExecute(self);
end;

procedure TfrmPrincipal.FiltrarId(const pId: Integer);
Var
  qry: TFDQuery;
  control: TEnderecoControl;
begin
  if (pId > 0) then
  begin
    control := TEnderecoControl.Create;
    try
      qry:= nil;
      mmTable.Close;
      qry:= control.FiltraId(pId);
      if Not (qry.IsEmpty) then
      begin
        mmTable.FieldDefs := qry.FieldDefs;
        mmTable.Data := qry.Data;
      end;
    finally
      FreeAndNil(Control);
      qry.Close;
    end;
  end;
end;

procedure TfrmPrincipal.dbgEnderecosDblClick(Sender: TObject);
begin
  actEditarExecute(self);
end;

procedure TfrmPrincipal.actEditarExecute(Sender: TObject);
begin
  HabilitarDesabilitarEdicao(true, mmTableID.AsInteger);
end;

procedure TfrmPrincipal.HabilitarDesabilitarEdicao(const pEdicao: Boolean;
  const pId: Integer = 0);
begin
  pnlFiltro.Enabled := Not pEdicao;
  pnlBotoesEdicao.Enabled := pEdicao;
  tsEdits.Enabled := pEdicao;
  tsDados.Enabled := Not pEdicao;

  if pEdicao then
  begin
    CarregarRegistroEdicao(pId);
    tsEdits.Show;
  end
  else
    tsDados.Show;
end;

procedure TfrmPrincipal.CarregarRegistroEdicao(const pId: Integer = 0);
begin
  if pId > 0 then
    FiltrarId(pId);

  edtEdicaoCep.Text := mmTableCep.Text;
  edtEdicaoLogradouro.Text := mmTableLogradouro.Text;
  edtEdicaoComplemento.Text := mmTableComplemento.Text;
  edtEdicaoBairro.Text := mmTableBairro.Text;
  edtEdicaoLocalidade.Text := mmTableLocalidade.Text;
  edtEdicaoUF.Text := mmTableUF.Text;
end;

procedure TfrmPrincipal.LimparCampos;
begin
  edtEdicaoCep.Clear;
  edtEdicaoLogradouro.Clear;
  edtEdicaoComplemento.Clear;
  edtEdicaoBairro.Clear;
  edtEdicaoUF.Clear;
  edtCep.Clear;
  edtLogradouro.Clear;
  edtComplemento.Clear;
  edtLocalidade.Clear;
  edtUF.Clear;
end;

procedure TfrmPrincipal.actCancelarExecute(Sender: TObject);
begin
  HabilitarDesabilitarEdicao(False, 0);
  LimparCampos;
  BuscaRegistros;
end;

procedure TfrmPrincipal.btnCancelarClick(Sender: TObject);
begin
  actCancelarExecute(self);
end;

procedure TfrmPrincipal.btnGravarClick(Sender: TObject);
begin
  actSalvarExecute(self);
end;

procedure TfrmPrincipal.actSalvarExecute(Sender: TObject);
Var
  vModel: TEnderecoModel;
  vControl: TEnderecoControl;
begin
  vModel := TEnderecoModel.Create;
  vControl := TEnderecoControl.Create;
  try
    vModel.Id := mmTableID.AsInteger;
    vModel.CEP:= edtEdicaoCep.Text;
    vModel.Logradouro := edtEdicaoLogradouro.Text;
    vModel.Bairro := edtEdicaoBairro.Text;
    vModel.Complemento := edtEdicaoComplemento.Text;
    vModel.Localidade := edtEdicaoLocalidade.Text;
    vModel.UF := edtEdicaoUF.Text;

    if vControl.EditarEndereco(vModel)then
      Application.MessageBox(PWideChar(MSG_SAVE), PWideChar('Atenção'), MB_OK)
    else
      Abort;

  finally
    FreeAndNil(vControl);
    FreeAndNil(vModel);
    HabilitarDesabilitarEdicao(False, 0);
    LimparCampos;
    BuscaRegistros;
  end;
end;

procedure TfrmPrincipal.actDeletarExecute(Sender: TObject);
Var
  vControl: TEnderecoControl;
begin
  if Application.MessageBox('Deseja realmente excluir este registro!',
                            'Atenção',
                            mb_yesno + mb_iconquestion) = id_yes then
  begin
    vControl.Delete(mmTableID.AsInteger);
    BuscaRegistros;
  end;
end;

end.
