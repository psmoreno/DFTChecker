unit fmOfSerieRepeat;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls;

type

  { TFormOFRepeated }

  TFormOFRepeated = class(TForm)
    LabelWarning: TLabel;
    TimerWarning: TTimer;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerWarningTimer(Sender: TObject);
  private
    { private declarations }
    CountClose:integer;
    RTimerEnabled:boolean;
  public
    { public declarations }
    property TimerEnabled:boolean read RTimerEnabled write RTimerEnabled;
  end;

var
  FormOFRepeated: TFormOFRepeated;

implementation

{$R *.lfm}

{ TFormOFRepeated }

procedure TFormOFRepeated.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  RTimerEnabled:=false;
  TimerWarning.Enabled:=false;
  CountClose:=0;
end;

procedure TFormOFRepeated.FormCreate(Sender: TObject);
begin
  RTimerEnabled:=false;
end;

procedure TFormOFRepeated.FormShow(Sender: TObject);
begin
  TimerWarning.Enabled:=true;
  if RTimerEnabled then
  begin
     LabelWarning.Caption:='Esta placa ya ha sido ingresada a la OF.';
  end
  else
  begin
     LabelWarning.Caption:='Realizando backup, espere un momento...';
  end;
end;

procedure TFormOFRepeated.TimerWarningTimer(Sender: TObject);
begin
   if RTimerEnabled then
   begin
      CountClose:=CountClose+1;
      if CountClose >= 3 then
      begin
           Close;
      end;
   end;
end;

end.

