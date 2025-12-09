unit PREVMAIN;

{$MODE Delphi}

interface

uses
  SysUtils, LCLIntf, LCLType, {LMessages, Messages,} Classes, Graphics, Controls,
  Forms, Dialogs, Menus, {Tabs,} StdCtrls, ExtCtrls, Buttons,
  ComCtrls{,checklst};

type
  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    Filemenu: TMenuItem;
    D1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    R1: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    exitbut: TButton;
    runbut: TButton;
    helpbut: TBitBtn;
    Label2: TLabel;
    PageControlUit: TPageControl;
    View1: TMenuItem;
    View2: TMenuItem;
    Popupuitop: TPopupMenu;
    Outputoptions1: TMenuItem;
    Closealloutput1: TMenuItem;
    SpecBut: TButton;
    Messages1: TMenuItem;
    Sensitivity1: TMenuItem;
    Keepinterventions1: TMenuItem;
    N13: TMenuItem;
    Uncertainty1: TMenuItem;
    PopupMain: TPopupMenu;
    Dataset1: TMenuItem;
    Runtimeoptions1: TMenuItem;
    Outputoptions2: TMenuItem;
    procedure N2Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure exitbutClick(Sender: TObject);
    procedure D1Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure runbutClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBoxpopClick(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure helpbutClick(Sender: TObject);
    procedure ListBoxRiskClick(Sender: TObject);
    procedure LifeListBoxClick(Sender: TObject);
    procedure View1Click(Sender: TObject);
    procedure Outputoptions1Click(Sender: TObject);
    procedure Closealloutput1Click(Sender: TObject);
    procedure ListBoxmortClick(Sender: TObject);
    procedure SpecButClick(Sender: TObject);
    procedure ListboxdismortClick(Sender: TObject);
    procedure ListBoxdisincClick(Sender: TObject);
    procedure ListBoxdisprevClick(Sender: TObject);
    procedure ListBoxdisDALYClick(Sender: TObject);
    procedure ListBoxdiscostClick(Sender: TObject);
    procedure Messages1Click(Sender: TObject);
    procedure Sensitivity1Click(Sender: TObject);
    procedure Keepinterventions1Click(Sender: TObject);
    procedure Uncertainty1Click(Sender: TObject);
    procedure ListBoxDisabClick(Sender: TObject);
    procedure TotcostListBoxClick(Sender: TObject);
    procedure ListBoxdiscfatClick(Sender: TObject);
    procedure ListBoxdisremiClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    dispagebool:boolean;
    dispages:TPageControl;
    procedure Creboekhoudlijsten;
    procedure Delboekhoudlijsten;
    procedure pointersweg;
    procedure exitdialog;
    procedure volgorde;
    function createtab(PC:TPageControl;tabname:string;tabcap:string;lb:string;oc:Tnotifyevent):Tlistbox;
  public
    { Public declarations }
    riskuitlist,disuitlistmort,disuitlistinc,disuitlistprev,disuitlistcfat,
    disuitlistremi,disuitlistdaly,
    disuitlistcost,lifeuitlist,popuitlist,mortuitlist,Totdisablist,totcostlist,
    sensrunlist:Tlist;
    repeatrun:Boolean;
    uitmesstring:string;
    sensbool,uncertbool:Boolean;
    globallookback:integer;
    procedure bezigofniet(bez:boolean);
    procedure beziglook;
    procedure uitvoerlook;
    procedure startlook;
    procedure delcur;
    procedure crecur;
    procedure creuit;
    procedure deluit;
    procedure dorun;
    procedure updatecaption;
    procedure startboodschap(regel:string);
    procedure stopboodschap(regel:string);
    procedure uitvoeropzet;
    procedure uitvoerafbraak;
  end;

var
  MainForm: TMainForm;




implementation

{$R *.lfm}

uses math,GESCALE, WINGLOB,ABOUTUN,DATASET,RUNOP, OUTOP, {RUNSPEC,}
     Tabeluit, Grafuit1,
     INITIAL,DisUnit,STARTUN,dynchart, BEVOLUN,CalcUnit,
  memomes,Sensunit,
  OutvarUnit, Disoptions, Popoptions;

var    startt,stopt:Tdatetime;


procedure TMainForm.exitdialog;
begin
  if Application.MessageBox('Terminate Prevent?', 'Confirm',
    MB_YES_NO+MB_ICONQUESTION) = IDYES then
    begin
      pointersweg;
      {hier moeten nog andere schoonmaak statements komen}
      population.Free;
      Delboekhoudlijsten;
      Application.Terminate;
    end;
end;


procedure TMainForm.N2Click(Sender: TObject);
begin
  exitdialog;
end;

procedure TMainForm.N11Click(Sender: TObject);
begin
  aboutbox.show;
end;

procedure TMainForm.Messages1Click(Sender: TObject);
begin
  memoform.show;
end;


procedure TMainForm.exitbutClick(Sender: TObject);
begin
  exitdialog;
end;

procedure TMainForm.D1Click(Sender: TObject);
begin
  pointersweg;
  datasetForm.verlaatset;
  datasetform.showmodal;
  updatecaption;
  Screen.Cursor := crHourGlass;
  runbut.enabled:=false;
  specbut.enabled:=false;
  refresh;
  application.processmessages;
  datasetForm.leescurset;
  runopform.setrunops;
  Screen.Cursor := crDefault;
  runbut.enabled:=true;
  specbut.enabled:=true;
  application.processmessages;
end;

procedure TMainForm.updatecaption;
begin
  datasetform.currentset;
  caption:='Prevent - '+currentdataset;
  refresh;
end;



procedure TMainForm.N6Click(Sender: TObject);
begin
  runopform.showmodal;
end;

procedure TMainForm.N7Click(Sender: TObject);
begin
  outopform.showmodal;
end;

procedure TMainForm.pointersweg;

var ind:integer;

begin
  repeatrun:=False;
  if uitbool then
  begin
    deluit;
    delcur;
  end;
  currflist.clear;
  curdislist.clear;
  curipmlist.clear;
  curdisdalylist.clear;
  curdiscostlist.clear;
end;

procedure TMainForm.bezigofniet(bez:boolean);
begin
 { ledred.lit:=bez;
  ledgreen.lit:=not bez;}
  if bez then
     Screen.Cursor := crHourglass { Show hourglass cursor }
  else  Screen.Cursor := crDefault;                  { Always restore to normal }
end;

procedure TMainForm.beziglook;

begin
  bezigofniet(true);
  Specbut.enabled:=false;
  runbut.enabled:=false;
  MainForm.D1.enabled:=false;
end;

procedure TMainForm.uitvoerlook;

begin
  bezigofniet(false);
  PageControlUit.visible:=uitbool;
  label2.visible:=true;
  N6.enabled:=false;
  runbut.caption:='&New run';
  runbut.hint:='New simulation run';
  runbut.enabled:=true;
  repaint;
end;

procedure TMainForm.startlook;
begin
  uitbool:=false;
  PageControlUit.visible:=uitbool;
  label2.visible:=false;
  Specbut.enabled:=true;
  N6.enabled:=true;
  MainForm.D1.enabled:=true;
  runbut.caption:='&Run';
  runbut.hint:='Start simulation run';
  runbut.enabled:=true;
  bezigofniet(false);
  repaint;
end;


procedure TMainForm.crecur;

var tt,ind:integer;

begin
  for ind:=0 to curdislist.count-1 do
    with Tdisease(curdislist.items[ind]) do ziektedata;
  application.processmessages;
  datasetForm.leescurrfdis;    //Moet voor de RRinvoer
  for ind:=0 to curdislist.count-1 do
    with Tdisease(curdislist.items[ind]) do RRinvoer;
  application.processmessages;
  population.popinlezen;
  application.processmessages;
end;

procedure TMainForm.delcur;

var tt,ind:integer;

begin
{  for ind:=0 to currflist.count-1 do
     with Triskfactor(currflist.items[ind]) do curafbreuk; Tcatrf.curafbreuk doet niks}
  application.processmessages;
  population.popweg;
end;



procedure TMainForm.creuit;

var ind:integer;

begin
  for ind:=0 to currflist.count-1 do
     with Tgenentity(currflist.items[ind]) do uitvoeropzet;
  for ind:=0 to curdislist.count-1 do
     with Tdisease(curdislist.items[ind]) do uitvoeropzet;
  population.popuitvoeropzet;
end;


procedure TMainForm.deluit;

var tt,ind:integer;

begin
  uitvoerafbraak;
  for ind:=0 to currflist.count-1 do
     with Tgenentity(currflist.items[ind]) do uitvoerafbraak;
  if not keepinterventions1.Checked then
    for ind:=0 to currflist.count-1 do
     with Tgenentity(currflist.items[ind]) do intervensafbreuk;
  for ind:=0 to curdislist.count-1 do
     with Tdisease(curdislist.items[ind]) do uitvoerafbraak;
  population.popuitvoerafbraak;
end;

procedure TMainForm.startboodschap(regel:string);

begin
  startt:=now;
  memoform.memo1.lines.Add(regel+', '+aboutbox.version.Caption+' date: '
        +DateToStr(Date)+', dataset: '+currentdataset+'.');
  memoform.memo1.lines.add('Started at: '+ TimeToStr(startt));
end;

procedure TMainForm.stopboodschap(regel:string);

var Year, Month, Day, Hour, Min, Sec, MSec: Word;

begin
  stopt:=now;
  memoform.memo1.lines.add(regel+' completed at: '+ TimeToStr(stopt));
  DecodeTime(stopt-startt, Hour, Min, Sec, MSec);
  memoform.memo1.lines.add('Elapsed time: '+inttostr(hour)+' hours, '
    +IntToStr(Min)+' minutes, '+FloatToStrf(sec+msec/1000.0,fffixed,6,2)+' seconds.');
end;


procedure TMainForm.runbutClick(Sender: TObject);


begin
  if uitbool then
  begin
    deluit;
    startlook;
    runopform.setrunops;
    disopform.setdisop;
    PopopForm.setpopop;
  end else
  begin
    beziglook;
    startboodschap('Prevent run');
    crecur;
    creuit;
    dorun;
    uitvoeropzet;
    repeatrun:=True;
    stopboodschap('Run');
    uitvoerlook;
  end;
end;



function Sortlistbydependencies(Item1, Item2: Pointer): Integer;
var
  num:integer;
begin
  if Tgenentity(item1).rflist.count=0 then
  begin
    if Tgenentity(item2).rflist.count=0 then
    begin
      Result:=0;   {ie the same}
      exit;
    end;
    Result:=1;   {ie move item1 down in the list}
    exit;
  end else
  if Tgenentity(item2).rflist.count=0 then
  begin
    Result:=-1;   {ie move item1 up in the list}
    exit;
  end else
  for num:=0 to Tgenentity(item1).rflist.count-1 do
  begin
    if Tgenentity(Trfdis(Tgenentity(Item1).rflist.items[num]).dis).name=
       Tgenentity(item2).name then  //item2 is a disease for item1
    begin
      Result:=-1;   {ie move item1 up in the list}
      exit;
    end
  end;
  for num:=0 to Tgenentity(item2).rflist.count-1 do
  begin
    if Tgenentity(Trfdis(Tgenentity(Item2).rflist.items[num]).dis).name=
       Tgenentity(item1).name then  //item1 is a disease for item2
    begin
      Result:=1;   {ie move item1 down in the list}
      exit;
    end
  end;
  Result:=0;
end;


procedure TMainForm.volgorde;
var
    ind:integer;
begin
  globallookback:=0;
  for ind:=0 to currflist.count-1 do
    globallookback:=max(globallookback,Tgenentity(currflist.items[ind]).lookback);
  for ind:=0 to curdislist.count-1 do
    globallookback:=max(globallookback,Tdisease(curdislist.items[ind]).lookback);
  curgenentlist.sort(Sortlistbydependencies);
end;


procedure TMainForm.dorun;

var
    ind,tt:integer;
begin
  uitbool:=true;
  for ind:=0 to currflist.count-1 do
    Tgenentity(currflist.items[ind]).leesinvoer;
  for ind:=0 to curdislist.count-1 do
    with Tdisease(curdislist.items[ind]) do ziektedata;   //herhaal vanwege de trends
  volgorde;
  for tt:=-globallookback to et do
  begin                     //de jaarstap proc moet zelf de eerste tt checken
    for ind:=0 to curgenentlist.count-1 do
    begin
      Tgenentity(curgenentlist.items[ind]).dojaarstap(tt);
      Tgenentity(curgenentlist.items[ind]).dopzaanpas(tt);
    end;
  end;
{  for ind:=0 to curgenentlist.count-1 do
     Tgenentity(curgenentlist.items[ind]).pzlistcor; Not needed anymore}
  population.bevolking;
  application.processmessages;
end;

procedure TMainForm.Creboekhoudlijsten;
begin
  {datasets}
  bestandenlist:=Tlist.create;
  {outputformlists}
  tablelist:=Tlist.create;
  dynchartlist:=Tlist.create;
  statchartlist:=Tlist.create;
  {outputitemslists}
  mortuitlist:=Tlist.create;
  popuitlist:=Tlist.create;
  lifeuitlist:=Tlist.create;
  totdisablist:=Tlist.create;
  totcostlist:=Tlist.create;
  disuitlistmort:=Tlist.create;
  disuitlistinc:=Tlist.create;
  disuitlistprev:=Tlist.create;
  disuitlistcfat:=Tlist.create;
  disuitlistremi:=Tlist.create;
  disuitlistdaly:=Tlist.create;
  disuitlistcost:=Tlist.create;
  riskuitlist:=Tlist.create;
  {RF en ziektelists}
  diseaselist:=Tlist.create;
  riskfactorlist:=Tlist.create;
  curdislist:=Tlist.create;
  currflist:=Tlist.create;
  genentitylist:=Tlist.create;
  curgenentlist:=Tlist.create;
  ipmlist:=Tlist.create;
  curipmlist:=Tlist.create;
  disremilist:=Tlist.create;
  curdisremilist:=Tlist.create;
  disdalylist:=Tlist.create;
  curdisdalylist:=Tlist.create;
  discostlist:=Tlist.create;
  curdiscostlist:=Tlist.create;
end;

procedure TMainForm.Delboekhoudlijsten;
begin
  {datasets}
  bestandenlist.free;
  {outputformlists}
  tablelist.free;
  dynchartlist.free;
  statchartlist.free;
  {outputitemslists}
  mortuitlist.free;
  popuitlist.free;
  lifeuitlist.free;
  totdisablist.free;
  totcostlist.free;
  disuitlistmort.free;
  disuitlistinc.free;
  disuitlistprev.free;
  disuitlistcfat.free;
  disuitlistremi.free;
  disuitlistdaly.free;
  disuitlistcost.free;
  riskuitlist.free;
  {RF en ziektelists}
  diseaselist.free;
  riskfactorlist.free;
  curdislist.free;
  currflist.free;
  genentitylist.free;
  curgenentlist.free;
  ipmlist.free;
  curipmlist.free;
  disremilist.free;
  curdisremilist.free;
  disdalylist.free;
  curdisdalylist.free;
  discostlist.free;
  curdiscostlist.free;
end;


procedure TMainForm.FormCreate(Sender: TObject);
begin
  geautoscale(mainform);
  startlook;
  graphbool:=true;
  repeatrun:=False;
  sensbool:=False;
  uncertbool:=false;
  creboekhoudlijsten;
  opening;
end;


function TMainForm.createtab(PC:TPageControl;tabname:string;tabcap:string;lb:string;oc:Tnotifyevent):Tlistbox;
var
  doos:Tlistbox;
  tab:TTabSheet;
begin
  tab:=TTabSheet.Create(PC);
  with tab do
  begin
    PageControl:=PC;
    Name:=tabname;
    Caption:=tabcap;
  end;
  doos:=Tlistbox.Create(tab);
  doos.parent:=Tab;
  doos.name:=lb;
  doos.align:=alclient;
  doos.color:=clBtnFace;
  doos.OnClick:=oc;
  result:=doos;
end;

procedure TMainForm.uitvoeropzet;
var
  dlb:Tlistbox;
  tab:TTabSheet;

begin
  popuitlist.clear;
  dlb:=createtab(Pagecontroluit,'Poptab','Population','Listboxpop',ListBoxpopClick);

  popstruc:=TGloboutvararpop.create('Population Structure',dlb,popuitlist,population.tpopu,false);
  popstrucdif:=TGloboutvararpop.create('Population Difference by age',dlb,popuitlist,population.tpopu,true);
  genuitpop60:=Tgenuitpop60.create(et);
  popprop60:=TGlobTotoutvararp60.create('Population age '+inttostr(outopform.proppopSpin.Value)+' and over (%)',dlb,popuitlist,genuitpop60,false);
  if popopform.realpop.ItemIndex=0 then
  begin
    numbirths:=TGlobTotoutvarar.create('Number of births',dlb,popuitlist,population.gebo,false);
    numbirthsdif:=TGlobTotoutvarar.create('Number of births difference',dlb,popuitlist,population.gebo,true);
  end;

  if not incionlybool then
  begin
    mortuitlist.clear;
    dlb:=createtab(Pagecontroluit,'Mortpage','Mortality','Listboxmort',ListBoxmortClick);

    totalmort:=TGlobTotoutvarar.create('Total Mortality (numbers)',dlb,mortuitlist,population.ttotmor,false);
    totalmortred:=TGlobTotoutvarar.create('Total Mortality Difference (numbers)',dlb,mortuitlist,population.ttotmor,true);
    dynmorag:=TGloboutvarar.create('Total Mortality by age',dlb,mortuitlist,population.ttotmor,false);
    dynmoragdif:=TGloboutvarar.create('Total Mortality Difference by age',dlb,mortuitlist,population.ttotmor,true);

    totdisablist.clear;
    if population.dalebool then
    begin
      dlb:=createtab(Pagecontroluit,'DisabTab','Disability','ListBoxdisab',ListBoxdisabClick);
      Totalyld:=TGlobTotoutvarar.create('Total years lived with disability (numbers)',dlb,totdisablist,population.tdaly,false);
      totalylddif:=TGlobTotoutvarar.create('Total years lived with disability difference (numbers)',dlb,totdisablist,population.tdaly,true);
      dynyldag:=TGloboutvarar.create('Total years lived with disability by age',dlb,totdisablist,population.tdaly,false);
      dynyldagdif:=TGloboutvarar.create('Total years lived with disability difference by age',dlb,totdisablist,population.tdaly,true);
    end;

    totcostlist.clear;
    if population.costbool then
    begin
      dlb:=createtab(Pagecontroluit,'Totcosttab','Costs','TotcostListBox',TotcostListBoxClick);
      Totalcost:=TGlobTotoutvararcost.create('Total health care costs',dlb,totcostlist,population.tcosts,false);
      Totalcostdif:=TGlobTotoutvararcost.create('Total health care costs difference',dlb,totcostlist,population.tcosts,true);
      dyncostage:=TGloboutvararcost.create('Health care costs by age',dlb,totcostlist,population.tcosts,false);
      dyncostagedif:=TGloboutvararcost.create('Health care costs difference by age',dlb,totcostlist,population.tcosts,true);
    end;

    lifeuitlist.clear;
    dlb:=createtab(Pagecontroluit,'lifetab','Expectancy','LifeListBox',LifeListBoxClick);

    dynsurv:=TGloboutvararsurv.create('Survival Curves',dlb,lifeuitlist,population.tsurviv,false);
    expectant:=TGlobTotoutvararexpec.create('Life Expectancy (years)',dlb,lifeuitlist,population.texpec,false);
    expectantdif:=TGlobTotoutvararexpec.create('Life Expectancy difference (years)',dlb,lifeuitlist,population.texpec,true);
    if population.dalebool then
    begin
      dalexpectant:=TGlobTotoutvararexpec.create('Disability Adjusted Life Expectancy (years)',dlb,lifeuitlist,population.tdale,false);
      dalexpectantdif:=TGlobTotoutvararexpec.create('Disability Adjusted Life Expectancy difference (years)',dlb,lifeuitlist,population.tdale,true);
      disexpectant:=TGlobTotoutvararexpec.create('Life Expectancy with disability (years)',dlb,lifeuitlist,population.texpecdis,false);
      disexpectantdif:=TGlobTotoutvararexpec.create('Life Expectancy with disability difference (years)',dlb,lifeuitlist,population.texpecdis,true);
    end;
  end;
  dispagebool:=(not incionlybool) and (curipmlist.count>0);

  disuitlistmort.clear;
  disuitlistinc.clear;
  disuitlistprev.clear;
  disuitlistcfat.clear;
  disuitlistremi.clear;
  disuitlistdaly.clear;
  disuitlistcost.clear;

  if dispagebool then
  begin
    {er zijn ziekten met meer dan een uitvoer variabele}
    tab:=TTabSheet.Create(PageControluit);
    with tab do
    begin
      PageControl:=PageControluit;
      Name:='Diseasetab';
      Caption:='Diseases';
    end;
    dispages:=TPageControl.Create(tab);
    dispages.Parent:=tab;
    dispages.Align:=alClient;

    dlb:=createtab(dispages,'DisInctab','Incidence','ListBoxdisinc',ListBoxdisincClick);
    disnumtotinc:=TdisTotoutvar.create('Incidence (numbers, all ages)',dlb,disuitlistinc,curipmlist,invr,false);
    disnumtotincred:=TdisTotoutvar.create('Incidence difference (numbers, all ages)',dlb,disuitlistinc,curipmlist,invr,true);
    disincage:=Tdisoutvarar.create('Incidence by age',dlb,disuitlistinc,curipmlist,invr,false);
    disincagedif:=Tdisoutvarar.create('Incidence difference by age',dlb,disuitlistinc,curipmlist,invr,true);

    dlb:=createtab(dispages,'DisPrevtab','Prevalence','ListBoxdisprev',ListBoxdisprevClick);
    disnumtotprev:=TdisTotoutvar.create('Prevalence (numbers, all ages)',dlb,disuitlistprev,curipmlist,prevr,false);
    disnumtotprevred:=TdisTotoutvar.create('Prevalence difference (numbers, all ages)',dlb,disuitlistprev,curipmlist,prevr,true);
    disprevage:=Tdisoutvarar.create('Prevalence by age',dlb,disuitlistprev,curipmlist,prevr,false);
    disprevagedif:=Tdisoutvarar.create('Prevalence difference by age',dlb,disuitlistprev,curipmlist,prevr,true);

    dlb:=createtab(dispages,'morttab','Mortality','ListBoxdismort',ListBoxdismortClick);
    disnumtotmor:=TdisTotoutvar.create('Mortality (numbers, all ages)',dlb,disuitlistmort,curdislist,morvr,false);
    disnumtotmortred:=TdisTotoutvar.create('Mortality difference (numbers, all ages)',dlb,disuitlistmort,curdislist,morvr,true);
    dismorage:=Tdisoutvarar.create('Mortality by age',dlb,disuitlistmort,curdislist,morvr,false);
    dismoragedif:=Tdisoutvarar.create('Mortality difference by age',dlb,disuitlistmort,curdislist,morvr,true);

    dlb:=createtab(dispages,'CFattab','Case fatality','ListBoxdiscfat',ListBoxdiscfatClick);
    disnumtotcfat:=TdisTotoutvar.create('Case fatality (numbers, all ages)',dlb,disuitlistcfat,curipmlist,cfatvr,false);
    disnumtotcfatred:=TdisTotoutvar.create('Case fatality difference (numbers, all ages)',dlb,disuitlistcfat,curipmlist,cfatvr,true);
    discfatage:=Tdisoutvarar.create('Case fatality by age',dlb,disuitlistcfat,curipmlist,cfatvr,false);
    discfatagedif:=Tdisoutvarar.create('Case fatality difference by age',dlb,disuitlistcfat,curipmlist,cfatvr,true);

    if curdisremilist.count>0 then
    begin
      dlb:=createtab(dispages,'Remitab','Remission','ListBoxdisremi',ListBoxdisremiClick);
      disnumtotremi:=TdisTotoutvar.create('Remission (numbers, all ages)',dlb,disuitlistremi,curdisremilist,remivr,false);
      disnumtotremired:=TdisTotoutvar.create('Remission difference (numbers, all ages)',dlb,disuitlistremi,curdisremilist,remivr,true);
      disremiage:=Tdisoutvarar.create('Remission by age',dlb,disuitlistremi,curdisremilist,remivr,false);
      disremiagedif:=Tdisoutvarar.create('Remission difference by age',dlb,disuitlistremi,curdisremilist,remivr,true);
    end;

    if curdisdalylist.count>0 then
    begin
      dlb:=createtab(dispages,'dalytab','Disability','ListBoxdisdaly',ListBoxdisdalyClick);
      disnumtotyld:=TdisTotoutvar.create('Years lived with disability (numbers, all ages)',dlb,disuitlistdaly,curdisdalylist,dalvr,false);
      disnumtotyldred:=TdisTotoutvar.create('Years lived with disability difference (numbers, all ages)',dlb,disuitlistdaly,curdisdalylist,dalvr,true);
      disyldage:=Tdisoutvarar.create('Years lived with disability by age',dlb,disuitlistdaly,curdisdalylist,dalvr,false);
      disyldagedif:=Tdisoutvarar.create('Years lived with disability difference by age',dlb,disuitlistdaly,curdisdalylist,dalvr,true);
    end;

    if curdiscostlist.count>0 then
    begin
      dlb:=createtab(dispages,'costtab','Costs','ListBoxdiscost',ListBoxdiscostClick);
      distotalcost:=TdisTotoutvarcost.create('Total disease costs',dlb,disuitlistcost,curdiscostlist,cosvr,false);
      distotalcostred:=TdisTotoutvarcost.create('Total disease costs difference',dlb,disuitlistcost,curdiscostlist,cosvr,true);
      discostage:=Tdisoutvararcost.create('Costs by age',dlb,disuitlistcost,curdiscostlist,cosvr,false);
      discostagedif:=Tdisoutvararcost.create('Cost difference by age',dlb,disuitlistcost,curdiscostlist,cosvr,true);
    end;

  end else {maar een ziekte variabele}
  begin
    if incionlybool then
    begin
      dlb:=createtab(Pagecontroluit,'Diseasetab','Diseases','ListBoxdisinc',ListBoxdisincClick);
      disnumtotinc:=TdisTotoutvar.create('Incidence (numbers, all ages)',dlb,disuitlistinc,curdislist,morvr,false);
      disnumtotincred:=TdisTotoutvar.create('Incidence difference (numbers, all ages)',dlb,disuitlistinc,curdislist,morvr,true);
      disincage:=Tdisoutvarar.create('Incidence by age',dlb,disuitlistinc,curdislist,morvr,false);
      disincagedif:=Tdisoutvarar.create('Incidence difference by age',dlb,disuitlistinc,curdislist,morvr,true);
    end else
    begin
      dlb:=createtab(Pagecontroluit,'Diseasetab','Diseases','ListBoxdismort',ListBoxdismortClick);
      disnumtotmor:=TdisTotoutvar.create('Mortality (numbers, all ages)',dlb,disuitlistmort,curdislist,morvr,false);
      disnumtotmortred:=TdisTotoutvar.create('Mortality difference (numbers, all ages)',dlb,disuitlistmort,curdislist,morvr,true);
      dismorage:=Tdisoutvarar.create('Mortality by age',dlb,disuitlistmort,curdislist,morvr,false);
      dismoragedif:=Tdisoutvarar.create('Mortality difference by age',dlb,disuitlistmort,curdislist,morvr,true);
    end;
  end;

  riskuitlist.clear;
  if currflist.count>0 then
  begin
    dlb:=createtab(Pagecontroluit,'risktab','Risk factors','ListBoxrisk',ListBoxriskClick);
    piftif:=Tdisoutvararpif.create('Potential and Trend Impact Fractions (%), by age',dlb,riskuitlist,curgenentlist,pifvr,false);
    rfprevuit:=TRfoutvar.create('Risk factor prevalences (%)',dlb,riskuitlist,currflist,false);
    rfprevuitdif:=TRfoutvar.create('Risk factor prevalences (%) difference',dlb,riskuitlist,currflist,true);
  end;
end;

procedure TMainForm.uitvoerafbraak;
var
  i:integer;
begin
  popuitlist.clear;

  popstruc.free;
  popstrucdif.free;
  popprop60.free;
  genuitpop60.free;
  if popopform.realpop.ItemIndex=0 then
  begin
    numbirths.free;
    numbirthsdif.free;
  end;

  if not incionlybool then
  begin

    mortuitlist.clear;

    totalmort.free;
    totalmortred.free;
    dynmorag.free;
    dynmoragdif.free;

    totdisablist.clear;
    if population.dalebool then
    begin
      Totalyld.free;
      totalylddif.free;
      dynyldag.free;
      dynyldagdif.free;
    end;

    totcostlist.clear;
    if population.costbool then
    begin
      Totalcost.free;
      Totalcostdif.free;
      dyncostage.free;
      dyncostagedif.free;
    end;


    lifeuitlist.clear;

    dynsurv.free;
    expectant.free;
    expectantdif.free;
    if population.dalebool then
    begin
      dalexpectant.free;
      dalexpectantdif.free;
      disexpectant.free;
      disexpectantdif.free;
    end;
  end;
  disuitlistmort.clear;
  disuitlistinc.clear;
  disuitlistprev.clear;
  disuitlistcfat.clear;
  disuitlistremi.clear;
  disuitlistdaly.clear;
  disuitlistcost.clear;

  if dispagebool then
  begin
    {er zijn ziekten met meer dan een uitvoer variabele}
    disnumtotinc.free;
    disnumtotincred.free;
    disincage.free;
    disincagedif.free;

    disnumtotprev.free;
    disnumtotprevred.free;
    disprevage.free;
    disprevagedif.free;

    disnumtotmor.free;
    disnumtotmortred.free;
    dismorage.free;
    dismoragedif.free;

    disnumtotcfat.free;
    disnumtotcfatred.free;
    discfatage.free;
    discfatagedif.free;

    if curdisremilist.count>0 then
    begin
      disnumtotremi.free;
      disnumtotremired.free;
      disremiage.free;
      disremiagedif.free;
    end;

    if curdisdalylist.count>0 then
    begin
      disnumtotyld.free;
      disnumtotyldred.free;
      disyldage.free;
      disyldagedif.free;
    end;

    if curdiscostlist.count>0 then
    begin
      distotalcost.free;
      distotalcostred.free;
      discostage.free;
      discostagedif.free;
    end;

    with dispages do
    for i:=PageCount-1 downto 0 do
     ttabsheet(pages[i]).free;

  end else
  begin
    if incionlybool then
    begin
      disnumtotinc.free;
      disnumtotincred.free;
      disincage.free;
      disincagedif.free;
    end else
    begin
      disnumtotmor.free;
      disnumtotmortred.free;
      dismorage.free;
      dismoragedif.free;
    end;
  end;

  riskuitlist.clear;

  if currflist.count>0 then
  begin
    piftif.free;
    rfprevuit.free;
    rfprevuitdif.free;
  end;

  with PageControluit do
  for i:=PageCount-1 downto 0 do
   ttabsheet(pages[i]).free;

end;


procedure TMainForm.ListBoxmortClick(Sender: TObject);

begin
  Toutvar(mortuitlist.items[Tlistbox(sender).itemindex]).laatzien;
end;

procedure TMainForm.ListBoxpopClick(Sender: TObject);

begin
  Toutvar(popuitlist.items[Tlistbox(sender).itemindex]).laatzien;
end;

procedure TMainForm.ListBoxDisabClick(Sender: TObject);
begin
  Toutvar(totdisablist.items[Tlistbox(sender).itemindex]).laatzien;
end;

procedure TMainForm.TotcostListBoxClick(Sender: TObject);
begin
  Toutvar(totcostlist.items[Tlistbox(sender).itemindex]).laatzien;
end;

procedure TMainForm.LifeListBoxClick(Sender: TObject);
begin
  Toutvar(lifeuitlist.items[Tlistbox(sender).itemindex]).laatzien;
end;

procedure TMainForm.ListboxdismortClick(Sender: TObject);
begin
  Toutvar(disuitlistmort.items[Tlistbox(sender).itemindex]).laatzien;
end;

procedure TMainForm.ListBoxdisincClick(Sender: TObject);
begin
  Toutvar(disuitlistinc.items[Tlistbox(sender).itemindex]).laatzien;
end;

procedure TMainForm.ListBoxdisprevClick(Sender: TObject);
begin
  Toutvar(disuitlistprev.items[Tlistbox(sender).itemindex]).laatzien;
end;

procedure TMainForm.ListBoxdiscfatClick(Sender: TObject);
begin
  Toutvar(disuitlistcfat.items[Tlistbox(sender).itemindex]).laatzien;
end;

procedure TMainForm.ListBoxdisremiClick(Sender: TObject);
begin
  Toutvar(disuitlistremi.items[Tlistbox(sender).itemindex]).laatzien;
end;

procedure TMainForm.ListBoxdisDALYClick(Sender: TObject);
begin
  Toutvar(disuitlistdaly.items[Tlistbox(sender).itemindex]).laatzien;
end;

procedure TMainForm.ListBoxdiscostClick(Sender: TObject);
begin
  Toutvar(disuitlistcost.items[Tlistbox(sender).itemindex]).laatzien;
end;

procedure TMainForm.ListBoxRiskClick(Sender: TObject);
begin
  Toutvar(riskuitlist.items[Tlistbox(sender).itemindex]).laatzien;
end;

procedure TMainForm.N9Click(Sender: TObject);
begin
  application.helpcontext(10);
end;

procedure TMainForm.helpbutClick(Sender: TObject);
begin
  application.helpcontext(helpcontext);
end;


procedure TMainForm.View1Click(Sender: TObject);

var tind,ori:integer;

begin
  ori:=tablelist.count-1;
  for tind:=ori downto 0 do Ttableuitform(tablelist.items[tind]).dicht;
  tablelist.clear;
  ori:=dynchartlist.count-1;
  for tind:=ori downto 0 do Tdyngraf(dynchartlist.items[tind]).dicht;
  dynchartlist.clear;
  ori:=statchartlist.count-1;
  for tind:=ori downto 0 do Tgraphuit1(statchartlist.items[tind]).dicht;
  statchartlist.clear;
end;

procedure TMainForm.Outputoptions1Click(Sender: TObject);
begin
  outopform.showmodal;
end;

procedure TMainForm.Closealloutput1Click(Sender: TObject);
begin
  View1Click(Sender);
end;


procedure TMainForm.SpecButClick(Sender: TObject);
begin
  runopform.showmodal;
end;





procedure TMainForm.Sensitivity1Click(Sender: TObject);
begin
  sensbool:=True;
  uncertbool:=false;
  sensform.ShowModal;
end;

procedure TMainForm.Keepinterventions1Click(Sender: TObject);
begin
  Keepinterventions1.Checked:=not Keepinterventions1.Checked;
end;

procedure TMainForm.Uncertainty1Click(Sender: TObject);
begin
  uncertbool:=True;
  sensbool:=false;
  sensform.ShowModal;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  datasetForm.leescurset;
  runopform.setrunops;
  updatecaption;
  romberg:=Tromberg.create;
  theominromberg:=Ttheominromberg.create;
end;

end.
