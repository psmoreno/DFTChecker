unit fmlinks;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, ZConnection, ZDataset, Forms, Controls,
  Graphics, Dialogs, StdCtrls, DbCtrls, ExtCtrls, Buttons, DBGrids,
  customconfig;

type

  { TFormLinks }

  TFormLinks = class(TForm)
    BitBtnLink: TBitBtn;
    BitBtnExit: TBitBtn;
    BitBtnUndo: TBitBtn;
    DataSourceLinksOFModels: TDataSource;
    DataSourceLinksModels: TDataSource;
    DataSourceLinksOF: TDataSource;
    DBGridLinkOF: TDBGrid;
    DBGridLinkModel: TDBGrid;
    DBGridLinkOFModel: TDBGrid;
    EditLinkOF: TEdit;
    EditLinkModel: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Panel1: TPanel;
    SpeedButtonOF: TSpeedButton;
    SpeedButtonModel: TSpeedButton;
    ZConnectionLinks: TZConnection;
    ZQueryLinkOFModels: TZQuery;
    ZQueryLinksModels: TZQuery;
    ZQueryLinksOF: TZQuery;
    procedure BitBtnExitClick(Sender: TObject);
    procedure BitBtnLinkClick(Sender: TObject);
    procedure BitBtnUndoClick(Sender: TObject);
    procedure DBGridLinkModelDblClick(Sender: TObject);
    procedure DBGridLinkOFDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SpeedButtonModelClick(Sender: TObject);
    procedure SpeedButtonOFClick(Sender: TObject);
  private
    { private declarations }
    CCF:TCustomConfig;
  public
    { public declarations }
    procedure LoadConfig(TCmCfg:TCustomConfig);
  end;

var
  FormLinks: TFormLinks;

implementation

{$R *.lfm}

{ TFormLinks }

procedure TFormLinks.BitBtnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFormLinks.BitBtnLinkClick(Sender: TObject);
begin
  if ((EditLinkOF.Text=ZQueryLinksOF.FieldByName('OrdenF').AsString)and
  (EditLinkModel.Text=ZQueryLinksModels.FieldByName('ModelName').AsString ))then
  begin
       // Creo el registro vinculo
       ZQueryLinkOFModels.Append;
       ZQueryLinkOFModels.FieldByName('NBox').AsInteger:=0;
       ZQueryLinkOFModels.FieldByName('strOF').AsString:=ZQueryLinksOF.FieldByName('OrdenF').AsString;
       ZQueryLinkOFModels.FieldByName('strModel').AsString:=ZQueryLinksModels.FieldByName('ModelName').AsString;
       ZQueryLinkOFModels.FieldByName('Status').AsInteger:=1;
       ZQueryLinkOFModels.CommitUpdates;

       //Cierro esa orden para hacer vinculos
       ZQueryLinksOF.Edit;
       ZQueryLinksOF.FieldByName('Status').AsInteger:=0;
       ZQueryLinksOF.CommitUpdates;
       ZQueryLinksOF.Close;
       ZQueryLinksOF.SQL.Text:='SELECT * FROM tordenf WHERE Status > 0';
       ZQueryLinksOF.Open;
  end;
end;

procedure TFormLinks.BitBtnUndoClick(Sender: TObject);
var
  strValue:string;
begin
  if ZQueryLinkOFModels.RecordCount>0 then
  begin
       //Borro el registro vinculo
       strValue:=ZQueryLinkOFModels.FieldByName('strOF').AsString;
       ZQueryLinkOFModels.Delete;

       ZQueryLinksOF.Close;
       ZQueryLinksOF.SQL.Text:='SELECT * FROM tordenf WHERE OrdenF like ''%'+strValue+'%'' ';
       //Reactivo la orden de fabricacion
       ZQueryLinksOF.Open;
       ZQueryLinksOF.Edit;
       ZQueryLinksOF.FieldByName('Status').AsInteger:=1;
       ZQueryLinksOF.CommitUpdates;
       ZQueryLinksOF.Close;
       ZQueryLinksOF.SQL.Text:='SELECT * FROM tordenf WHERE Status > 0';
       ZQueryLinksOF.Open;
  end;
end;

procedure TFormLinks.DBGridLinkModelDblClick(Sender: TObject);
begin
  SpeedButtonModelClick(self);
end;

procedure TFormLinks.DBGridLinkOFDblClick(Sender: TObject);
begin
  SpeedButtonOFClick(self);
end;

procedure TFormLinks.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  ZQueryLinksOF.Active:=false;
  ZQueryLinkOFModels.Active:=false;
  ZQueryLinkOFModels.Active:=false;
  ZConnectionLinks.Disconnect;
end;

procedure TFormLinks.FormShow(Sender: TObject);
var
  StrSQL:string;
begin
  ZConnectionLinks.HostName:=CCF.ConfigSQl.HIP;
  ZConnectionLinks.Port:=StrToInt(CCF.ConfigSQl.PConecction);
  ZConnectionLinks.Protocol:=CCF.ConfigSQl.Databasetype;
  ZConnectionLinks.Database:=CCF.ConfigSQl.DBname;
  ZConnectionLinks.User:=CCF.ConfigSQl.User;
  ZConnectionLinks.Password:=CCF.ConfigSQl.Pass;

  ZQueryLinksOF.Connection:=ZConnectionLinks;
  DataSourceLinksOF.DataSet:=ZQueryLinksOF;
  DBGridLinkOF.DataSource:=DataSourceLinksOF;

  ZQueryLinksModels.Connection:=ZConnectionLinks;
  DataSourceLinksModels.DataSet:=ZQueryLinksModels;
  DBGridLinkModel.DataSource:=DataSourceLinksModels;

  ZQueryLinkOFModels.Connection:=ZConnectionLinks;
  DataSourceLinksOFModels.DataSet:=ZQueryLinkOFModels;
  DBGridLinkOFModel.DataSource:=DataSourceLinksOFModels;

  StrSQL:='SELECT * FROM tordenf WHERE Status > 0';
  ZQueryLinksOF.SQL.Clear;
  ZQueryLinksOF.SQL.Text:=StrSQL;

  StrSQL:='SELECT * FROM tmodels';
  ZQueryLinksModels.SQL.Clear;
  ZQueryLinksModels.SQL.Text:=StrSQL;

  StrSQL:='SELECT * FROM tlinkofmod WHERE Status > 0';
  ZQueryLinkOFModels.SQL.Clear;
  ZQueryLinkOFModels.SQL.Text:=StrSQL;

  ZConnectionLinks.Connect;
  ZQueryLinksOF.Active:=true;
  ZQueryLinksModels.Active:=true;
  ZQueryLinkOFModels.Active:=true;
end;

procedure TFormLinks.SpeedButtonModelClick(Sender: TObject);
begin
  if EditLinkModel.Text=''then
  begin
     EditLinkModel.Text:=ZQueryLinksModels.FieldByName('ModelName').AsString;
  end
  else
  begin
     EditLinkModel.Text:='';
  end;
end;

procedure TFormLinks.SpeedButtonOFClick(Sender: TObject);
begin
  if EditLinkOF.Text=''then
  begin
     EditLinkOF.Text:=ZQueryLinksOF.FieldByName('OrdenF').AsString;
  end
  else
  begin
     EditLinkOF.Text:='';
  end;

end;

procedure TFormLinks.LoadConfig(TCmCfg:TCustomConfig);
begin
  CCF:=TCmCfg;
end;

end.

