unit fmModels;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, DbCtrls, Buttons, DBGrids,fmaddinsert, db, ZConnection, ZDataset,
  customconfig;

type

  { TFormModels }

  TFormModels = class(TForm)
    BitBtnAddModels: TBitBtn;
    BitBtnEditModels: TBitBtn;
    BitBtnDelModels: TBitBtn;
    BitBtnExitModels: TBitBtn;
    DataSourceModels: TDataSource;
    DBGridModels: TDBGrid;
    EditSearchModels: TEdit;
    Label1: TLabel;
    PanelOF1: TPanel;
    PanelOF2: TPanel;
    ZConnectionModels: TZConnection;
    ZQueryModels: TZQuery;
    procedure BitBtnAddModelsClick(Sender: TObject);
    procedure BitBtnDelModelsClick(Sender: TObject);
    procedure BitBtnEditModelsClick(Sender: TObject);
    procedure BitBtnExitModelsClick(Sender: TObject);
    procedure DBGridModelsDblClick(Sender: TObject);
    procedure EditSearchModelsKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
    CCF:TCustomConfig;
  public
    { public declarations }
    procedure LoadConfig(TCmCfg:TCustomConfig);
  end;

var
  FormModels: TFormModels;

implementation

{$R *.lfm}

{ TFormModels }

procedure TFormModels.BitBtnEditModelsClick(Sender: TObject);
var
  Pos:integer;
begin
  EditSearchModels.Text:='';
  Pos:=ZQueryModels.RecNo;
  ZQueryModels.Close;
  ZQueryModels.SQL.Clear;
  ZQueryModels.SQL.Text:='SELECT * FROM tmodels';
  ZQueryModels.Open;
  ZQueryModels.RecNo:=Pos;
  FormAddInsert.IsAnOF:=false;
  FormAddInsert.StrValue:=ZQueryModels.FieldByName('ModelName').AsString;
  if FormAddInsert.ShowModal=mrOK then
  begin
     ZQueryModels.Edit;
     ZQueryModels.FieldByName('ModelName').AsString:=FormAddInsert.StrValue;
     ZQueryModels.CommitUpdates;
  end;
end;

procedure TFormModels.BitBtnAddModelsClick(Sender: TObject);
begin
  EditSearchModels.Text:='';
  FormAddInsert.IsAnOF:=false;
  FormAddInsert.StrValue:='';
  if FormAddInsert.ShowModal=mrOK then
  begin
     ZQueryModels.Close;
     ZQueryModels.SQL.Clear;
     ZQueryModels.SQL.Text:='SELECT * FROM tmodels where ModelName LIKE ''%'+
     FormAddInsert.StrValue+'%''';
     ZQueryModels.Open;
     if ZQueryModels.RecordCount = 0 then
     begin
        ZQueryModels.Append;
        ZQueryModels.FieldByName('ModelName').AsString:=FormAddInsert.StrValue;
        ZQueryModels.CommitUpdates;
     end
     else
     begin
        MessageDlg('Error','Este modelo ya existe!',mtError,[mbOK],0);
     end;
     ZQueryModels.Close;
     ZQueryModels.SQL.Text:='SELECT * FROM tmodels';
     ZQueryModels.Open;
  end;
end;

procedure TFormModels.BitBtnDelModelsClick(Sender: TObject);
begin
  if (MessageDlg('Advertencia','Esta seguro que desea eliminar el registro seleccionado',
  mtWarning,mbYesNo,0)=mrYes) then
  begin
      ZQueryModels.Delete;
  end;
end;

procedure TFormModels.BitBtnExitModelsClick(Sender: TObject);
begin
  ZQueryModels.Close;
  Close;
end;

procedure TFormModels.DBGridModelsDblClick(Sender: TObject);
begin
  BitBtnEditModelsClick(nil);
end;

procedure TFormModels.EditSearchModelsKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  strSQL:string;
begin
  StrSQL:='SELECT * FROM tmodels';
  if EditSearchModels.Text<>'' then
  begin
     StrSQL:=StrSQL+' WHERE ModelName like ''%'+EditSearchModels.Text+'%'' ';
  end;
  ZQueryModels.Active:=false;
  ZQueryModels.SQL.Clear;
  ZQueryModels.SQL.Text:=strSQL;
  ZQueryModels.Active:=true;
end;

procedure TFormModels.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  ZQueryModels.Close;
  ZConnectionModels.Disconnect;
end;

procedure TFormModels.FormShow(Sender: TObject);
var
  StrSQL:string;
begin
  ZConnectionModels.HostName:=CCF.ConfigSQl.HIP;
  ZConnectionModels.Port:=StrToInt(CCF.ConfigSQl.PConecction);
  ZConnectionModels.Protocol:=CCF.ConfigSQl.Databasetype;
  ZConnectionModels.Database:=CCF.ConfigSQl.DBname;
  ZConnectionModels.User:=CCF.ConfigSQl.User;
  ZConnectionModels.Password:=CCF.ConfigSQl.Pass;
  ZQueryModels.Connection:=ZConnectionModels;
  DataSourceModels.DataSet:=ZQueryModels;
  DBGridModels.DataSource:=DataSourceModels;

  StrSQL:='SELECT * FROM tmodels';
  if EditSearchModels.Text<>'' then
  begin
     StrSQL:=StrSQL+' WHERE ModelName like ''%'+EditSearchModels.Text+'%'' ';
  end;
  ZQueryModels.SQL.Clear;
  ZQueryModels.SQL.Text:=StrSQL;
  ZConnectionModels.Connect;
  ZQueryModels.Active:=true;
  EditSearchModels.SetFocus;
end;

procedure TFormModels.LoadConfig(TCmCfg:TCustomConfig);
begin
  CCF:=TCmCfg;
end;

end.

