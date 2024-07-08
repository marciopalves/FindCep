unit control.ICepSeralization;

interface

Uses
  System.JSON,
  Xml.XMLIntf;

type
  IDataSerializer = interface
    ['{60C0B8D6-6B7E-4DE3-B456-5EAF9277BEB8}']
    function ToJSON: TJSONObject;
    procedure FromJSON(pJSON: TJSONObject);
    function ToXML: IXMLDocument;
    procedure FromXML(pXML: IXMLDocument);
  end;

  IDataStorage = interface
    ['{B2D1A5C4-3A93-4E5A-A7C2-97FB7AB2A702}']
    procedure Save(Data: TObject);
  end;

implementation

end.
