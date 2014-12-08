unit customconfig;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,IniPropStorage,ucrypto;

type

  {ConfigSQL}
  TConfigSQL=record
    Databasetype:string;
    HIP:string;
    PConecction:string;
    DBname:string;
    User:string;
    Pass:string;
  end;

  {ConfigExtraOptions}
  TConfigOptions = record
    DFTResult1:string;
    DFTResult2:string;
    DFTResult3:string;
    DFTResult4:string;
    DFTResultRepair:string;

    DFTFail1:string;
    DFTFail2:string;
    DFTFail3:string;
    DFTFail4:string;
    DFTFailRepair:string;

    UpdateDelay:string;
    EnableRemoteControl:string;
    EqId:string;
  end;

  {ConfigBackupOptions}
  TConfigBKPOptions = record
    VDate:string;
    VLastBkp:string;
    VHour:string;
    VRepeat:string;
    VOlder:string;
    EnableBKP:string;
  end;

  {CustomConfig}
  TCustomConfig=class
    private
      IniPropStorageConnection: TIniPropStorage;
      REncrypted:boolean;
      RUser:string;
      RPass:string;
      PCr:Pcrypto;
      RCryptoKey:string;

      function EncryptOp(UnencryptedStr:string):string;
      function UnencryptOP(EncryptedStr:string):string;
      function CalculateCryptoKey:string;

    protected
    public
      ConfigSQl:TConfigSQL;
      ConfigOptions:TConfigOptions;
      ConfigBKPOptions:TConfigBKPOptions;

      procedure SaveConfigIniFile;
      procedure ReadConfigIniFile;
      procedure CreateCryptoKey;
      function CheckForUserAndPas:boolean;

      property Encrypted:boolean read REncrypted write REncrypted;
      property User:string read RUser write RUser;
      property Pass:string read RPass write RPass;
      property CryptoKey:string read RCryptoKey;

      Constructor Create();
      destructor Free;
  end;

implementation

procedure TCustomConfig.ReadConfigIniFile;
begin
  IniPropStorageConnection.IniFileName := 'DFTCheck.ini';
  IniPropStorageConnection.IniSection:='OptionsConfig';
  REncrypted:=IniPropStorageConnection.ReadBoolean('Encripted',false);
  RCryptokey:=IniPropStorageConnection.ReadString('Cryptokey','');
  if ((RPass='')or(RUser='')) then
     exit;
  ConfigOptions.UpdateDelay:=UnencryptOP(IniPropStorageConnection.ReadString('UpdateDelay','30000'));

  ConfigOptions.DFTResult1:=UnencryptOP(IniPropStorageConnection.ReadString('DFTResult1','MES_ResultData1.txt'));
  ConfigOptions.DFTResult2:=UnencryptOP(IniPropStorageConnection.ReadString('DFTResult2','MES_ResultData2.txt'));
  ConfigOptions.DFTResult3:=UnencryptOP(IniPropStorageConnection.ReadString('DFTResult3','MES_ResultData3.txt'));
  ConfigOptions.DFTResult4:=UnencryptOP(IniPropStorageConnection.ReadString('DFTResult4','MES_ResultData4.txt'));
  ConfigOptions.DFTResultRepair:=UnencryptOP(IniPropStorageConnection.ReadString('DFTResultRepair','MES_ResultData5.txt'));

  ConfigOptions.DFTFail1:=UnencryptOP(IniPropStorageConnection.ReadString('DFTFail1','MES_StepData1.txt'));
  ConfigOptions.DFTFail2:=UnencryptOP(IniPropStorageConnection.ReadString('DFTFail2','MES_StepData2.txt'));
  ConfigOptions.DFTFail3:=UnencryptOP(IniPropStorageConnection.ReadString('DFTFail3','MES_StepData3.txt'));
  ConfigOptions.DFTFail4:=UnencryptOP(IniPropStorageConnection.ReadString('DFTFail4','MES_StepData4.txt'));
  ConfigOptions.DFTFailRepair:=UnencryptOP(IniPropStorageConnection.ReadString('DFTFailRepair','MES_StepData5.txt'));

  ConfigOptions.EnableRemoteControl:=UnencryptOP(IniPropStorageConnection.ReadString('EnableRControl','false'));
  ConfigOptions.EqId:=UnencryptOP(IniPropStorageConnection.ReadString('EquipmentId','Unknown'));

  IniPropStorageConnection.IniSection := 'SQLConfig';
  ConfigSQl.Databasetype:=UnencryptOP(IniPropStorageConnection.ReadString('DatabaseType','mysql-5'));
  ConfigSQl.HIP:=UnencryptOP(IniPropStorageConnection.ReadString('HostIP', '192.168.1.3'));
  ConfigSQl.PConecction:=UnencryptOP(IniPropStorageConnection.ReadString('SQLPort', '3306'));
  ConfigSQl.DBname:=UnencryptOP(IniPropStorageConnection.ReadString('DatabaseName', 'DFT'));
  ConfigSQl.User:=UnencryptOP(IniPropStorageConnection.ReadString('User', 'pabliten'));
  ConfigSQl.Pass:=UnencryptOP(IniPropStorageConnection.ReadString('Password', 'wizard'));

  IniPropStorageConnection.IniSection:='BKPOptions';
  ConfigBKPOptions.VDate:=UnencryptOP(IniPropStorageConnection.ReadString('InitialDate','07/12/2014'));
  ConfigBKPOptions.VLastBkp:=UnencryptOP(IniPropStorageConnection.ReadString('LastBackup','07/12/2014'));
  ConfigBKPOptions.VHour:=UnencryptOP(IniPropStorageConnection.ReadString('InitialHour','02:00'));
  ConfigBKPOptions.Vrepeat:=UnencryptOP(IniPropStorageConnection.ReadString('Repeat','SEMANAL'));
  ConfigBKPOptions.VOlder:=UnencryptOP(IniPropStorageConnection.ReadString('Antiguedad','SEMANAL'));
  ConfigBKPOptions.EnableBKP:=UnencryptOP(IniPropStorageConnection.ReadString('EnableBKP','false'));
