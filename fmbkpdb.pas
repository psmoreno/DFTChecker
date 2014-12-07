unit fmbkpdb;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,customconfig;

type
  TFormBkpDB = class(TForm)
  private
    { private declarations }
    CCF:TCustomConfig;
  public
    { public declarations }
    procedure LoadConfig(TCmCfg:TCustomConfig);
  end;

var
  FormBkpDB: TFormBkpDB;

implementation

{$R *.lfm}

procedure TFormBkpDB.LoadConfig(TCmCfg:TCustomConfig);
begin
  CCF:=TCmCfg;
end;

end.

