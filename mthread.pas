unit mthread;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,Crt,Dialogs,strutils;

type

  TCustomSamplerErrors =(ERROR_SUCCESS,CONNECTION_ERROR,TIMEOUT_ERROR);

  TShowSamplerStatusEvent = procedure(StSamplerStatus:String;Status:TCustomSamplerErrors) of Object;

  TMuestreo = class(TThread)
    private
      ArchivoData1:Text;
      ArchivoData2:Text;
      ArchivoData3:Text;

      ListaValores: TStringList;
      CadenaUnion: ansistring;
      CadenaTimer:ansistring;
      PuertoSerie:TSdpoSerial;
      VarStop:boolean;
      RStatus:TCustomSamplerErrors;
      RStatusText:string;

      RChannel:integer;
      RBulk:boolean;
      RBinaryData:boolean;
      RTimer:integer;
      ROnlyCapture:boolean;
      P1,C1:real;
      P2,C2:real;
      P3,C3:real;
      k:integer;//lo usamos para decidir que canal

      FOnShowStatus: TShowSamplerStatusEvent;
      procedure GetData;
      procedure Find_Device_ACK;
      procedure ShowStatus;
    protected
      procedure Execute; override;
    public
      procedure ActivatePort;
      procedure DeactivatePort;
      procedure InitializeValueOptions(Delimiter:PChar;PX1:real;CX1:real;PX2:real;CX2:real
                ;PX3:real;CX3:real);
      procedure AsignSampleFilenames(FL1:string;FL2:string;FL3:string);
      procedure CerrarArchivos;
      procedure ConfigurePort(PortName:string;BaudRate:TBaudRate;
                DataBits:TDataBits;StopBits:TStopBits;Parity:TParity);

      property Channel:integer read RChannel write RChannel;
      property Bulk:boolean read RBulk write RBulk;
      property BinaryData:boolean read RBinaryData write RBinaryData;
      property Timer:integer read RTimer write RTimer;
      property OnlyCapture:boolean read ROnlyCapture write ROnlyCapture;
      property GetTimeofSampling:ansistring read CadenaTimer;

      property OnShowStatus: TShowSamplerStatusEvent read FOnShowStatus write FOnShowStatus;
      property Status:TCustomSamplerErrors read RStatus write RStatus;
      Constructor Create(CreateSuspended : boolean);
      destructor Free;
    end;

implementation

Constructor TMuestreo.Create(CreateSuspended : boolean);
begin
 ListaValores := TStringList.Create;
 PuertoSerie:=TSdpoSerial.Create(nil);
 VarStop:=false;
 RChannel:=1;
 RBulk:=true;
 RBinaryData:=false;
 ROnlyCapture:=false;
 RStatus:=ERROR_SUCCESS;
 FreeOnTerminate:=true;
 inherited Create(CreateSuspended);
end;

procedure TMuestreo.CerrarArchivos;
begin
  case RChannel of
       1:CloseFile(ArchivoData1);
       2:CloseFile(ArchivoData2);
       3:CloseFile(ArchivoData3);
       4:begin
         CloseFile(ArchivoData1);
         CloseFile(ArchivoData2);
       end;
       5:begin
         CloseFile(ArchivoData1);
         CloseFile(ArchivoData2);
         CloseFile(ArchivoData3);
       end;
  end;
end;

destructor TMuestreo.Free;
begin
  PuertoSerie.Close;
  PuertoSerie.Free;
  CerrarArchivos;
  ListaValores.Free;
  inherited;
end;

procedure TMuestreo.InitializeValueOptions(Delimiter:PChar;PX1:real;CX1:real;PX2:real;CX2:real
;PX3:real;CX3:real);
begin
  ListaValores.Delimiter := Delimiter[0];
  CadenaUnion := '';
  P1:=PX1;
  C1:=CX1;
  P2:=PX2;
  C2:=CX2;
  P3:=PX3;
  C3:=CX3;
end;

procedure TMuestreo.Execute;
var
  Result:AnsiString;
  i:integer;
  switchPrefixes:TSysCharSet;
