unit dao.Endereco;

interface

Uses
  model.Endereco,
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
  FireDAC.Comp.Client;

type
  TEnderecoDao = class
    private
      procedure AjustaTamanhoCampos(pQry: TFDquery);
    public
      function RetornaTodos: TFDQuery;
      function BuscaPeloId(const pId: Integer): TFDquery;
      function BuscaEndereco(const pEndereco: TEnderecoModel): TFDquery;
      function Editar(pEndereco: TEnderecoModel): boolean;
      function Incluir(pEndereco: TEnderecoModel): boolean;
      function VerificaExistencia(const pEndereco: TEnderecoModel): Integer;
      function Deletar(const pId: Integer): Boolean;
  end;

implementation

Uses
  System.Classes,
  System.SysUtils,
  Data.DB,
  control.Conexao,
  dao.Sequencia,
  control.Utils;

{ TEnderecoDao }

Const
  SQL_GERAL = ' SELECT e.ID, e.CEP, e.LOGRADOURO, e.Bairro, e.COMPLEMENTO, e.LOCALIDADE, e.UF'+
              ' FROM ENDERECO e ';

  WHERE_ID = ' WHERE e.Id = :Id';

  WHERE_CEP = ' WHERE e.CEP = :Cep';

  SQL_INSERT = ' INSERT INTO ENDERECO (ID, CEP, LOGRADOURO, BAIRRO, COMPLEMENTO, LOCALIDADE, UF)'+
               ' VALUES ( :Id, :Cep, :LOGRADOURO, :BAIRRO, :COMPLEMENTO, :LOCALIDADE, :UF);';

  SQL_UPDATE = ' UPDATE ENDERECO e SET'+
               ' e.CEP = :Cep,'+
               ' e.LOGRADOURO = :Logradouro,'+
               ' e.BAIRRO = :BAIRRO,'+
               ' e.COMPLEMENTO = :Complemento,'+
               ' e.LOCALIDADE = :Localidade,'+
               ' e.UF = :UF'+
               ' WHERE e.Id = :Id';

  SQL_REFERENCIA = ' SELECT e.ID FROM ENDERECO e ';

  SQL_DELETE = ' DELETE FROM ENDERECO e WHERE e.Id = :Id';

  TAMANHO_MAXIMO_COLUNA_STRING = 250;

procedure TEnderecoDao.AjustaTamanhoCampos(pQry: TFDquery);
var
  vCont: Integer;
begin
  for vCont := 0 to pQry.FieldCount - 1 do
  begin
    if pQry.Fields[vCont].DataType in [ftString, ftWideString] then
    begin
      pQry.Fields[vCont].Size := TAMANHO_MAXIMO_COLUNA_STRING;
    end;
  end;
end;

function TEnderecoDao.RetornaTodos: TFDQuery;
Var
  qry: TFDquery;
begin
  qry:= DmConexao.CriaQuery;
  qry.SQL.Text := SQL_GERAL;
  qry.FieldDefs.Update;
  qry.Open;
  qry.FetchAll;
  result := qry;
end;

function TEnderecoDao.BuscaPeloId(const pId: Integer): TFDQuery;
Var
  qry: TFDquery;
begin
  qry:= DmConexao.CriaQuery;
  AjustaTamanhoCampos(qry);
  qry.Open(SQL_GERAL + WHERE_ID, [pId]);
  qry.FetchAll;
  result := qry;
end;

function TEnderecoDao.BuscaEndereco(const pEndereco: TEnderecoModel): TFDquery;
Const
  WHERE_ONE = ' 1=1';
Var
  qry: TFDquery;
