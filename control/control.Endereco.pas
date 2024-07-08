unit control.Endereco;

interface

uses
  IdHTTP,
  IdSSLOpenSSL,
  System.JSON,
  Xml.XMLDoc,
  System.SysUtils,
  System.Classes,
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
  control.ICepSeralization,
  control.IViaCep,
  model.Endereco;

type
  TEnderecoControl = class(TInterfacedObject, IViaCepService)
  private
    FHttp: TIdHTTP;
    FSSLHandler: TIdSSLIOHandlerSocketOpenSSL;
    FResponseStream: TStringStream;
  public
    constructor Create;
    destructor Destroy; override;
    function GetAddress(pCEP, pFormato: String; pEdicao: Boolean = false): String;
    function Validate(const pCep: string): Boolean;
    function VerificaExistencia(const pEnderecoModel: TEnderecoModel): Integer;
    function RetornaTodos: TFDQuery;
    function BuscaEndereco(const pEnderecoModel: TEnderecoModel): TFDQuery;
    function FiltraId(const pId: Integer): TFDQuery;
    function EditarEndereco(const pEnderecoModel: TEnderecoModel ): Boolean;
    function Delete(const pId: Integer): Boolean;
  end;

implementation

uses
  REST.Json,
  IdSSL,
  dao.Endereco;

{ TEnderecoControl }

constructor TEnderecoControl.Create;
begin
  FHttp := TIdHTTP.Create(nil);
  FSSLHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  FHttp.IOHandler := FSSLHandler;
  FSSLHandler.SSLOptions.SSLVersions := [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];
  FResponseStream:= TStringStream.Create('', TEncoding.UTF8);
end;

destructor TEnderecoControl.Destroy;
begin
  FreeAndNil(FHttp);
  FreeAndNil(FSSLHandler);
  FreeAndNil(FResponseStream);
  inherited;
end;

function TEnderecoControl.GetAddress(pCEP, pFormato: String; pEdicao: Boolean = false): String;
const
  URL = 'https://viacep.com.br/ws/';
  INVALID_CEP = '{'#$A'  "erro": true'#$A'}';
var
  vUrl: String;
  vModel: TEnderecoModel;
  vDao: TEnderecoDao;
begin
  result:= EmptyStr;
  vDao := TenderecoDao.Create;
  try
    vUrl := URL + pCep +'/'+ pFormato;
    FHttp.Get(vUrl, FResponseStream);
    if(FHttp.ResponseCode = 200) and (not (FResponseStream.DataString).Equals(INVALID_CEP)) then
    begin
      vModel := TJson.JsonToObject<TEnderecoModel>(UTF8ToString(PAnsiChar(AnsiString(FResponseStream.DataString))));

      if (pEdicao)then
        vDao.Editar(vModel)
      else
        vDao.Incluir(vModel);
      Result:= FResponseStream.DataString;

    end;
  finally
    FResponseStream.Free;
  end;
end;

function TEnderecoControl.Validate(const pCep: string): Boolean;
const
  INVALID_CHARACTER = -1;
begin
  Result := True;
  if pCep.Trim.Length <> 8 then
    Exit(False);
  if StrToIntDef(pCep, INVALID_CHARACTER) = INVALID_CHARACTER then
    Exit(False);
end;

function TEnderecoControl.VerificaExistencia(const pEnderecoModel: TEnderecoModel): Integer;
Var
  dao: TEnderecoDao;
begin
  dao := TEnderecoDao.Create;
  try
    result := dao.VerificaExistencia(pEnderecoModel);
  finally
    FreeAndNil(dao);
  end;
end;

function TEnderecoControl.RetornaTodos: TFDQuery;
Var
  dao: TEnderecoDao;
begin
  dao := TEnderecoDao.Create;
  try
    result := dao.RetornaTodos();
  finally
    FreeAndNil(dao);
  end;
end;

function TEnderecoControl.BuscaEndereco(
  const pEnderecoModel: TEnderecoModel): TFDQuery;
Var
  dao: TEnderecoDao;
begin
  dao := TEnderecoDao.Create;
  try
    result := dao.BuscaEndereco(pEnderecoModel);
  finally
    FreeAndNil(dao);
  end;
end;

function TEnderecoControl.FiltraId(const pId: Integer): TFDQuery;
Var
  dao: TEnderecoDao;
begin
  dao := TEnderecoDao.Create;
  try
    result := dao.BuscaPeloId(pId);
  finally
    FreeAndNil(dao);
  end;
end;

function TEnderecoControl.EditarEndereco(
  const pEnderecoModel: TEnderecoModel): Boolean;
Var
  dao: TEnderecoDao;
begin
  result := false;
  dao := TEnderecoDao.Create;
  try
    dao.Editar(pEnderecoModel);
    result := true;
  finally
    FreeAndNil(dao);
  end;

end;

function TEnderecoControl.Delete(const pId: Integer): Boolean;
Var
  dao: TEnderecoDao;
begin
  result := false;
  dao := TEnderecoDao.Create;
  try
    dao.Deletar(pId);
    result := true;
  finally
    FreeAndNil(dao);
  end;
end;

end.
