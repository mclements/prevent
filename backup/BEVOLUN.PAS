
Unit BEVOLUN;

{$MODE Delphi}

Interface

uses sysutils,forms,classes,StdCtrls,INITIAL,trendintvunit,OutvarUnit;

const
  birthlow=10;
  birthhigh=50;

Type
  Tpopulation=class
    pop,totmor,totdale:Tscenar95;
    origmor,origpop,expec,ovdale:Tar95;
    omor:Tscenar95;
    ovcosts:Tar95;
    tpopu,tdaly,ttotmor:Tgenuit;
    tdale,texpec,texpecdis:Tgenuitexpec;
    gebo:Tgenuittot;
    tsurviv,tcosts:Tgenuitcost;  //niet maal 100,000 in uitvoer
    dalebool:boolean;
    costbool:boolean;
    costunit:string;
    TotCost:Tcostvardata;
    Totmordat,Totdaledat,Totpopdat:Tmvardata;
    migration:Tmvardata;
    migrationbool,migrationboth:boolean;
    migrationnaam:string;
    Ovmortrend:Tmvardata;
    Ovmortrendbool,Ovmortrendboth:boolean;
    Ovmortrendnaam:string;
    BirthRate:Tbirthvardata;
    BirthRatebool,BirthRateboth:boolean;
    BirthRatenaam:string;
    procedure stablepop;
    procedure startpop;
    Procedure bevolking;
    Procedure Popinlezen;
    Procedure Popweg;
    procedure popuitvoeropzet;
    procedure popuitvoerafbraak;
    Procedure overigmort;
    constructor create;
    destructor destroy; override;
  end;

var
  population:Tpopulation;
{===========================================================================}

Implementation

Uses
  {WINGLOB,}
  {STARTUN,}DATASET, {PREVMAIN,}DisUnit,{dynpyra,}Popoptions,datmod1;


constructor Tpopulation.create;

begin
  inherited create;
end;

destructor Tpopulation.destroy;
begin
  inherited destroy;
end;

procedure Tpopulation.popuitvoeropzet;

begin
  ttotmor:=Tgenuit.create(et);
  if dalebool then
  begin
    tdaly:=Tgenuit.create(et);
    tdale:=Tgenuitexpec.create(et);
    texpecdis:=Tgenuitexpec.create(et);
  end;
  if costbool then
  begin
    tcosts:=Tgenuitcost.create(et);
  end;
  tpopu:=Tgenuit.create(et);
  tsurviv:=Tgenuitcost.create(et);
  gebo:=Tgenuittot.create(et);
  texpec:=Tgenuitexpec.create(et);
  if migrationbool then
  begin
    migration:=Tmvardata.create('Migration',true);
    migration.leesvarels('SELECT * FROM Migration where InterventionName='+
       datasetform.psq(migrationnaam)+' order by time, lage');
    migrationboth:=popopform.Migrboth.State=cbunchecked;
  end;
  if Ovmortrendbool then
  begin
    Ovmortrend:=Tmvardata.create('Othermortalitytrend',false);
    Ovmortrend.leesvarels('SELECT * FROM Othermortalitytrend where InterventionName='+
       datasetform.psq(Ovmortrendnaam)+' order by time, lage');
    Ovmortrendboth:=popopform.trendboth.State=cbunchecked;
  end;
  BirthRate:=Tbirthvardata.create('BirthRates',false);
  if BirthRatebool then
  begin
    BirthRate.leesvarels('SELECT * FROM BirthRates where InterventionName='+
       datasetform.psq(BirthRatenaam)+' order by time, lage');
    BirthRateboth:=popopform.fertboth.State=cbunchecked;
  end else
  begin
    BirthRate.leesvarels('SELECT * FROM BirthRates where InterventionName='+
       datasetform.psq('Standard')+' order by time, lage');
    BirthRateboth:=false;

  end;
  BirthRate.maakjaar(0);
end;

procedure Tpopulation.popuitvoerafbraak;