begin
   switchPrefixes:=[' '];
   RStatusText:='Muestreando ...';
   RStatus:=ERROR_SUCCESS;
   Synchronize(@ShowStatus);
   PuertoSerie.WriteData('C');
   Delay(100);
   Result:=IntToStr(RChannel);
   for i:=1 to Length(Result) do
   begin
     PuertoSerie.WriteData(Result[i]);
     Sleep(100);
   end;
   PuertoSerie.WriteData('X');
   Delay(100);
   Result:=PuertoSerie.ReadData;
   i:=AnsiPos(':=',Result)+3;
   Result:=ExtractSubstr(Result,i,switchPrefixes);
   if AnsiPos(IntToStr(RChannel),Result)=0 then
   begin
     RStatusText:='Error de canal ...';
     RStatus:=HANDSHAKE_ERROR;
   end;
   if RBulk= true then
   begin
      PuertoSerie.WriteData('B');
      Delay(100);
      Result:=PuertoSerie.ReadData;
      if strscan(PChar(Result),'B')=nil then
      begin
           RStatusText:='Error de configuración ...';
           exit;
      end;
   end
   else
   begin
      PuertoSerie.WriteData('H');
      Delay(100);
      Result:=PuertoSerie.ReadData;
      if strscan(PChar(Result),'H')=nil then
      begin
           RStatusText:='Error de configuración ...';
           exit;
      end;
      //-------------------------------------------------------
      //aca se setea el timer del circuito
      PuertoSerie.WriteData('D');
      Result:=IntToStr(RTimer);
      for i:=1 to Length(Result) do
      begin
         PuertoSerie.WriteData(Result[i]);
         Sleep(100);
      end;
      PuertoSerie.WriteData('X');
      Sleep(100);
      Result:=PuertoSerie.ReadData;
      i:=AnsiPos(':=',Result)+3;
      Result:=ExtractSubstr(Result,i,switchPrefixes);
      if AnsiPos(Result,IntToStr(RTimer))=0 then
      begin
          RStatusText:='Error de configuración ...';
          exit;
      end;
      //-------------------------------------------------------
   end;
   if RBinaryData=false then
   begin
      PuertoSerie.WriteData('A');
      Delay(100);
      Result:=PuertoSerie.ReadData;
      if strscan(PChar(Result),'A')=nil then
      begin
           RStatusText:='Error de configuración ...';
           exit;
      end;
   end
   else
   begin
      PuertoSerie.WriteData('R');
      Delay(100);
      Result:=PuertoSerie.ReadData;
      if strscan(PChar(Result),'R')=nil then
      begin
           RStatusText:='Error de configuración ...';
           exit;
      end;
   end;
   Sleep(1000);
   Result:=PuertoSerie.ReadData;
   PuertoSerie.WriteData('S');
   RStatus:=SAMPLIN_TIME;
   Delay(500);
   case RChannel of
        1:Rewrite(ArchivoData1);
        2:Rewrite(ArchivoData2);
        3:Rewrite(ArchivoData3);
        4:begin
           Rewrite(ArchivoData1);
           Rewrite(ArchivoData2);
        end;
        5:begin
           Rewrite(ArchivoData1);
           Rewrite(ArchivoData2);
           Rewrite(ArchivoData3);
        end;
   end;
   k:=1;
   GetData;
end;

procedure TMuestreo.GetData;
var
  i: integer;
