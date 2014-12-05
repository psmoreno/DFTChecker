program dftchecker;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, csvdocument_package, fmmain, zcomponent, fmModels, fmof, fmlinks,
  fmoptions, fmabout, fmclosebox, fmaddinsert, fmintro, customconfig,
  ucrypto, lhelpcontrolpkg, fmsearchDMS, fmsearchdft, fmusers;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  //Application.CreateForm(TFormIntro, FormIntro);
  Application.CreateForm(TFormOF, FormOF);
  Application.CreateForm(TFormModels, FormModels);
  Application.CreateForm(TFormLinks, FormLinks);
  Application.CreateForm(TFormOptions, FormOptions);
  Application.CreateForm(TFormAbout, FormAbout);
  Application.CreateForm(TFormCloseOF, FormCloseOF);
  Application.CreateForm(TFormAddInsert, FormAddInsert);
  Application.CreateForm(TFormSearchDFT, FormSearchDFT);
  Application.CreateForm(TFormSearchDMS, FormSearchDMS);
  Application.CreateForm(TFormUsers, FormUsers);
  Application.Run;
end.

