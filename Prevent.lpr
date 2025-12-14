program Prevent;

{$MODE Delphi}

(*
To do: bug in total mortality & disability by age when pop projection is on
*)
uses
  LCLIntf, LCLType, LMessages,
  Forms, Interfaces, tachartlazaruspkg,
  Prevmain in 'prevmain.pas' {MainForm},
  Aboutun in 'aboutun.pas' {AboutBox},
  Dataset in 'dataset.pas' {datasetForm},
  Winglob in 'winglob.pas',
  Runop in 'runop.pas' {runopform},
  Outop in 'outop.pas' {outopform},
  Runspec in 'runspec.pas' {runForm},
  Startun in 'startun.pas',
  kies in 'kies.pas' {kiesform},
  INITIAL in 'initial.pas',
  Gescale in 'gescale.pas',
  dynchart in 'dynchart.pas' {dyngraf},
  dynpyra in 'dynpyra.pas' {dynpyramid},
  Fkies in 'fkies.pas' {FkiesForm},
  grafuit1 in 'grafuit1.pas' {graphuit1},
  Tabeluit in 'tabeluit.pas' {tableuitform},
  dynlijns in 'dynlijns.pas' {dynlijnen},
  dynbars in 'dynbars.pas' {dynbarren},
  DisUnit in 'disunit.pas',
  rfoptions in 'rfoptions.pas' {RFOpForm},
  Disoptions in 'disoptions.pas' {DisopForm},
  bevolun in 'bevolun.pas',
  Popoptions in 'popoptions.pas' {PopopForm},
  memomes in 'memomes.pas' {MemoForm},
  datmod1 in 'datmod1.pas' {DataModule2: TDataModule},
  Sensunit in 'sensunit.pas' {SensForm},
  parasel in 'parasel.pas' {ParaselForm},
  Permusens in 'permusens.pas' {PermuForm},
  GetnameUnit in 'getnameunit.pas' {Getnameform},
  PredefintUnit in 'predefintunit.pas' {PredefintForm},
  trendintvunit in 'trendintvunit.pas',
  OutvarUnit in 'outvarunit.pas',
  CalcUnit in 'calcunit.pas';

{$R *.res}

begin
  Application.Initialize;
  Aboutbox:=Taboutbox.Create(Application);
  aboutbox.Show;
  aboutbox.Update;
  Application.Title:='Prevent';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TDataModule2, DataModule2);
  Application.CreateForm(TdatasetForm, datasetForm);
  Application.CreateForm(Trunopform, runopform);
  Application.CreateForm(Toutopform, outopform);
  Application.CreateForm(TrunForm, runForm);
  Application.CreateForm(Tkiesform, kiesform);
  Application.CreateForm(TFkiesForm, FkiesForm);
  Application.CreateForm(TRFOpForm, RFOpForm);
  Application.CreateForm(TDisopForm, DisopForm);
  Application.CreateForm(TPopopForm, PopopForm);
  Application.CreateForm(TMemoForm, MemoForm);
  Application.CreateForm(TSensForm, SensForm);
  Application.CreateForm(TParaselForm, ParaselForm);
  Application.CreateForm(TPermuForm, PermuForm);
  Application.CreateForm(TGetnameform, Getnameform);
  Application.CreateForm(TPredefintForm, PredefintForm);
  aboutbox.hide;
  aboutbox.close;
  Application.Run;
end.




