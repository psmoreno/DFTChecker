unit ubackups;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ZConnection, ZDataset,dateutils,customconfig;
type

  TCustomSamplerErrors =(ERROR_SUCCESS,DFTRESULT_SUCCESS,DFTFAIL_SUCCESS,DMS_SUCCESS);
  TShowSamplerStatusEvent = procedure(StSamplerStatus:String;Status:TCustomSamplerErrors) of Object;

  {TBackups}
   TBackups=class(TThread)
     private
       { private declarations }
       TCC:TCustomConfig;
       RDateFrom:TDateTime;
       RIsOlder:string;
       RStatus:TCustomSamplerErrors;
       RStatusText:string;
       FOnShowStatus: TShowSamplerStatusEvent;

       ZConnectionBkp:TZConnection;
       ZQueryReadRecords:TZQuery;
       ZQueryBkp:TZQuery;
       i:integer;
       CurDate:TDateTime;
       DateLimit:TDateTime;
       DayConversion:integer;

       procedure MakeDFTResultsBackups;
       procedure MakeDFTFailBackups;
       procedure MakeDMSBakups;
       procedure ShowStatus;
     protected
       { protected declarations }
      procedure Execute; override;
     public
       { public declarations }
       procedure LoadConfig(TCmCfg:TCustomConfig);
       procedure LoadSettings(DateFrom:TDateTime;IsOlder:string);

       property OnShowStatus: TShowSamplerStatusEvent read FOnShowStatus write FOnShowStatus;
       property Status:TCustomSamplerErrors read RStatus write RStatus;

       Constructor Create(CreateSuspended : boolean);
       destructor Free;
   end;

implementation

Constructor TBackups.Create(CreateSuspended : boolean);
begin
  TCC:=TCustomConfig.Create;
  ZConnectionBkp:=TZConnection.Create(nil);
  ZQueryReadRecords:=TZQuery.Create(nil);
  ZQueryBkp:=TZQuery.Create(nil);
  FreeOnTerminate:=true;
  inherited Create(CreateSuspended);
end;

destructor TBackups.Free;
begin
  ZQueryReadRecords.Close;
  ZQueryBkp.Close;
  ZConnectionBkp.Disconnect;
  inherited;
end;

procedure TBackups.LoadConfig(TCmCfg:TCustomConfig);
begin
  TCC:=TCmCfg;
end;

procedure TBackups.LoadSettings(DateFrom:TDateTime;IsOlder:string);
begin
  RDateFrom:=DateFrom;
  RIsOlder:=IsOlder;
end;

procedure TBackups.ShowStatus;
begin
   if Assigned(FOnShowStatus) then
    begin
      FOnShowStatus(RStatusText,RStatus);
    end
end;

procedure TBackups.Execute;
begin
  RStatusText:='Comenzando con los backups';
  RStatus:=ERROR_SUCCESS;
  Synchronize(@ShowStatus);

  case RIsOlder of
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

  DateLimit:=IncDay(RDateFrom,-DayConversion);

  ZConnectionBkp.HostName:=TCC.ConfigSQl.HIP;
  ZConnectionBkp.Port:=StrToInt(TCC.ConfigSQl.PConecction);
  ZConnectionBkp.Protocol:=TCC.ConfigSQl.Databasetype;
  ZConnectionBkp.Database:=TCC.ConfigSQl.DBname;
  ZConnectionBkp.User:=TCC.ConfigSQl.User;
  ZConnectionBkp.Password:=TCC.ConfigSQl.Pass;
  ZQueryReadRecords.Connection:=ZConnectionBkp;
  ZQueryBkp.Connection:=ZConnectionBkp;

  RStatusText:='Realizando backup resultados DFT';
  RStatus:=DFTRESULT_SUCCESS;
  Synchronize(@ShowStatus);
  MakeDFTResultsBackups;

  RStatusText:='Realizando backup fallas DFT';
  RStatus:=DFTFAIL_SUCCESS;
  Synchronize(@ShowStatus);
  MakeDFTFailBackups;

  RStatusText:='Realizando backup operaciones DMS';
  RStatus:=DMS_SUCCESS;
  Synchronize(@ShowStatus);
  MakeDMSBakups;

