unit fmsearchdft;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, LR_PGrid, ZConnection, ZDataset,
  Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, DBGrids, Buttons,
  customconfig,CsvDocument;

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
  private
    { private declarations }
      CCF:TCustomConfig;
      procedure FilterResults;
      procedure SaveLogData(AFileName:string);
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

procedure TFormSearchDFT.LoadConfig(TCmCfg:TCustomConfig);
begin
  CCF:=TCmCfg;
end;

procedure TFormSearchDFT.FilterResults;
var
  StrSQL:string;
begin
  StrSQL:='SELECT * FROM tdftresults ORDER BY id DESC LIMIT 10000';
  if EditSrchDFT.Text<>'' then
  begin
     StrSQL:='SELECT * FROM tdftresults WHERE OfSerie LIKE ''%'+EditSrchDFT.Text+'%''';
     if ((CheckGroupShow.Checked[0]=true) and (CheckGroupShow.Checked[1]=false)) then
     begin
        StrSQL:=StrSQL+'AND Tresult LIKE ''OK''';
     end;

     if ((CheckGroupShow.Checked[0]=false) and (CheckGroupShow.Checked[1]=true)) then
     begin
        StrSQL:=StrSQL+'AND Tresult LIKE ''NG''';
     end;

     StrSQL:=StrSQL+ ' ORDER BY OfSerie ASC';
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

end.

