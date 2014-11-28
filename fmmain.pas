unit fmmain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, LR_Desgn, LR_View, LazHelpCHM, ZDataset,
  ZConnection, Forms, Controls, Graphics, Dialogs, Menus, ComCtrls, StdCtrls,
  DBGrids, Buttons, ExtCtrls, ActnList, LazHelpHTML, fmOF, fmModels, fmlinks,
  fmoptions, fmKanbam, fmabout, fmnewbox, fmclosebox, HelpIntfs, customconfig,
  fmIntro, LResources, LR_Class;

type

  { TFormPrincipal }

  TFormPrincipal = class(TForm)
    ActionPrintPallet: TAction;
    ActionAbout: TAction;
    ActionHelp: TAction;
    ActionExit: TAction;
    ActionConfig: TAction;
    ActionOFLink: TAction;
    ActionNewBox: TAction;
    ActionCloseBox: TAction;
    ActionPrintKB: TAction;
    ActionChkPCB: TAction;
    ActionEditOF: TAction;
    ActionEditModels: TAction;
    ActionListPrincipal: TActionList;
    BitBtnAddBox: TBitBtn;
    BitBtnCloseBox: TBitBtn;
    BitBtnPrintKB: TBitBtn;
    DataSourcePrincipal: TDataSource;
    DBGridPrincipal: TDBGrid;
    EditPCB: TEdit;
    frReportMain: TfrReport;
    GroupBoxQuery: TGroupBox;
    GroupBoxDB: TGroupBox;
    GroupBoxPrincipal: TGroupBox;
    HTMLBrowserHelpViewerMain: THTMLBrowserHelpViewer;
    HTMLHelpDatabaseMain: THTMLHelpDatabase;
    ImageListPrincipal16: TImageList;
    ImageListPrincipal32: TImageList;
    ImageResult: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LabelOF: TLabel;
    LabelModel: TLabel;
    LabelIDBOX: TLabel;
    Label7: TLabel;
    LabelQty: TLabel;
    Label9: TLabel;
    MainMenuPrincipal: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    SpeedButtonCheck: TSpeedButton;
    TimerMain: TTimer;
    ToolBarPrincipal: TToolBar;
    ToolButton1: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ZConnectionPrincipal: TZConnection;
    ZQueryPrincipal: TZQuery;
    procedure ActionAboutExecute(Sender: TObject);
    procedure ActionChkPCBExecute(Sender: TObject);
    procedure ActionCloseBoxExecute(Sender: TObject);
    procedure ActionConfigExecute(Sender: TObject);
    procedure ActionEditModelsExecute(Sender: TObject);
    procedure ActionEditOFExecute(Sender: TObject);
    procedure ActionExitExecute(Sender: TObject);
    procedure ActionHelpExecute(Sender: TObject);
    procedure ActionNewBoxExecute(Sender: TObject);
    procedure ActionOFLinkExecute(Sender: TObject);
    procedure ActionPrintKBExecute(Sender: TObject);
    procedure EditPCBKeyPress(Sender: TObject; var Key: char);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure TimerMainTimer(Sender: TObject);
  private
    { private declarations }
    FI:TFormIntro;
    CCF:TCustomConfig;
    IsInExecution:boolean;
    TotalCount:integer;
    CurrentCount:integer;
    OrderActive:boolean;

    procedure LoadFormOptions(MdResult:integer);
    procedure RecordDFTResults(FilePath:string);
    procedure BackupAllRecords;
    procedure ExtractResources;
    procedure RegisterWrongPCB;
  public
    { public declarations }
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.lfm}

{ TFormPrincipal }

procedure TFormPrincipal.ActionEditOFExecute(Sender: TObject);
var
  Result:integer;
begin
  FI.LoadConfig(CCF);
  Result:=FI.ShowModal;
  case Result of
       mrCancel:begin
          exit;
       end;
       mrOK:begin
          FormOF.LoadConfig(CCF);
          FormOF.ShowModal;
       end;
       mrYes:begin
          FormOF.LoadConfig(CCF);
          FormOF.ShowModal;
       end;
  end;
end;

procedure TFormPrincipal.ActionExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TFormPrincipal.ActionHelpExecute(Sender: TObject);
begin
  ShowHelpOrErrorForKeyword('','Help\index.html');
