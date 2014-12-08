unit ubackups;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ZConnection, ZDataset,dateutils,customconfig;
type
  {TBackups}
   TBackups=class
     private
       { private declarations }
       TCC:TCustomConfig;
     public
       { public declarations }
       procedure LoadConfig(TCmCfg:TCustomConfig);
       procedure MakeBackup(DateFrom:TDateTime;IsOlder:string);
       constructor Create(Parent:TObject);
   end;

implementation

constructor TBackups.Create(Parent:TObject);
begin
  TCC:=TCustomConfig.Create;
end;

procedure TBackups.MakeBackup(DateFrom:TDateTime;IsOlder:string);
var
  ZConnectionBkp:TZConnection;
  ZQueryReadRecords:TZQuery;
  ZQueryBkp:TZQuery;
  i:integer;
  CurDate:TDateTime;
  DateLimit:TDateTime;
  DayConversion:integer;
begin
  ZConnectionBkp:=TZConnection.Create(nil);
  ZQueryReadRecords:=TZQuery.Create(nil);
  ZQueryBkp:=TZQuery.Create(nil);

  case IsOlder of
       'DIARIA':begin
           DayConversion:=1;
       end;
       'SEMANAL':begin
           DayConversion:=7;
       end;
       'MENSUAL':begin
           DayConversion:=30;
       end;
       'TRIMESTRAL':begin
           DayConversion:=90;
       end;
       'SEMESTRAL':begin
           DayConversion:=180;
       end;
  end;

  DateLimit:=IncDay(DateFrom,-DayConversion);

  ZConnectionBkp.HostName:=TCC.ConfigSQl.HIP;
  ZConnectionBkp.Port:=StrToInt(TCC.ConfigSQl.PConecction);
  ZConnectionBkp.Protocol:=TCC.ConfigSQl.Databasetype;
  ZConnectionBkp.Database:=TCC.ConfigSQl.DBname;
  ZConnectionBkp.User:=TCC.ConfigSQl.User;
  ZConnectionBkp.Password:=TCC.ConfigSQl.Pass;
  ZQueryReadRecords.Connection:=ZConnectionBkp;
  ZQueryBkp.Connection:=ZConnectionBkp;
  try
    ZQueryReadRecords.SQL.Text:='SELECT * FROM tdftresults';
    ZQueryBkp.SQL.Text:='SELECT * FROM bkpdftresults';
    ZQueryReadRecords.Open;
    ZQueryReadRecords.First;
    i:=0;
    while i<(ZQueryReadRecords.RecordCount-1)do
    begin
       CurDate:=StrToDate(StringReplace(ZQueryReadRecords.FieldByName('TestDate').AsString,'-','/',[rfReplaceAll]));
       if CurDate <= DateLimit then
       begin
          ZQueryBkp.Open;
          ZQueryBkp.Append;

          ZQueryBkp.FieldByName('OfSerie').AsString:=ZQueryReadRecords.FieldByName('OfSerie').AsString;
          ZQueryBkp.FieldByName('Tresult').AsString:=ZQueryReadRecords.FieldByName('Tresult').AsString;
          ZQueryBkp.FieldByName('TestDate').AsDateTime:=CurDate;
          ZQueryBkp.FieldByName('TestHour').AsString:=ZQueryReadRecords.FieldByName('TestHour').AsString;
          ZQueryBkp.FieldByName('NJig').AsInteger:=ZQueryReadRecords.FieldByName('NJig').AsInteger;
          ZQueryBkp.FieldByName('Line_id').AsInteger:=ZQueryReadRecords.FieldByName('Line_id').AsInteger;
          ZQueryBkp.FieldByName('TestTime').AsFloat:=ZQueryReadRecords.FieldByName('TestTime').AsFloat;
          ZQueryBkp.FieldByName('Chassis').AsString:=ZQueryReadRecords.FieldByName('Chassis').AsString;

          ZQueryBkp.CommitUpdates;
          ZQueryBkp.Close;
          ZQueryReadRecords.Delete;
          i:=i-1;
       end
       else
       begin
          ZQueryReadRecords.Next;
       end;
       i:=i+1;
    end;
    ZQueryReadRecords.Close;

  finally
    ZQueryReadRecords.Close;
    ZQueryBkp.Close;
    ZConnectionBkp.Disconnect;
  end;
end;

procedure TBackups.LoadConfig(TCmCfg:TCustomConfig);
begin
  TCC:=TCmCfg;
end;

end.

