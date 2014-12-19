unit fmOF;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, DbCtrls, Buttons, DBGrids,fmaddinsert, db, ZConnection, ZDataset,
  customconfig;

type

  { TFormOF }

  TFormOF = class(TForm)
    BitBtnAddOF: TBitBtn;
    BitBtnEditOF: TBitBtn;
    BitBtnDelOF: TBitBtn;
    BitBtnExitOF: TBitBtn;
    DataSourceOF: TDataSource;
    DBGridOF: TDBGrid;
    EditSearchOF: TEdit;
    Label1: TLabel;
    PanelOF1: TPanel;
    PanelOF2: TPanel;
    ZConnectionOF: TZConnection;
    ZQueryOF: TZQuery;
    procedure BitBtnAddOFClick(Sender: TObject);
    procedure BitBtnDelOFClick(Sender: TObject);
    procedure BitBtnEditOFClick(Sender: TObject);
    procedure BitBtnExitOFClick(Sender: TObject);
    procedure DBGridOFDblClick(Sender: TObject);
    procedure EditSearchOFKeyUp(Sender: TObject; var Key: Word;
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
  FormOF: TFormOF;

implementation

{$R *.lfm}

{ TFormOF }

procedure TFormOF.BitBtnEditOFClick(Sender: TObject);
var
  Pos:integer;
begin
  EditSearchOF.Text:='';
  Pos:=ZQueryOF.RecNo;
  ZQueryOF.Close;
  ZQueryOF.SQL.Clear;
  ZQueryOF.SQL.Text:='SELECT * FROM tordenf';
  ZQueryOF.Open;
  ZQueryOF.RecNo:=Pos;
  FormAddInsert.InputType:=1;
  FormAddInsert.StrValue:=ZQueryOF.FieldByName('OrdenF').AsString;
  if FormAddInsert.ShowModal=mrOK then
  begin
     ZQueryOF.Edit;
     ZQueryOF.FieldByName('OrdenF').AsString:=FormAddInsert.StrValue;
     ZQueryOF.CommitUpdates;
  end;
  FormAddInsert.InputType:=3;
  FormAddInsert.StrValue:=ZQueryOF.FieldByName('Qty').AsString;
  if FormAddInsert.ShowModal=mrOK then
  begin
     ZQueryOF.Edit;
     ZQueryOF.FieldByName('Qty').AsString:=FormAddInsert.StrValue;
     ZQueryOF.CommitUpdates;
  end;
end;

procedure TFormOF.BitBtnAddOFClick(Sender: TObject);
var
  tmpOF:string;
  tmpQty:integer;
  CanContinue:boolean;
begin
  EditSearchOF.Text:='';
  FormAddInsert.InputType:=1;
  FormAddInsert.StrValue:='';
  if FormAddInsert.ShowModal=mrOK then
  begin
     ZQueryOF.Close;
     ZQueryOF.SQL.Clear;
     ZQueryOF.SQL.Text:='SELECT * FROM tordenf where OrdenF LIKE ''%'+
     FormAddInsert.StrValue+'%''';
     ZQueryOF.Open;
     if ZQueryOF.RecordCount = 0 then
     begin
        tmpOF:=FormAddInsert.StrValue;
        CanContinue:=true;
     end
     else
     begin
        MessageDlg('Error','Esta orden de fabricacion ya existe, pueder ser que este cerrada!',mtError,[mbOK],0);
        CanContinue:=false;
     end;
  end;

  if (CanContinue=false) then
     exit;

  FormAddInsert.InputType:=3;
  FormAddInsert.StrValue:='';
  if FormAddInsert.ShowModal=mrOK then
  begin
      tmpQty:=StrToInt(FormAddInsert.StrValue);
      ZQueryOF.Append;
      ZQueryOF.FieldByName('OrdenF').AsString:=tmpOF;
      ZQueryOF.FieldByName('Qty').AsInteger:=tmpQty;
      //Por lo general la orden se crea abierta o sea status = 1
      ZQueryOF.CommitUpdates;
  end;

  ZQueryOF.Close;
  ZQueryOF.SQL.Text:='SELECT * FROM tordenf WHERE Status > 0';
  ZQueryOF.Open;
end;

procedure TFormOF.BitBtnDelOFClick(Sender: TObject);
begin
  if (MessageDlg('Advertencia','Esta seguro que desea eliminar el registro seleccionado',
  mtWarning,mbYesNo,0)=mrYes) then
  begin
      ZQueryOF.Delete;
  end;
end;

procedure TFormOF.BitBtnExitOFClick(Sender: TObject);
begin
  ZQueryOF.Close;
  Close;
end;

procedure TFormOF.DBGridOFDblClick(Sender: TObject);
begin
  BitBtnEditOFClick(nil);
end;

procedure TFormOF.FormShow(Sender: TObject);
var
  StrSQL:string;
begin
  ZConnectionOF.HostName:=CCF.ConfigSQl.HIP;
  ZConnectionOF.Port:=StrToInt(CCF.ConfigSQl.PConecction);
  ZConnectionOF.Protocol:=CCF.ConfigSQl.Databasetype;
  ZConnectionOF.Database:=CCF.ConfigSQl.DBname;
  ZConnectionOF.User:=CCF.ConfigSQl.User;
  ZConnectionOF.Password:=CCF.ConfigSQl.Pass;
  ZQueryOF.Connection:=ZConnectionOF;
  DataSourceOF.DataSet:=ZQueryOF;
  DBGridOF.DataSource:=DataSourceOF;

  StrSQL:='SELECT * FROM tordenf WHERE Status > 0';
  if EditSearchOF.Text<>'' then
  begin
     StrSQL:=StrSQL+' AND OrdenF like ''%'+EditSearchOF.Text+'%'' ';
  end;
  ZQueryOF.SQL.Clear;
  ZQueryOF.SQL.Text:=StrSQL;
  ZConnectionOF.Connect;
  ZQueryOF.Active:=true;
  EditSearchOF.SetFocus;
end;

procedure TFormOF.LoadConfig(TCmCfg:TCustomConfig);
begin
  CCF:=TCmCfg;
end;

procedure TFormOF.EditSearchOFKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  strSQL:string;
begin
  StrSQL:='SELECT * FROM tordenf WHERE Status > 0';
  if EditSearchOF.Text<>'' then
  begin
     StrSQL:=StrSQL+' AND OrdenF like ''%'+EditSearchOF.Text+'%'' ';
  end;
  ZQueryOF.Active:=false;
  ZQueryOF.SQL.Clear;
  ZQueryOF.SQL.Text:=strSQL;
  ZQueryOF.Active:=true;
end;

procedure TFormOF.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  ZQueryOF.Active:=false;
  ZConnectionOF.Disconnect;
end;

end.