end;

procedure TFormPrincipal.ActionNewBoxExecute(Sender: TObject);
var
  strpos:string;
begin
  FormNewBox.LoadConfig(CCF);
  if FormNewBox.ShowModal=mrOK then
  begin
     LabelOF.Caption:='OF'+FormNewBox.OFb;
     LabelModel.Caption:=FormNewBox.Model;
     TotalCount:=FormNewBox.Qty;
     strpos:=IntToStr(TotalCount);
     LabelQty.Caption:='00/'+copy('00',0,2-Length(strPos))+strPos;
     strPos:=IntToStr(FormNewBox.Nbox);;
     LabelIDBOX.Caption:='OF'+FormNewBox.OFb+copy('0000',0,4-Length(strPos))+strPos;
     ActionCloseBox.Enabled:=true;
     ActionNewBox.Enabled:=false;
     ActionChkPCB.Enabled:=true;
     EditPCB.Enabled:=true;
     ImageResult.Visible:=true;

     ZQueryPrincipal.Close;
     ZQueryPrincipal.SQL.Text:='TRUNCATE TABLE controlpcb';
     ZQueryPrincipal.ExecSQL;
     ZQueryPrincipal.SQL.Clear;
     ZQueryPrincipal.SQL.Text:='SELECT * FROM Controlpcb';
     ZQueryPrincipal.Open;
     CurrentCount:=0;

     IsInExecution:=true;
     OrderActive:=true;//timer 's independent semaphore
  end;
end;

procedure TFormPrincipal.ActionOFLinkExecute(Sender: TObject);
var
  Result:integer;
begin
  FI.LoadConfig(CCF);
  Result:=FI.ShowModal;
  case Result of
       mrCancel:begin
          exit;
       end;
       mrOK:begin
          FormLinks.LoadConfig(CCF);
          FormLinks.ShowModal;
       end;
       mrYes:begin
          FormLinks.LoadConfig(CCF);
          FormLinks.ShowModal;
       end;
  end;
end;

procedure TFormPrincipal.ActionPrintKBExecute(Sender: TObject);
begin
  FormKanbam.ShowModal;
end;

procedure TFormPrincipal.EditPCBKeyPress(Sender: TObject; var Key: char);
begin
  if Integer(key)=13 then
  begin
     ActionChkPCBExecute(self);
  end;
end;

procedure TFormPrincipal.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  ZQueryPrincipal.Close;
  ZConnectionPrincipal.Disconnect;
end;

procedure TFormPrincipal.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  If OrderActive then
  Begin;
      CanClose := not OrderActive;
      MessageDlg('Antes de Cerrar la aplicación debe terminar de completar la Caja.', mtinformation, [mbOK],0);
  end;
end;

procedure TFormPrincipal.FormCreate(Sender: TObject);
var
  Result:integer;
