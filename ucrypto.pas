unit ucrypto;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,base64,Dialogs,FileUtil,BlowFish;

type

  Pcrypto=class(TObject)
    private
      RAutoEncrypt:boolean;
    public
      function Encriptar(Clave:AnsiString;Cadena:AnsiString):AnsiString;
      function Desencriptar(Clave:AnsiString;Cadena:AnsiString):AnsiString;
      procedure EncriptarLog(LogOrigen:AnsiString;LogSalida:AnsiString;Clave:AnsiString);
      procedure DesencriptarLog(LogOrigen:AnsiString;LogSalida:AnsiString;Clave:AnsiString);
      // if AutoEncrypt is true, then "Clave" is useless
      property AutoEncrypt:boolean read RAutoEncrypt write RAutoEncrypt;
      constructor Create;
      destructor Detroy;
  end;

var
  Crypto:Pcrypto;

implementation

function Pcrypto.Encriptar(Clave:AnsiString;Cadena:AnsiString):AnsiString;
var
  en: TBlowFishEncryptStream;
  se: TStringStream;
begin
  if RAutoEncrypt then
  begin
    Clave:=IntToStr(FileSize(ApplicationName));
  end;
  se := TStringStream.Create('');
  en := TBlowFishEncryptStream.Create(Trim(Clave),se);
    en.Write(Cadena[1],Length(Cadena));
  en.Free;
  Encriptar:=EncodeStringBase64(se.DataString);
  se.Free;
end;

function Pcrypto.Desencriptar(Clave:AnsiString;Cadena:AnsiString):AnsiString;
var
  de: TBlowFishDeCryptStream;
  sd:TStringStream;
  Resultado:string;
begin
  if RAutoEncrypt then
  begin
    Clave:=IntToStr(FileSize(ApplicationName));
  end;
  try
     sd := TStringStream.Create(DecodeStringBase64(Trim(Cadena)));
     de := TBlowFishDeCryptStream.Create(Trim(Clave),sd);
     SetLength(Resultado,sd.Size);
     de.Read(Resultado[1],sd.Size);
  except
     resultado:='';
  end;
  Desencriptar:=Trim(resultado);
end;

procedure Pcrypto.EncriptarLog(LogOrigen:AnsiString;LogSalida:AnsiString;Clave:AnsiString);
var
  Texto:TStringList;
  i:integer;
begin
  Texto:=TStringList.Create;
  Texto.LoadFromFile(LogOrigen);
  for i:=0 to (Texto.Count-1) do
  begin
    Texto[i]:=Encriptar(Clave,Texto[i]);
  end;
  Texto.SaveToFile(LogSalida);
end;

procedure Pcrypto.DesencriptarLog(LogOrigen:AnsiString;LogSalida:AnsiString;Clave:AnsiString);
var
  Texto:TStringList;
  i:integer;
begin
  Texto:=TStringList.Create;
  Texto.LoadFromFile(LogOrigen);
  for i:=0 to (Texto.Count-1) do
  begin
    Texto[i]:=Desencriptar(Clave,Texto[i]);
  end;
  Texto.SaveToFile(LogSalida);
end;

constructor Pcrypto.Create;
begin
   inherited Create;
   RAutoEncrypt:=false;
end;

destructor Pcrypto.Detroy;
begin

end;

end.

