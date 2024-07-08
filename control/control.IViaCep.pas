unit control.IViaCep;

interface

type
  IViaCepService = interface
    ['{A55CBB5E-5D9A-4BA7-8B11-8BFD2B8C6E5F}']
    function GetAddress(pCep: string; pFormato: String; pEdicao: Boolean = false): String;
    function Validate(const pCep: string): Boolean;
  end;

implementation

end.
