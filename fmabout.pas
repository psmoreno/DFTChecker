unit fmabout;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls;

type

  { TFormAbout }

  TFormAbout = class(TForm)
    ImageAbout: TImage;
    procedure ImageAboutClick(Sender: TObject);
    procedure ImageAboutDblClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FormAbout: TFormAbout;

implementation

{$R *.lfm}

{ TFormAbout }

procedure TFormAbout.ImageAboutClick(Sender: TObject);
begin
  Close;
end;

procedure TFormAbout.ImageAboutDblClick(Sender: TObject);
begin
  Close;
end;

end.

