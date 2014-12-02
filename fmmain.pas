unit fmmain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil,LR_Desgn,LazHelpCHM, ZDataset, ZConnection,
  Forms, Controls, Graphics, Dialogs, Menus,  ComCtrls, StdCtrls, DBGrids,
  Buttons, ExtCtrls, ActnList, LazHelpHTML, fmOF, fmModels, fmlinks, fmoptions,
  fmsearchdft, fmabout, fmclosebox, HelpIntfs, customconfig,
  fmIntro, LResources, LR_Class;

type

  { TFormPrincipal }

  TFormPrincipal = class(TForm)
    ActionSearchDMS: TAction;
    ActionAbout: TAction;
    ActionHelp: TAction;
    ActionExit: TAction;
    ActionConfig: TAction;
    ActionOFLink: TAction;
    ActionRun: TAction;
    ActionCloseOF: TAction;
    ActionSearchDFT: TAction;
    ActionChkPCB: TAction;
    ActionEditOF: TAction;
    ActionEditModels: TAction;
    ActionListPrincipal: TActionList;
    BitBtnRun: TBitBtn;
    BitBtnCloseOF: TBitBtn;
    BitBtnSearchDFT: TBitBtn;
    BitBtnSearchDNS: TBitBtn;
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
    LabelOFActives: TLabel;
    LabelCountOpDMS: TLabel;
    LabelCountMag: TLabel;
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
    procedure ActionCloseOFExecute(Sender: TObject);
    procedure ActionConfigExecute(Sender: TObject);
    procedure ActionEditModelsExecute(Sender: TObject);
    procedure ActionEditOFExecute(Sender: TObject);
    procedure ActionExitExecute(Sender: TObject);
    procedure ActionHelpExecute(Sender: TObject);
    procedure ActionRunExecute(Sender: TObject);
    procedure ActionOFLinkExecute(Sender: TObject);
    procedure ActionSearchDFTExecute(Sender: TObject);
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
    OrderActive:boolean;
    MagazzineCount:integer;
    CurrentCount:integer;

    procedure LoadFormOptions(MdResult:integer);
    procedure RecordDFTResults(FilePath:string);
    procedure ExtractResources;
    procedure RegisterWrongPCB;
    function CustomFormatNumbers(Value:integer;TotalLenghtofValue:integer):string;
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

procedure TFormPrincipal.ActionRunExecute(Sender: TObject);
const
  Run:boolean=false;

begin
  if Run=false then
  begin
     try
        ZConnectionPrincipal.Connect;
        ZQueryPrincipal.Active:=true;
        LabelOFActives.Caption:=CustomFormatNumbers(ZQueryPrincipal.RecordCount,4);
        LabelCountOpDMS.Caption:=CustomFormatNumbers(0,4);
        LabelCountMag.Caption:=CustomFormatNumbers(0,4);

        ZQueryPrincipal.Close;
        ZQueryPrincipal.SQL.Text:='SELECT * FROM tlinkofmod WHERE Status > 0';
        ZQueryPrincipal.Open;
        if ZQueryPrincipal.RecordCount >0 then
        begin
           ActionChkPCB.Enabled:=true;
           EditPCB.Enabled:=true;
        end
        else
        begin
           ActionChkPCB.Enabled:=false;
           EditPCB.Enabled:=false;
        end;

        IsInExecution:=true;
        OrderActive:=true;

        MagazzineCount:=0;
        CurrentCount:=0;
        ActionRun.Caption:='Detener';
        Run:=true;
     except
           MessageDlg('Advertencia','No se encontró una conexion SQL disponible, funcionalidad limitada!',
           mtWarning,[mbOK],0);
           ActionRun.Caption:='Comenzar';
     end;
  end
  else
  begin
     IsInExecution:=false;
     OrderActive:=false;
     ZQueryPrincipal.Close;
     ZConnectionPrincipal.Disconnect;
     ActionRun.Caption:='Comenzar';
     ActionChkPCB.Enabled:=false;
     EditPCB.Enabled:=false;
     Run:=false;
  end;

  if Run=true then
  begin
     ActionEditOF.Enabled:=false;
     ActionEditModels.Enabled:=false;
     ActionOFLink.Enabled:=false;
     ActionConfig.Enabled:=false;
     BitBtnRun.Color:=clGreen;
  end
  else
  begin
     ActionEditOF.Enabled:=true;
     ActionEditModels.Enabled:=true;
     ActionOFLink.Enabled:=true;
     ActionConfig.Enabled:=true;
     self.Caption:='Sistema de control de Magazzines DFT';
     self.Color:=clDefault;
     BitBtnRun.Color:=clDefault;
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

