unit fmaddinsert;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons;

type

  { TFormAddInsert }

  TFormAddInsert = class(TForm)
    EditAddInsert: TEdit;
    PanelAddInsert: TPanel;
    SpeedButtonOK: TSpeedButton;
    SpeedButtonCancel: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure SpeedButtonCancelClick(Sender: TObject);
    procedure SpeedButtonOKClick(Sender: TObject);
  private
    { private declarations }
    RStrValue:string;
    RIsAnOf:boolean;
  public
    { public declarations }
    property StrValue:string read RStrValue write RStrValue;
    property IsAnOF:boolean read RIsAnOf write RIsAnOf;
  end;

var
  FormAddInsert: TFormAddInsert;

implementation

{$R *.lfm}

{ TFormAddInsert }

procedure TFormAddInsert.SpeedButtonCancelClick(Sender: TObject);
begin
  self.Close;
  ModalResult:=mrCancel;
end;

procedure TFormAddInsert.FormShow(Sender: TObject);
begin
  EditAddInsert.Text:=RStrValue;
  if RIsAnOf then
  begin
     EditAddInsert.MaxLength:=6;
  end
  else
  begin
     EditAddInsert.MaxLength:=0;
  end;
end;

procedure TFormAddInsert.SpeedButtonOKClick(Sender: TObject);
var
  tmp:integer;
begin
  if RIsAnOF then
  begin
     if ((Length(EditAddInsert.Text)=6)and(TryStrToInt(EditAddInsert.Text,tmp))) then
     begin
       RStrValue:=EditAddInsert.Text;
       self.Close;
       ModalResult:=mrOK;
     end
     else
     begin
       MessageDlg('Error','El formato de la orden de fabricacion es un numero de 6 digitos!',mtError,[mbOK],0);
       EditAddInsert.SelectAll;
       EditAddInsert.SetFocus;
     end;
  end
  else
  begin
     RStrValue:=EditAddInsert.Text;
     self.Close;
     ModalResult:=mrOK;
  end;
end;

end.