begin
  ttotmor.free;
  if dalebool then
  begin
    tdaly.free;
    tdale.free;
    texpecdis.Free;
  end;
  if costbool then tcosts.Free;
  tpopu.Free;
  gebo.Free;
  tsurviv.free;
  texpec.Free;
  if migrationbool then
  begin
    migration.free;
    migrationbool:=false;
  end;
  if Ovmortrendbool then
  begin
    Ovmortrend.free;
    Ovmortrendbool:=false;
  end;
  birthrate.Free;
end;


Procedure Tpopulation.Popinlezen;

var ag:integer;
    sex:Tsex;

begin
  Totmordat:=Tmvardata.create('TotalMortality',false);
  Totmordat.leesvarels('SELECT * FROM TotalMortality where ScenarioName='+
     datasetform.psq('Standard')+' order by time, lage');
  Totmordat.maakjaar(0);
  for sex:=men to fem do
    for ag:=0 to disaggmax do
      origmor[sex,ag]:=Totmordat.oneydata[sex,ag];

  if costbool then
  begin
    TotCost:=Tcostvardata.create('TotalCost',false);
    TotCost.leesvarels('SELECT * FROM TotalCost where ScenarioName='+
       datasetform.psq('Standard')+' order by time, lage');
    TotCost.maakjaar(0);
    for sex:=men to fem do
      for ag:=0 to disaggmax do
        ovcosts[sex,ag]:=totcost.oneydata[sex,ag];
  end;{if}

  if dalebool then
  begin
    Totdaledat:=Tmvardata.create('TotalDisability',false);
    Totdaledat.leesvarels('SELECT * FROM TotalDisability where ScenarioName='+
       datasetform.psq('Standard')+' order by time, lage');
    Totdaledat.maakjaar(0);
    for sex:=men to fem do
      for ag:=0 to disaggmax do
        ovdale[sex,ag]:=Totdaledat.oneydata[sex,ag];

  end;{if}

  if popopform.realpop.itemindex=0 then
  begin
    Totpopdat:=Tmvardata.create('Population',true);
    Totpopdat.leesvarels('SELECT * FROM Population where ScenarioName='+
       datasetform.psq('BaseYear')+' order by time, lage');
    Totpopdat.maakjaar(0);
    for sex:=men to fem do
      for ag:=0 to disaggmax do
        origpop[sex,ag]:=Totpopdat.oneydata[sex,ag];

  end;
end;

Procedure Tpopulation.Popweg;

begin
  Totmordat.free;
  if costbool then
    TotCost.free;
  if dalebool then
    Totdaledat.free;
  if popopform.realpop.itemindex=0 then
    Totpopdat.free;
end;


procedure Tpopulation.startpop;

begin
  omor[ref]:=origmor;
  pop[ref]:=origpop;
end;


procedure Tpopulation.stablepop;

var a,z:integer;
    sex:Tsex;

begin
  totmor[ref]:=omor[ref];
  for z:=0 to curdislist.count-1 do
  with Tdisease(curdislist.items[z]) do
   for sex:=men to fem do
    for a:=0 to disaggmax do
          totmor[ref,sex,a]:=totmor[ref,sex,a]+
             ozmort.datavar[0,sex,ref,a div 5];
   for sex:=men to fem do
    for a:=0 to disaggmax do
          totmor[ref,sex,a]:=1.0-exp(-totmor[ref,sex,a]);
   for sex:=men to fem do
   begin
     pop[ref,sex,0]:=100000.0;
     for a:=0 to disaggmax-1 do
       pop[ref,sex,a+1]:=pop[ref,sex,a]*(1-totmor[ref,sex,a]);
     pop[ref,sex,disaggmax]:=pop[ref,sex,disaggmax]/totmor[ref,sex,disaggmax];
   end;
   pop[intv]:=pop[ref];
end;



Procedure Tpopulation.overigmort;

var sex:tsex;
    z,a:integer;

