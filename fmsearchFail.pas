unit fmsearchFail;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, LR_PGrid, ZConnection, ZDataset,
  Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, DBGrids, Buttons,
  customconfig,dateutils;

type

  { TFormSearchFail }

  TFormSearchFail = class(TForm)
    BitBtnExport: TBitBtn;
    BitBtnPrint: TBitBtn;
    BitBtnClose: TBitBtn;
    DataSourceSrchFail: TDataSource;
    DBGridSrchFail: TDBGrid;
    EditSrchFail: TEdit;
    FrPrintGridSrchFail: TFrPrintGrid;
    Label1: TLabel;
    PanelRFilter: TPanel;
    PanelButtons: TPanel;
    RadioGroupRestrict: TRadioGroup;
    SaveDialogFail: TSaveDialog;
    ZConnectionSrchFail: TZConnection;
    ZQuerySrchFail: TZQuery;
    procedure BitBtnCloseClick(Sender: TObject);
    procedure BitBtnExportClick(Sender: TObject);
    procedure BitBtnPrintClick(Sender: TObject);
    procedure EditSrchFailKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure RadioGroupRestrictSelectionChanged(Sender: TObject);
  private
    { private declarations }
      CCF:TCustomConfig;
      procedure FilterResults;
      function GetAllDayOfWeek:TStringList;
  public
    { public declarations }
      procedure LoadConfig(TCmCfg:TCustomConfig);
  end;

var
  FormSearchFail: TFormSearchFail;

implementation

{$R *.lfm}

{ TFormSearchFail }

procedure TFormSearchFail.BitBtnCloseClick(Sender: TObject);
begin
  ZQuerySrchFail.Active:=false;
  ZConnectionSrchFail.Disconnect;
  Close;
end;

procedure TFormSearchFail.BitBtnExportClick(Sender: TObject);
begin
  if SaveDialogFail.Execute then
  begin

  end;
end;

procedure TFormSearchFail.BitBtnPrintClick(Sender: TObject);
begin
  FrPrintGridSrchFail.PreviewReport;
end;

procedure TFormSearchFail.EditSrchFailKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  FilterResults;
end;

procedure TFormSearchFail.FormShow(Sender: TObject);
begin
  ZConnectionSrchFail.HostName:=CCF.ConfigSQl.HIP;
  ZConnectionSrchFail.Port:=StrToInt(CCF.ConfigSQl.PConecction);
  ZConnectionSrchFail.Protocol:=CCF.ConfigSQl.Databasetype;
  ZConnectionSrchFail.Database:=CCF.ConfigSQl.DBname;
  ZConnectionSrchFail.User:=CCF.ConfigSQl.User;
  ZConnectionSrchFail.Password:=CCF.ConfigSQl.Pass;
  ZQuerySrchFail.Connection:=ZConnectionSrchFail;
  DataSourceSrchFail.DataSet:=ZQuerySrchFail;
  DBGridSrchFail.DataSource:=DataSourceSrchFail;

  FilterResults;
  EditSrchFail.SetFocus;
end;

procedure TFormSearchFail.RadioGroupRestrictSelectionChanged(Sender: TObject);
begin
  FilterResults;
end;

procedure TFormSearchFail.LoadConfig(TCmCfg:TCustomConfig);
begin
  CCF:=TCmCfg;
end;

procedure TFormSearchFail.FilterResults;
var
  StrSQL:string;
  ListOfDay:TStringList;
begin
  if EditSrchFail.Text <>'' then
  begin
      StrSQL:='SELECT * FROM tstepfail WHERE OfSerie LIKE ''%'+EditSrchFail.Text+'%''';
  end
  else
  begin
      StrSQL:='SELECT * FROM tstepfail WHERE OfSerie LIKE ''%''';
  end;

  case RadioGroupRestrict.ItemIndex of
       0:begin
           StrSQL:=StrSQL+' ORDER BY OfSerie ASC LIMIT 10000';
       end;
       1:begin
           StrSQL:=StrSQL+'AND Fdate LIKE '''+FormatDateTime('dd-mm-yyyy',date)+'''';
       end;
       2:begin
          ListOfDay:=GetAllDayOfWeek;
          StrSQL:=StrSQL+'AND ( Fdate LIKE '''+ListOfDay[1]+''' OR Fdate LIKE '''+
          ListOfDay[2]+''' OR Fdate LIKE '''+ListOfDay[3]+''' OR Fdate LIKE '''+
          ListOfDay[4]+''' OR Fdate LIKE '''+ListOfDay[5]+''' OR Fdate LIKE '''+
          ListOfDay[6]+''' OR Fdate LIKE '''+ListOfDay[7]+''' )';
       end;
  end;
  ZQuerySrchFail.Active:=false;
  ZQuerySrchFail.SQL.Text:=strSQL;
  ZQuerySrchFail.Active:=true;
end;

function TFormSearchFail.GetAllDayOfWeek:TStringList;
var
   Lista:TStringList;
   i:integer;
   k:integer;
   CurDayPos:integer;
begin
   Lista:=TStringList.Create;
   for i:=0 to 8 do
   begin
        Lista.Add('N');
   end;

   CurDayPos:=DayOfWeek(date);
   k:=1;
   for i:=(CurDayPos) to 8 do
   begin
      Lista[i]:=FormatDateTime('dd-mm-yyyy',IncDay(date,k));
      k:=k+1;
   end;
   k:=0;
   for i:=(CurDayPos-1) downto 1 do
   begin
      Lista[i]:=FormatDateTime('dd-mm-yyyy',IncDay(date,-k));
      k:=k+1;
   end;

   GetAllDayOfWeek:=Lista;
end;

end.