procedure TFormPrincipal.ActionSearchDFTExecute(Sender: TObject);
var
  Result:integer;
begin
  FI.LoadConfig(CCF);
  Result:=FI.ShowModal;
  if Result=mrOK then
  begin
     FormSearchDFT.LoadConfig(CCF);
     FormSearchDFT.ShowModal;
  end;
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
      MessageDlg('Debe detener la aplicación antes de cerrarla.', mtinformation, [mbOK],0);
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
   LabelOFActives.Caption:='';
   LabelCountOpDMS.Caption:='';
   LabelCountMag.Caption:='';

   ZConnectionPrincipal.HostName:=CCF.ConfigSQl.HIP;
   ZConnectionPrincipal.Port:=StrToInt(CCF.ConfigSQl.PConecction);
   ZConnectionPrincipal.Protocol:=CCF.ConfigSQl.Databasetype;
   ZConnectionPrincipal.Database:=CCF.ConfigSQl.DBname;
   ZConnectionPrincipal.User:=CCF.ConfigSQl.User;
   ZConnectionPrincipal.Password:=CCF.ConfigSQl.Pass;
   ZQueryPrincipal.Connection:=ZConnectionPrincipal;
   DataSourcePrincipal.DataSet:=ZQueryPrincipal;
   ZQueryPrincipal.SQL.Text:='SELECT * FROM tlinkofmod WHERE Status=1';
   ExtractResources;
   OrderActive:=false;
end;

procedure TFormPrincipal.TimerMainTimer(Sender: TObject);
const
  WarningOnLostConnect:integer=0;