begin
  for sex:=men to fem do
    for a:=0 to disaggmax do
     begin
       pop[intv,sex,a]:=pop[ref,sex,a];
       omor[ref,sex,a]:=-ln(1-omor[ref,sex,a]);{omzetten van kans naar rate}
       for z:=0 to curdislist.count-1 do
          with Tdisease(curdislist.items[z]) do
            omor[ref,sex,a]:=omor[ref,sex,a]-
             ozmort.datavar[0,sex,ref,a div 5];
     end;{s,a loop}
  omor[intv]:=omor[ref];
  if dalebool then
  for sex:=men to fem do
    for a:=0 to disaggmax do
         for z:=0 to curdisdalylist.count-1 do
          with Tipm(curdisdalylist.items[z]) do
            ovdale[sex,a]:=ovdale[sex,a]-
             ozyld.datavar[0,sex,ref,a div 5];
  if costbool then
  for z:=0 to curipmlist.count-1 do
    if Tipm(curipmlist.items[z]).costbool then
    with Tipm(curipmlist.items[z]) do
    for sex:=men to fem do
      for a:=0 to disaggmax do
        ovcosts[sex,a]:=ovcosts[sex,a]-ozcost.datavar[0,sex,ref,a div 5];
end;


Procedure Tpopulation.bevolking;

procedure popuread;

var a,tt:integer;
    sex:Tsex;
    tmpstr:string;

begin
  tmpstr:='SELECT * FROM Population where ScenarioName='+
     datasetform.psq('Projection')+' and time<='+inttostr(et)+' order by time, lage';
  with datasetform do
  begin
    putquery1(tmpstr);
    with datamodule2.inputQ1 do
    begin
      first;
      while not eof do
      begin
        tt:=fieldbyname('time').asinteger;
        a:=fieldbyname('lage').asinteger div 5;
        tpopu.datavar[tt,men,ref,a]:=fieldbyname('Males').asfloat;
        tpopu.datavar[tt,fem,ref,a]:=fieldbyname('Females').asfloat;
        for sex:=men to fem do
          tpopu.datavar[tt,sex,intv,a]:=tpopu.datavar[tt,sex,ref,a];
        Next;
      end;
      close;
    end;
    datamodule2.SQLTransaction1.Commit;
    end;
  end;
end;



procedure popuvul(tt:integer);

var a:integer;
    sex:Tsex;
    scen:Tscen;

begin
  for scen:=ref to intv do
   for sex:=men to fem do
   begin
     for a:=0 to aggmax do tpopu.datavar[tt,sex,scen,a]:=0.0;
     for a:=0 to disaggmax-1 do
        tpopu.datavar[tt,sex,scen,a div 5]:=
          tpopu.datavar[tt,sex,scen,a div 5]+pop[scen,sex,a];
      tpopu.datavar[tt,sex,scen,aggmax]:=pop[scen,sex,disaggmax];
   end;
end;

procedure morvul(tt:integer);

var a:integer;
    sex:Tsex;
    scen:Tscen;

begin
  for scen:=ref to intv do
   for sex:=men to fem do
   begin
     for a:=0 to aggmax do ttotmor.datavar[tt,sex,scen,a]:=0.0;
     for a:=0 to disaggmax do
       ttotmor.datavar[tt,sex,scen,a div 5]:=ttotmor.datavar[tt,sex,scen,a div 5]+totmor[scen,sex,a];
     for a:=0 to aggmax do
     if tpopu.datavar[tt,sex,scen,a]>0.0 then
      ttotmor.datavar[tt,sex,scen,a]:=
        ttotmor.datavar[tt,sex,scen,a]/tpopu.datavar[tt,sex,scen,a];
   end;
  if dalebool then
  for scen:=ref to intv do
   for sex:=men to fem do
   begin
     for a:=0 to aggmax do tdaly.datavar[tt,sex,scen,a]:=0.0;
     for a:=0 to disaggmax do
       tdaly.datavar[tt,sex,scen,a div 5]:=tdaly.datavar[tt,sex,scen,a div 5]+totdale[scen,sex,a];
     for a:=0 to aggmax do
     if tpopu.datavar[tt,sex,scen,a]>0 then
      tdaly.datavar[tt,sex,scen,a]:=
        tdaly.datavar[tt,sex,scen,a]/tpopu.datavar[tt,sex,scen,a];
   end;
