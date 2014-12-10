unit fmOfSerieRepeat;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls;

type

  { TFormOFRepeated }

  TFormOFRepeated = class(TForm)
    Label1: TLabel;
    TimerWarning: TTimer;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure TimerWarningTimer(Sender: TObject);
  private
    { private declarations }
    CountClose:integer;
  public
    { public declarations }
  end;

var
  FormOFRepeated: TFormOFRepeated;

implementation

{$R *.lfm}

{ TFormOFRepeated }

procedure TFormOFRepeated.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  TimerWarning.Enabled:=false;
  CountClose:=0;
end;

procedure TFormOFRepeated.FormShow(Sender: TObject);
begin
  TimerWarning.Enabled:=true;
end;

procedure TFormOFRepeated.TimerWarningTimer(Sender: TObject);
begin
   CountClose:=CountClose+1;
   if CountClose >= 3 then
   begin
     Close;
   end;
end;

end.

