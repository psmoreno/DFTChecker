unit fmsearchrepair;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, LR_Class, LR_PGrid, ZConnection, ZDataset,
  Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, DBGrids, Buttons,
  dateutils,customconfig,CsvDocument,fmaddinsert;
type

  { TFormSearchRepair }

  TFormSearchRepair = class(TForm)
    BitBtnGetPCB: TBitBtn;
    BitBtnRepairPCB: TBitBtn;
    BitBtnScrapPCB: TBitBtn;
    BitBtnPrint: TBitBtn;
    BitBtnExport: TBitBtn;
    BitBtnExit: TBitBtn;
    DataSourceSrchRepair: TDataSource;
    DBGridSrchRepair: TDBGrid;
    EditSrchRepair: TEdit;
    FrPrintGridSrchRepair: TFrPrintGrid;
    Label1: TLabel;
    PanelMainButtons: TPanel;
    PanelRepairButtons: TPanel;
    PanelSrchRepair: TPanel;
    RadioGroupSrchRepair: TRadioGroup;
    SaveDialogSrchRepair: TSaveDialog;
    ZConnectionSrchRepair: TZConnection;
    ZQuerySrchRepair: TZQuery;
    procedure BitBtnExitClick(Sender: TObject);
    procedure BitBtnExportClick(Sender: TObject);
    procedure BitBtnGetPCBClick(Sender: TObject);
    procedure BitBtnPrintClick(Sender: TObject);
    procedure BitBtnRepairPCBClick(Sender: TObject);
    procedure BitBtnScrapPCBClick(Sender: TObject);
    procedure EditSrchRepairKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure RadioGroupSrchRepairSelectionChanged(Sender: TObject);
  private
    { private declarations }
    CCF:TCustomConfig;
    procedure FilterResults;
    function GetAllDayOfWeek:TStringList;
    procedure SaveLogData(AFileName:string);
    procedure LocateBoard(ICase:integer);
  public
    { public declarations }
    procedure LoadConfig(TCmCfg:TCustomConfig);
  end;

var
  FormSearchRepair: TFormSearchRepair;

implementation

{$R *.lfm}

{ TFormSearchRepair }

procedure TFormSearchRepair.FormShow(Sender: TObject);
begin
  ZConnectionSrchRepair.HostName:=CCF.ConfigSQl.HIP;
  ZConnectionSrchRepair.Port:=StrToInt(CCF.ConfigSQl.PConecction);
  ZConnectionSrchRepair.Protocol:=CCF.ConfigSQl.Databasetype;
  ZConnectionSrchRepair.Database:=CCF.ConfigSQl.DBname;
  ZConnectionSrchRepair.User:=CCF.ConfigSQl.User;
  ZConnectionSrchRepair.Password:=CCF.ConfigSQl.Pass;
  ZQuerySrchRepair.Connection:=ZConnectionSrchRepair;
  DataSourceSrchRepair.DataSet:=ZQuerySrchRepair;
  DBGridSrchRepair.DataSource:=DataSourceSrchRepair;

  FilterResults;
  EditSrchRepair.SetFocus;
end;

procedure TFormSearchRepair.RadioGroupSrchRepairSelectionChanged(Sender: TObject
  );
begin
  FilterResults;
end;

procedure TFormSearchRepair.BitBtnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFormSearchRepair.BitBtnExportClick(Sender: TObject);
begin
   if SaveDialogSrchRepair.Execute then
   begin
     SaveLogData(SaveDialogSrchRepair.FileName);
   end;
end;

procedure TFormSearchRepair.BitBtnGetPCBClick(Sender: TObject);
begin
  LocateBoard(1);
end;

procedure TFormSearchRepair.BitBtnPrintClick(Sender: TObject);
begin
  FrPrintGridSrchRepair.PreviewReport;
end;

procedure TFormSearchRepair.BitBtnRepairPCBClick(Sender: TObject);
begin
  LocateBoard(2);
end;

procedure TFormSearchRepair.BitBtnScrapPCBClick(Sender: TObject);
begin
  LocateBoard(3);
end;

procedure TFormSearchRepair.EditSrchRepairKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  FilterResults;
end;

function TFormSearchRepair.GetAllDayOfWeek:TStringList;
var
   Lista:TStringList;
   i:integer;
   k:integer;
   CurDayPos:integer;
begin
   Lista:=TStringList.Create;
   for i:=0 to 8 do
   begin
        Lista.Add('N');
   end;

   CurDayPos:=DayOfWeek(date);
   k:=1;
   for i:=(CurDayPos) to 8 do
   begin
      Lista[i]:=FormatDateTime('dd/mm/yyyy',IncDay(date,k));
      k:=k+1;
   end;
   k:=0;
   for i:=(CurDayPos-1) downto 1 do
   begin
      Lista[i]:=FormatDateTime('dd/mm/yyyy',IncDay(date,-k));
      k:=k+1;
   end;

   GetAllDayOfWeek:=Lista;