begin
  while (not VarStop) do
  begin
    ListaValores.DelimitedText := CadenaUnion + PuertoSerie.ReadData;
    for i := 0 to (ListaValores.Count - 1) do
    begin
      if AnsiStrLastChar(PChar(ListaValores[i])) = ';' then
      begin
        try
          RStatusText:=(Copy(ListaValores[i], 1, Length(ListaValores[i]) - 1));
          case RChannel of
               1:begin
                  RStatusText:=FloatToStr((StrToInt(RStatusText)*P1)+C1);
                  WriteLn(ArchivoData1,RStatusText+';');
               end;
               2:begin
                 RStatusText:=FloatToStr((StrToInt(RStatusText)*P2)+C2);
                 WriteLn(ArchivoData2,RStatusText+';');
               end;
               3:begin
                 RStatusText:=FloatToStr((StrToInt(RStatusText)*P3)+C3);
                 WriteLn(ArchivoData3,RStatusText+';');
               end;
               4:begin
                      if k=1 then
                      begin
                          RStatusText:=FloatToStr((StrToInt(RStatusText)*P1)+C1);
                          WriteLn(ArchivoData1,RStatusText+';');
                          k:=2;
                      end
                      else
                      begin
                          RStatusText:=FloatToStr((StrToInt(RStatusText)*P2)+C2);
                          WriteLn(ArchivoData2,RStatusText+';');
                          k:=1;
                      end;
                 end;
               5:begin
                 case k of
                      1:begin
                         RStatusText:=FloatToStr((StrToInt(RStatusText)*P1)+C1);
                         WriteLn(ArchivoData1,RStatusText+';');
                         k:=2;
                      end;
                      2:begin
                         RStatusText:=FloatToStr((StrToInt(RStatusText)*P2)+C2);
                         WriteLn(ArchivoData2,RStatusText+';');
                         k:=3;
                      end;
                      3:begin
                         RStatusText:=FloatToStr((StrToInt(RStatusText)*P3)+C3);
                         WriteLn(ArchivoData3,RStatusText+';');
                         k:=1;
                      end;
                 end;
               end;
          end;
          if ROnlyCapture=false then
          begin
            Synchronize(@ShowStatus);
          end;
        finally
          CadenaUnion := '';
        end;
      end
      else
      begin
        CadenaUnion := ListaValores[i];
      end;
    end;
  end;
end;

procedure TMuestreo.ShowStatus;
begin
   if Assigned(FOnShowStatus) then
    begin
      FOnShowStatus(RStatusText,RStatus);
    end
end;

procedure TMuestreo.ConfigurePort(PortName:string;BaudRate:TBaudRate;
  DataBits:TDataBits;StopBits:TStopBits;Parity:TParity);
begin
   PuertoSerie.Device := PortName;
   PuertoSerie.BaudRate := BaudRate;
   PuertoSerie.DataBits := DataBits;
   PuertoSerie.StopBits := StopBits;
   PuertoSerie.Parity := Parity;
end;

procedure TMuestreo.ActivatePort;
begin
  try
  PuertoSerie.Open;
  RStatus:=ERROR_SUCCESS;
  PuertoSerie.WriteData('E');
  Delay(250);
  Find_Device_ACK;
  except
    RStatus:=PORT_NOT_AVAILABLE;
    RStatusText:='Puerto no disponible';
  end;
  Synchronize(@ShowStatus);
end;

procedure TMuestreo.DeactivatePort;
begin
  if PuertoSerie.Active then
  begin
       VarStop:=true;
       PuertoSerie.WriteData('S');
       if RBulk = true then
       begin
            Delay(1000);
       end
       else
       begin
           Delay(2*RTimer);
       end;
       PuertoSerie.Close;
       RStatus:=PORT_NOT_AVAILABLE;
       RStatusText:='Puerto no disponible';
       Synchronize(@ShowStatus);
  end;
end;

procedure TMuestreo.Find_Device_ACK;
var
  tmp: string;
begin
  if PuertoSerie.DataAvailable then
  begin
    tmp := PuertoSerie.ReadData;
    if (strscan(PChar(tmp), 'Y') <> nil) then
    begin
      RStatus:=ERROR_SUCCESS;
      RStatusText:='Se ha activado correctamente el dispositivo';
      Exit;
    end;
  end;
  RStatus:=CHANNEL_ERROR;
  RStatusText:='El dispositivo no se ha conectado correctamente';
end;

procedure TMuestreo.AsignSampleFilenames(FL1:string;FL2:string;FL3:string);
begin
   Assign(ArchivoData1,FL1);
   Assign(ArchivoData2,FL2);
   Assign(ArchivoData3,FL3);
end;

end.

