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
    procedure EditAddInsertKeyPress(Sender: TObject; var Key: char);
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
    function InputProcess:integer;
    function CheckValidOfSerial:boolean;
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
       1:begin    // Es una orden de fabricacion
          EditAddInsert.MaxLength:=6;
          Self.Caption:='Ingrese orden de fabricación';
       end;
       2:begin   // Modelo de TV
          EditAddInsert.MaxLength:=0;
          self.Caption:='Ingrese el modelo de TV';
       end;
       3:begin   // Cantidad de placas a producir
         EditAddInsert.MaxLength:=4;
         Self.Caption:='Ingrese la cantidad de placas a producir';
       end;
       4:begin   // Es un serial valido de una placa
         EditAddInsert.MaxLength:=11;
         Self.Caption:='Ingrese el serial de la PCB';
       end;
  end;
end;

procedure TFormAddInsert.EditAddInsertKeyPress(Sender: TObject; var Key: char);
var
  CHKresult:boolean;
begin
  if integer(Key)=13 then
  begin
      case InputProcess of
       1:begin
          Close;
          ModalResult:=mrOK;
       end;
       2:begin
          Close;
          ModalResult:=mrOK;
       end;
       3:begin
          Close;
          ModalResult:=mrOK;
       end;
       4:begin
          Close;
          ModalResult:=mrOK;
       end;
     end;
  end;
end;

procedure TFormAddInsert.SpeedButtonOKClick(Sender: TObject);
var
  CHKresult:boolean;
begin
  case InputProcess of
       1:begin
          Close;
          ModalResult:=mrOK;
       end;
       2:begin
          Close;
          ModalResult:=mrOK;
       end;
       3:begin
          Close;
          ModalResult:=mrOK;
       end;
       4:begin
          Close;
          ModalResult:=mrOK;
       end;
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

function TFormAddInsert.InputProcess:integer;
var
  CHKresult:integer;
begin
  CHKresult:=0;
  case RInputType of
       1:begin    // Es una orden de fabricacion
          if CheckOF then
             CHKresult:=1;
       end;
       2:begin   // Modelo de TV
          if CheckTVModel then
             CHKresult:=2;
       end;
       3:begin   // Cantidad de placas a producir
         if CheckQty then
             CHKresult:=3;
       end;
       4:begin
         if CheckValidOfSerial then
            CHKresult:=4;
       end;
  end;
  InputProcess:=CHKresult;
end;

function TFormAddInsert.CheckValidOfSerial:boolean;
var
  tmp:Int64;
begin
  if ((Length(EditAddInsert.Text)=11)and(TryStrToInt64(EditAddInsert.Text,tmp))) then
  begin
       CheckValidOfSerial:=true;
  end
  else
  begin
        MessageDlg('Error','Debe ingresar una orden de fabricación válida!',mtError,[mbOK],0);
        EditAddInsert.SelectAll;
        EditAddInsert.SetFocus;
       CheckValidOfSerial:=false;
  end;
end;

end.

