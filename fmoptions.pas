unit fmoptions;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, ExtCtrls,customconfig;

type

  { TFormOptions }

  TFormOptions = class(TForm)
    BitBtnOK: TBitBtn;
    BitBtnExit: TBitBtn;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Edit1: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Edit14: TEdit;
    Edit15: TEdit;
    Edit16: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    GroupBoxMySQL: TGroupBox;
    GroupBoxPaths: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    OpenDialogPath: TOpenDialog;
    PanelButtons: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    procedure BitBtnExitClick(Sender: TObject);
    procedure BitBtnOKClick(Sender: TObject);
    procedure SpeedButton10Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
  private
    { private declarations }
    TCC:TCustomConfig;
    procedure LoadValuesIntoControls;
  public
    { public declarations }
    procedure ReturnConfig(out CCF:TCustomConfig);
    procedure LoadConfig(TCmCfg:TCustomConfig);
  end;

var
  FormOptions: TFormOptions;

implementation

{$R *.lfm}

{ TFormOptions }

procedure TFormOptions.BitBtnExitClick(Sender: TObject);
begin
  self.Close;
  self.ModalResult:=mrCancel;
end;

procedure TFormOptions.BitBtnOKClick(Sender: TObject);
begin
  self.close;
  self.ModalResult:=mrOK;
end;

procedure TFormOptions.SpeedButton10Click(Sender: TObject);
begin
  if OpenDialogPath.Execute then
  begin
     Edit16.Text:=OpenDialogPath.FileName;
  end;
end;

procedure TFormOptions.SpeedButton1Click(Sender: TObject);
begin
  if OpenDialogPath.Execute then
  begin
     Edit1.Text:=OpenDialogPath.FileName;
  end;
end;

procedure TFormOptions.SpeedButton2Click(Sender: TObject);
begin
   if OpenDialogPath.Execute then
  begin
     Edit2.Text:=OpenDialogPath.FileName;
  end;
end;

procedure TFormOptions.SpeedButton3Click(Sender: TObject);
begin
   if OpenDialogPath.Execute then
  begin
     Edit3.Text:=OpenDialogPath.FileName;
  end;
end;

procedure TFormOptions.SpeedButton4Click(Sender: TObject);
begin
   if OpenDialogPath.Execute then
  begin
     Edit4.Text:=OpenDialogPath.FileName;
  end;
end;

procedure TFormOptions.SpeedButton5Click(Sender: TObject);
begin
  if OpenDialogPath.Execute then
  begin
     Edit5.Text:=OpenDialogPath.FileName;
  end;
end;

procedure TFormOptions.SpeedButton6Click(Sender: TObject);
begin
  if OpenDialogPath.Execute then
  begin
     Edit12.Text:=OpenDialogPath.FileName;
  end;
end;

procedure TFormOptions.SpeedButton7Click(Sender: TObject);
begin
  if OpenDialogPath.Execute then
  begin
     Edit13.Text:=OpenDialogPath.FileName;
  end;
end;

procedure TFormOptions.SpeedButton8Click(Sender: TObject);
begin
  if OpenDialogPath.Execute then
  begin
     Edit14.Text:=OpenDialogPath.FileName;
  end;
end;

procedure TFormOptions.SpeedButton9Click(Sender: TObject);
begin
  if OpenDialogPath.Execute then
  begin
     Edit15.Text:=OpenDialogPath.FileName;
  end;
end;

procedure TFormOptions.LoadValuesIntoControls;
begin
  Edit1.Text:=TCC.ConfigOptions.DFTResult1;
  Edit2.Text:=TCC.ConfigOptions.DFTResult2;
  Edit3.Text:=TCC.ConfigOptions.DFTResult3;
  Edit4.Text:=TCC.ConfigOptions.DFTResult4;
  Edit5.Text:=TCC.ConfigOptions.DFTResultRepair;

  Edit12.Text:=TCC.ConfigOptions.DFTFail1;
  Edit13.Text:=TCC.ConfigOptions.DFTFail2;
  Edit14.Text:=TCC.ConfigOptions.DFTFail3;
  Edit15.Text:=TCC.ConfigOptions.DFTFail4;
  Edit16.Text:=TCC.ConfigOptions.DFTFailRepair;

  Edit6.Text:=TCC.ConfigSQl.HIP;
  Edit7.Text:=TCC.ConfigSQl.PConecction;
  Edit8.Text:=TCC.ConfigSQl.DBname;
  Edit9.Text:=TCC.ConfigSQl.User;
  Edit10.Text:=TCC.ConfigSQl.Pass;
  Edit11.Text:=IntToStr(StrToInt(TCC.ConfigOptions.UpdateDelay)div 1000);

  if (TCC.ConfigOptions.EnableRemoteControl='true') then
  begin
    CheckBox1.Checked:=true;
  end
  else
  begin
    CheckBox1.Checked:=false;
  end;

  if (TCC.Encrypted)then
  begin
    CheckBox2.Checked:=true;
  end
  else
  begin
    CheckBox2.Checked:=false;
  end;
end;

procedure TFormOptions.ReturnConfig(out CCF:TCustomConfig);
begin
   CCF.ConfigOptions.DFTResult1:=Edit1.Text;
   CCF.ConfigOptions.DFTResult2:=Edit2.Text;
   CCF.ConfigOptions.DFTResult3:=Edit3.Text;
   CCF.ConfigOptions.DFTResult4:=Edit4.Text;
   CCF.ConfigOptions.DFTResultRepair:=Edit5.Text;

   CCF.ConfigOptions.DFTFail1:=Edit12.Text;
   CCF.ConfigOptions.DFTFail2:=Edit13.Text;
   CCF.ConfigOptions.DFTFail3:=Edit14.Text;
   CCF.ConfigOptions.DFTFail4:=Edit15.Text;
   CCF.ConfigOptions.DFTFailRepair:=Edit16.Text;

   CCF.ConfigSQl.HIP:=Edit6.Text;
   CCF.ConfigSQl.PConecction:=Edit7.Text;
   CCF.ConfigSQl.DBname:=Edit8.Text;
   CCF.ConfigSQl.User:=Edit9.Text;
   CCF.ConfigSQl.Pass:=Edit10.Text;
   CCF.ConfigOptions.UpdateDelay:=IntToStr(StrToInt(Edit11.Text)*1000);

   if CheckBox1.Checked then
   begin
      CCF.ConfigOptions.EnableRemoteControl:='true';
   end
   else
   begin
      CCF.ConfigOptions.EnableRemoteControl:='false';
   end;
   CCF.Encrypted:=CheckBox2.Checked;
end;

procedure TFormOptions.LoadConfig(TCmCfg:TCustomConfig);
begin
   TCC:=TCmCfg;
   LoadValuesIntoControls;
end;

end.

