unit Runop;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Spin;

type
  Trunopform = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    chainGroup: TRadioGroup;
    closebut: TButton;
    disGroup: TRadioGroup;
    rfchoicebut: TButton;
    IntervBut: TButton;
    DisBut: TButton;
    rfopBut: TButton;
    DisopBut: TButton;
    Panel3: TPanel;
    GenopBut: TButton;
    Spinrun: TSpinEdit;
    lengthLabel: TLabel;
    procedure closebutClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure rfchoicebutClick(Sender: TObject);
    procedure chainGroupClick(Sender: TObject);
    procedure IntervButClick(Sender: TObject);
    procedure DisButClick(Sender: TObject);
    procedure disGroupClick(Sender: TObject);
    procedure rfopButClick(Sender: TObject);
    procedure DisopButClick(Sender: TObject);
    procedure GenopButClick(Sender: TObject);
    procedure SpinrunChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure herzetform;
    procedure setrunops;
  end;

var
  runopform: Trunopform;

implementation

{$R *.DFM}

uses gescale,initial,disunit,winglob,runspec, kies,rfoptions,
  Disoptions,popoptions,predefintunit, Dataset, datmod1,trendintvunit,math;

procedure Trunopform.setrunops;

var ind:integer;

begin
  with runopform do
  begin
    if disgroup.itemindex=0 then
    begin
      curdislist.clear;
      curipmlist.clear;
      curdisremilist.clear;
      curdisdalylist.clear;
      curdiscostlist.clear;
      for ind:=0 to diseaselist.count-1 do
           Tdisease(diseaselist.items[ind]).curlijstvoegtoe(ind);
    end;
    if chaingroup.itemindex=0 then
    begin
      currflist.clear;
      for ind:=0 to riskfactorlist.count-1 do
        currflist.add(Tgenentity(riskfactorlist.items[ind]));
    end;
  end;
end;

procedure Trunopform.closebutClick(Sender: TObject);
begin
  setrunops;
  close;
end;


procedure Trunopform.FormCreate(Sender: TObject);
begin
  geautoscale(runopform);
  lengthlabel.caption:='Length of run '+#13#10+'(years)';
  setrunops;
end;

procedure Trunopform.FormActivate(Sender: TObject);

begin
  herzetform;
end;

procedure Trunopform.herzetform;
begin
  chaingroup.enabled:=not uitbool;
  disbut.enabled:=disGroup.itemindex=2;
  rfchoicebut.enabled:=chainGroup.itemindex=1;
  intervbut.enabled:=currflist.count>0;
end;

procedure Trunopform.rfchoicebutClick(Sender: TObject);
begin
  runForm.datsetlabelset;
{  rfprevForm.datsetlabelset;}
  runform.rfchoice:=true;
  runForm.filrisfaclist;
  runform.showmodal;
  herzetform;
end;

procedure Trunopform.chainGroupClick(Sender: TObject);
begin
  herzetform;
end;

procedure Trunopform.IntervButClick(Sender: TObject);
var
  tmpstr:string;
  num,risfac,predefresult:integer;

