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
    RInputType:integer;

    function CheckOF:boolean;
    function CheckTVModel:boolean;
    function CheckQty:boolean;
  public
    { public declarations }
    property StrValue:string read RStrValue write RStrValue;
    property InputType:integer read RInputType write RInputType;
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
  case RInputType of
       0:begin    // Es una orden de fabricacion
          EditAddInsert.MaxLength:=6;
          Self.Caption:='Ingrese orden de fabricación';
       end;
       1:begin   // Modelo de TV
          EditAddInsert.MaxLength:=0;
          self.Caption:='Ingrese el modelo de TV';
       end;
       2:begin   // Cantidad de placas a producir
         EditAddInsert.MaxLength:=4;
         Self.Caption:='Ingrese la cantidad de placas a producir';
       end;
  end;
end;

procedure TFormAddInsert.SpeedButtonOKClick(Sender: TObject);
var
  CHKresult:boolean;
begin
  case RInputType of
       0:begin    // Es una orden de fabricacion
          CHKresult:=CheckOF;
       end;
       1:begin   // Modelo de TV
          CHKresult:=CheckTVModel;
       end;
       2:begin   // Cantidad de placas a producir
         CHKresult:=CheckQty;
       end;
  end;

  if CHKresult=true then
  begin
       self.Close;
       ModalResult:=mrOK;
  end;
end;

function TFormAddInsert.CheckOF:boolean;
var
  tmp:integer;
begin
  if ((Length(EditAddInsert.Text)=6)and(TryStrToInt(EditAddInsert.Text,tmp))) then
  begin
       RStrValue:=EditAddInsert.Text;
       CheckOF:=true;
  end
  else
  begin
       MessageDlg('Error','El formato de la orden de fabricacion es un numero de 6 digitos!',mtError,[mbOK],0);
       EditAddInsert.SelectAll;
       EditAddInsert.SetFocus;
       CheckOF:=false;
  end;
end;

function TFormAddInsert.CheckTVModel:boolean;
begin
   RStrValue:=EditAddInsert.Text;
   CheckTVModel:=true;
end;

function TFormAddInsert.CheckQty:boolean;
var
  tmp:integer;
begin
  if ((Length(EditAddInsert.Text)<=4)and(TryStrToInt(EditAddInsert.Text,tmp))) then
  begin
       if tmp>0 then
       begin
            RStrValue:=EditAddInsert.Text;
            CheckQty:=true;
       end
       else
       begin
            MessageDlg('Error','La cantidad es un número entre 1 y 9999!',mtError,[mbOK],0);
            EditAddInsert.SelectAll;
            EditAddInsert.SetFocus;
            CheckQty:=false;
       end;
  end
  else
  begin
       MessageDlg('Error','Se debe ingresar un número entero válido!',mtError,[mbOK],0);
       EditAddInsert.SelectAll;
       EditAddInsert.SetFocus;
       CheckQty:=false;
  end;
end;

end.

