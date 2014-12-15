unit fmsearchdft;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, LR_PGrid, ZConnection, ZDataset,
  Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, DBGrids, Buttons,
  customconfig,CsvDocument,dateutils;

type

  { TFormSearchDFT }

  TFormSearchDFT = class(TForm)
    BitBtnExport: TBitBtn;
    BitBtnPrint: TBitBtn;
    BitBtnClose: TBitBtn;
    CheckGroupShow: TCheckGroup;
    ColorDialog1: TColorDialog;
    DataSourceSrchDFT: TDataSource;
    DBGridSrchDFT: TDBGrid;
    EditSrchDFT: TEdit;
    FrPrintGridSrchDFT: TFrPrintGrid;
    Label1: TLabel;
    PanelRFilter: TPanel;
    PanelButtons: TPanel;
    RadioGroupRestrict: TRadioGroup;
    SaveDialogSrchDFT: TSaveDialog;
    ZConnectionSrchDFT: TZConnection;
    ZQuerySrchDFT: TZQuery;
    procedure BitBtnCloseClick(Sender: TObject);
    procedure BitBtnExportClick(Sender: TObject);
    procedure BitBtnPrintClick(Sender: TObject);
    procedure CheckGroupShowItemClick(Sender: TObject; Index: integer);
    procedure EditSrchDFTKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure RadioGroupRestrictSelectionChanged(Sender: TObject);
  private
    { private declarations }
      CCF:TCustomConfig;
      procedure FilterResults;
      procedure SaveLogData(AFileName:string);
      function GetAllDayOfWeek:TStringList;
  public
    { public declarations }
      procedure LoadConfig(TCmCfg:TCustomConfig);
  end;

var
  FormSearchDFT: TFormSearchDFT;

implementation

{$R *.lfm}

{ TFormSearchDFT }

procedure TFormSearchDFT.BitBtnCloseClick(Sender: TObject);
begin
  ZQuerySrchDFT.Active:=false;
  ZConnectionSrchDFT.Disconnect;
  Close;
end;

procedure TFormSearchDFT.BitBtnExportClick(Sender: TObject);
begin
  if SaveDialogSrchDFT.Execute then
  begin
     SaveLogData(SaveDialogSrchDFT.FileName);
  end;
end;

procedure TFormSearchDFT.BitBtnPrintClick(Sender: TObject);
begin
  FrPrintGridSrchDFT.PreviewReport;
end;

procedure TFormSearchDFT.CheckGroupShowItemClick(Sender: TObject; Index: integer
  );
begin
  FilterResults;
end;


procedure TFormSearchDFT.EditSrchDFTKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  FilterResults;
end;

procedure TFormSearchDFT.FormShow(Sender: TObject);
begin
  ZConnectionSrchDFT.HostName:=CCF.ConfigSQl.HIP;
  ZConnectionSrchDFT.Port:=StrToInt(CCF.ConfigSQl.PConecction);
  ZConnectionSrchDFT.Protocol:=CCF.ConfigSQl.Databasetype;
  ZConnectionSrchDFT.Database:=CCF.ConfigSQl.DBname;
  ZConnectionSrchDFT.User:=CCF.ConfigSQl.User;
  ZConnectionSrchDFT.Password:=CCF.ConfigSQl.Pass;
  ZQuerySrchDFT.Connection:=ZConnectionSrchDFT;
  DataSourceSrchDFT.DataSet:=ZQuerySrchDFT;
  DBGridSrchDFT.DataSource:=DataSourceSrchDFT;
  CheckGroupShow.Checked[0]:=true;
  CheckGroupShow.Checked[1]:=true;

  FilterResults;
  EditSrchDFT.SetFocus;
end;

procedure TFormSearchDFT.RadioGroupRestrictSelectionChanged(Sender: TObject);
begin
  FilterResults;
end;

procedure TFormSearchDFT.LoadConfig(TCmCfg:TCustomConfig);
begin
  CCF:=TCmCfg;
end;

procedure TFormSearchDFT.FilterResults;
var
  StrSQL:string;
  strChCfg:string;
  i:integer;
  ListOfDay:TStringList;