end;

procedure TFormSearchRepair.FilterResults;
var
  StrSQL:string;
  ListOfDay:TStringList;
begin
  if EditSrchRepair.Text <>'' then
  begin
      StrSQL:='SELECT * FROM twrongpcb WHERE OfSerial LIKE ''%'+EditSrchRepair.Text+'%''';
  end
  else
  begin
      StrSQL:='SELECT * FROM twrongpcb WHERE OfSerial LIKE ''%''';
  end;

  case RadioGroupSrchRepair.ItemIndex of
       0:begin
           StrSQL:=StrSQL+'AND WRDate = '+FormatDateTime('dd/mm/yyyy',date);
       end;
       1:begin
           ListOfDay:=GetAllDayOfWeek;
           StrSQL:=StrSQL+'AND WRDate BETWEEN '+ListOfDay[1]+
           ' AND '+ListOfDay[7];
       end;
       2:begin
           StrSQL:=StrSQL+'AND WRDate BETWEEN '+FormatDateTime('dd/mm/yyyy',StartOfTheMonth(Today))+
           ' AND '+FormatDateTime('dd/mm/yyyy',EndOfTheMonth(Today));
       end;
       3:begin
           StrSQL:=StrSQL+' ORDER BY OfSerial ASC LIMIT 10000';
       end;
  end;
  ZQuerySrchRepair.Active:=false;
  ZQuerySrchRepair.SQL.Text:=strSQL;
  ZQuerySrchRepair.Active:=true;
end;

procedure TFormSearchRepair.LoadConfig(TCmCfg:TCustomConfig);
begin
  CCF:=TCmCfg;
end;

procedure TFormSearchRepair.SaveLogData(AFileName:string);
var
  i:integer;
  Parser:TCSVDocument;
begin
  Parser:=TCSVDocument.Create;
  Parser.Clear;

  Parser.Delimiter:=';';
  Parser.IgnoreOuterWhitespace:=true;
  Parser.QuoteOuterWhitespace:=false;
  ZQuerySrchRepair.First;
  for i:=0 to (ZQuerySrchRepair.RecordCount-1)do
  begin
     Parser.Cells[0,i]:=ZQuerySrchRepair.FieldByName('Id').AsString;
     Parser.Cells[1,i]:=ZQuerySrchRepair.FieldByName('WRDate').AsString;
     Parser.Cells[2,i]:=ZQuerySrchRepair.FieldByName('WRHour').AsString;
     Parser.Cells[3,i]:=ZQuerySrchRepair.FieldByName('OfSerial').AsString;
     Parser.Cells[4,i]:=ZQuerySrchRepair.FieldByName('ModelName').AsString;
     Parser.Cells[4,i]:=ZQuerySrchRepair.FieldByName('JIG').AsString;
     Parser.Cells[4,i]:=ZQuerySrchRepair.FieldByName('strFail').AsString;
     ZQuerySrchRepair.Next;
  end;
  Parser.SaveToFile(AFilename);
  Parser.Free;
  ShowMessage('Finalizo el guardado de datos');
end;

procedure TFormSearchRepair.LocateBoard(ICase:integer);
var
  LastStrSQL:string;
begin
  EditSrchRepair.Text:='';
  FormAddInsert.InputType:=4;
  FormAddInsert.StrValue:='';

  while FormAddInsert.ShowModal=mrOK do
  begin
      ZQuerySrchRepair.Close;
      LastStrSQL:=ZQuerySrchRepair.SQL.Text;
      ZQuerySrchRepair.SQL.Text:='SELECT * FROM twrongpcb WHERE OFSerial LIKE ''%'+
      FormAddInsert.StrValue +'%''';
      ZQuerySrchRepair.Open;
      if ZQuerySrchRepair.RecordCount = 1 then
      begin
          ZQuerySrchRepair.Edit;
          case ICase of
               1:begin
                  ZQuerySrchRepair.FieldByName('Status').AsInteger:=2;//Ingresa al reparacion
               end;
               2:begin
                  ZQuerySrchRepair.FieldByName('Status').AsInteger:=3;//Reparada
               end;
               3:begin
                  ZQuerySrchRepair.FieldByName('Status').AsInteger:=4;//Scrap
               end;
          end;
          ZQuerySrchRepair.CommitUpdates;
      end;
      ZQuerySrchRepair.Close;
      ZQuerySrchRepair.SQL.Text:=LastStrSQL;
      ZQuerySrchRepair.Open;
  end;
end;

end.

