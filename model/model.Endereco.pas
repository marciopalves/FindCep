unit model.Endereco;

interface

uses
  REST.Json.Types,
  System.JSON,
  Xml.XMLIntf,
  Xml.XMLDoc,
  control.ICepSeralization;

type

  TEnderecoModel = class(TInterfacedObject, IDataSerializer)
  private
    FId: Integer;
    FCEP: string;
    FLogradouro: string;
    FComplemento: string;
    FBairro: string;
    FLocalidade: string;
    FUF: string;

  public
    property Id: Integer read FId write FId;
    property CEP: string read FCEP write FCEP;
    property Logradouro: string read FLogradouro write FLogradouro;
    property Complemento: string read FComplemento write FComplemento;
    property Bairro: string read FBairro write FBairro;
    property Localidade: string read FLocalidade write FLocalidade;
    property UF: string read FUF write FUF;

    function ToJSONString: string;
    function FromJSONString(const AJSONString: string): TEnderecoModel;
    function ToJSON: TJSONObject;
    procedure FromJSON(pJSON: TJSONObject);
    function ToXML: Xml.XMLIntf.IXMLDocument;
    procedure FromXML(pXML: IXMLDocument);
    function ToXmlString: String;

  end;

implementation

uses
  REST.Json,
  System.SysUtils,
  System.Classes;

{ TEnderecoModel }

function TEnderecoModel.FromJSONString(const AJSONString: string): TEnderecoModel;
begin
  Result := TJson.JsonToObject<TEnderecoModel>(AJSONString);
end;

function TEnderecoModel.ToJSONString: string;
begin
  Result := TJson.ObjectToJsonString(Self, [joIgnoreEmptyStrings]);
end;

function TEnderecoModel.ToJSON: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('Cep', TJSONString.Create(FCEP));
  Result.AddPair('Logradouro', TJSONString.Create(FLogradouro));
  Result.AddPair('Complemento', TJSONString.Create(FComplemento));
  Result.AddPair('Bairro', TJSONNumber.Create(FBairro));
  Result.AddPair('Localidade', TJSONNumber.Create(FLocalidade));
  Result.AddPair('UF', TJSONNumber.Create(FUF));
end;

procedure TEnderecoModel.FromJSON(pJSON: TJSONObject);
begin
  if pJSON.TryGetValue('Cep', FCep) then
    FCep := pJSON.GetValue('Cep').Value;
  if pJSON.TryGetValue('Logradouro', FLogradouro) then
    FLogradouro := pJSON.GetValue('Logradouro').Value;
  if pJSON.TryGetValue('Complemento', FComplemento) then
    FComplemento := pJSON.GetValue('Complemento').Value;
  if pJSON.TryGetValue('Bairro', FBairro) then
    FBairro := pJSON.GetValue('Bairro').Value;
  if pJSON.TryGetValue('Localidade', FLocalidade) then
    FLocalidade := pJSON.GetValue('Localidade').Value;
  if pJSON.TryGetValue('UF', FUF) then
    FUF := pJSON.GetValue('UF').Value;
end;

function TEnderecoModel.ToXML: IXMLDocument;
var
  RootNode: IXMLNode;
begin
  Result := NewXMLDocument;
  Result.Options := [doNodeAutoCreate, doNodeAutoIndent, doAttrNull, doAutoPrefix];
  Result.Version := '1.0';
  Result.Encoding := 'UTF-8';
  RootNode := Result.AddChild('Endereco');
  RootNode.AddChild('Cep').Text := FCep;
  RootNode.AddChild('Logradouro').Text := FLogradouro;
  RootNode.AddChild('Complemento').Text := FComplemento;
  RootNode.AddChild('Bairro').Text := FBairro;
  RootNode.AddChild('Localidade').Text := FLocalidade;
  RootNode.AddChild('UF').Text := FUF;
end;

procedure TEnderecoModel.FromXML(pXML: IXMLDocument);
var
  RootNode: IXMLNode;
begin
  RootNode := pXML.DocumentElement;
  if Assigned(RootNode) then
  begin
    FCep := RootNode.ChildNodes['Cep'].Text;
    FLogradouro := RootNode.ChildNodes['Logradouro'].Text;
    FComplemento := RootNode.ChildNodes['Complemento'].Text;
    FBairro := RootNode.ChildNodes['Bairro'].Text;
    FLocalidade := RootNode.ChildNodes['Localidade'].Text;
    FUF := RootNode.ChildNodes['UF'].Text;
  end;
end;

function TEnderecoModel.ToXmlString: string;
var
   vXMLStringStream: TStringStream;
   vXMLDocument: IXMLDocument;
begin
  vXMLStringStream := TStringStream.Create;
  vXMLDocument := ToXML;
  try
    vXMLDocument.SaveToStream(vXMLStringStream);
    Result := vXMLStringStream.DataString;
  finally
    FreeAndNil(vXMLStringStream);
  end;
end;

end.
