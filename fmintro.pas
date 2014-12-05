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
    RUsers:TStringList;
    RPass:TStringList;
    RSections:TStringList;
    RLevels:TStringList;

    RCurSection:string;
    RCurLevel:string;
    RAllowNotRootUser:boolean;
    RisRootUser:boolean;

    function CheckValues:boolean;
  public
    { public declarations }
    procedure ReturnConfig(out CCF:TCustomConfig);
    procedure LoadConfig(TCmCfg:TCustomConfig);
    property Users:TStringList read RUsers write RUsers;
    property Pass:TStringList read RPass write RPass;
    property Sections:TStringList read RSections write RSections;
    property Levels:TStringList read RLevels write RLevels;
    property CurSection:string read RCurSection write RCurSection;
    property CurLevel:string read RCurLevel write RCurLevel;
    property AllowNotRootUser:boolean read RAllowNotRootUser write RAllowNotRootUser;
    property isRootUser:boolean read RisRootUser;
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
var
  i:integer;
  strRootUser:string;
  strRootPass:string;
begin
  if TCC.CryptoKey <>'' then
  begin
       if CheckValues then
       begin
            strRootUser:=TCC.User;
            strRootPass:=TCC.Pass;

            TCC.User:=EditUser.Text;
            TCC.Pass:=EditPass.Text;
            if TCC.CheckForUserAndPas then
            begin
                 Close();
                 RisRootUser:=true;
                 ModalResult:=mrOK;
            end
            else
            begin
                 //ahora usaremos los usuarios validos
                 if RAllowNotRootUser then
                 begin
                    for i:=0 to RUsers.Count-1 do
                    begin
                      if ((RUsers[i]=EditUser.Text)and(RPass[i]=EditPass.Text)and(RSections[i]=RCurSection)
                      and (RLevels[i]=RCurLevel))then
                      begin
                          Close;
                          RisRootUser:=false;
                          TCC.User:=strRootUser;
                          TCC.Pass:=strRootPass;
                          ModalResult:=mrOK;
                          Exit;
                      end;
                    end;
                 end;

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
  RUsers:=TStringList.Create;
  RPass:=TStringList.Create;
  RSections:=TStringList.Create;
  RLevels:=TStringList.Create;
  RCurSection:='';
  RCurLevel:='';
  RAllowNotRootUser:=false;
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