end;

procedure TCustomConfig.SaveConfigIniFile;
begin
  IniPropStorageConnection.IniFileName :='DFTCheck.ini';
  IniPropStorageConnection.IniSection := 'SQLConfig';
  IniPropStorageConnection.WriteString('DatabaseType',EncryptOp(ConfigSQl.Databasetype));
  IniPropStorageConnection.WriteString('HostIP',EncryptOp(ConfigSQl.HIP));
  IniPropStorageConnection.WriteString('SQLPort',EncryptOp(ConfigSQl.PConecction));
  IniPropStorageConnection.WriteString('DatabaseName',EncryptOp(ConfigSQl.DBname));
  IniPropStorageConnection.WriteString('User',EncryptOp(ConfigSQl.User));
  IniPropStorageConnection.WriteString('Password',EncryptOp(ConfigSQl.Pass));

  IniPropStorageConnection.IniSection:='OptionsConfig';
  IniPropStorageConnection.WriteBoolean('Encripted',REncrypted);
  IniPropStorageConnection.WriteString('UpdateDelay',EncryptOp(ConfigOptions.UpdateDelay));

  IniPropStorageConnection.WriteString('DFTResult1',EncryptOp(ConfigOptions.DFTResult1));
  IniPropStorageConnection.WriteString('DFTResult2',EncryptOp(ConfigOptions.DFTResult2));
  IniPropStorageConnection.WriteString('DFTResult3',EncryptOp(ConfigOptions.DFTResult3));
  IniPropStorageConnection.WriteString('DFTResult4',EncryptOp(ConfigOptions.DFTResult4));
  IniPropStorageConnection.WriteString('DFTResultRepair',EncryptOp(ConfigOptions.DFTResultRepair));

  IniPropStorageConnection.WriteString('DFTFail1',EncryptOp(ConfigOptions.DFTFail1));
  IniPropStorageConnection.WriteString('DFTFail2',EncryptOp(ConfigOptions.DFTFail2));
  IniPropStorageConnection.WriteString('DFTFail3',EncryptOp(ConfigOptions.DFTFail3));
  IniPropStorageConnection.WriteString('DFTFail4',EncryptOp(ConfigOptions.DFTFail4));
  IniPropStorageConnection.WriteString('DFTFailRepair',EncryptOp(ConfigOptions.DFTFailRepair));

  IniPropStorageConnection.WriteString('EnableRControl',EncryptOp(ConfigOptions.EnableRemoteControl));
  IniPropStorageConnection.WriteString('EquipmentId',EncryptOp(ConfigOptions.EqId));
  CreateCryptoKey;
  IniPropStorageConnection.WriteString('Cryptokey',RCryptokey);

  IniPropStorageConnection.IniSection:='BKPOptions';
  IniPropStorageConnection.WriteString('InitialDate',EncryptOp(ConfigBKPOptions.VDate));
  IniPropStorageConnection.WriteString('LastBackup',EncryptOp(ConfigBKPOptions.VLastBkp));
  IniPropStorageConnection.WriteString('InitialHour',EncryptOp(ConfigBKPOptions.VHour));
  IniPropStorageConnection.WriteString('Repeat',EncryptOp(ConfigBKPOptions.VRepeat));
  IniPropStorageConnection.WriteString('Antiguedad',EncryptOp(ConfigBKPOptions.VOlder));
  IniPropStorageConnection.WriteString('EnableBKP',EncryptOp(ConfigBKPOptions.EnableBKP));
end;

Constructor TCustomConfig.Create();
begin
  IniPropStorageConnection:=TIniPropStorage.Create(nil);
  PCr:=Pcrypto.Create;
  REncrypted:=false;
end;

destructor TCustomConfig.Free;
begin
  IniPropStorageConnection.Free;
end;

function TCustomConfig.EncryptOp(UnencryptedStr:string):string;
var
   EncryptedStr:string;
begin
  if REncrypted then
  begin
    EncryptedStr:=Pcr.Encriptar(RPass,UnencryptedStr);
  end
  else
  begin
    EncryptedStr:=UnencryptedStr;
  end;
  EncryptOp:=EncryptedStr;
end;

function TCustomConfig.UnencryptOp(EncryptedStr:string):string;
var
   UnencryptedStr:string;
begin
   if REncrypted then
   begin
     UnencryptedStr:=Pcr.Desencriptar(RPass,EncryptedStr);
   end
   else
   begin
     UnencryptedStr:=EncryptedStr;
   end;
   UnencryptOp:=UnencryptedStr;
end;

function TCustomConfig.CalculateCryptoKey:string;
begin
  CalculateCryptoKey:=PCr.Encriptar(RPass,RUser);
end;

function TCustomConfig.CheckForUserAndPas:boolean;
begin
   if RCryptoKey = CalculateCryptoKey then
   begin
     CheckForUserAndPas:=true;
   end
   else
   begin
     CheckForUserAndPas:=false;
   end;
end;

procedure TCustomConfig.CreateCryptoKey;
begin
   RCryptoKey:=CalculateCryptoKey;
end;

end.