begin
 risfac:=kiesform.currfkiezen;
 if risfac>-1 then //user pressed cancel
 begin
   if Tgenentity(currflist.items[risfac]) is Tcategory then
   begin
     PredefintForm.predefchecklist.clear;
      with datasetform do
      begin
        putquery1('SELECT distinct Interventionname FROM CatrfInterventions '+
                  'where RiskfactorName='+
                  psq(Tgenentity(currflist.items[risfac]).Name));
        with datamodule2.inputQ1 do
        begin
          first;
          while not eof do
          begin
            PredefintForm.predefchecklist.Items.Add(fields[0].asstring);
            next;
          end;
        end;
      end;{with}
      if PredefintForm.predefchecklist.items.count>0 then
      begin
        PredefintForm.caption:='Interventions for the risk factor '+Tgenentity(currflist.items[risfac]).name;
        Predefresult:=PredefintForm.showmodal;
        if predefresult=mrOK then
        with Tcategory(currflist.items[risfac]) do
        begin
          intervbool:=true;
          intervens:=Tcatintervens.create('CatrfInterventions',false);
          intervens.zetcatno(catno);
          intervens.leesvarels('SELECT * FROM CatrfInterventions where RiskfactorName='+
             datasetform.psq(name)+' and InterventionName='+
             datasetform.psq(PredefintForm.predefchecklist.items[PredefintForm.predefchecklist.itemindex])+'and catno=0 order by time, lage');
          for num:=1 to catno-1 do
            intervens.leesvarelscat('SELECT * FROM CatrfInterventions where RiskfactorName='+
             datasetform.psq(name)+' and InterventionName='+
             datasetform.psq(PredefintForm.predefchecklist.items[PredefintForm.predefchecklist.itemindex])+'and catno='+inttostr(num)+' order by time, lage',num);
          Rrintervention:=intervens.RRintervens;
        end;
      end;
    end else //the risk factor is Tconrf
   begin
     PredefintForm.predefchecklist.clear;
      with datasetform do
      begin
        putquery1('SELECT distinct Interventionname FROM ConrfInterventions '+
                  'where RiskfactorName='+
                  psq(Tgenentity(currflist.items[risfac]).Name));
        with datamodule2.inputQ1 do
        begin
          first;
          while not eof do
          begin
            PredefintForm.predefchecklist.Items.Add(fields[0].asstring);
            next;
          end;
        end;
      end;{with}
      if PredefintForm.predefchecklist.items.count>0 then
      begin
        PredefintForm.caption:='Interventions for the risk factor '+Tgenentity(currflist.items[risfac]).name;
        Predefresult:=PredefintForm.showmodal;
        if predefresult=mrOK then
        with Tconrf(currflist.items[risfac]) do
        begin
          intervbool:=true;
          intervens:=Tconmvardata.create('ConrfInterventions',false);
          intervens.interventionname:=PredefintForm.predefchecklist.items[PredefintForm.predefchecklist.itemindex];
          {corresponding statements are in tconrf.leesinvoer}
        end;
      end;
    end;
  end;  
end;

procedure Trunopform.DisButClick(Sender: TObject);
begin
  runForm.datsetlabelset;
  runform.fildislist;
  runform.rfchoice:=false;
  runform.showmodal;
  herzetform;
end;

procedure Trunopform.disGroupClick(Sender: TObject);
begin
  disbut.enabled:=disGroup.itemindex=2;
end;

procedure Trunopform.rfopButClick(Sender: TObject);
var
  trf:integer;
begin
  trf:=kiesform.currfkiezen;
  if trf>-1 then
  begin
    rfopform.risfac:=currflist.items[trf];
    rfopform.showmodal;
  end;  
end;

procedure Trunopform.DisopButClick(Sender: TObject);
var
  predefresult,tdis:integer;

begin
  tdis:=kiesform.curdiskiezen(curdislist);
  if tdis>-1 then
  begin
    disopform.ziekte:=Tdisease(curdislist.items[tdis]);
    disopform.ziekte.zetopties;
    disopform.showmodal;
  end;

(*  PredefintForm.predefchecklist.clear;
  with datasetform do
  begin
    putquery1('SELECT distinct Interventionname FROM DiseaseInterventions '+
              'where DiseaseInterventions.DiseaseName='+
              psq(disopform.ziekte.Name));
    with datamodule2.inputQ1 do
    begin
      first;
      while not eof do
      begin
        PredefintForm.predefchecklist.Items.Add(fields[0].asstring);
        next;
      end;
    end;
  end;{with}
  if PredefintForm.predefchecklist.items.count>0 then
  begin
    PredefintForm.caption:='Interventions for disease '+disopform.ziekte.Name;
    Predefresult:=PredefintForm.showmodal;
    if predefresult=mrOK then
         trendform.readpredef
      else disopform.showmodal;
  end;*)
end;

procedure Trunopform.GenopButClick(Sender: TObject);
begin
  popopform.showmodal;
end;




procedure Trunopform.SpinrunChange(Sender: TObject);
begin
  et:=spinrun.value;
end;

end.
