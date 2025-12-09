program Prevent;

{$MODE Delphi}

(*
To do: bug in total mortality & disability by age when pop projection is on
*)
uses
  LCLIntf, LCLType, LMessages,
  Forms, Interfaces, tachartlazaruspkg,
  Prevmain in 'PREVMAIN.PAS' {MainForm},
  Aboutun in 'ABOUTUN.PAS' {AboutBox},
  Dataset in 'DATASET.PAS' {datasetForm},
  Winglob in 'WINGLOB.PAS',
  Runop in 'RUNOP.PAS' {runopform},
  Outop in 'OUTOP.PAS' {outopform},
  Runspec in 'RUNSPEC.PAS' {runForm},
  Startun in 'STARTUN.PAS',
  kies in 'kies.pas' {kiesform},
  INITIAL in 'INITIAL.PAS',
  Gescale in 'GESCALE.PAS',
  dynchart in 'dynchart.pas' {dyngraf},
  dynpyra in 'dynpyra.pas' {dynpyramid},
  Fkies in 'Fkies.pas' {FkiesForm},
  grafuit1 in 'Grafuit1.pas' {graphuit1},
  Tabeluit in 'Tabeluit.pas' {tableuitform},
  dynlijns in 'dynlijns.pas' {dynlijnen},
  dynbars in 'dynbars.pas' {dynbarren},
  DisUnit in 'DisUnit.pas',
  rfoptions in 'rfoptions.pas' {RFOpForm},
  Disoptions in 'Disoptions.pas' {DisopForm},
  bevolun in 'BEVOLUN.PAS',
  Popoptions in 'Popoptions.pas' {PopopForm},
  memomes in 'memomes.pas' {MemoForm},
  datmod1 in 'datmod1.pas' {DataModule2: TDataModule},
  Sensunit in 'Sensunit.pas' {SensForm},
  parasel in 'parasel.pas' {ParaselForm},
  Permusens in 'Permusens.pas' {PermuForm},
  GetnameUnit in 'GetnameUnit.pas' {Getnameform},
  PredefintUnit in 'PredefintUnit.pas' {PredefintForm},
  trendintvunit in 'trendintvunit.pas',
  OutvarUnit in 'OutvarUnit.pas',
  CalcUnit in 'CalcUnit.pas';

{$R *.res}

begin
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