begin
  qry:= DmConexao.CriaQuery;
  qry.SQL.Text := SQL_GERAL + WHERE_ONE;

  if (pEndereco.Cep <> '') then
  begin
    qry.Sql.Add(' And e.Cep = :Cep');
    qry.ParambyName('Cep').AsString := pEndereco.cep;
  end;

  if (pEndereco.Logradouro <> '') then
  begin
    qry.Sql.Add(' And e.Logradouro = :Logradouro');
    qry.ParambyName('Logradouro').AsString := pEndereco.Logradouro;
  end;

  if pEndereco.Bairro <> '' then
  begin
    qry.Sql.Add(' And e.Bairro = :Bairro');
    qry.ParambyName('Bairro').AsString := pEndereco.Bairro;
  end;

  if pEndereco.Localidade <> '' then
  begin
    qry.Sql.Add(' And e.Localidade = :Localidade');
    qry.ParambyName('Localidade').AsString := pEndereco.Localidade;
  end;

  if pEndereco.UF <> '' then
  begin
    qry.Sql.Add(' And e.UF = :UF');
    qry.ParambyName('UF').AsString := pEndereco.UF;
  end;

  AjustaTamanhoCampos(qry);
  qry.Open;
  qry.FetchAll;
  result := qry;
end;

function TEnderecoDao.Editar(pEndereco: TEnderecoModel): boolean;
Var
  qry: TFDquery;
begin
  result := False;
  qry:= DmConexao.CriaQuery;
  try
    qry.Sql.Text:= SQL_UPDATE;
    qry.ParamByName('Id').AsInteger:= pEndereco.Id;
    qry.ParamByName('Cep').AsString:= pEndereco.Cep;
    qry.ParamByName('Logradouro').AsString:= pEndereco.Logradouro;
    qry.ParamByName('Complemento').AsString:= pEndereco.Complemento;
    qry.ParamByName('Bairro').AsString:= pEndereco.Bairro;
    qry.ParamByName('Localidade').AsString:= pEndereco.Localidade;
    qry.ParamByName('UF').AsString:= pEndereco.Uf;
    qry.ExecSql;
    result:= True;
  finally
    FreeAndNil(qry);
  end;
end;

function TEnderecoDao.Incluir(pEndereco: TEnderecoModel): boolean;
Var
  qry: TFDquery;
begin
  result := False;
  qry:= DmConexao.CriaQuery;
  try
    qry.Sql.Text:= SQL_INSERT;
    qry.ParamByName('Id').AsInteger:= TRegistro.Proximo('Endereco', 'Id');
    qry.ParamByName('Cep').AsString:= TUtils.ApenasNumerosString(pEndereco.Cep);
    qry.ParamByName('Logradouro').AsString:= pEndereco.Logradouro;
    qry.ParamByName('Complemento').AsString:= pEndereco.Complemento;
    qry.ParamByName('Bairro').AsString:= pEndereco.Bairro;
    qry.ParamByName('Localidade').AsString:= pEndereco.Localidade;
    qry.ParamByName('UF').AsString := pEndereco.Uf;
    qry.ExecSql;
    result:= True;
  finally
    FreeAndNil(qry);
  end;
end;

function TEnderecoDao.VerificaExistencia(const pEndereco: TEnderecoModel): Integer;
Var
  qry: TFDquery;
begin
  qry:= DmConexao.CriaQuery;
  try
    if pEndereco.Id > 0 then
    begin
      qry.Open(SQL_REFERENCIA + WHERE_ID, [pEndereco.Id]);
      result := qry.FieldByName('Id').AsInteger;
    end;

    if pEndereco.CEP <> '' then
    begin
      qry.Open(SQL_REFERENCIA + WHERE_CEP, [pEndereco.CEP]);
      result := qry.FieldByName('Id').AsInteger;
    end;

  finally
    FreeAndNil(qry);
  end;
end;

function TEnderecoDao.Deletar(const pId: Integer): Boolean;
Var
  qry: TFDquery;
begin
  result := False;
  qry:= DmConexao.CriaQuery;
  try
    qry.Sql.Text:= SQL_DELETE;
    qry.ParamByName('Id').AsInteger := pId;
    qry.ExecSQL;
    result := true;
  finally
    FreeAndNil(qry);
  end;
end;

end.
