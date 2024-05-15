program Pitikare;

uses
  Forms,
  mainfrm in 'mainfrm.pas' {fMain},
  panelfr in 'panelfr.pas' {frPanel: TFrame},
  fs in 'fs.pas',
  winfs in 'winfs.pas',
  aboutfrm in 'aboutfrm.pas' {fAbout},
  procs in 'procs.pas',
  fsrep in 'fsrep.pas',
  progfrm in 'progfrm.pas' {fProgress},
  destfrm in 'destfrm.pas' {fDest};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Pitikare Commander';
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.
