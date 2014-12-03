unit fmsearchDMS;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, LR_PGrid, ZConnection, ZDataset,
  Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, DBGrids, Buttons,
  customconfig;

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
    SaveDialogDMS: TSaveDialog;
    ZConnectionSrchDMS: TZConnection;
    ZQuerySrchDMS: TZQuery;
    procedure BitBtnCloseClick(Sender: TObject);
    procedure BitBtnExportClick(Sender: TObject);
    procedure BitBtnPrintClick(Sender: TObject);
    procedure EditSrchDMSKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
      CCF:TCustomConfig;
      procedure FilterResults;
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

procedure TFormSearchDMS.LoadConfig(TCmCfg:TCustomConfig);
begin
  CCF:=TCmCfg;
end;

procedure TFormSearchDMS.FilterResults;
var
  StrSQL:string;
begin
  StrSQL:='SELECT * FROM tdms ORDER BY id DESC LIMIT 1000';
  if EditSrchDMS.Text<>'' then
  begin
     StrSQL:='SELECT * FROM tdms WHERE OfSerie LIKE ''%'+EditSrchDMS.Text+'%'' ORDER BY OfSerial ASC';
  end;
  ZQuerySrchDMS.Active:=false;
  ZQuerySrchDMS.SQL.Text:=strSQL;
  ZQuerySrchDMS.Active:=true;
end;

end.

