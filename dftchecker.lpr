program dftchecker;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, fortes324forlaz, fmmain, zcomponent, fmModels, fmof, fmlinks,
  fmoptions, fmabout, fmclosebox, fmaddinsert, fmintro, customconfig,
  ucrypto, lhelpcontrolpkg, fmKanbam
  { you can add units after this };

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
  Application.CreateForm(TFormKanbam, FormKanbam);
  Application.Run;
end.

