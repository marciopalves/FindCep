unit control.Utils;

interface

type
  TUtils = class
  public
    class function ApenasNumerosString(const pTexto: String):String;
    class function JsonToXml(const pJson: string): string;
  end;

implementation

uses
  System.SysUtils, System.Classes, superobject, OmniXML, OmniXMLUtils;

{ TJsonUtils }

class function TUtils.ApenasNumerosString(const pTexto: String): String;
var
  vText : PChar;
begin
  vText := PChar(pTexto);
  Result := '';

  while (vText^ <> #0) do
  begin
    {$IFDEF UNICODE}
    if CharInSet(vText^, ['0'..'9']) then
    {$ELSE}
    if vText^ in ['0'..'9'] then
    {$ENDIF}
      Result := Result + vText^;

    Inc(vText);
  end;
end;

class function TUtils.JsonToXml(const pJson: string): string;
var
  JSONObj: ISuperObject;
  XMLDoc: IXMLDocument;
  RootNode: IXMLNode;

  procedure ConvertNode(SuperObj: ISuperObject; XMLNode: IXMLNode);
  var
    Pair: TSuperAvlEntry;
    ChildNode: IXMLNode;
    ArrayElement: ISuperObject;
    i: Integer;
  begin
    for Pair in SuperObj.AsObject do
    begin
      case Pair.Value.DataType of
        stObject:
          begin
            ChildNode := XMLNode.OwnerDocument.CreateElement(Pair.Name);
            XMLNode.ChildNodes.Add(ChildNode);
            ConvertNode(Pair.Value, ChildNode);
          end;
        stArray:
          begin
            for i := 0 to Pair.Value.AsArray.Length - 1 do
            begin
              ArrayElement := Pair.Value.AsArray[i];
              ChildNode := XMLNode.OwnerDocument.CreateElement('item'); // Ajuste conforme sua estrutura XML desejada
              XMLNode.ChildNodes.Add(ChildNode);
              ConvertNode(ArrayElement, ChildNode);
            end;
          end;
      else
        ChildNode := XMLNode.OwnerDocument.CreateElement(Pair.Name);
        ChildNode.Text := Pair.Value.AsString;
        XMLNode.ChildNodes.Add(ChildNode);
      end;
    end;
  end;

begin
  Result := '';

  try
    JSONObj := SO(pJson);
    XMLDoc := CreateXMLDoc;
    RootNode := XMLDoc.CreateElement('root');
    ConvertNode(JSONObj, RootNode);
    Result := XMLDoc.XML;
  except
    on E: Exception do
      raise Exception.Create('Erro ao converter JSON para XML: ' + E.Message);
  end;
  JSONObj := nil;
  XMLDoc := nil;
  RootNode := nil;
end;

end.

