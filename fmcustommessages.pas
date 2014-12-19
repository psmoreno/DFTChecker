unit fmcustommessages;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls;

type

  { TFormCustomMessages }

  TFormCustomMessages = class(TForm)
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
  FormCustomMessages: TFormCustomMessages;

implementation

{$R *.lfm}

{ TFormCustomMessages }

procedure TFormCustomMessages.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  RTimerEnabled:=false;
  TimerWarning.Enabled:=false;
  CountClose:=0;
end;

procedure TFormCustomMessages.FormCreate(Sender: TObject);
begin
  RTimerEnabled:=false;
end;

procedure TFormCustomMessages.FormShow(Sender: TObject);
begin
  TimerWarning.Enabled:=true;
  if RTimerEnabled then
  begin
     Self.Caption:='AVISO: Serial de TV ya utilizado';
     LabelWarning.Caption:='Esta placa ya ha sido ingresada a la OF.';
  end
  else
  begin
     Self.Caption:='Realizando backups';
     LabelWarning.Caption:='Realizando backup, espere un momento...';
  end;
end;

procedure TFormCustomMessages.TimerWarningTimer(Sender: TObject);
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