begin
   CCF:= TCustomConfig.Create;
   FI:=TFormIntro.Create(self);

   CCF.ReadConfigIniFile;
   if CCF.Encrypted and((CCF.User='')or(CCF.Pass=''))then
   begin
      FI.LoadConfig(CCF);
      Result:=FI.ShowModal;
      case Result of
           mrCancel:begin
               Application.Terminate;
           end;
           mrOK:begin
               FI.ReturnConfig(CCF);
               CCF.ReadConfigIniFile;
           end;
           mrYes:begin
               Application.Terminate;
           end;
      end;
   end;

   if (CCF.ConfigOptions.EnableRemoteControl='true') then
   begin
       {Remote:=TRemoteOperation.Create(true);
       Remote.FreeOnTerminate:=true;
       Remote.Databasetype:=CCF.ConfigSQl.Databasetype;
       Remote.HostIP:=CCF.ConfigSQl.HIP;
       Remote.PConecction:=StrToInt(CCF.ConfigSQl.PConecction);
       Remote.DBname:=CCF.ConfigSQl.DBname;
       Remote.User:=CCF.ConfigSQl.User;
       Remote.Pass:=CCF.ConfigSQl.Pass;
       Remote.TableName:=CCF.ConfigSQl.TableName;
       Remote.IDRecord:='vsector';
       Remote.strIDRecord:=Trim(UpperCase(CCF.ConfigSQl.AreaInformation));
       Remote.OnShowRemoteOpEvent:=@ShowRemoteOp;
       Remote.Start;}
   end;

   TimerMain.Interval:=StrToInt(CCF.ConfigOptions.UpdateDelay);
   TimerMain.Enabled:=true;
   IsInExecution:=false;
   ImageResult.Visible:=false;
   LabelOF.Caption:='';
   LabelModel.Caption:='';
   LabelIDBOX.Caption:='';
   LabelQty.Caption:='  /  ';

   ZConnectionPrincipal.HostName:=CCF.ConfigSQl.HIP;
   ZConnectionPrincipal.Port:=StrToInt(CCF.ConfigSQl.PConecction);
   ZConnectionPrincipal.Protocol:=CCF.ConfigSQl.Databasetype;
   ZConnectionPrincipal.Database:=CCF.ConfigSQl.DBname;
   ZConnectionPrincipal.User:=CCF.ConfigSQl.User;
   ZConnectionPrincipal.Password:=CCF.ConfigSQl.Pass;
   ZQueryPrincipal.Connection:=ZConnectionPrincipal;
   DataSourcePrincipal.DataSet:=ZQueryPrincipal;
   ZQueryPrincipal.SQL.Text:='SELECT * FROM Controlpcb';
   ExtractResources;
   OrderActive:=false;
   try
     ZConnectionPrincipal.Connect;
     ZQueryPrincipal.Active:=true;
   except
     MessageDlg('Advertencia','No se encontró una conexion SQL disponible, funcionalidad limitada!',
     mtWarning,[mbOK],0);
   end;
end;

procedure TFormPrincipal.TimerMainTimer(Sender: TObject);
begin
  if ((IsInExecution=true) and (OrderActive=true)) then
  begin
    if FileExistsUTF8(CCF.ConfigOptions.DFTResult1) then
    begin
       RecordDFTResults(CCF.ConfigOptions.DFTResult1);
    end;

    if FileExistsUTF8(CCF.ConfigOptions.DFTResult2) then
    begin
       RecordDFTResults(CCF.ConfigOptions.DFTResult2);
    end;

    if FileExistsUTF8(CCF.ConfigOptions.DFTResult3) then
    begin
       RecordDFTResults(CCF.ConfigOptions.DFTResult3);
    end;

    if FileExistsUTF8(CCF.ConfigOptions.DFTResult4) then
    begin
       RecordDFTResults(CCF.ConfigOptions.DFTResult4);
    end;

    if FileExistsUTF8(CCF.ConfigOptions.DFTResultRepair) then
    begin
       RecordDFTResults(CCF.ConfigOptions.DFTResultRepair);
    end;
  end;
end;

procedure TFormPrincipal.ActionEditModelsExecute(Sender: TObject);
var
  Result:integer;
begin
  FI.LoadConfig(CCF);
  Result:=FI.ShowModal;
  case Result of
       mrCancel:begin
          exit;
       end;
       mrOK:begin
          FormModels.LoadConfig(CCF);
          FormModels.ShowModal;
       end;
       mrYes:begin
          FormModels.LoadConfig(CCF);
          FormModels.ShowModal;
       end;
  end;
end;

procedure TFormPrincipal.ActionConfigExecute(Sender: TObject);
var
  Result:integer;
begin
  FI.LoadConfig(CCF);
  Result:=FI.ShowModal;
  case Result of
       mrCancel:begin
          exit;
       end;
       mrOK:begin
          LoadFormOptions(mrOK);
       end;
       mrYes:begin
          LoadFormOptions(mrYes);
       end;
  end;
end;

procedure TFormPrincipal.ActionAboutExecute(Sender: TObject);
begin
 FormAbout.ShowModal;
end;

procedure TFormPrincipal.ActionChkPCBExecute(Sender: TObject);
var
  ZQueryLoadPCBinPallet:TZQuery;
  ZConnectionLoadPCBinPallet:TZConnection;
  strCount:string;