begin
  if EditSrchDFT.Text <>'' then
  begin
      StrSQL:='SELECT * FROM tdftresults WHERE OfSerie LIKE ''%'+EditSrchDFT.Text+'%'' AND ';
  end
  else
  begin
      StrSQL:='SELECT * FROM tdftresults WHERE ';
  end;

  strChCfg:='';
  for i:=0 to (CheckGroupShow.Items.Count-1) do
  begin
     if CheckGroupShow.Checked[i] then
     begin
        strChCfg:=strChCfg+'1';
     end
     else
     begin
        strChCfg:=strChCfg+'0';
     end;
  end;

  case StrToInt(strChCfg) of
       0:begin
          StrSQL:=StrSQL+'Tresult LIKE ''%''';
       end;
       10:begin
           StrSQL:=StrSQL+'Tresult LIKE ''OK''';
       end;
       1:begin
           StrSQL:=StrSQL+'Tresult LIKE ''NG''';
       end;
       11:begin
           StrSQL:=StrSQL+'Tresult LIKE ''%''';
       end;
  end;

  case RadioGroupRestrict.ItemIndex of
       0:begin
           StrSQL:=StrSQL+' ORDER BY OfSerie ASC LIMIT 10000';
       end;
       1:begin
           StrSQL:=StrSQL+'AND TestDate LIKE '''+FormatDateTime('dd/mm/yyyy',date)+'''';
       end;
       2:begin
          ListOfDay:=GetAllDayOfWeek;
          StrSQL:=StrSQL+'AND ( TestDate LIKE '''+ListOfDay[1]+''' OR TestDate LIKE '''+
          ListOfDay[2]+''' OR TestDate LIKE '''+ListOfDay[3]+''' OR TestDate LIKE '''+
          ListOfDay[4]+''' OR TestDate LIKE '''+ListOfDay[5]+''' OR TestDate LIKE '''+
          ListOfDay[6]+''' OR TestDate LIKE '''+ListOfDay[7]+''' )';
       end;
  end;
  ZQuerySrchDFT.Active:=false;
  ZQuerySrchDFT.SQL.Text:=strSQL;
  ZQuerySrchDFT.Active:=true;
end;

procedure TFormSearchDFT.SaveLogData(AFileName:string);
var
  i:integer;
  Parser:TCSVDocument;
begin
  Parser:=TCSVDocument.Create;
  Parser.Clear;

  Parser.Delimiter:=';';
  Parser.IgnoreOuterWhitespace:=true;
  Parser.QuoteOuterWhitespace:=false;
  ZQuerySrchDFT.First;
  for i:=0 to (ZQuerySrchDFT.RecordCount-1)do
  begin
     Parser.Cells[0,i]:=ZQuerySrchDFT.FieldByName('Id').AsString;
     Parser.Cells[1,i]:=ZQuerySrchDFT.FieldByName('OfSerie').AsString;
     Parser.Cells[2,i]:=ZQuerySrchDFT.FieldByName('TResult').AsString;
     Parser.Cells[3,i]:=ZQuerySrchDFT.FieldByName('TestDate').AsString;
     Parser.Cells[4,i]:=ZQuerySrchDFT.FieldByName('TestHour').AsString;
     Parser.Cells[5,i]:=ZQuerySrchDFT.FieldByName('NJig').AsString;
     Parser.Cells[6,i]:=ZQuerySrchDFT.FieldByName('Line_id').AsString;
     Parser.Cells[7,i]:=ZQuerySrchDFT.FieldByName('TestTime').AsString;
     Parser.Cells[8,i]:=ZQuerySrchDFT.FieldByName('Chassis').AsString;
     ZQuerySrchDFT.Next;
  end;
  Parser.SaveToFile(AFilename);
  Parser.Free;
  ShowMessage('Finalizo el guardado de datos');
end;

function TFormSearchDFT.GetAllDayOfWeek:TStringList;
var
   Lista:TStringList;
   i:integer;
   k:integer;
   CurDayPos:integer;
begin
   Lista:=TStringList.Create;
   for i:=0 to 9 do
   begin
        Lista.Add('N');
   end;

   CurDayPos:=DayOfWeek(date);
   k:=0;
   for i:=(CurDayPos+1) to 8 do
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

end.