end;

procedure lifetab(tt:integer);

var a:integer;
    kleinl,grootL:array[0..disaggmaxmax] of double;
    grootT,grootTH:double;
    sex:Tsex;
    scen:Tscen;

begin
  for scen:=ref to intv do
   for sex:=men to fem do
   begin
     kleinl[0]:=100.0;
     for a:=0 to disaggmax-1 do
     begin
       if (a mod 5)=0 then tsurviv.datavar[tt,sex,scen,a div 5]:=kleinl[a];
       kleinl[a+1]:=kleinl[a]*(exp(-totmor[scen,sex,a]));
       grootL[a]:=0.5*(kleinl[a]+kleinl[a+1]);
     end;
     tsurviv.datavar[tt,sex,scen,aggmax]:=kleinl[disaggmax];
     grootL[disaggmax]:=kleinl[disaggmax]/(1-exp(-totmor[scen,sex,disaggmax]));
     grootT:=0.0;
     if dalebool then
     begin
       grootTH:=0.0;
       for a:=disaggmax downto 0 do
       begin
         grootT:=grootT+grootL[a];
         grootTH:=grootTH+grootL[a]*(1.0-totdale[scen,sex,a]);
         if tt=0 then expec[sex,a]:=grootT/kleinl[a];
         if (a mod 5)=0 then
         begin
           texpec.datavar[tt,sex,scen,a div 5]:=grootT/kleinl[a];
           tdale.datavar[tt,sex,scen,a div 5]:=grootTH/kleinl[a];
           texpecdis.datavar[tt,sex,scen,a div 5]:=
             texpec.datavar[tt,sex,scen,a div 5]-tdale.datavar[tt,sex,scen,a div 5];
         end;
       end;
     end else
     begin
       for a:=disaggmax downto 0 do
       begin
         grootT:=grootT+grootL[a];
         if tt=0 then expec[sex,a]:=grootT/kleinl[a];
         if (a mod 5)=0 then
         begin
           texpec.datavar[tt,sex,scen,a div 5]:=grootT/kleinl[a];
         end;
       end;
     end;
   end;
end;

procedure sterftes(tt:integer);

var a,z,tint:integer;
    scen:Tscen;
    sex:Tsex;

begin
   if Ovmortrendbool then
   begin
     Ovmortrend.maakjaar(tt);
     for a:=disaggmax downto 0 do
       for sex:=men to fem do
       if Ovmortrendboth then
        for scen:=ref to intv do
           omor[scen,sex,a]:=omor[scen,sex,a]*(1.0+Ovmortrend.oneydata[sex,a])
       else omor[intv,sex,a]:=omor[intv,sex,a]*(1.0+Ovmortrend.oneydata[sex,a]);
   end;

  for scen:=ref to intv do
  begin
    totmor[scen]:=omor[scen];
    for z:=0 to curdislist.count-1 do
    with Tdisease(curdislist.items[z]) do
     for sex:=men to fem do
      for a:=0 to disaggmax do
            totmor[scen,sex,a]:=totmor[scen,sex,a]
              +ozmort.datavar[tt,sex,scen,a div 5];

    if dalebool then
    begin
      totdale[scen]:=ovdale;
      for z:=0 to curdisdalylist.count-1 do
      with Tipm(curdisdalylist.items[z]) do
       for sex:=men to fem do
        for a:=0 to disaggmax do
              totdale[scen,sex,a]:=totdale[scen,sex,a]
                +ozyld.datavar[tt,sex,scen,a div 5];
    end;
    if costbool then
    begin
      for sex:=men to fem do
      begin
       for a:=0 to aggmax do
        tcosts.datavar[tt,sex,scen,a]:=0.0;
       for a:=0 to disaggmax do
        tcosts.datavar[tt,sex,scen,a div 5]:=
          tcosts.datavar[tt,sex,scen,a div 5]+ovcosts[sex,a];
       for a:=0 to aggmax-1 do
        tcosts.datavar[tt,sex,scen,a]:=
          tcosts.datavar[tt,sex,scen,a]/5.0;
        tcosts.datavar[tt,sex,scen,aggmax]:=
          tcosts.datavar[tt,sex,scen,aggmax]/restagg;
      end;
      for z:=0 to curipmlist.count-1 do
      if Tipm(curipmlist.items[z]).costbool then
       with Tipm(curipmlist.items[z]) do
       for sex:=men to fem do
        for a:=0 to aggmax do
           tcosts.datavar[tt,sex,scen,a]:=tcosts.datavar[tt,sex,scen,a]
                +ozcost.datavar[tt,sex,scen,a];
    end;
   end;