begin
  self.IsInExecution:=false;
  ZConnectionLoadPCBinPallet:=TZConnection.Create(nil);
  ZQueryLoadPCBinPallet:=TZQuery.Create(nil);

  ZConnectionLoadPCBinPallet.HostName:=CCF.ConfigSQl.HIP;
  ZConnectionLoadPCBinPallet.Port:=StrToInt(CCF.ConfigSQl.PConecction);
  ZConnectionLoadPCBinPallet.Protocol:=CCF.ConfigSQl.Databasetype;
  ZConnectionLoadPCBinPallet.Database:=CCF.ConfigSQl.DBname;
  ZConnectionLoadPCBinPallet.User:=CCF.ConfigSQl.User;
  ZConnectionLoadPCBinPallet.Password:=CCF.ConfigSQl.Pass;
  ZQueryLoadPCBinPallet.Connection:=ZConnectionLoadPCBinPallet;
  ZQueryLoadPCBinPallet.SQL.Text:='SELECT * FROM dftresults WHERE OfSerie LIKE '''+
  EditPCB.Text +'''';
  ZConnectionLoadPCBinPallet.Connect;
  ZQueryLoadPCBinPallet.Open;
  if ZQueryLoadPCBinPallet.RecordCount>0 then
  begin
     ZQueryLoadPCBinPallet.Last;
     if ZQueryLoadPCBinPallet.FieldByName('Result').AsString='OK' then
     begin
       ZQueryPrincipal.Close;
       ZQueryPrincipal.SQL.Text:='SELECT * FROM controlpcb WHERE OfSerial LIKE '''+
       EditPCB.Text+'''';
       ZQueryPrincipal.Open;
       if ZQueryPrincipal.RecordCount = 0 then
       begin
            ImageResult.Picture.LoadFromLazarusResource('OK');
            ImageResult.Visible:=true;
            ZQueryPrincipal.Append;
            ZQueryPrincipal.FieldByName('BPRdate').AsString:=DateToStr(date);
            ZQueryPrincipal.FieldByName('BPRhour').AsString:=TimeToStr(now);
            ZQueryPrincipal.FieldByName('OfSerial').AsString:=EditPCB.Caption;
            ZQueryPrincipal.FieldByName('ModelName').AsString:=LabelModel.Caption;
            ZQueryPrincipal.CommitUpdates;
            CurrentCount:=CurrentCount+1;
            strCount:=IntToStr(CurrentCount);
            LabelQty.Caption:=Copy('00',0,2-Length(strCount))+strCount+Copy(LabelQty.Caption,3,5);
            if CurrentCount = TotalCount then
            begin
                 EditPCB.Enabled:=false;
                 ActionChkPCB.Enabled:=false;
                 ActionCloseBoxExecute(self);
            end;

       end
       else
       begin
         ShowMessage('Esta placa ya sido ingresada');
         ImageResult.Picture.LoadFromLazarusResource('OK');
         ImageResult.Visible:=true;
       end;
       ZQueryPrincipal.Close;
       ZQueryPrincipal.SQL.Text:='SELECT * FROM controlpcb';
       ZQueryPrincipal.Open;
     end
     else
     begin
       RegisterWrongPCB;
       ImageResult.Picture.LoadFromLazarusResource('NG');
       ImageResult.Visible:=true;
     end;
  end
  else
  begin
     ImageResult.Picture.LoadFromLazarusResource('NT');
     ImageResult.Visible:=true;
  end;
  ZQueryLoadPCBinPallet.Close;
  ZConnectionLoadPCBinPallet.Disconnect;
  if EditPCB.Enabled then
  begin
       EditPCB.SelectAll;
       EditPCB.SetFocus;
  end;
  self.IsInExecution:=true;
end;

procedure TFormPrincipal.ActionCloseBoxExecute(Sender: TObject);
begin
  FormCloseBox.LoadConfig(CCF);
  FormCloseBox.strOF:=Self.LabelIDBOX.Caption;
  FormCloseBox.PCBQty:=Self.LabelQty.Caption;
  if FormCloseBox.ShowModal=mrOK then
  begin
     IsInExecution:=false;
     OrderActive:=false;
     ActionCloseBox.Enabled:=false;
     ActionNewBox.Enabled:=true;
     ActionChkPCB.Enabled:=false;
     EditPCB.Enabled:=false;
     ImageResult.Visible:=false;
     LabelOF.Caption:='';
     LabelModel.Caption:='';
     LabelIDBOX.Caption:='';
     LabelQty.Caption:='  /  ';
     BackupAllRecords;
  end;
end;

procedure TFormPrincipal.LoadFormOptions(MdResult:integer);
begin
  CCF.ReadConfigIniFile;
  FormOptions.LoadConfig(CCF);
  if FormOptions.ShowModal = mrOk then
  begin
    FormOptions.ReturnConfig(CCF);
    TimerMain.Enabled:=false;
    TimerMain.Interval:=StrToInt(CCF.ConfigOptions.UpdateDelay);
    TimerMain.Enabled:=true;
    if MdResult=mrYes then
    begin
      CCF.Encrypted:=true;
    end;
    CCF.SaveConfigIniFile;
  end;
end;

procedure TFormPrincipal.RecordDFTResults(FilePath:string);
const
  debug=0;
var
  Cadenas:TStringList;
  Componentes:TStringList;
  i,k:integer;
  strSqlRecord:string;
  ZQueryLoadDFTRecords:TZQuery;
  ZConnectionLoadDFTRrecords:TZConnection;
begin
  self.IsInExecution:=false; //stop a while the timer

  Cadenas:=TStringList.Create;
  Componentes:=TStringList.Create;
  ZConnectionLoadDFTRrecords:=TZConnection.Create(nil);
  ZQueryLoadDFTRecords:=TZQuery.Create(nil);

  ZConnectionLoadDFTRrecords.HostName:=CCF.ConfigSQl.HIP;
  ZConnectionLoadDFTRrecords.Port:=StrToInt(CCF.ConfigSQl.PConecction);
  ZConnectionLoadDFTRrecords.Protocol:=CCF.ConfigSQl.Databasetype;
  ZConnectionLoadDFTRrecords.Database:=CCF.ConfigSQl.DBname;
  ZConnectionLoadDFTRrecords.User:=CCF.ConfigSQl.User;
  ZConnectionLoadDFTRrecords.Password:=CCF.ConfigSQl.Pass;
  ZQueryLoadDFTRecords.Connection:=ZConnectionLoadDFTRrecords;
  ZConnectionLoadDFTRrecords.Connect;
  Cadenas.LoadFromFile(FilePath);
  Componentes.Clear;
  if debug=0 then
     Componentes.SaveToFile(FilePath);
  for i:=0 to (Cadenas.Count-1) do
  begin
     Componentes.DelimitedText:=Copy(Cadenas[i],Pos('values(%d',Cadenas[i])+10,Length(Cadenas[i]));
     Componentes.Delimiter:=',';
     for k:=0 to (Componentes.Count-1) do
     begin
        Componentes[k]:=StringReplace(Componentes[k],')','',[rfReplaceAll,rfIgnoreCase]);
        Componentes[k]:=StringReplace(Componentes[k],'(','',[rfReplaceAll,rfIgnoreCase]);
     end;
     strSqlRecord:='INSERT INTO dftresults(OfSerie,Result,TestDate,TestHour,NJig,Line_id,TestTime,Chassis) VALUES ('+
     Componentes[0]+','+Componentes[1]+',"'+DateToStr(date)+'","'+TimeToStr(Now)+'",'+Componentes[2]+','+Componentes[3]+','+
     Componentes[4]+','+Componentes[5]+');';
     ZQueryLoadDFTRecords.SQL.Clear;
     if debug=1 then
     begin
       ShowMessage(strSqlRecord);
     end;
     ZQueryLoadDFTRecords.SQL.Text:=strSqlRecord;
     ZQueryLoadDFTRecords.ExecSQL;
  end;
  Cadenas.Clear;

  ZQueryLoadDFTRecords.Close;
  ZConnectionLoadDFTRrecords.Disconnect;

  self.IsInExecution:=true; // resume the timer
end;

Procedure TFormPrincipal.BackupAllRecords;
var
  ZConnectionBKP:TZConnection;
  ZQueryBKP:TZQuery;
  Counter:integer;
begin
  ZConnectionBKP:=TZConnection.Create(nil);
  ZQueryBKP:=TZQuery.Create(nil);

  ZConnectionBKP.HostName:=CCF.ConfigSQl.HIP;
  ZConnectionBKP.Port:=StrToInt(CCF.ConfigSQl.PConecction);
  ZConnectionBKP.Protocol:=CCF.ConfigSQl.Databasetype;
  ZConnectionBKP.Database:=CCF.ConfigSQl.DBname;
  ZConnectionBKP.User:=CCF.ConfigSQl.User;
  ZConnectionBKP.Password:=CCF.ConfigSQl.Pass;
  ZQueryBKP.Connection:=ZConnectionBKP;
  ZQueryBKP.SQL.Text:='SELECT * FROM tbpr';
  ZConnectionBKP.Connect;
  ZQueryBKP.Open;
  ZQueryPrincipal.Close;
  ZQueryPrincipal.SQL.Text:='SELECT * FROM controlpcb';
  ZQueryPrincipal.Open;
  ZQueryPrincipal.First;
  Counter:=1;
  while (Counter <=ZQueryPrincipal.RecordCount) do
  begin
     ZQueryBKP.Append;
     ZQueryBKP.FieldByName('BPRdate').AsString:=ZQueryPrincipal.FieldByName('BPRdate').AsString;
     ZQueryBKP.FieldByName('BPRhour').AsString:=ZQueryPrincipal.FieldByName('BPRhour').AsString;
     ZQueryBKP.FieldByName('OfSerial').AsString:=ZQueryPrincipal.FieldByName('OfSerial').AsString;
     ZQueryBKP.FieldByName('ModelName').AsString:=ZQueryPrincipal.FieldByName('ModelName').AsString;
     ZQueryBKP.CommitUpdates;
     Counter:=Counter+1;
     ZQueryPrincipal.Next;
  end;
  ZQueryBKP.Close;
  ZConnectionBKP.Disconnect;
end;

procedure TFormPrincipal.ExtractResources;
var
   rs1:TLazarusResourceStream;
begin
     if not FileExists('CreateDB.sql') then
     begin
        rs1 := TLazarusResourceStream.Create('SQL DFT Nuevo',nil);
        {try}
           rs1.SaveToFile('CreateDB.sql');
        {finally}
           rs1.Free;
     end;
end;

procedure TFormPrincipal.RegisterWrongPCB;
var
  ZQueryLoadWrongPCB:TZQuery;
  ZConnectionLoadWrongPCB:TZConnection;

begin
  ZConnectionLoadWrongPCB:=TZConnection.Create(nil);
  ZQueryLoadWrongPCB:=TZQuery.Create(nil);

  ZConnectionLoadWrongPCB.HostName:=CCF.ConfigSQl.HIP;
  ZConnectionLoadWrongPCB.Port:=StrToInt(CCF.ConfigSQl.PConecction);
  ZConnectionLoadWrongPCB.Protocol:=CCF.ConfigSQl.Databasetype;
  ZConnectionLoadWrongPCB.Database:=CCF.ConfigSQl.DBname;
  ZConnectionLoadWrongPCB.User:=CCF.ConfigSQl.User;
  ZConnectionLoadWrongPCB.Password:=CCF.ConfigSQl.Pass;
  ZQueryLoadWrongPCB.Connection:=ZConnectionLoadWrongPCB;
  ZQueryLoadWrongPCB.SQL.Text:='SELECT * FROM wrongpcb';
  ZConnectionLoadWrongPCB.Connect;
  ZQueryLoadWrongPCB.Open;
  ZQueryLoadWrongPCB.Append;

  ZQueryLoadWrongPCB.FieldByName('BPRdate').AsString:=DateToStr(Date);
  ZQueryLoadWrongPCB.FieldByName('BPRhour').AsString:=TimeToStr(Now);
  ZQueryLoadWrongPCB.FieldByName('OfSerial').AsString:=EditPCB.Text;
  ZQueryLoadWrongPCB.FieldByName('ModelName').AsString:=LabelModel.Caption;

  ZQueryLoadWrongPCB.CommitUpdates;
  ZQueryLoadWrongPCB.Close;
  ZConnectionLoadWrongPCB.Disconnect;
end;

initialization
{$I Databases.lrs}
{$I Cresources.lrs}
end.

