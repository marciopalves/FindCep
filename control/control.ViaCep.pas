unit control.ViaCep;

interface

uses
  IdHTTP,
  IdSSLOpenSSL,
  System.JSON,
  Xml.XMLDoc,
  control.ICepSeralization,
  control.IViaCep,
  model.Endereco;

type
  TViaCepControl = class(TInterfacedObject, IViaCepService)
  private
    FHttpClient: TIdHTTP;
    FIdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
  public
    constructor Create;
    destructor Destroy; override;
    function GetAddress(pCEP: string; pFormato: string): TEnderecoModel;
    function Validate(const pCep: string): Boolean;
  end;

implementation

uses
  System.SysUtils,
  System.Classes,
  REST.Json;
{ TViaCepService }

constructor TViaCepControl.Create;
begin
  FHttpClient := TIdHTTP.Create(nil);
  FIdSSLIOHandlerSocketOpenSSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  FHttpClient.IOHandler := FIdSSLIOHandlerSocketOpenSSL;
  FIdSSLIOHandlerSocketOpenSSL.SSLOptions.SSLVersions := [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];
end;

destructor TViaCepControl.Destroy;
begin
  FreeAndNil(FHttpClient);
  FreeAndNil(FIdSSLIOHandlerSocketOpenSSL);
  inherited;
end;

function TViaCepControl.GetAddress(pCEP, pFormato: string): TEnderecoModel;
const
  URL = 'https://viacep.com.br/ws/';
  INVALID_CEP = '{'#$A'  "erro": true'#$A'}';
var
  vUrl: String;
  LResponse: TStringStream;
begin
  result:= nil;
  LResponse := TStringStream.Create;
  try
    vUrl := URL + pCep + '/' + pFormato;
    FHttpClient.Get(vUrl, LResponse);
    if(FHttpClient.ResponseCode = 200) and (not (LResponse.DataString).Equals(INVALID_CEP)) then
      Result := TJson.JsonToObject<TEnderecoModel>(UTF8ToString(PAnsiChar(AnsiString(LResponse.DataString))));
  finally
    LResponse.Free;
  end;
end;

function TViaCepControl.Validate(const pCep: string): Boolean;
const
  INVALID_CHARACTER = -1;
begin
  Result := True;
  if pCep.Trim.Length <> 8 then
    Exit(False);
  if StrToIntDef(pCep, INVALID_CHARACTER) = INVALID_CHARACTER then
    Exit(False);
end;

end.
