unit fmclosebox;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, ZConnection, ZDataset, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, StdCtrls, Buttons, customconfig;

type

  { TFormCloseBox }

  TFormCloseBox = class(TForm)
    BitBtnOK: TBitBtn;
    BitBtnCancel: TBitBtn;
    EditOFObserv: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    LabelQty: TLabel;
    LabelOF: TLabel;
    Label3: TLabel;
    PanelClosePallet: TPanel;
    ZConnectionCloseBox: TZConnection;
    ZQueryCloseBox: TZQuery;
    procedure BitBtnCancelClick(Sender: TObject);
    procedure BitBtnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
    CCF:TCustomConfig;
    RstrOF:string;
    RPCBQty:string;
  public
    { public declarations }
    procedure LoadConfig(TCmCfg:TCustomConfig);
    property strOF:string read RstrOF write RstrOF;
    property PCBQty:string read RPCBQty write RPCBQty;
  end;

var
  FormCloseBox: TFormCloseBox;

implementation

{$R *.lfm}

{ TFormCloseBox }

procedure TFormCloseBox.BitBtnCancelClick(Sender: TObject);
begin
  Close;
  ModalResult:=mrCancel;
end;

procedure TFormCloseBox.BitBtnOKClick(Sender: TObject);
var
  Count:integer;
  Total:integer;
begin
  Count:=StrToInt(Copy(RPCBQty,0,2));
  Total:=StrToInt(Copy(RPCBQty,4,5));
  if Count < Total then
  begin
    if (MessageDlg('Advertencia','Esta seguro que desea cerra la orden de fabricacion sin que este completa?',
    mtConfirmation,mbYesNo,0)<>mrYes) then
    begin
       exit;
    end;
  end;
  ZQueryCloseBox.SQL.Text:='SELECT * FROM pallet';
  ZConnectionCloseBox.Connect;
  ZQueryCloseBox.Open;
  ZQueryCloseBox.Append;
  ZQueryCloseBox.FieldByName('OrdenF').AsString:=RstrOF;
  ZQueryCloseBox.FieldByName('Qty').AsInteger:=Count;
  ZQueryCloseBox.FieldByName('FullQty').AsInteger:=Total;
  ZQueryCloseBox.FieldByName('Observ').AsString:=EditOFObserv.Text;
  ZQueryCloseBox.CommitUpdates;
  ZQueryCloseBox.Close;
  ZConnectionCloseBox.Disconnect;
  Close;
  ModalResult:=mrOK;
end;

procedure TFormCloseBox.FormShow(Sender: TObject);
begin
  ZConnectionCloseBox.HostName:=CCF.ConfigSQl.HIP;
  ZConnectionCloseBox.Port:=StrToInt(CCF.ConfigSQl.PConecction);
  ZConnectionCloseBox.Protocol:=CCF.ConfigSQl.Databasetype;
  ZConnectionCloseBox.Database:=CCF.ConfigSQl.DBname;
  ZConnectionCloseBox.User:=CCF.ConfigSQl.User;
  ZConnectionCloseBox.Password:=CCF.ConfigSQl.Pass;
  ZQueryCloseBox.Connection:=ZConnectionCloseBox;

  LabelOF.Caption:=RstrOF;
  LabelQty.Caption:=RPCBQty;
  EditOFObserv.Text:='';
end;

procedure TFormCloseBox.LoadConfig(TCmCfg:TCustomConfig);
begin
   CCF:=TCmCfg;
end;

end.

