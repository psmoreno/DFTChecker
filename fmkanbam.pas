unit fmKanbam;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, RLReport, Forms, Controls, Graphics, Dialogs,
  ExtCtrls;

type

  { TFormKanbam }

  TFormKanbam = class(TForm)
    PanelRFilter: TPanel;
    PanelPrintDesign: TPanel;
    PanelButtons: TPanel;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FormKanbam: TFormKanbam;

implementation

{$R *.lfm}

end.

