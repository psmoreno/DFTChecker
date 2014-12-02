unit fmclosebox;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, ZConnection, ZDataset, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, StdCtrls, Buttons, customconfig;

type

  { TFormCloseOF }

  TFormCloseOF = class(TForm)
    BitBtnOK: TBitBtn;
    BitBtnCancel: TBitBtn;
    EditOF: TEdit;
    EditOFObserv: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    PanelClosePallet: TPanel;
    ZConnectionCloseBox: TZConnection;
    ZQueryCloseBox: TZQuery;
    procedure BitBtnCancelClick(Sender: TObject);
    procedure BitBtnOKClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
    CCF:TCustomConfig;
    RstrOf:string;
  public
    { public declarations }
    procedure LoadConfig(TCmCfg:TCustomConfig);
    property strOf:string read RstrOf write RstrOf;
  end;

var
  FormCloseOF: TFormCloseOF;

implementation

{$R *.lfm}

{ TFormCloseOF }

procedure TFormCloseOF.BitBtnCancelClick(Sender: TObject);
begin
  Close;
  ModalResult:=mrCancel;
end;

procedure TFormCloseOF.BitBtnOKClick(Sender: TObject);
var
  tmp:integer;
  OpResult:boolean;
begin
  if ((Length(EditOF.Text)=6)and(TryStrToInt(EditOF.Text,tmp))) then
  begin
    ZConnectionCloseBox.Connect;
    ZQueryCloseBox.SQL.Text:='SELECT * FROM tlinkofmod WHERE strOF LIKE '''+
    EditOF.Text+''' AND Status>0';
    ZQueryCloseBox.Open;
    if ZQueryCloseBox.RecordCount=1 then
    begin
         ZQueryCloseBox.Edit;
         ZQueryCloseBox.FieldByName('Observ').AsString:=EditOFObserv.Text;
         ZQueryCloseBox.FieldByName('Status').AsInteger:=0;
         ZQueryCloseBox.CommitUpdates;
         OpResult:=true;
    end
    else
    begin
         MessageDlg('Error','Esta orden de fabricacion no se encuentra activa!',mtError,[mbOK],0);
         OpResult:=false;
    end;
    BitBtnCancel.Enabled:=true;
    ZQueryCloseBox.Close;
    ZConnectionCloseBox.Disconnect;
  end
  else
  begin
    MessageDlg('Error','El formato de la orden de fabricacion es un numero de 6 digitos!',mtError,[mbOK],0);
    OpResult:=false;
  end;
  if OpResult then
  begin
    Close;
    ModalResult:=mrOK;
  end
  else
  begin
    EditOF.SelectAll;
    EditOF.SetFocus
  end;
end;

procedure TFormCloseOF.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose:=BitBtnCancel.Enabled;
  if BitBtnCancel.Enabled = false then
  begin
     MessageDlg('Es obligatorio cerrar la orden de fabricación', mtinformation, [mbOK],0);
  end;
end;

procedure TFormCloseOF.FormShow(Sender: TObject);
begin
  ZConnectionCloseBox.HostName:=CCF.ConfigSQl.HIP;
  ZConnectionCloseBox.Port:=StrToInt(CCF.ConfigSQl.PConecction);
  ZConnectionCloseBox.Protocol:=CCF.ConfigSQl.Databasetype;
  ZConnectionCloseBox.Database:=CCF.ConfigSQl.DBname;
  ZConnectionCloseBox.User:=CCF.ConfigSQl.User;
  ZConnectionCloseBox.Password:=CCF.ConfigSQl.Pass;
  ZQueryCloseBox.Connection:=ZConnectionCloseBox;
  EditOF.Text:=RstrOf;
  EditOFObserv.Text:='';
  if RstrOf <> '' then
  begin
    BitBtnCancel.Enabled:=false;
    EditOFObserv.SetFocus;
  end
  else
  begin
    BitBtnCancel.Enabled:=true;
    EditOF.SetFocus;
  end;
end;

procedure TFormCloseOF.LoadConfig(TCmCfg:TCustomConfig);
begin
   CCF:=TCmCfg;
end;

end.

