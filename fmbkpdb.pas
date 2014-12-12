unit fmbkpdb;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, EditBtn, Buttons, ubackups, customconfig,fmOfSerieRepeat;

type

  { TFormBkpDB }

  TFormBkpDB = class(TForm)
    BitBtnBkpNow: TBitBtn;
    BitBtnSaveOpt: TBitBtn;
    BitBtnClose: TBitBtn;
    CheckBoxActiveBKP: TCheckBox;
    ComboBoxHourBkpDB: TComboBox;
    ComboBoxRepeatBkpDB: TComboBox;
    ComboBoxSelectOldRecords: TComboBox;
    DateEditBkpDB: TDateEdit;
    GroupBoxBKPOptions: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    PanelLastBkp: TPanel;
    PanelButtons: TPanel;
    procedure BitBtnBkpNowClick(Sender: TObject);
    procedure BitBtnCloseClick(Sender: TObject);
    procedure BitBtnSaveOptClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
    TCC:TCustomConfig;
    UBkp:TBackups;
    LastBackup:string;
    RChangeBkpDate:boolean;
  public
    { public declarations }
    procedure LoadConfig(TCmCfg:TCustomConfig);
    procedure ReturnConfig(out CCF:TCustomConfig);
    property ChangeBkpDate:boolean read RChangeBkpDate;
  end;

var
  FormBkpDB: TFormBkpDB;

implementation

{$R *.lfm}

procedure TFormBkpDB.BitBtnCloseClick(Sender: TObject);
begin
  Close;
  ModalResult:=mrCancel;
  if RChangeBkpDate then
  begin
     ModalResult:=mrOK;
  end;
end;

procedure TFormBkpDB.BitBtnBkpNowClick(Sender: TObject);
begin
  FormOFRepeated.TimerEnabled:=false;
  FormOFRepeated.Show;
  UBkp.LoadConfig(TCC);
  UBkp.MakeBackup(date,'SEMANAL');
  RChangeBkpDate:=true;
  LastBackup:=DateToStr(Date);
  PanelLastBkp.Caption:='Backup: '+LastBackup;
  FormOFRepeated.TimerEnabled:=true;
end;

procedure TFormBkpDB.BitBtnSaveOptClick(Sender: TObject);
begin
  self.close;
  self.ModalResult:=mrOK;
end;

procedure TFormBkpDB.FormCreate(Sender: TObject);
begin
  UBkp:=TBackups.Create(nil);
end;

procedure TFormBkpDB.FormShow(Sender: TObject);
begin
  //DateEditBkpDB.Date:=StrToDate(TCC.ConfigBKPOptions.VDate);
  DateEditBkpDB.Text:=TCC.ConfigBKPOptions.VDate;
  ComboBoxHourBkpDB.ItemIndex:=ComboBoxHourBkpDB.Items.IndexOf(TCC.ConfigBKPOptions.VHour);
  ComboBoxRepeatBkpDB.ItemIndex:=ComboBoxRepeatBkpDB.Items.IndexOf(TCC.ConfigBKPOptions.VRepeat);
  ComboBoxSelectOldRecords.ItemIndex:=ComboBoxSelectOldRecords.Items.IndexOf(TCC.ConfigBKPOptions.VOlder);
  if TCC.ConfigBKPOptions.EnableBKP = 'true' then
  begin
    CheckBoxActiveBKP.Checked:=true;
  end
  else
  begin
    CheckBoxActiveBKP.Checked:=false;
  end;
  RChangeBkpDate:=false;
  PanelLastBkp.Caption:=TCC.ConfigBKPOptions.VLastBkp;
end;

procedure TFormBkpDB.LoadConfig(TCmCfg:TCustomConfig);
begin
  TCC:=TCmCfg;
end;

procedure TFormBkpDB.ReturnConfig(out CCF:TCustomConfig);
begin
   CCF.ConfigBKPOptions.VDate:=DateToStr(DateEditBkpDB.Date);
   CCF.ConfigBKPOptions.VHour:=ComboBoxHourBkpDB.Items[ComboBoxHourBkpDB.ItemIndex];
   CCF.ConfigBKPOptions.VRepeat:=ComboBoxRepeatBkpDB.Items[ComboBoxRepeatBkpDB.ItemIndex];
   CCF.ConfigBKPOptions.VOlder:=ComboBoxSelectOldRecords.Items[ComboBoxSelectOldRecords.ItemIndex];

   if CheckBoxActiveBKP.Checked then
   begin
      CCF.ConfigBKPOptions.EnableBKP:='true';
   end
   else
   begin
      CCF.ConfigBKPOptions.EnableBKP:='false';
   end;

   CCF.ConfigBKPOptions.VLastBkp:=self.LastBackup;
end;

end.