end;

Procedure Poploop;

var
    t,a:integer;
    scen:Tscen;
    sex:Tsex;

begin
  for t:=0 to et do
  begin
   if not readpopproj then popuvul(t) else if t=0 then popuvul(t);
   sterftes(t);
   if not incionlybool then lifetab(t);     
   for sex:=men to fem do
   begin
     for a:=disaggmax downto 0 do
     begin
       for scen:=ref to intv do
       begin
         totmor[scen,sex,a]:=pop[scen,sex,a]*(1.0-exp(-totmor[scen,sex,a]));
  {Let op: totmor bevat eerst rates, maar nu aantallen}
         if a<disaggmax-1 then pop[scen,sex,a+1]:=pop[scen,sex,a]-totmor[scen,sex,a]
         else if a=disaggmax-1 then pop[scen,sex,a+1]:=pop[scen,sex,a+1]+pop[scen,sex,a]-totmor[scen,sex,a]
         else if a=disaggmax then pop[scen,sex,a]:=pop[scen,sex,a]-totmor[scen,sex,a];
         totdale[scen,sex,a]:=totdale[scen,sex,a]*pop[scen,sex,a];
  {Let op: totdale bevat eerst rates, maar nu aantallen}
       end;{j loop}
     end;{a loop}
   end;{s loop}
   morvul(t);

   if not readpopproj then
   begin
     if popopform.realpop.itemindex=0 then
     begin
       if birthratebool then birthrate.maakjaar(t); //haal nieuwe oneydata
       for sex:=men to fem do
       begin
         for scen:=ref to intv do
           pop[scen,sex,0]:=0.0;
         if birthrateboth then   //beide pops met dezelfde rates, al dan niet met trend
          for scen:=ref to intv do
          for a:=0 to disaggmax do
           pop[scen,sex,0]:=pop[scen,sex,0]+pop[scen,fem,a]*birthrate.oneydata[sex,a]
         else  //de ref heeft oorspronkelijke rate, de intv de eventuele nieuwe
          for a:=0 to disaggmax do
          begin
            pop[ref,sex,0]:=pop[ref,sex,0]+pop[ref,fem,a]*birthrate.oneydatat0[sex,a];
            pop[intv,sex,0]:=pop[intv,sex,0]+pop[intv,fem,a]*birthrate.oneydata[sex,a];
          end;
        end;
     end else //Lifetable populatie
     for scen:=ref to intv do
     for sex:=men to fem do pop[scen,sex,0]:=100000.0;

     for scen:=ref to intv do
      for sex:=men to fem do gebo.datavar[t,sex,scen,0]:=pop[scen,sex,0];



     if migrationbool then
     begin
       migration.maakjaar(t);
       for a:=disaggmax downto 0 do
         for sex:=men to fem do
         if migrationboth then
          for scen:=ref to intv do
             pop[scen,sex,a]:=pop[scen,sex,a]+migration.oneydata[sex,a]
         else pop[intv,sex,a]:=pop[intv,sex,a]+migration.oneydata[sex,a];
     end;
   end; {if not readpopproj}  
  end;{t loop}
end;{poploop}


Begin
{  costbool:=false;
  for ind:=0 to curdislist.count-1 do
     if Tdisease(curdislist.items[ind]).costbool then costbool:=true;;}
  startpop;
  overigmort;
  if popopform.realpop.itemindex=1 then stablepop;
  if readpopproj then popuread;
  poploop;
end;

End.