end;

procedure TBackups.MakeDFTResultsBackups;
begin
   try
    ZQueryReadRecords.SQL.Text:='SELECT * FROM tdftresults';
    ZQueryBkp.SQL.Text:='SELECT * FROM bkpdftresults';
    ZConnectionBkp.Connect;
    ZQueryReadRecords.Open;
    ZQueryReadRecords.First;
    i:=0;
    while i<(ZQueryReadRecords.RecordCount)do
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
   finally
     ZQueryReadRecords.Close;
     ZQueryBkp.Close;
     ZConnectionBkp.Disconnect;
   end;
end;

procedure TBackups.MakeDFTFailBackups;
begin
  try
    ZQueryReadRecords.SQL.Text:='SELECT * FROM tstepfail';
    ZQueryBkp.SQL.Text:='SELECT * FROM bkpstepfail';
    ZConnectionBkp.Connect;
    ZQueryReadRecords.Open;
    ZQueryReadRecords.First;
    i:=0;
    while i<(ZQueryReadRecords.RecordCount)do
    begin
       CurDate:=StrToDate(StringReplace(ZQueryReadRecords.FieldByName('Fdate').AsString,'-','/',[rfReplaceAll]));
       if CurDate <= DateLimit then
       begin
          ZQueryBkp.Open;
          ZQueryBkp.Append;

          ZQueryBkp.FieldByName('Fdate').AsDateTime:=CurDate;
          ZQueryBkp.FieldByName('Fhour').AsString:=ZQueryReadRecords.FieldByName('Fhour').AsString;
          ZQueryBkp.FieldByName('OfSerie').AsString:=ZQueryReadRecords.FieldByName('OfSerie').AsString;
          ZQueryBkp.FieldByName('Step_no').AsInteger:=ZQueryReadRecords.FieldByName('Step_no').AsInteger;
          ZQueryBkp.FieldByName('Step_name').AsString:=ZQueryReadRecords.FieldByName('Step_name').AsString;
          ZQueryBkp.FieldByName('Tresult').AsString:=ZQueryReadRecords.FieldByName('Tresult').AsString;
          ZQueryBkp.FieldByName('NJig').AsInteger:=ZQueryReadRecords.FieldByName('NJig').AsInteger;

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
  finally
    ZQueryReadRecords.Close;
    ZQueryBkp.Close;
    ZConnectionBkp.Disconnect;
  end;
end;

procedure TBackups.MakeDMSBakups;
begin
  try
    ZQueryReadRecords.SQL.Text:='SELECT * FROM tdms';
    ZQueryBkp.SQL.Text:='SELECT * FROM bkpdms';
    ZQueryReadRecords.Open;
    ZQueryReadRecords.First;
    i:=0;
    while i<(ZQueryReadRecords.RecordCount)do
    begin
       CurDate:=StrToDate(StringReplace(ZQueryReadRecords.FieldByName('DMSdate').AsString,'-','/',[rfReplaceAll]));
       if CurDate <= DateLimit then
       begin
          ZQueryBkp.Open;
          ZQueryBkp.Append;

          ZQueryBkp.FieldByName('DMSdate').AsDateTime:=CurDate;
          ZQueryBkp.FieldByName('DMShour').AsString:=ZQueryReadRecords.FieldByName('DMShour').AsString;
          ZQueryBkp.FieldByName('OfSerial').AsString:=ZQueryReadRecords.FieldByName('OfSerial').AsString;
          ZQueryBkp.FieldByName('ModelName').AsString:=ZQueryReadRecords.FieldByName('ModelName').AsString;

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
  finally
    ZQueryReadRecords.Close;
    ZQueryBkp.Close;
    ZConnectionBkp.Disconnect;
  end;
end;

end.