begin
  if ((IsInExecution=true) and (OrderActive=true)) then
  begin
    if FileExistsUTF8(CCF.ConfigOptions.DFTResult1) then
    begin
       WarningOnLostConnect:=0;
       RecordDFTResults(CCF.ConfigOptions.DFTResult1);
    end;

    if FileExistsUTF8(CCF.ConfigOptions.DFTResult2) then
    begin
       WarningOnLostConnect:=0;
       RecordDFTResults(CCF.ConfigOptions.DFTResult2);
    end;

    if FileExistsUTF8(CCF.ConfigOptions.DFTResult3) then
    begin
       WarningOnLostConnect:=0;
       RecordDFTResults(CCF.ConfigOptions.DFTResult3);
    end;

    if FileExistsUTF8(CCF.ConfigOptions.DFTResult4) then
    begin
       WarningOnLostConnect:=0;
       RecordDFTResults(CCF.ConfigOptions.DFTResult4);
    end;

    if FileExistsUTF8(CCF.ConfigOptions.DFTResultRepair) then
    begin
       WarningOnLostConnect:=0;
       RecordDFTResults(CCF.ConfigOptions.DFTResultRepair);
    end;

    WarningOnLostConnect:=WarningOnLostConnect+1;
    if WarningOnLostConnect>=5 then
    begin
       self.Caption:='Sistema de control de Magazzines DFT - ERROR DE CONEXION';
       self.Color:=clYellow;
    end
    else
    begin
       self.Caption:='Sistema de control de Magazzines DFT';
       self.Color:=clDefault;
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
  CurCnt:integer;
  ModelName:string;
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
  ZQueryLoadPCBinPallet.SQL.Text:='SELECT * FROM tdftresults WHERE OfSerie LIKE '''+
  EditPCB.Text +'''';
  ZConnectionLoadPCBinPallet.Connect;
  ZQueryLoadPCBinPallet.Open;
  if ZQueryLoadPCBinPallet.RecordCount>0 then
  begin
     ZQueryLoadPCBinPallet.Close;
     ZQueryLoadPCBinPallet.SQL.Text:='SELECT * FROM tdftresults WHERE OfSerie LIKE '''+
     EditPCB.Text +''' AND Result LIKE ''OK''';
     ZQueryLoadPCBinPallet.Open;
     if ZQueryLoadPCBinPallet.RecordCount > 0 then
     begin
       ZQueryPrincipal.Close;
       ZQueryPrincipal.SQL.Text:='SELECT * FROM tdms WHERE OfSerial LIKE '''+
       EditPCB.Text+'''';
       ZQueryPrincipal.Open;
       if ZQueryPrincipal.RecordCount = 0 then
       begin
            ZQueryPrincipal.Close;
            ZQueryPrincipal.SQL.Text:='SELECT * FROM tlinkofmod WHERE Status > 0 AND strOf LIKE '''+
            Copy(EditPCB.Text,0,6)+'''';
            ZQueryPrincipal.Open;
            if ZQueryPrincipal.RecordCount = 1 then
            begin
               CurrentCount:=CurrentCount+1;
               LabelCountOpDMS.Caption:=CustomFormatNumbers(CurrentCount,4);
               LabelCountOpDMS.Caption:=CustomFormatNumbers(CurrentCount,4);

               ZQueryPrincipal.Edit;
               ZQueryPrincipal.FieldByName('ActualCount').AsInteger:=ZQueryPrincipal.FieldByName('ActualCount').AsInteger+1;
               if ((ZQueryPrincipal.FieldByName('ActualCount').AsInteger mod ZQueryPrincipal.FieldByName('Nbox').AsInteger)=0)
               then begin
                ZQueryPrincipal.FieldByName('ActualMagazzine').AsInteger:=ZQueryPrincipal.FieldByName('ActualMagazzine').AsInteger+1;
                MagazzineCount:=MagazzineCount+1;
              end;
              ZQueryPrincipal.CommitUpdates;
              CurCnt:=ZQueryPrincipal.FieldByName('ActualCount').AsInteger;

              ModelName:=ZQueryPrincipal.FieldByName('ModelName').AsString;
              ZQueryPrincipal.Close;
              ZQueryPrincipal.SQL.Text:='SELECT * FROM tdms WHERE OfSerial LIKE '''+ EditPCB.Text+'''';
              ZQueryPrincipal.Open;
              ZQueryPrincipal.Append;
              ZQueryPrincipal.FieldByName('DMSdate').AsString:=DateToStr(date);
              ZQueryPrincipal.FieldByName('DMShour').AsString:=TimeToStr(now);
              ZQueryPrincipal.FieldByName('OfSerial').AsString:=EditPCB.Caption;
              ZQueryPrincipal.FieldByName('ModelName').AsString:=ModelName;
              ZQueryPrincipal.CommitUpdates;

              ZQueryPrincipal.Close;
              ZQueryPrincipal.SQL.Text:='SELECT * FROM tordenf WHERE OrdenF LIKE '''+Copy(EditPCB.Text,0,6)+ '''' ;
              ZQueryPrincipal.Open;
              if ZQueryPrincipal.FieldByName('Qty').AsInteger <= CurCnt then
              begin
                FormCloseOF.LoadConfig(CCF);
                FormCloseOF.strOf:=Copy(EditPCB.Text,0,6);
                FormCloseOF.ShowModal;
              end;

              ZQueryPrincipal.Close;
              ZQueryPrincipal.SQL.Text:='SELECT * FROM tlinkofmod WHERE Status > 0';
              ZQueryPrincipal.Open;

              if ZQueryPrincipal.RecordCount = 0 then
              begin
                ActionRunExecute(nil);
              end;

              ImageResult.Picture.LoadFromLazarusResource('OK');
              ImageResult.Visible:=true;
            end
            else
            begin
              MessageDlg('No pertenece a ninguna orden de fabricacion activa', mtinformation, [mbOK],0);
              ZQueryPrincipal.Close;
              ZQueryPrincipal.SQL.Text:='SELECT * FROM tlinkofmod WHERE Status > 0';
              ZQueryPrincipal.Open;
            end;
       end
       else
       begin
         MessageDlg('Esta placa ya ha sido ingresada', mtinformation, [mbOK],0);
         ImageResult.Picture.LoadFromLazarusResource('OK');
         ImageResult.Visible:=true;
         ZQueryPrincipal.Close;
         ZQueryPrincipal.SQL.Text:='SELECT * FROM tlinkofmod WHERE Status > 0';
         ZQueryPrincipal.Open;
       end;
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

procedure TFormPrincipal.ActionCloseOFExecute(Sender: TObject);
begin
  FormCloseOF.LoadConfig(CCF);
  FormCloseOF.strOf:='';
  if FormCloseOF.ShowModal=mrOK then
  begin
     IsInExecution:=false;
     OrderActive:=false;
     ActionCloseOF.Enabled:=false;
     ActionRun.Enabled:=true;
     ActionChkPCB.Enabled:=false;
     EditPCB.Enabled:=false;
     ImageResult.Visible:=false;
     LabelOFActives.Caption:='';
     LabelCountOpDMS.Caption:='';
     LabelCountMag.Caption:='';
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
  try
     ZConnectionLoadDFTRrecords.Connect;
     Cadenas.LoadFromFile(FilePath);
     Componentes.Clear;
     if debug=0 then
     begin
        Componentes.SaveToFile(FilePath);
     end;
     for i:=0 to (Cadenas.Count-1) do
     begin
          Componentes.DelimitedText:=Copy(Cadenas[i],Pos('values(%d',Cadenas[i])+10,Length(Cadenas[i]));
          Componentes.Delimiter:=',';
          for k:=0 to (Componentes.Count-1) do
          begin
               Componentes[k]:=StringReplace(Componentes[k],')','',[rfReplaceAll,rfIgnoreCase]);
               Componentes[k]:=StringReplace(Componentes[k],'(','',[rfReplaceAll,rfIgnoreCase]);
          end;
          strSqlRecord:='INSERT INTO tdftresults(OfSerie,Result,TestDate,TestHour,NJig,Line_id,TestTime,Chassis) VALUES ('+
          Componentes[0]+','+Componentes[1]+',"'+FormatDateTime('dd-mm-yyyy',date)+'","'+TimeToStr(Now)+'",'+Componentes[2]+','+Componentes[3]+','+
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
  finally
    ZQueryLoadDFTRecords.Close;
    ZConnectionLoadDFTRrecords.Disconnect;
    self.IsInExecution:=true; // resume the timer
  end;
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
  ZQueryLoadWrongPCB.SQL.Text:='SELECT * FROM twrongpcb';
  ZConnectionLoadWrongPCB.Connect;
  ZQueryLoadWrongPCB.Open;
  ZQueryLoadWrongPCB.Append;

  ZQueryLoadWrongPCB.FieldByName('WRdate').AsString:=DateToStr(Date);
  ZQueryLoadWrongPCB.FieldByName('WRhour').AsString:=TimeToStr(Now);
  ZQueryLoadWrongPCB.FieldByName('OfSerial').AsString:=EditPCB.Text;
  ZQueryLoadWrongPCB.FieldByName('ModelName').AsString:=LabelCountOpDMS.Caption;

  ZQueryLoadWrongPCB.CommitUpdates;
  ZQueryLoadWrongPCB.Close;
  ZConnectionLoadWrongPCB.Disconnect;
end;

function TFormPrincipal.CustomFormatNumbers(Value:integer;TotalLenghtofValue:integer):string;
var
  StrResult:string;
  i:integer;
  StrValue:string;
begin
  StrResult:='';
  for i:=1 to TotalLenghtofValue do
  begin
     StrResult:=StrResult+'0';
  end;
  StrValue:=IntToStr(Value);
  StrResult:=Copy(StrResult,0,TotalLenghtofValue-Length(StrValue))+StrValue;
  CustomFormatNumbers:=StrResult;
end;

initialization
{$I Databases.lrs}
{$I Cresources.lrs}
end.

