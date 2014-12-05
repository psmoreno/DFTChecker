unit fmusers;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, ZDataset, ZConnection, Forms, Controls,
  Graphics, Dialogs, StdCtrls, DBGrids, ExtCtrls, Buttons,customconfig;

type

  { TFormUsers }

  TFormUsers = class(TForm)
    BitBtnAdd: TBitBtn;
    BitBtnEdit: TBitBtn;
    BitBtnDelete: TBitBtn;
    BitBtnExit: TBitBtn;
    ComboBoxUserSection: TComboBox;
    ComboBoxUserLevel: TComboBox;
    DataSourceUsers: TDataSource;
    DBGridUsers: TDBGrid;
    EditUserFilter: TEdit;
    EditUserName: TEdit;
    EditUserPass: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    PanelFilterUsers: TPanel;
    PanelButtons: TPanel;
    PanelUsers: TPanel;
    ZConnectionUsers: TZConnection;
    ZQueryUsers: TZQuery;
    procedure BitBtnAddClick(Sender: TObject);
    procedure BitBtnDeleteClick(Sender: TObject);
    procedure BitBtnEditClick(Sender: TObject);
    procedure BitBtnExitClick(Sender: TObject);
    procedure DBGridUsersDblClick(Sender: TObject);
    procedure EditUserFilterKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditUserNameKeyPress(Sender: TObject; var Key: char);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
    CCF:TCustomConfig;
    RUsers:TStringList;
    RPass:TStringList;
    RSections:TStringList;
    RLevels:TStringList;

    procedure FilterRecords;
    function CheckValues:boolean;
  public
    { public declarations }
    procedure LoadConfig(TCmCfg:TCustomConfig);
    property Users:TStringList read RUsers;
    property Pass:TStringList read RPass;
    property Sections:TStringList read RSections;
    property Levels:TStringList read RLevels;
  end;

var
  FormUsers: TFormUsers;

implementation

{$R *.lfm}

{ TFormUsers }

procedure TFormUsers.FormShow(Sender: TObject);
begin
  ZConnectionUsers.HostName:=CCF.ConfigSQl.HIP;
  ZConnectionUsers.Port:=StrToInt(CCF.ConfigSQl.PConecction);
  ZConnectionUsers.Protocol:=CCF.ConfigSQl.Databasetype;
  ZConnectionUsers.Database:=CCF.ConfigSQl.DBname;
  ZConnectionUsers.User:=CCF.ConfigSQl.User;
  ZConnectionUsers.Password:=CCF.ConfigSQl.Pass;
  ZQueryUsers.Connection:=ZConnectionUsers;
  DataSourceUsers.DataSet:=ZQueryUsers;
  DBGridUsers.DataSource:=DataSourceUsers;

  FilterRecords;
  EditUserName.SetFocus;
end;

procedure TFormUsers.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  ZQueryUsers.Active:=false;
  ZConnectionUsers.Disconnect;
end;

procedure TFormUsers.FormCreate(Sender: TObject);
begin
  RUsers:=TStringList.Create;
  RPass:=TStringList.Create;
  RSections:=TStringList.Create;
  RLevels:=TStringList.Create;
end;

procedure TFormUsers.BitBtnExitClick(Sender: TObject);
var
  i:integer;
begin
  ZQueryUsers.Close;
  ZQueryUsers.SQL.Text:='SELECT * FROM tusers';
  ZQueryUsers.Open;
  ZQueryUsers.First;
  RUsers.Clear;;
  RPass.Clear;
  RSections.Clear;
  RLevels.Clear;
  for i:=0 to ZQueryUsers.RecordCount-1 do
  begin
     RUsers.Add(ZQueryUsers.FieldByName('UserName').AsString);
     RPass.Add(ZQueryUsers.FieldByName('UserPass').AsString);
     RSections.Add(ZQueryUsers.FieldByName('PSection').AsString);
     RLevels.Add(ZQueryUsers.FieldByName('TAutorization').AsString);
     ZQueryUsers.Next;
  end;
  ZQueryUsers.Close;
  ZConnectionUsers.Disconnect;
  Close;
end;

procedure TFormUsers.DBGridUsersDblClick(Sender: TObject);
begin
  EditUserName.Text:=ZQueryUsers.FieldByName('UserName').AsString;
  EditUserPass.Text:=ZQueryUsers.FieldByName('UserPass').AsString;
  ComboBoxUserSection.ItemIndex:=ZQueryUsers.FieldByName('PSection').AsInteger-1;
  ComboBoxUserLevel.ItemIndex:=ZQueryUsers.FieldByName('TAutorization').AsInteger-1;
