unit ucrypto;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,base64,Dialogs,FileUtil;

type

  Pcrypto=class(TObject)
    private
      function XOREXC(Clave:AnsiString;Cadena:AnsiString):AnsiString;
    public
      function Encriptar(Clave:AnsiString;Cadena:AnsiString):AnsiString;
      function Desencriptar(Clave:AnsiString;Cadena:AnsiString):AnsiString;
      function GetInlinePass(ExeName:AnsiString):AnsiString;
      procedure SetInlinePass(ExeName:AnsiString;Clave:AnsiString);
      procedure EncriptarLog(LogOrigen:AnsiString;LogSalida:AnsiString;Clave:AnsiString);
      procedure DesencriptarLog(LogOrigen:AnsiString;LogSalida:AnsiString;Clave:AnsiString);
      constructor Create;
      destructor Detroy;
  end;

var
  Crypto:Pcrypto;

implementation

function Pcrypto.XOREXC(Clave:AnsiString;Cadena:AnsiString):AnsiString;
var
  klen:integer;
  vlen:integer;
  k,v:integer;
  resultado:AnsiString;
begin
  k:=1;
  v:=1;
  klen:=Length(Clave);
  vlen:=Length(Cadena);
  resultado:=Cadena;
  while(v<=vlen)do
  begin
    resultado[v]:=Char(integer(Cadena[v]) xor integer(Clave[k]));
    k:=k+1;
    if k<=klen then
       k:=k
    else
       k:=1;
  v:=v+1;
  end;
  XOREXC:=resultado;
end;

function Pcrypto.Encriptar(Clave:AnsiString;Cadena:AnsiString):AnsiString;
var
  resultado:AnsiString;
  strTmp:AnsiString;
  i:integer;
begin
  resultado:='';
  strTmp:=cadena;
  i:=0;
  while (Length(strTmp)<Length(Clave))do
  begin
    i:=i+(Length(Clave)-Length(strTmp));
    strTmp:=strTmp+Copy(strTmp,0,Length(Clave)-Length(strTmp));
    resultado:='#'+IntToStr(i);
  end;
  try
     strTmp:=XOREXC(Clave,strTmp);
     strTmp:=EncodeStringBase64(strTmp);
     resultado:=strTmp+resultado;
  except
    resultado:='';
  end;
  Encriptar:=resultado;
end;

function Pcrypto.Desencriptar(Clave:AnsiString;Cadena:AnsiString):AnsiString;
var
  resultado:AnsiString;
  strTmp:AnsiString;
  Lower:boolean;
  i:integer;
begin
  try
     i:=Pos('#',Cadena);
     if i > 0 then
     begin
       strTmp:=copy(Cadena,0,i-1);
       Lower:=true;
     end
     else
     begin
       strTmp:=Cadena;
       Lower:=false;
     end;

     if Length(Cadena)>0 then
        strTmp:=DecodeStringBase64(strTmp);
     strTmp:=XOREXC(Clave,strTmp);

     if Lower then
     begin
        i:=StrToInt(Copy(Cadena,i+1,Length(Cadena)));
        resultado:=copy(strTmp,0,Length(strTmp)-i);
     end
     else
     begin
        resultado:=strTmp;
     end;

  except
     resultado:='';
  end;
  Desencriptar:=resultado;
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

function Pcrypto.GetInlinePass(ExeName:AnsiString):AnsiString;
var
  i:integer;
  buffer:array [1..100] of Byte;
  PassLen:LongInt;
  Clave:AnsiString;
begin
  if FileExists(ExeName) then
  begin
    with TFileStream.Create(ExeName, fmOpenRead) do
    try
       Seek(-8,soFromEnd);
       Read(buffer,8);
       if (buffer[1]=byte('P'))and(buffer[2]=byte('M'))and(buffer[3]=byte('A'))and(buffer[4]=byte('M')) then
       begin
          PassLen:=integer(integer(buffer[5]) shl 24);
          PassLen:=PassLen+(integer(buffer[6]) shl 16);
          PassLen:=PassLen+(integer(buffer[7]) shl 8);
          PassLen:=PassLen+(integer(buffer[8]));
          Seek(-(8+PassLen),soFromEnd);
          Read(buffer,PassLen);
          SetLength(Clave,PassLen);
          for i:=1 to PassLen do
              Clave[i]:=char(buffer[i]);
          Clave:=XOREXC(IntToStr(PassLen),Clave);
          GetInlinePass:=Clave;
       end;
    finally
       Free;
    end;
  end;
end;

procedure Pcrypto.SetInlinePass(ExeName:AnsiString;Clave:AnsiString);
var
  i:integer;
  buffer:array [1..100] of Byte;
  PassLen:longint;
begin
  if FileExists(ExeName) then
  begin
    with TFileStream.Create(ExeName, fmOpenReadWrite) do
    try
       Seek(0,soFromEnd);
       PassLen:=Length(Clave);
       Clave:=XOREXC(IntToStr(PassLen),Clave);
       for i:=1 to PassLen do
           buffer[i]:=Byte(Clave[i]);
       Write(Buffer, PassLen);
       buffer[1]:=byte('P');
       buffer[2]:=byte('M');
       buffer[3]:=byte('A');
       buffer[4]:=byte('M');
       Write(Buffer,4);
       buffer[1]:=Byte((PassLen shr 24)and $00FF);
       buffer[2]:=Byte((PassLen shr 16)and $00FF);
       buffer[3]:=Byte((PassLen shr 8)and $00FF);
       buffer[4]:=Byte(PassLen and $00FF);
       Write(Buffer,4);
    finally
       Free;
    end;
  end;
end;

constructor Pcrypto.Create;
begin
   inherited Create;
end;

destructor Pcrypto.Detroy;
begin

end;

end.

