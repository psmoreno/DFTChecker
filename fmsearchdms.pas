unit fmsearchDMS;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, LR_PGrid, ZConnection, ZDataset,
  Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, DBGrids, Buttons,
  customconfig,dateutils,CsvDocument;

type

  { TFormSearchDMS }

  TFormSearchDMS = class(TForm)
    BitBtnExport: TBitBtn;
    BitBtnPrint: TBitBtn;
    BitBtnClose: TBitBtn;
    DataSourceSrchDMS: TDataSource;
    DBGridSrchDMS: TDBGrid;
    EditSrchDMS: TEdit;
    FrPrintGridSrchDMS: TFrPrintGrid;
    Label1: TLabel;
    PanelRFilter: TPanel;
    PanelButtons: TPanel;
    RadioGroupRestrict: TRadioGroup;
    SaveDialogDMS: TSaveDialog;
    ZConnectionSrchDMS: TZConnection;
    ZQuerySrchDMS: TZQuery;
    procedure BitBtnCloseClick(Sender: TObject);
    procedure BitBtnExportClick(Sender: TObject);
    procedure BitBtnPrintClick(Sender: TObject);
    procedure EditSrchDMSKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure RadioGroupRestrictSelectionChanged(Sender: TObject);
  private
    { private declarations }
      CCF:TCustomConfig;
      procedure FilterResults;
      function GetAllDayOfWeek:TStringList;
      procedure SaveLogData(AFileName:string);
  public
    { public declarations }
      procedure LoadConfig(TCmCfg:TCustomConfig);
  end;

var
  FormSearchDMS: TFormSearchDMS;

implementation

{$R *.lfm}

{ TFormSearchDMS }

procedure TFormSearchDMS.BitBtnCloseClick(Sender: TObject);
begin
  ZQuerySrchDMS.Active:=false;
  ZConnectionSrchDMS.Disconnect;
  Close;
end;

procedure TFormSearchDMS.BitBtnExportClick(Sender: TObject);
begin
  if SaveDialogDMS.Execute then
  begin
     SaveLogData(SaveDialogDMS.FileName);
  end;
end;

procedure TFormSearchDMS.BitBtnPrintClick(Sender: TObject);
begin
  FrPrintGridSrchDMS.PreviewReport;
end;

procedure TFormSearchDMS.EditSrchDMSKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  FilterResults;
end;

procedure TFormSearchDMS.FormShow(Sender: TObject);
begin
  ZConnectionSrchDMS.HostName:=CCF.ConfigSQl.HIP;
  ZConnectionSrchDMS.Port:=StrToInt(CCF.ConfigSQl.PConecction);
  ZConnectionSrchDMS.Protocol:=CCF.ConfigSQl.Databasetype;
  ZConnectionSrchDMS.Database:=CCF.ConfigSQl.DBname;
  ZConnectionSrchDMS.User:=CCF.ConfigSQl.User;
  ZConnectionSrchDMS.Password:=CCF.ConfigSQl.Pass;
  ZQuerySrchDMS.Connection:=ZConnectionSrchDMS;
  DataSourceSrchDMS.DataSet:=ZQuerySrchDMS;
  DBGridSrchDMS.DataSource:=DataSourceSrchDMS;

  FilterResults;
  EditSrchDMS.SetFocus;
end;

procedure TFormSearchDMS.RadioGroupRestrictSelectionChanged(Sender: TObject);
begin
  FilterResults;
end;

procedure TFormSearchDMS.LoadConfig(TCmCfg:TCustomConfig);
begin
  CCF:=TCmCfg;
end;

procedure TFormSearchDMS.FilterResults;
var
  StrSQL:string;
  ListOfDay:TStringList;
begin
  if EditSrchDMS.Text <>'' then
  begin
      StrSQL:='SELECT * FROM tdms WHERE OfSerial LIKE ''%'+EditSrchDMS.Text+'%''';
  end
  else
  begin
      StrSQL:='SELECT * FROM tdms WHERE OfSerial LIKE ''%''';
  end;

  case RadioGroupRestrict.ItemIndex of
       0:begin
           StrSQL:=StrSQL+' ORDER BY OfSerial ASC LIMIT 10000';
       end;
       1:begin
           StrSQL:=StrSQL+'AND DMSdate LIKE '''+FormatDateTime('dd/mm/yyyy',date)+'''';
       end;
       2:begin
          ListOfDay:=GetAllDayOfWeek;
          StrSQL:=StrSQL+'AND ( DMSdate LIKE '''+ListOfDay[1]+''' OR DMSdate LIKE '''+
          ListOfDay[2]+''' OR DMSdate LIKE '''+ListOfDay[3]+''' OR DMSdate LIKE '''+
          ListOfDay[4]+''' OR DMSdate LIKE '''+ListOfDay[5]+''' OR DMSdate LIKE '''+
          ListOfDay[6]+''' OR DMSdate LIKE '''+ListOfDay[7]+''' )';
       end;
  end;
  ZQuerySrchDMS.Active:=false;
  ZQuerySrchDMS.SQL.Text:=strSQL;
  ZQuerySrchDMS.Active:=true;
end;

function TFormSearchDMS.GetAllDayOfWeek:TStringList;
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

procedure TFormSearchDMS.SaveLogData(AFileName:string);
var
  i:integer;
  Parser:TCSVDocument;
begin
  Parser:=TCSVDocument.Create;
  Parser.Clear;

  Parser.Delimiter:=';';
  Parser.IgnoreOuterWhitespace:=true;
  Parser.QuoteOuterWhitespace:=false;
  ZQuerySrchDMS.First;
  for i:=0 to (ZQuerySrchDMS.RecordCount-1)do
  begin
     Parser.Cells[0,i]:=ZQuerySrchDMS.FieldByName('Id').AsString;
     Parser.Cells[1,i]:=ZQuerySrchDMS.FieldByName('DMSdate').AsString;
     Parser.Cells[2,i]:=ZQuerySrchDMS.FieldByName('DMShour').AsString;
     Parser.Cells[3,i]:=ZQuerySrchDMS.FieldByName('OfSerial').AsString;
     Parser.Cells[4,i]:=ZQuerySrchDMS.FieldByName('ModelName').AsString;
     ZQuerySrchDMS.Next;
  end;
  Parser.SaveToFile(AFilename);
  Parser.Free;
  ShowMessage('Finalizo el guardado de datos');
end;

end.