end;

procedure TFormUsers.EditUserFilterKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  FilterRecords;
end;

procedure TFormUsers.EditUserNameKeyPress(Sender: TObject; var Key: char);
begin
  if integer(Key) = 13 then
    begin
         key := #0;
         EditUserPass.SelectAll;
         EditUserPass.SetFocus;
    end;
end;

procedure TFormUsers.BitBtnAddClick(Sender: TObject);
var
  strFilter:string;
begin
  ZQueryUsers.Close;
  strFilter:=EditUserFilter.Text;

  if CheckValues=true then
  begin
       EditUserFilter.Text:='';
       ZQueryUsers.SQL.Text:='SELECT * FROM tusers';
       ZQueryUsers.Open;
       ZQueryUsers.Append;
       ZQueryUsers.FieldByName('UserName').AsString:=EditUserName.Text;
       ZQueryUsers.FieldByName('UserPass').AsString:=EditUserPass.Text;
       ZQueryUsers.FieldByName('PSection').AsInteger:=ComboBoxUserSection.ItemIndex+1;
       ZQueryUsers.FieldByName('TAutorization').AsInteger:=ComboBoxUserLevel.ItemIndex+1;
       ZQueryUsers.CommitUpdates;
       EditUserName.Text:='';
       EditUserPass.Text:='';
       EditUserFilter.Text:=strFilter;
       FilterRecords;
       EditUserName.SetFocus;
  end;
end;

procedure TFormUsers.BitBtnDeleteClick(Sender: TObject);
begin
  if (MessageDlg('Advertencia','Esta seguro que desea eliminar el registro seleccionado',
  mtWarning,mbYesNo,0)=mrYes) then
  begin
      ZQueryUsers.Delete;
  end;
end;

procedure TFormUsers.BitBtnEditClick(Sender: TObject);
begin
  if CheckValues=true then
  begin
       ZQueryUsers.Edit;
       ZQueryUsers.FieldByName('UserName').AsString:=EditUserName.Text;
       ZQueryUsers.FieldByName('UserPass').AsString:=EditUserPass.Text;
       ZQueryUsers.FieldByName('PSection').AsInteger:=ComboBoxUserSection.ItemIndex+1;
       ZQueryUsers.FieldByName('TAutorization').AsInteger:=ComboBoxUserLevel.ItemIndex+1;
       ZQueryUsers.CommitUpdates;
       EditUserName.Text:='';
       EditUserPass.Text:='';
       FilterRecords;
       EditUserName.SetFocus;
  end;
end;
procedure TFormUsers.LoadConfig(TCmCfg:TCustomConfig);
begin
  CCF:=TCmCfg;
end;

procedure TFormUsers.FilterRecords;
var
  StrSQL:string;
begin
  StrSQL:='SELECT * FROM tusers';
  if EditUserFilter.Text<>'' then
  begin
     StrSQL:=StrSQL+' WHERE UserName LIKE ''%'+EditUserFilter.Text+'%'' ';
  end;
  ZQueryUsers.SQL.Text:=StrSQL;
  ZConnectionUsers.Connect;
  ZQueryUsers.Active:=true;
end;

function TFormUsers.CheckValues:boolean;
var
  ChResult:boolean;
begin
  if EditUserName.Text='' then
  begin
     MessageDlg('Error','El nombre de usuario no debe estar vacio',mtCustom,[mbOK],0);
     EditUserName.SetFocus;
     ChResult:=false;
  end
  else
  begin
    if EditUserPass.Text='' then
    begin
       MessageDlg('Error','El password no debe estar vacio',mtCustom,[mbOK],0);
       ShowMessage('El password no debe estar vacio');
       EditUserPass.SetFocus;
       ChResult:=false;
    end
    else
    begin
      if ComboBoxUserSection.ItemIndex<0 then
      begin
         MessageDlg('Error','Se debe elegir una seccion del programa valida',mtCustom,[mbOK],0);
         ComboBoxUserSection.SetFocus;
         ChResult:=false;
      end
      else
      begin
        if ComboBoxUserLevel.ItemIndex < 0 then
        begin
           MessageDlg('Error','Se debe elegir un nivel permiso valido',mtCustom,[mbOK],0);
           ShowMessage('Se debe elegir un nivel de permiso valido');
           ComboBoxUserLevel.SetFocus;
           ChResult:=false;
        end
        else
        begin
          ChResult:=true;
        end;
      end;
    end;
  end;
  CheckValues:=ChResult;
end;

end.

