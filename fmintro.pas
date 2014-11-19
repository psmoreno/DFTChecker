unit fmIntro;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil,Forms, Controls, Graphics,
  Dialogs, StdCtrls, ExtCtrls,customconfig;

type
  { TFormIntro }

  TFormIntro = class(TForm)
    ButtonAcept: TButton;
    ButtonCancel: TButton;
    EditUser: TEdit;
    EditPass: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    PanelButtons: TPanel;
    PanelPassword: TPanel;
    procedure ButtonAceptClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure EditUserKeyPress(Sender: TObject; var Key: char);
    procedure EditPassKeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
    TCC:TCustomConfig;

    function CheckValues:boolean;
  public
    { public declarations }
    procedure ReturnConfig(out CCF:TCustomConfig);
    procedure LoadConfig(TCmCfg:TCustomConfig);
  end;

var
  FormIntro: TFormIntro;

implementation

{$R *.lfm}

{ TFormIntro }

function TFormIntro.CheckValues:boolean;
begin
  if EditUser.Text='' then
  begin
    MessageDlg('Error','Nombre de usuario no puede ser nulo, por favor revise',mtError,[mbOK],0);
    EditUser.SetFocus;
    CheckValues:=false;
    exit;
  end;

  if EditPass.Text='' then
  begin
    MessageDlg('Error','La contraseña no puede ser nula, por favor revise',mtError,[mbOK],0);
    EditPass.SetFocus;
    CheckValues:=false;
    exit;
  end;
  CheckValues:=true;
end;

procedure TFormIntro.ButtonAceptClick(Sender: TObject);
begin
  if TCC.CryptoKey <>'' then
  begin
       if CheckValues then
       begin
            TCC.User:=EditUser.Text;
            TCC.Pass:=EditPass.Text;
            if TCC.CheckForUserAndPas then
            begin
                 Close();
                 ModalResult:=mrOK;
            end
            else
            begin
                 EditUser.Clear;
                 EditPass.Clear;
                 EditUser.SetFocus;
                 MessageDlg('Error','La contraseña es incorrecta',mtError,[mbOK],0);
            end;
       end;
  end
  else
  begin
       TCC.User:=EditUser.Text;
       TCC.Pass:=EditPass.Text;
       Close();
       ModalResult:=mrYes;
  end;
end;

procedure TFormIntro.ButtonCancelClick(Sender: TObject);
begin
  Close();
  ModalResult:=mrCancel;
end;

procedure TFormIntro.EditUserKeyPress(Sender: TObject; var Key: char);
begin
    if integer(Key) = 13 then
    begin
         key := #0;
         EditPass.SelectAll;
         EditPass.SetFocus;
    end;
end;

procedure TFormIntro.EditPassKeyPress(Sender: TObject; var Key: char);
begin
  if integer(Key) = 13 then
    begin
         key := #0;
         ButtonAceptClick(nil);
    end;
end;

procedure TFormIntro.FormCreate(Sender: TObject);
begin
  TCC:=TCC.Create;
end;

procedure TFormIntro.FormShow(Sender: TObject);
begin
  EditUser.Clear;
  EditPass.Clear;
  EditUser.SetFocus;
end;

procedure TFormIntro.ReturnConfig(out CCF:TCustomConfig);
begin
   CCF.Pass:=TCC.Pass;
   CCF.User:=TCC.User;
   CCF.Encrypted:=TCC.Encrypted;
end;

procedure TFormIntro.LoadConfig(TCmCfg:TCustomConfig);
begin
   TCC:=TCmCfg;
end;

end.

