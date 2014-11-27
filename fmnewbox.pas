unit fmnewbox;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, ZConnection, ZDataset, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, StdCtrls, Buttons, Spin,customconfig;

type

  { TFormNewBox }

  TFormNewBox = class(TForm)
    BitBtnOK: TBitBtn;
    BitBtnCancel: TBitBtn;
    EditOF: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    PanelNewBox: TPanel;
    SpinEditNewBox: TSpinEdit;
    ZConnectionNewBox: TZConnection;
    ZQueryNewBox: TZQuery;
    procedure BitBtnCancelClick(Sender: TObject);
    procedure BitBtnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
    CCF:TCustomConfig;
    ROFb:string;
    RModel:string;
    RQty:integer;
    RNbox:integer;
  public
    { public declarations }
    procedure LoadConfig(TCmCfg:TCustomConfig);
    property OFb:string read ROFb;
    property Model:string read RModel;
    property Qty:integer read RQty;
    property Nbox:integer read RNbox;
  end;

var
  FormNewBox: TFormNewBox;

implementation

{$R *.lfm}

{ TFormNewBox }

procedure TFormNewBox.BitBtnCancelClick(Sender: TObject);
begin
  Close;
  ModalResult:=mrCancel;
end;

procedure TFormNewBox.BitBtnOKClick(Sender: TObject);
var
  tmp:integer;
begin
  if ((Length(EditOF.Text)=6)and(TryStrToInt(EditOF.Text,tmp))) then
  begin
    ZQueryNewBox.SQL.Text:='SELECT * FROM tlinkofmod WHERE strOF LIKE '''+
    EditOF.Text+''' AND Status>0';
    ZQueryNewBox.Open;
    if ZQueryNewBox.RecordCount=1 then
    begin
        ZQueryNewBox.Close;
        ZQueryNewBox.SQL.Text:='SELECT MAX(Nbox) as MVAL FROM tlinkofmod WHERE Status = 0';
        ZQueryNewBox.Open;
        tmp:=ZQueryNewBox.FieldByName('MVAL').AsInteger+1;
        ZQueryNewBox.Close;

        ZQueryNewBox.SQL.Text:='SELECT * FROM tlinkofmod WHERE strOF LIKE '''+
        EditOF.Text+'''';
        ZQueryNewBox.Open;
        ROFb:=EditOF.Text;
        RModel:=ZQueryNewBox.FieldByName('strModel').AsString;
        ZQueryNewBox.Edit;
        ZQueryNewBox.FieldByName('Status').AsInteger:=0;
        ZQueryNewBox.FieldByName('Nbox').AsInteger:=tmp;
        ZQueryNewBox.CommitUpdates;
        RNbox:=tmp;
        RQty:=SpinEditNewBox.Value;
        Close;
        ModalResult:=mrOK;
    end
    else
    begin
       MessageDlg('Error','Esta orden de fabricacion no se encuentra activa!',mtError,[mbOK],0);
       EditOF.SelectAll;
       EditOF.SetFocus;
    end;
    ZQueryNewBox.Close;
  end
  else
  begin
    MessageDlg('Error','El formato de la orden de fabricacion es un numero de 6 digitos!',mtError,[mbOK],0);
    EditOF.SelectAll;
    EditOF.SetFocus;
  end;
end;

procedure TFormNewBox.FormShow(Sender: TObject);
begin
  ZConnectionNewBox.HostName:=CCF.ConfigSQl.HIP;
  ZConnectionNewBox.Port:=StrToInt(CCF.ConfigSQl.PConecction);
  ZConnectionNewBox.Protocol:=CCF.ConfigSQl.Databasetype;
  ZConnectionNewBox.Database:=CCF.ConfigSQl.DBname;
  ZConnectionNewBox.User:=CCF.ConfigSQl.User;
  ZConnectionNewBox.Password:=CCF.ConfigSQl.Pass;
  ZQueryNewBox.Connection:=ZConnectionNewBox;

  EditOF.Clear;
  EditOF.SetFocus;
end;

procedure TFormNewBox.LoadConfig(TCmCfg:TCustomConfig);
begin
   CCF:=TCmCfg;
end;

end.

