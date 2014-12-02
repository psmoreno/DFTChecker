unit fmsearchdft;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, RLReport, LR_PGrid, ZConnection, ZDataset,
  Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, DBGrids, Buttons,
  customconfig;

type

  { TFormSearchDFT }

  TFormSearchDFT = class(TForm)
    BitBtnExport: TBitBtn;
    BitBtnPrint: TBitBtn;
    BitBtnClose: TBitBtn;
    CheckGroupShow: TCheckGroup;
    DataSourceSrchDFT: TDataSource;
    DBGridSrchDFT: TDBGrid;
    EditSrchDFT: TEdit;
    FrPrintGridSrchDFT: TFrPrintGrid;
    Label1: TLabel;
    PanelRFilter: TPanel;
    PanelButtons: TPanel;
    ZConnectionSrchDFT: TZConnection;
    ZQuerySrchDFT: TZQuery;
    procedure BitBtnCloseClick(Sender: TObject);
    procedure BitBtnPrintClick(Sender: TObject);
    procedure EditSrchDFTKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
      CCF:TCustomConfig;
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

procedure TFormSearchDFT.BitBtnPrintClick(Sender: TObject);
begin
  FrPrintGridSrchDFT.PreviewReport;
end;

procedure TFormSearchDFT.EditSrchDFTKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  StrSQL:string;
begin
  StrSQL:='SELECT * FROM tdftresults ORDER BY OfSerie ASC LIMIT 1000';
  if EditSrchDFT.Text<>'' then
  begin
     StrSQL:='SELECT * FROM tdftresults WHERE OfSerie LIKE ''%'+EditSrchDFT.Text+'%'' ORDER BY OfSerie';
  end;
  ZQuerySrchDFT.Active:=false;
  ZQuerySrchDFT.SQL.Text:=strSQL;
  ZQuerySrchDFT.Active:=true;
end;

procedure TFormSearchDFT.FormShow(Sender: TObject);
var
  StrSQL:string;
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

  StrSQL:='SELECT * FROM tdftresults ORDER BY OfSerie ASC LIMIT 1000';
  if EditSrchDFT.Text<>'' then
  begin
     StrSQL:='SELECT * FROM tdftresults WHERE OfSerie LIKE ''%'+EditSrchDFT.Text+'%'' ORDER BY OfSerie';
  end;
  ZQuerySrchDFT.SQL.Text:=StrSQL;
  ZConnectionSrchDFT.Connect;
  ZQuerySrchDFT.Active:=true;
  EditSrchDFT.SetFocus;
end;

procedure TFormSearchDFT.LoadConfig(TCmCfg:TCustomConfig);
begin
  CCF:=TCmCfg;
end;

end.

