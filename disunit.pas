unit DisUnit;

{$MODE Delphi}

interface

uses classes,math,StdCtrls,INITIAL,trendintvunit,OutvarUnit;

Type
  Tgenentity=class
    name:string;
    lookback:integer;
    rflist:Tlist;
    pzlist:Tgenuitpif;
    intervbool:boolean;
    procedure RRinvoer; virtual; abstract;
    procedure leesinvoer; virtual; abstract;
    procedure uitvoeropzet; virtual;
    procedure uitvoerafbraak; virtual;
    procedure pzaanpas(tt:integer);
    procedure ReadRRinvoer(disvar:string);
    procedure interventie(tijd:integer); virtual; abstract;
    procedure intervensafbreuk; virtual; abstract;
    procedure jaarstap(tt:integer); virtual; abstract;
    procedure dojaarstap(tt:integer);
    procedure dopzaanpas(tt:integer);
    procedure pzlistcor;
    constructor create(n:string);
    destructor destroy; override;
  end;

  Tcategory=class(Tgenentity)
    catno:integer;
    catnames:array of string;
    prevrf:Tcatdatavar;
    intervens:Tcatintervens;
    Rrintervention:boolean;
    constructor create(n:string);
    destructor destroy; override;
  end;

  Tcatrf=class(Tcategory)
    expouit:Tgenuitrf;
    prevalen:Tcatmvardata;
    procedure curafbreuk;
    procedure uitvoeropzet; override;
    procedure uitvoerafbraak; override;
    procedure intervensafbreuk; override;
    procedure interventie(tijd:integer); override;
    procedure RRinvoer; override;
    procedure leesinvoer; override;
    procedure maakuitvoer(tt:integer);
    procedure jaarstap(tt:integer); override;
    constructor create(n:string);
  end;

  Tcatrfcohort=class(Tcatrf)
    Initage:integer;
    initinterv:array of array[Tsex] of double;
    initprev:Tcatcohortmvardata;
    changep,mortrr:Tcatmvardata;
    totmor:Tmvardata;
    excessmort:array of Tar95;
    procedure interventie(tijd:integer); override;
    procedure leesinvoer; override;
    procedure jaarstap(tt:integer); override;
    constructor create(n:string);
    destructor destroy; override;
  end;


  Tnormal=class(Tdistribution)
    function calc(x:double;dp:Tdisparams):double; override;
    procedure zetlxhx(dp:Tdisparams;var llx,lhx,lx,hx:double); override;
    procedure paspiftoe(depif:double;dp:Tdisparams); override;
    constructor create(n:string);
    destructor destroy; override;
  end;

  Tlognormal=class(Tnormal)
    function calc(x:double;dp:Tdisparams):double; override;
    procedure zetlxhx(dp:Tdisparams;var llx,lhx,lx,hx:double); override;
{    procedure paspiftoe(depif:double); override;
    constructor create(n:string);
    destructor destroy; override;}
  end;

  Tlognormaloffset=class(Tlognormal)
    function calc(x:double;dp:Tdisparams):double; override;
    procedure paspiftoe(depif:double;dp:Tdisparams); override;
    procedure zetlxhx(dp:Tdisparams;var llx,lhx,lx,hx:double); override;
    constructor create(n:string);
  end;

  Tweibull=class(Tdistribution)
    function calc(x:double;dp:Tdisparams):double; override;
    function mean(alfa,beta:double):double;
    procedure zetlxhx(dp:Tdisparams;var llx,lhx,lx,hx:double); override;
    procedure paspiftoe(depif:double;dp:Tdisparams); override;
    constructor create(n:string);
    destructor destroy; override;
  end;

  Tlinkfunc=class
    influname,lfname:string;
    lfparanum:integer;
    lfparams:array of double;
    function lfcalc(x:double):double; virtual; abstract;
{    procedure zetpar(pp:double); virtual; abstract;      }
    constructor create(n,i:string);
    destructor destroy; override;
  end;

  Tlinear=class(Tlinkfunc)
    function lfcalc(x:double):double; override;
{    procedure zetpar(pp:double); override;        }
    constructor create(n,i:string);
  end;

  Tperunit=class(Tlinkfunc)
    function lfcalc(x:double):double; override;
    constructor create(n,i:string);
  end;

  Tlinear2=class(Tlinkfunc)
    lforigparams:array of double;
    function lfcalc(x:double):double; override;
{    procedure zetpar(pp:double); override;                }
    constructor create(n,i:string);
    destructor destroy; override;
  end;

  Tlogit=class(Tlinear)
    function lfcalc(x:double):double; override;
  end;

  Tloglinear=class(Tlinear)
    function lfcalc(x:double):double; override;
  end;

  Tconrf=class(Tgenentity)
    expouit:Tgenuitconrf;
    curinflu:integer;
    prevalen:Tmvarddist;
    intervens:Tconmvardata;
    dist:Tcondists;
    llx,lhx,lx,hx,step:double;
    procedure leesinvoer; override;
    procedure RRinvoer; override;
    procedure uitvoeropzet; override;
    procedure uitvoerafbraak; override;
    procedure interventie(tijd:integer); override;
    procedure intervensafbreuk; override;
    procedure jaarstap(tt:integer);  override;
    function getagegroups:Tstrings;
    procedure maakuitvoer(tt:integer);
    constructor create(n:string);
    destructor destroy; override;
  end;


  Tdisease=class(Tcategory)
    morts1:Tscenar95;
    ozmort:Tgenuit;
    dismortrend:Tcostvardata;
    dismortrendbool,dismortrendboth:boolean;
    dismortrendnaam,dismortrendvar:string;
    procedure curlijstvoegtoe(ind:integer); virtual;
    procedure zetopties; virtual;
    procedure readziektedata(disvar:string;sex:Tsex;var vars1:Tscenar95);
    procedure ziektedata; virtual;
    procedure uitvoeropzet; override;
    procedure uitvoerafbraak; override;
    procedure RRinvoer; override;
    procedure trendaanpas(tt:integer); virtual;
    procedure paspiftoe(tt:integer); virtual;
    procedure maakuitvoer(tt:integer); virtual;
    procedure jaarstap(tt:integer); override;
    procedure leesinvoer; override;
    procedure interventie(tijd:integer); override;
    procedure intervensafbreuk; override;
    constructor create(n:string);
    destructor destroy; override;
  end;

  Tincionly=class(Tdisease)
    procedure ziektedata; override;
    procedure RRinvoer; override;
    constructor create(n:string);
  end;

  Tipm=class(Tdisease)
    incis1,cfat1,prevs1:Tscenar95;
    ozprev,ozyld:Tgenuit;
    ozinci:Tgenuitinci;
    ozcfat:Tgenuitcfat;
    ozcost:Tgenuitcost;
    disincitrend:Tmvardata;
    disincitrendbool,disincitrendboth:boolean;
    disincitrendnaam:string;
    dalybool,costbool,rftoobool:boolean;
    DisCost:Tcostvardata;
    DisCosttrendbool,DisCosttrendboth:boolean;
    DisCosttrendnaam:string;
    Disdaly:Tcostvardata;
    Disdalytrendbool,Disdalytrendboth:boolean;
    Disdalytrendnaam:string;
    Procedure interpol(vijfars:Tar20;var eenars:Tar95);
    procedure curlijstvoegtoe(ind:integer); override;
    procedure zetopties; override;
    procedure ziektedata; override;
    Procedure costdalydata;
    procedure uitvoeropzet; override;
    procedure uitvoerafbraak; override;
    procedure RRinvoer; override;
    procedure trendaanpas(tt:integer); override;
    procedure paspiftoe(tt:integer); override;
    procedure maakuitvoer(tt:integer); override;
    constructor create(n:string);
    destructor destroy; override;
  end;

  Tstate=(healthy,diseased,dead);
  Tstatears=array[Tscen,Tstate] of Tar951;
  Tinterms=(wee,vee,el,qu,mortotaal);

  Thazard3=class(Tipm)
    intermar:array[Tinterms] of Tar95;
    statesar:Tstatears;
    remis1:Tscenar95;
    ozremi:Tgenuitcfat;
    disremitrend:Tmvardata;
    disremitrendbool,disremitrendboth:boolean;
    disremitrendnaam:string;
    function weefunc(scen:Tscen;sex:Tsex;ag:integer):Double;
    function veefunc(scen:Tscen;sex:Tsex;ag:integer):Double;
    function elfunc(scen:Tscen;sex:Tsex;ag:integer;tt:integer):Double;
    function qufunc(scen:Tscen;sex:Tsex;ag:integer;tt:integer):Double;
    procedure mortprevfunc(scen:Tscen;sex:Tsex;ag:integer);
    procedure nexthealthy(scen:Tscen;sex:Tsex;ag:integer);
    procedure nextdiseased(scen:Tscen;sex:Tsex;ag:integer);
    procedure nextdead(scen:Tscen;sex:Tsex;ag:integer);
    procedure nextprocs(scen:Tscen;sex:Tsex;ag:integer;tt:integer);
    procedure basiceen(scen:Tscen;sex:Tsex;ag:integer;tt:integer);
    procedure curlijstvoegtoe(ind:integer); override;
    procedure ziektedata; override;
    procedure uitvoeropzet; override;
    procedure uitvoerafbraak; override;
    procedure trendaanpas(tt:integer); override;
    procedure paspiftoe(tt:integer); override;
    procedure maakuitvoer(tt:integer); override;
    constructor create(n:string);
    destructor destroy; override;
  end;

  Tlagfunc=(lin,expon,logis);

  Trfdis=class
    rfac,dis:Tgenentity;
    cum,lat,lag,latplag:integer;
    lagfunc:Tlagfunc;
    pidr00:Tpidr;
{    corfac:double;            }
    procedure zetpidr20(out pidr:Tpidr);
    procedure getpidr(var pidr:Tpidr;tt:integer;nuleen:integer); virtual; abstract;
    procedure readrrs(disvar,disname:string); virtual; abstract;
    function laglat(tdif:integer):double;
    constructor create(rf,di:Tgenentity);
    destructor destroy; override;
  end;

  Trfdiscat=class(Trfdis)
    RelRis:Tcatmvardata;
    currr:Tcatar95;
    RRinterv:boolean;
    procedure getpidr(var pidr:Tpidr;tt:integer;nuleen:integer); override;
    procedure readrrs(disvar,disname:string); override;
    constructor create(rf,di:Tgenentity);
    destructor destroy; override;
  end;

  Trfdiscon=class(Trfdis)
    Riskfunc:Tmvarfunc;
    linkfunc:array[Tsex] of array of Tlinkfunc;
    curscen:Tscen;
    cursex:Tsex;
    curag,curtt:integer;
    themin0:array[Tsex] of double;
    function theminfunction(x:double):double;
    procedure setthemin0;
    procedure getpidr(var pidr:Tpidr;tt:integer;nuleen:integer); override;
    procedure readrrs(disvar,disname:string); override;
    function intfunction(x:double):double;
    constructor create(rf,di:Tgenentity);
    destructor destroy; override;
  end;



var
  diseaselist, curdislist, ipmlist,curipmlist,
  disremilist, curdisremilist, disdalylist,curdisdalylist,
  discostlist, curdiscostlist:Tlist;
  disease:Tdisease;
  rfdis:Trfdis;
  riskfactorlist,currflist,genentitylist,curgenentlist:Tlist;
  riskfactor:Tgenentity;

implementation

{--------------------------------------------------------------------}

uses sysutils,{PREVMAIN,}DATASET,Disoptions,datmod1,memomes,CalcUnit,dialogs;

{---------------------------------------------------------------------}
procedure Tgenentity.dojaarstap(tt:integer);
begin
  if tt+lookback>=0 then
     jaarstap(tt+lookback);
end;

procedure Tgenentity.dopzaanpas(tt:integer);
begin
  if tt+lookback>0 then pzaanpas(tt+lookback);     
end;

constructor Tgenentity.create(n:string);
begin
  inherited create;
  name:=n;
  rflist:=Tlist.create;
  intervbool:=false;
end;


procedure Tgenentity.pzaanpas(tt:integer);
// versie zonder cumulative risk, age group perspective

var ind,ag,ht,pt:integer;
    pidr0,pidrt:Tpidr;
    scen:Tscen;
    sex:Tsex;
    pif,tmp:double;
    rfdis:Trfdis; // included for debugging

begin
  try
  for ind:=0 to rflist.count-1 do
  begin
    rfdis := Trfdis(rflist.items[ind]);
  with rfdis do
  begin
    zetpidr20(pidr0);
    pidrt:=pidr0;
    getpidr(pidr0,tt,1);
    getpidr(pidrt,tt,0);
    for scen:=ref to intv do
    for sex:=men to fem do
    begin
      for ht:=tt to et+self.lookback do
      begin
        if ht-self.lookback>=0 then
        begin
          pt:=ht-self.lookback;
          if (pt<length(dis.pzlist.datavar)) then
          for ag:=0 to disaggmax do
          begin
          if (pidr0[scen,sex,ag]>0.0) then
            pif:=(laglat(ht-tt)*(pidr0[scen,sex,ag]-
                    pidrt[scen,sex,ag])/pidr0[scen,sex,ag])
            else pif := 1.0;
            if pif=1.0 then tmp := 0.0 else tmp := exp(ln(1.0-pif)*0.2);
            if ag<disaggmax then
              dis.pzlist.datavar[pt,sex,scen,ag div 5]:=
                dis.pzlist.datavar[pt,sex,scen,ag div 5]*tmp
            else  //pif eerst omzetten naar rate, dan delen door 5, en dan weer kans
              dis.pzlist.datavar[pt,sex,scen,ag div 5]:=
                dis.pzlist.datavar[pt,sex,scen,ag div 5]*(1.0-pif);
          end;
        end;
      end;
      end;
    end; // with
  end; // for ind
  except
    on E:Exception do
      MessageDlg('PZerror: '+e.message+', '+self.name+', PIDR0 '+floattostrf(pidr0[scen,sex,ag],fffixed,10,3)+
                ' PIDRt '+floattostrf(pidrt[scen,sex,ag],fffixed,10,3)+
                ' tt '+inttostr(tt)+' ht '+inttostr(ht), mtError, [mbOK], 0);
  end;
end;


(*
procedure Tgenentity.pzaanpas(tt:integer);
// versie zonder cumulative risk, cohort perspective

var ind,ag,ht,pt,agcoh,tmpll:integer;
    pidr0,pidrt:Tpidr;
    scen:Tscen;
    sex:Tsex;
    pif,pif2,tmpll2:double;
    rfdis:Trfdis; // included for debugging

begin
  try
  for ind:=0 to rflist.count-1 do
  begin
    rfdis := Trfdis(rflist.items[ind]); // included for debugging
  with rfdis do
  begin
    zetpidr20(pidr0);
    pidrt:=pidr0;
    getpidr(pidr0,tt,1);
    getpidr(pidrt,tt,0);
    if tt=1 then
    begin
      for scen:=ref to intv do
      for sex:=men to fem do
      begin
        for ag:=0 to disaggmax do
           if pidr0[scen,sex,ag-1]>0.0 then
             pidr00[scen,sex,ag]:=1.0-(pidr0[scen,sex,ag-1]-pidr0[scen,sex,ag])/pidr0[scen,sex,ag-1]
             else pidr00[scen,sex,ag]:=1.0;
        for ag:=disaggmax+1 to disaggmaxmax do pidr00[scen,sex,ag]:=1.0;
      end;
    end;
    for scen:=ref to intv do
    for sex:=men to fem do
    begin
      for ag:=0 to disaggmax do
      begin
        if (pidr00[scen,sex,ag]>0.0) and (pidr0[scen,sex,ag-1]>0.0)
        then pif:=1.0-(1.0-(pidr0[scen,sex,ag-1]-
                pidrt[scen,sex,ag])/pidr0[scen,sex,ag-1])/pidr00[scen,sex,ag]
        else pif:=1.0;
//        if (pidr0[scen,sex,ag-1]-pidr0[scen,sex,ag]=pidr0[scen,sex,ag-1]-pidrt[scen,sex,ag])
//        and (pidr0[scen,sex,ag-1]-pidr0[scen,sex,ag]<>pidr00[scen,sex,ag-1]-pidr00[scen,sex,ag]) then pif:=0.0;
//        if (tt>28) and (ag=65) then pif:=0.0; doesn't work either: intervention goes to highest age as well
        for agcoh:=ag to disaggmax do
        begin
          pt:=tt-self.lookback+agcoh-ag;
          if (pt>=0) and (pt<length(dis.pzlist.datavar)) then
          begin  //problem: when lag>1 the same agcoh pt combination will be hit on successive tts
            if pidr0[ref,sex,ag-1]=pidr0[ref,sex,-1] then tmpll:=1000  //this is to remove the lag in age
            else tmpll:=agcoh-ag+1;
            tmpll2 := 1.0-pif*laglat(tmpll);
            if tmpll2 >0.0 then tmpll2 := exp(ln(tmpll2)*0.2);
            if agcoh<disaggmax then
              dis.pzlist.datavar[pt,sex,scen,agcoh div 5]:=
                dis.pzlist.datavar[pt,sex,scen,agcoh div 5]*tmpll2
                // dis.pzlist.datavar[pt,sex,scen,agcoh div 5]*exp(ln(1.0-pif*laglat(tmpll))*0.2)
            else  //pif eerst omzetten naar rate, dan delen door 5, en dan weer kans
              dis.pzlist.datavar[pt,sex,scen,agcoh div 5]:=
                dis.pzlist.datavar[pt,sex,scen,agcoh div 5]*(1.0-pif*laglat(tmpll));
          end;
        end;
      end;
    end;
    end; //with
  end; //ind
  except
    on E:Exception do
      MessageDlg('PZerror: '+e.message+', '+self.name+', agcoh '+inttostr(agcoh)+', ag '+inttostr(ag)+', PIDR00 '+floattostrf(Trfdis(rflist.items[ind]).pidr00[scen,sex,ag],fffixed,10,3)+
      ', PIDR0 '+floattostrf(pidr0[scen,sex,ag],fffixed,10,3)+
                ' PIDRt '+floattostrf(pidrt[scen,sex,ag],fffixed,10,3)+', pif '+floattostrf(pif,fffixed,10,3)+
                ' tt '+inttostr(tt)+' pt '+inttostr(pt), mtError, [mbOK], 0);
  end;
end;
*)

procedure Tgenentity.ReadRRinvoer(disvar:string);
var ind1:integer;

begin
  for ind1:=0 to rflist.count-1 do
  with Trfdis(rflist.items[ind1]) do readrrs(disvar,dis.name);
end;{ReadRRinvoer}



procedure Tgenentity.uitvoeropzet;
begin
  pzlist:=Tgenuitpif.create(et+lookback);
end;

procedure Tgenentity.uitvoerafbraak;
begin
  pzlist.free;
end;

procedure Tgenentity.pzlistcor;
var ag,tt:integer;
    scen:Tscen;
    sex:Tsex;
begin
  for tt:=et downto 0 do
   for scen:=ref to intv do
    for sex:=men to fem do
     for ag:=0 to aggmax do
       pzlist.datavar[tt,sex,scen,ag]:=pzlist.datavar[tt,sex,scen,ag]/pzlist.datavar[0,sex,scen,ag];
end;

destructor Tgenentity.destroy;
begin
  rflist.free;
  inherited destroy;
end;
{---------------------------------------------------------------------}
constructor Tcategory.create(n:string);
begin
  inherited create(n);
  Rrintervention:=false;
end;

destructor Tcategory.destroy;
begin
  catnames:=nil;
  inherited destroy;
end;

{---------------------------------------------------------------------}

constructor Tcatrf.create(n:string);
begin
  inherited create(n);
  prevalen:=Tcatmvardata.create('CatrfExposure',false);
  catno:=1;
end;

procedure Tcatrf.leesinvoer;
var
  num:integer;
begin
  prevalen.zetcatno(catno);
  prevalen.leesvarels('SELECT * FROM CatrfExposure where RiskfactorName='+
  datasetform.psq(name)+' and ScenarioName='+
     datasetform.psq('Standard')+' and catno=0 order by time, lage');
  for num:=1 to catno-1 do
    prevalen.leesvarelscat('SELECT * FROM CatrfExposure where RiskfactorName='+
    datasetform.psq(name)+' and ScenarioName='+
     datasetform.psq('Standard')+' and catno='+inttostr(num)+' order by time, lage',num);
  RRinvoer;
end;

procedure Tcatrf.RRinvoer;

begin
  ReadRRinvoer('Prevalence');
end;{RRinvoer}


procedure Tcatrf.jaarstap(tt:integer);
{const
  tiny=0.000001;}
var
     cn,ag:integer;
     sex:Tsex;
     tmp,tmp2:double;
begin
  prevalen.maakjaar(tt-lookback);
  for sex:=men to fem do
   for ag:=0 to disaggmax do
   begin
     tmp:=0.0;
     for cn:=1 to catno-1 do
     begin
       prevrf[tt,sex,ref,cn,ag]:=prevalen.oneydata[cn,sex,ag]*
         (pzlist.datavar[tt,sex,ref,ag div 5]/pzlist.datavar[0,sex,ref,ag div 5]);
       tmp:=tmp+prevrf[tt,sex,ref,cn,ag];
     end;
     prevrf[tt,sex,ref,0,ag]:=1.0-tmp;
   end;
  if tt=0 then
  for sex:=men to fem do
   for cn:=0 to catno-1 do
    for ag:=0 to disaggmax do
    prevrf[tt,sex,intv,cn,ag]:=prevrf[tt,sex,ref,cn,ag]
  else
  begin
   for sex:=men to fem do
    for ag:=disaggmax downto 0 do
    begin
      for cn:=1 to catno-1 do
      begin
        if prevrf[tt-1,sex,ref,cn,ag]>0.0 then               //geen deling door 0
         tmp:=prevrf[tt-1,sex,intv,cn,ag]*
           (prevrf[tt,sex,ref,cn,ag]/prevrf[tt-1,sex,ref,cn,ag])
             -prevrf[tt-1,sex,intv,cn,ag]            //autonome trend in ref geldt ook voor intv
            else tmp:=prevrf[tt,sex,ref,cn,ag];     //?
        prevrf[tt,sex,intv,cn,ag]:=prevrf[tt-1,sex,intv,cn,ag]+tmp;
      end;
    end;
    for ag:=0 to disaggmax do
      for sex:=men to fem do
      begin
        tmp2:=0.0;
        for cn:=1 to catno-1 do
        begin
          prevrf[tt,sex,intv,cn,ag]:=min(1.0,prevrf[tt,sex,intv,cn,ag]
            *(1.0-((pzlist.datavar[tt-1,sex,intv,ag div 5]/pzlist.datavar[0,sex,intv,ag div 5])
            /(pzlist.datavar[tt-1,sex,ref,ag div 5]/pzlist.datavar[0,sex,ref,ag div 5])
            -(pzlist.datavar[tt,sex,intv,ag div 5]/pzlist.datavar[0,sex,intv,ag div 5])
            /(pzlist.datavar[tt,sex,ref,ag div 5]/pzlist.datavar[0,sex,ref,ag div 5]))));
          tmp2:=tmp2+prevrf[tt,sex,intv,cn,ag];         //pz intv contains both ref and intv!
        end;
        prevrf[tt,sex,intv,0,ag]:=1.0-tmp2;
      end;
  end;
  if intervbool then interventie(tt-lookback);
  maakuitvoer(tt);
end;

procedure Tcatrf.maakuitvoer(tt:integer);
var  scen:Tscen;
     ag,cn:integer;
     sex:Tsex;
begin
  for scen:=ref to intv do
  begin
    for ag:=0 to disaggmax do
     for sex:=men to fem do
     begin
       for cn:=1 to catno-1 do
        expouit.datavar[tt,sex,scen,ag div 5]:=
           expouit.datavar[tt,sex,scen,ag div 5]
            +prevrf[tt,sex,scen,cn,ag];
     end;
    for ag:=0 to aggmax-1 do
     for sex:=men to fem do
        expouit.datavar[tt,sex,scen,ag]:=
         expouit.datavar[tt,sex,scen,ag]/5.0;
     for sex:=men to fem do
        expouit.datavar[tt,sex,scen,aggmax]:=
         expouit.datavar[tt,sex,scen,aggmax]/restagg;
  end;{with scen}
end;


procedure Tcatrf.curafbreuk;
begin
  intervensafbreuk;
end;

procedure Tcatrf.uitvoeropzet;

var  scen:Tscen;
     t,cn:integer;
     sex:Tsex;
begin
  inherited uitvoeropzet;
  setlength(prevrf,et+lookback+2);
  for t:=0 to et+lookback+1 do
   for scen:=ref to intv do
    for sex:=men to fem do
    begin
      setlength(prevrf[t,sex,scen],catno);
      for cn:=0 to catno-1 do
        setlength(prevrf[t,sex,scen,cn],disaggmax+1);
    end;
  expouit:=Tgenuitrf.create(et+lookback);
end;

procedure Tcatrf.uitvoerafbraak;

begin
  inherited uitvoerafbraak;
  prevrf:=nil;
  expouit.free;
end;

procedure Tcatrf.intervensafbreuk;

begin
  if intervbool then
  begin
    intervens.free;
    intervbool:=false;
  end;
end;

procedure Tcatrf.interventie(tijd:integer);

var
     ind,ag,cn:integer;
     sex:Tsex;
     tmp:double;
begin
  intervens.maakjaar(tijd);
  if intervens.RRintervens then
  begin
    for ind:=0 to rflist.count-1 do
     with Trfdiscat(rflist.items[ind]) do
     for cn:=0 to catno-1 do
      for ag:=0 to disaggmax do
       for sex:=men to fem do
         currr[cn,sex,ag]:=currr[cn,sex,ag]-(1.0-RelRis.oneydata[cn,sex,ag])*intervens.oneydata[cn,sex,ag];
  end else
  begin
    for ag:=0 to disaggmax do
     for sex:=men to fem do
     begin
       tmp:=0.0;
       for cn:=1 to catno-1 do
       begin
         prevrf[tijd+lookback,sex,intv,cn,ag]:=
          prevrf[tijd+lookback,sex,intv,cn,ag]*(1.0-intervens.oneydata[cn,sex,ag]);
         tmp:=tmp+prevrf[tijd+lookback,sex,intv,cn,ag];
       end;
       prevrf[tijd+lookback,sex,intv,0,ag]:=1.0-tmp;
     end;
  end;
end;


constructor Tcatrfcohort.create(n:string);
begin
  inherited create(n);
  initprev:=Tcatcohortmvardata.create('CatrfCohortInitial',false);
  changep:=Tcatmvardata.create('CatrfCohortChange',false);
  mortrr:=Tcatmvardata.create('CatrfCohortMortRR',false);
end;


procedure Tcatrfcohort.leesinvoer;
var
  num:integer;
  sex:Tsex;
  cn,ag:integer;
begin
  inherited leesinvoer;
  initprev.zetcatno(catno);
  initprev.leesvarels('SELECT * FROM CatrfCohortInitial where RiskfactorName='+
  datasetform.psq(name)+' and ScenarioName='+
     datasetform.psq('Standard')+' and catno=0 order by time, age');
  initage:=initprev.varelrij[0]^.lage;
  for num:=1 to catno-1 do
    initprev.leesvarelscat('SELECT * FROM CatrfCohortInitial where RiskfactorName='+
    datasetform.psq(name)+' and ScenarioName='+
     datasetform.psq('Standard')+' and catno='+inttostr(num)+' order by time, age',num);
  changep.zetcatno(catno);
  for num:=1 to catno-1 do
    changep.leesvarelscat('SELECT * FROM CatrfCohortChange where RiskfactorName='+
    datasetform.psq(name)+' and ScenarioName='+
     datasetform.psq('Standard')+' and catno='+inttostr(num)+' order by time, lage',num);
  mortrr.zetcatno(catno);
  for num:=1 to catno-1 do
    mortrr.leesvarelscat('SELECT * FROM CatrfCohortMortRR where RiskfactorName='+
    datasetform.psq(name)+' and ScenarioName='+
     datasetform.psq('Standard')+' and catno='+inttostr(num)+' order by time, lage',num);
  mortrr.maakjaar(0);
  Totmor:=Tmvardata.create('TotalMortality',false);
  Totmor.leesvarels('SELECT * FROM TotalMortality where ScenarioName='+
     datasetform.psq('Standard')+' order by time, lage');
  Totmor.maakjaar(0);
  setlength(excessmort,catno-1);
  for cn:=1 to catno-1 do
  for sex:=men to fem do
    for ag:=0 to disaggmax do
      excessmort[cn-1,sex,ag]:=1.0-exp(-Totmor.oneydata[sex,ag]*(mortrr.oneydata[cn,sex,ag]-1.0));
  setlength(initinterv,catno);
  for cn:=0 to catno-1 do
    for sex:=men to fem do initinterv[cn,sex]:=1.0;
end;


procedure Tcatrfcohort.jaarstap(tt:integer);
var  scen:Tscen;
     cn,ag:integer;
     sex:Tsex;
     tmp,tmp2:double;
begin
  if tt=0 then
  begin
    prevalen.maakjaar(tt-lookback);
    for sex:=men to fem do
     for ag:=0 to disaggmax do
     begin
       tmp:=0.0;
       for cn:=1 to catno-1 do
       begin
         prevrf[tt,sex,ref,cn,ag]:=prevalen.oneydata[cn,sex,ag];
         tmp:=tmp+prevrf[tt,sex,ref,cn,ag];
       end;
       prevrf[tt,sex,ref,0,ag]:=1.0-tmp;
     end;
    for sex:=men to fem do
     for cn:=0 to catno-1 do
      for ag:=0 to disaggmax do
      prevrf[tt,sex,intv,cn,ag]:=prevrf[tt,sex,ref,cn,ag];
  end else
  begin
    initprev.maakjaar(tt-lookback-1);
    for scen:=ref to intv do
    for sex:=men to fem do
    begin
      tmp:=0.0;
      for cn:=1 to catno-1 do
      begin
        if scen=intv then prevrf[tt,sex,scen,cn,initage]:=initprev.oneydata[cn,sex]*initinterv[cn,sex]
          else prevrf[tt,sex,scen,cn,initage]:=initprev.oneydata[cn,sex];
        tmp:=tmp+prevrf[tt,sex,scen,cn,initage];
      end;
      prevrf[tt,sex,scen,0,initage]:=1.0-tmp;
    end;
    changep.maakjaar(tt-lookback-1);
    for scen:=ref to intv do
    for sex:=men to fem do
    for ag:=disaggmax downto initage+1 do
    begin
      tmp:=0.0;
      for cn:=1 to catno-1 do
      begin
        prevrf[tt,sex,scen,cn,ag]:=
          prevrf[tt-1,sex,scen,cn,ag-1]*(1.0+changep.oneydata[cn,sex,ag-1])*(1-excessmort[cn-1,sex,ag-1]);
        tmp:=tmp+prevrf[tt,sex,scen,cn,ag];
      end;
      prevrf[tt,sex,scen,0,ag]:=1.0-tmp;
    end;
    for scen:=ref to intv do
    for sex:=men to fem do
    for ag:=0 to initage-1 do
    begin
      for cn:=1 to catno-1 do
        prevrf[tt,sex,scen,cn,ag]:=0.0;
      prevrf[tt,sex,scen,0,ag]:=1.0;
    end;
{    for ag:=0 to disaggmax do
      for sex:=men to fem do
      begin
        tmp2:=0.0;
        for cn:=1 to catno-1 do
        begin
          prevrf[tt,sex,intv,cn,ag]:=min(1.0,prevrf[tt,sex,intv,cn,ag]
            *(1.0-((pzlist.datavar[tt-1,sex,intv,ag div 5]/pzlist.datavar[0,sex,intv,ag div 5])
            /(pzlist.datavar[tt-1,sex,ref,ag div 5]/pzlist.datavar[0,sex,ref,ag div 5])
            -(pzlist.datavar[tt,sex,intv,ag div 5]/pzlist.datavar[0,sex,intv,ag div 5])
            /(pzlist.datavar[tt,sex,ref,ag div 5]/pzlist.datavar[0,sex,ref,ag div 5]))));
          tmp2:=tmp2+prevrf[tt,sex,intv,cn,ag];         //pz intv contains both ref and intv!
        end;
        prevrf[tt,sex,intv,0,ag]:=1.0-tmp2;
      end;}
  end;
  if intervbool then interventie(tt-lookback);
  maakuitvoer(tt);
end;

procedure Tcatrfcohort.interventie(tijd:integer);

var
     ind,ag,cn:integer;
     sex:Tsex;
     tmp:double;
begin
  inherited interventie(tijd);
  for sex:=men to fem do
    for cn:=1 to catno-1 do
       initinterv[cn,sex]:=initinterv[cn,sex]*(1.0-intervens.oneydata[cn,sex,initage]);
end;

destructor Tcatrfcohort.destroy;
begin
  initinterv:=nil;
  inherited destroy;
end;


{---------------------------------------------------------------------}


constructor Tnormal.create(n:string);
begin
  inherited create(n);
  paramnum:=2;
  setlength(oriparams,2);
  setlength(thminparams,2);
  setlength(disparamnames,2);
  disparamnames[0]:='mu';
  disparamnames[1]:='sigma';
end;

function Tnormal.calc(x:double;dp:Tdisparams):double;
begin
  result:=(1.0/(sqrt(2.0*pi)*dp[1]))*exp(-0.5*intpower((x-dp[0])/dp[1],2));
end;

procedure Tnormal.zetlxhx(dp:Tdisparams;var llx,lhx,lx,hx:double);
begin
  llx:=dp[0]-4.0*dp[1];
  lhx:=dp[0]+4.0*dp[1];
  lx:=min(lx,llx);
  hx:=max(hx,lhx);
end;

procedure Tnormal.paspiftoe(depif:double;dp:Tdisparams);
var
  num:integer;
begin
  for num:=0 to paramnum-1 do  //so depif should be 1-pif (=pzlist)
    dp[num]:=thminparams[num]+(dp[num]-thminparams[num])*depif;
end;

destructor Tnormal.destroy;
begin
  inherited destroy;
end;

procedure Tlognormal.zetlxhx(dp:Tdisparams;var llx,lhx,lx,hx:double);
var
  stdev,mean:double;
begin
  llx:=0.0000001;
  stdev:=sqrt(exp(2*dp[0])*exp(intpower(dp[1],2))*(exp(intpower(dp[1],2))-1));
  mean:=exp(dp[0]+0.5*dp[1]);
  lhx:=mean+5.0*stdev;
  lx:=min(lx,llx);
  hx:=max(lhx,hx);
end;


function Tlognormal.calc(x:double;dp:Tdisparams):double;
begin
  result:=(1.0/(sqrt(2.0*pi)*dp[1]*x))*exp(-0.5*intpower((ln(x)-dp[0])/dp[1],2));
end;

constructor Tlognormaloffset.create(n:string);
begin
  inherited create(n);
  paramnum:=3;
  setlength(oriparams,3);
  setlength(thminparams,3);
  setlength(disparamnames,3);
  disparamnames[2]:='offset';
end;

function Tlognormaloffset.calc(x:double;dp:Tdisparams):double;
begin
  result:=(1.0/(sqrt(2.0*pi)*dp[1]*(x-dp[2])))*exp(-0.5*intpower((ln(x-dp[2])-dp[0])/dp[1],2));
end;

procedure Tlognormaloffset.paspiftoe(depif:double;dp:Tdisparams);
var
  num:integer;
begin
  for num:=0 to paramnum-2 do //laat de offset met rust: geeft negativen in calc
    dp[num]:=thminparams[num]+(dp[num]-thminparams[num])*depif;
end;


procedure Tlognormaloffset.zetlxhx(dp:Tdisparams;var llx,lhx,lx,hx:double);
var
  stdev,mean:double;
begin
  llx:=oriparams[2]+0.0000001;
  stdev:=sqrt(exp(2*dp[0])*exp(intpower(dp[1],2))*(exp(intpower(dp[1],2))-1));
  mean:=exp(dp[0]+0.5*dp[1])+dp[2];
  lhx:=mean+5.0*stdev;
  lx:=min(lx,llx);
  hx:=max(lhx,hx);
end;


constructor Tweibull.create(n:string);
begin
  inherited create(n);
  paramnum:=2;
  setlength(oriparams,2);
  setlength(thminparams,2);
  setlength(disparamnames,2);
  disparamnames[0]:='alpha';
  disparamnames[1]:='beta';
end;

function Tweibull.calc(x:double;dp:Tdisparams):double;
begin
  result:=((dp[0]/power(dp[1],dp[0]))*power(x,dp[0]-1.0)*exp(-power(x/dp[1],dp[0])));
end;

function Tweibull.mean(alfa,beta:double):double;
begin
  result:=beta*exp(gammaln(1.0+1.0/alfa));
end;

{  mean:=(parvals[0]/parvals[1])*exp(gammaln(1.0/parvals[1]));
  stdev:=(parvals[0]/sqrt(parvals[1])*
     sqrt(2.0*exp(gammaln(2.0/parvals[1]))-(1.0/parvals[1])*intpower(exp(gammaln(1.0/parvals[1])),2)));
}

procedure Tweibull.paspiftoe(depif:double;dp:Tdisparams);
var
  num:integer;
begin
  for num:=0 to paramnum-1 do
    dp[num]:=thminparams[num]+(dp[num]-thminparams[num])*depif;
end;

procedure Tweibull.zetlxhx(dp:Tdisparams;var llx,lhx,lx,hx:double);
var
  stdev,mean,stdevth,meanth:double;
begin
  llx:=0.0;
  mean:=dp[1]*exp(gammaln(1.0+1.0/dp[0]));
  stdev:=(dp[1]/sqrt(dp[0])*
     sqrt(2.0*exp(gammaln(2.0/dp[0]))-(1.0/dp[0])*intpower(exp(gammaln(1.0/dp[0])),2)));
  lhx:=mean+5.0*stdev;
  lx:=min(lx,llx);
  hx:=max(lhx,hx);
end;

destructor Tweibull.destroy;
begin
  inherited destroy;
end;

constructor Tlinkfunc.create(n,i:string);
begin
  inherited create;
  lfname:=n;
  influname:=i;
end;

destructor Tlinkfunc.destroy;
begin
  lfparams:=nil;
  inherited destroy;
end;

constructor Tlinear.create(n,i:string);
begin
  inherited create(n,i);
  lfparanum:=2;
  setlength(lfparams,2);
end;
{
procedure Tlinear.zetpar(pp:double);
begin
  lfparams[1]:=pp;
end;
 }
function Tlinear.lfcalc(x:double):double;
var tmp:double;
begin
  tmp:=lfparams[0]+x*lfparams[1];
  if tmp<1.0 then result:=exp(tmp-1.0) else result:=tmp;
end;  {this avoides negative returns, and goes asymptotically to 0 as tmp<1}

constructor Tperunit.create(n,i:string);
begin
  inherited create(n,i);
  lfparanum:=3;
  setlength(lfparams,3);
end;

function Tperunit.lfcalc(x:double):double;
begin
  result:=max(1.0,power(lfparams[0],(x-lfparams[1])/lfparams[2]));
end;

constructor Tlinear2.create(n,i:string);
begin
  inherited create(n,i);
  lfparanum:=4;
  setlength(lfparams,4);
  setlength(lforigparams,4);
end;
{
procedure Tlinear2.zetpar(pp:double);
begin
  lfparams[1]:=lforigparams[1]*pp;
  lfparams[2]:=lforigparams[2]*pp;
end;
}
function Tlinear2.lfcalc(x:double):double;
var tmp:double;
begin
  if x<lfparams[3] then tmp:=lfparams[0]+x*lfparams[1]
    else tmp:=lfparams[0]+lfparams[3]*lfparams[1]+x*lfparams[2];
  if tmp<1.0 then result:=exp(tmp-1.0) else result:=tmp;
end;  {this avoides negative returns, and goes asymptotically to 0 as tmp<1}

destructor Tlinear2.destroy;
begin
  lforigparams:=nil;
  inherited destroy;
end;


function Tlogit.lfcalc(x:double):double;
begin
  result:=1.0/(1.0+exp(-lfparams[0]-x*lfparams[1]));
end;

function Tloglinear.lfcalc(x:double):double;
begin
  result:=exp(lfparams[0]+x*lfparams[1]);
end;


constructor Tconrf.create(n:string);
begin
  inherited create(n);
  prevalen:=Tmvarddist.create('ConrfExposure',false);
end;


procedure Tconrf.leesinvoer;
var
  sex:Tsex;
  scen:Tscen;
  num,pnum,tt:integer;
begin
  prevalen.leesvarels('SELECT * FROM ConrfExposure where ConrfName='+
  datasetform.psq(name)+' and ScenarioName='+
     datasetform.psq('Standard')+' order by time, lage');
  for scen:=ref to intv do
  for sex:=men to fem do
    setlength(dist[scen,sex],prevalen.agnum);
  for scen:=ref to intv do
  for sex:=men to fem do
  for num:=0 to length(dist[scen,sex])-1 do
  begin
    if  prevalen.varelrij[num]^.distri='normal' then dist[scen,sex,num]:=Tnormal.create('Normal')
    else if  prevalen.varelrij[num]^.distri='weibull' then dist[scen,sex,num]:=Tweibull.create('Weibull')
    else if  prevalen.varelrij[num]^.distri='lognormal' then dist[scen,sex,num]:=Tlognormal.create('Lognormal')
    else if  prevalen.varelrij[num]^.distri='lognormaloffset' then dist[scen,sex,num]:=Tlognormaloffset.create('Lognormaloffset')
    else MessageDlg('Unknown distribution specified', mtError, [mbOK], 0);
    dist[scen,sex,num].lage:=prevalen.varelrij[num]^.lage;
    dist[scen,sex,num].hage:=prevalen.varelrij[num]^.hage;
    for pnum:=0 to dist[scen,sex,num].paramnum-1 do
    begin
      dist[scen,sex,num].oriparams[pnum]:=prevalen.varelrij[num]^.mfwaarde[sex,0,pnum];
      dist[scen,sex,num].thminparams[pnum]:=prevalen.varelrij[num]^.mfwaarde[sex,1,pnum];
    end;
{    dist[scen,sex,num].zetlxhx(lx,hx,step);}
  end;
  for scen:=ref to intv do
    for sex:=men to fem do
      for num:=0 to length(dist[scen,sex])-1 do
      begin
        setlength(dist[scen,sex,num].curparams,et+lookback+2);
        for tt:=0 to et+lookback+1 do
        begin
          setlength(dist[scen,sex,num].curparams[tt],length(dist[scen,sex,num].oriparams));
          for pnum:=0 to dist[scen,sex,num].paramnum-1 do
            dist[scen,sex,num].curparams[tt,pnum]:=dist[scen,sex,num].oriparams[pnum];
        end;
      end;
  RRinvoer;
  prevalen.zetoneydata;
  if intervbool then
  begin
    intervens.zetparno(dist);
    intervens.leesvarels('SELECT * FROM ConrfInterventions where RiskfactorName='+
           datasetform.psq(name)+' and InterventionName='+
           datasetform.psq(intervens.interventionname)+' order by time, lage');
  end;
  lx:=5E20;
  hx:=-5E20;
  step:=5E20;
end;

function Tconrf.getagegroups:Tstrings;
var
  agstr:Tstrings;
  num:integer;
begin
  agstr:=Tstringlist.Create;
  for num:=0 to length(dist[ref,men])-2 do
    agstr.add(inttostr(dist[ref,men,num].lage)+'-'+inttostr(dist[ref,men,num].hage-1));
  agstr.add(inttostr(dist[ref,men,length(dist[ref,men])-1].lage)+'+');
  result:=agstr;
end;


procedure Tconrf.RRinvoer;

begin
  ReadRRinvoer('Prevalence');
end;{RRinvoer}

procedure Tconrf.uitvoeropzet;
begin
  inherited uitvoeropzet;
  expouit:=Tgenuitconrf.create(et+lookback);
end;

procedure Tconrf.uitvoerafbraak;
var
  sex:Tsex;
  scen:Tscen;
  num:integer;
begin
  inherited uitvoerafbraak;
  for scen:=ref to intv do
    for sex:=men to fem do
      for num:=0 to length(dist[scen,sex])-1 do
         dist[scen,sex,num].curparams:=nil;
end;


procedure Tconrf.jaarstap(tt:integer);
var
  sex:Tsex;
  scen:Tscen;
  num,ag,pnum,dd:integer;
  tmp:double;
begin
  prevalen.maakjaar(tt-lookback);
  for sex:=men to fem do
   for ag:=0 to length(dist[ref,sex])-1 do
   begin
     tmp:=0.0;
     dd:=0;
     for num:=dist[ref,sex,ag].lage div 5 to (dist[ref,sex,ag].hage-1) div 5 do
     begin
       if pzlist.datavar[0,sex,ref,num]>0.0 then
       tmp:=tmp+pzlist.datavar[tt,sex,ref,num]/pzlist.datavar[0,sex,ref,num];
       inc(dd);
     end;
     tmp:=tmp/dd;;
     for pnum:=0 to dist[ref,sex,ag].paramnum-1 do
       dist[ref,sex,ag].curparams[tt,pnum]:=prevalen.oneydata[sex,ag,pnum];
     dist[ref,sex,ag].paspiftoe(tmp,dist[ref,sex,ag].curparams[tt]);
   end;
  if tt=0 then
  for sex:=men to fem do
   for ag:=0 to length(dist[ref,sex])-1 do
    for pnum:=0 to dist[ref,sex,ag].paramnum-1 do
    dist[intv,sex,ag].curparams[tt,pnum]:=dist[ref,sex,ag].curparams[tt,pnum]
  else
  begin
    for sex:=men to fem do
     for ag:=0 to length(dist[ref,sex])-1 do
      for pnum:=0 to dist[ref,sex,ag].paramnum-1 do
      begin
        dist[intv,sex,ag].curparams[tt,pnum]:=dist[intv,sex,ag].curparams[tt-1,pnum]*
          (dist[ref,sex,ag].curparams[tt,pnum]/dist[ref,sex,ag].curparams[tt-1,pnum]);
      end;
    for sex:=men to fem do
     for ag:=0 to length(dist[intv,sex])-1 do
     begin
       tmp:=0.0;
       dd:=0;
       for num:=(dist[intv,sex,ag].lage div 5) to ((dist[intv,sex,ag].hage-1) div 5) do
       begin
         if (pzlist.datavar[0,sex,intv,num]>0.0) and (pzlist.datavar[0,sex,ref,num]>0.0) then
           tmp:=tmp+1.0-((pzlist.datavar[tt-1,sex,intv,num]/pzlist.datavar[0,sex,intv,num])
             /(pzlist.datavar[tt-1,sex,ref,num]/pzlist.datavar[0,sex,ref,num])
             -(pzlist.datavar[tt,sex,intv,num]/pzlist.datavar[0,sex,intv,num])
             /(pzlist.datavar[tt,sex,ref,num]/pzlist.datavar[0,sex,ref,num]));
         inc(dd);
       end;
       tmp:=tmp/dd;
       dist[intv,sex,ag].paspiftoe(tmp,dist[intv,sex,ag].curparams[tt]);
     end;
  end;
  if intervbool then interventie(tt-lookback);
  maakuitvoer(tt);
end;

procedure Tconrf.maakuitvoer(tt:integer);
var  scen:Tscen;
     ag,pp:integer;
     sex:Tsex;
begin
  for scen:=ref to intv do
  begin
    for sex:=men to fem do
     for ag:=0 to length(dist[scen,sex])-1  do
       for pp:=0 to dist[scen,sex,ag].paramnum-1 do
         expouit.distpars[tt,scen,sex,pp,ag]:=dist[scen,sex,ag].curparams[tt,pp];
  end;{with scen}
end;

procedure Tconrf.interventie(tijd:integer);

var
 pnum,tt,ag:integer;
 sex:Tsex;

begin
  intervens.maakjaar(tijd);
  for sex:=men to fem do
   for ag:=0 to length(dist[intv,sex])-1 do
    for pnum:=0 to dist[intv,sex,ag].paramnum-1 do
      dist[intv,sex,ag].curparams[tijd+lookback,pnum]:=dist[intv,sex,ag].thminparams[pnum]+
      (dist[intv,sex,ag].curparams[tijd+lookback,pnum]-dist[intv,sex,ag].thminparams[pnum])*
      (1.0-intervens.oneydata[sex,ag,pnum]);

end;


procedure Tconrf.intervensafbreuk;
begin
  if intervbool then
  begin
    intervens.free;
    intervbool:=false;
  end;
end;

destructor Tconrf.destroy;
var
  num:integer;
  sex:Tsex;
  scen:Tscen;
  ag:integer;
begin
  for scen:=ref to intv do
   for sex:=men to fem do
   begin
     for ag:=0 to length(dist[scen,sex])-1 do dist[scen,sex,ag].free;
     dist[scen,sex]:=nil;
   end;
  inherited destroy;
end;

{---------------------------------------------------------------------}

constructor Tdisease.create(n:string);

begin
  inherited create(n);
  dismortrendvar:='mortality';
end;

procedure Tdisease.curlijstvoegtoe(ind:integer);

begin
  curdislist.add(Tdisease(diseaselist.items[ind]));
end;

procedure Tdisease.uitvoeropzet;

begin
  inherited uitvoeropzet;
  ozmort:=Tgenuit.create(et);
  if dismortrendbool then
  begin
    dismortrend:=Tcostvardata.create('DiseaseInterventions',false);
    dismortrend.leesvarels('SELECT * FROM DiseaseInterventions where InterventionName='+
       datasetform.psq(dismortrendnaam)+' and DiseaseName='
       + datasetform.psq(name)+' and Param='+datasetform.psq(dismortrendvar)+' order by time, lage');
    if incionlybool then dismortrendboth:=disopform.inciboth.State=cbunchecked
      else dismortrendboth:=disopform.cfatboth.State=cbunchecked;
  end;
end;

procedure Tdisease.uitvoerafbraak;

begin
  inherited uitvoerafbraak;
  ozmort.free;
  if dismortrendbool then
  begin
    dismortrend.free;
    dismortrendbool:=false;
  end;
end;

procedure Tdisease.zetopties;

begin
  disopform.caption:='Options for '+name;
  disopform.cfatgroup.caption:='Mortality trends';
end;

procedure Tdisease.readziektedata(disvar:string;sex:Tsex;var vars1:Tscenar95);

var
  tmpstr:string;
  ag:integer;

begin
  with datasetform do
  begin
    tmpstr:='select Lage, Hage, Value from DiseaseInputVars where DiseaseName='
    +psq(self.name)+' and Sex='+psq(sexnaam[sex])+
    ' and Disvar='+psq(disvar)+' order by Lage';
    putquery1(tmpstr);
    with datamodule2.inputq1 do
    begin
      first;
      while not eof do
      begin
        for ag:=Fields[0].AsInteger to Fields[1].AsInteger-1 do
          vars1[ref,sex,ag]:=Fields[2].Asfloat;
        next;
      end;
      close;
    end;
    datamodule2.SQLTransaction1.Commit;
  end;
  vars1[intv]:=vars1[ref];
end;

Procedure Tdisease.ziektedata;

var sex:Tsex;

begin
  for sex:=men to fem do
    readziektedata('Mortality',sex,morts1);
end;{ziektedata}

Procedure Tdisease.RRinvoer;

begin
  ReadRRinvoer('Mortality');
end;{RRinvoer}

procedure Tdisease.jaarstap(tt:integer);
begin
  paspiftoe(tt);
end;

procedure Tdisease.trendaanpas(tt:integer);

var av:integer;
    scen:Tscen;
    sex:Tsex;

begin
   if dismortrendbool then
   begin
     dismortrend.maakjaar(tt);
     for av:=disaggmax downto 0 do
       for sex:=men to fem do
       if dismortrendboth then
        for scen:=ref to intv do
           morts1[scen,sex,av]:=morts1[scen,sex,av]*(1.0+dismortrend.oneydata[sex,av])
       else morts1[intv,sex,av]:=morts1[intv,sex,av]*(1.0+dismortrend.oneydata[sex,av]);
   end;
end;

procedure Tdisease.paspiftoe(tt:integer);

var av:integer;
    scen:Tscen;
    sex:Tsex;

begin
  trendaanpas(tt);
  for av:=0 to disaggmax do
   for scen:=ref to intv do
    for sex:=men to fem do
        if pzlist.datavar[0,sex,scen,av div 5]>0.0 then
           ozmort.datavar[tt,sex,scen,av div 5]:=
           ozmort.datavar[tt,sex,scen,av div 5]+
              morts1[scen,sex,av]*(pzlist.datavar[tt,sex,scen,av div 5]/pzlist.datavar[0,sex,scen,av div 5]);
  maakuitvoer(tt);
end;

procedure Tdisease.maakuitvoer(tt:integer);
var av:integer;
    scen:Tscen;
    sex:Tsex;

begin
  for sex:=men to fem do
   for scen:=ref to intv do
   begin
     for av:=0 to aggmax-1 do
       ozmort.datavar[tt,sex,scen,av]:=
       ozmort.datavar[tt,sex,scen,av]/5.0;
     ozmort.datavar[tt,sex,scen,aggmax]:=
     ozmort.datavar[tt,sex,scen,aggmax]/restagg;
   end;
end;

procedure Tdisease.leesinvoer;
begin
     raise Exception.Create('Tdisease.leesinvoer() should not be called');
end;

procedure Tdisease.interventie(tijd:integer);
begin
     raise Exception.Create('Tdisease.interventie() should not be called');
end;

procedure Tdisease.intervensafbreuk;
begin
     raise Exception.Create('Tdisease.intervensafbreuk() should not be called');
end;

destructor Tdisease.destroy;

var ind:integer;

begin
  inherited destroy;
end;

{---------------------------------------------------------------------}
constructor Tincionly.create(n:string);

begin
  inherited create(n);
  dismortrendvar:='incidence';
end;

procedure Tincionly.ziektedata;
var sex:Tsex;

begin
  for sex:=men to fem do
    readziektedata('Incidence',sex,morts1);
end;{ziektedata}

Procedure Tincionly.RRinvoer;

begin
  ReadRRinvoer('Incidence');
end;{RRinvoer}

{---------------------------------------------------------------------}

constructor Tipm.create(n:string);

begin
  inherited create(n);
  dismortrendvar:='case fatality';
end;

procedure Tipm.curlijstvoegtoe(ind:integer);

begin
  inherited curlijstvoegtoe(ind);
  curipmlist.add(Tdisease(diseaselist.items[ind]));
  if costbool then curdiscostlist.add(Tdisease(diseaselist.items[ind]));
  if dalybool then curdisdalylist.add(Tdisease(diseaselist.items[ind]));
end;

procedure Tipm.uitvoeropzet;
var  scen:Tscen;
     t,cn:integer;
     sex:Tsex;
begin
  inherited uitvoeropzet;
  ozprev:=Tgenuit.create(et);
  ozinci:=Tgenuitinci.create(et,ozprev.datavar);
  ozcfat:=Tgenuitcfat.create(et,ozprev.datavar);
  if dalybool then ozyld:=Tgenuit.create(et);
  if Costbool then ozcost:=Tgenuitcost.create(et);
  if disincitrendbool then
  begin
    disincitrend:=Tmvardata.create('DiseaseInterventions',false);
    disincitrend.leesvarels('SELECT * FROM DiseaseInterventions where InterventionName='+
       datasetform.psq(disincitrendnaam)+' and DiseaseName='
       + datasetform.psq(name)+' and Param=''incidence'' order by time, lage');
    disincitrendboth:=disopform.inciboth.State=cbunchecked;
  end;
  if rftoobool then
  begin
    setlength(prevrf,et+lookback+2); 
    for t:=0 to et+lookback+1 do
     for scen:=ref to intv do
      for sex:=men to fem do
      begin
        setlength(prevrf[t,sex,scen],catno);
        for cn:=0 to catno-1 do
          setlength(prevrf[t,sex,scen,cn],disaggmax+1);
      end;
  end;
end;


procedure Tipm.uitvoerafbraak;

begin
  inherited uitvoerafbraak;
  ozprev.free;
  ozinci.free;
  ozcfat.free;
  if costbool then ozcost.free;
  if dalybool then ozyld.free;
  if disincitrendbool then
  begin
    disincitrend.free;
    disincitrendbool:=false;
  end;
  if rftoobool then prevrf:=nil;
end;

procedure Tipm.zetopties;

begin
  inherited zetopties;
  disopform.cfatgroup.caption:='Case fatality trends';
end;

Procedure Tipm.interpol(vijfars:Tar20;var eenars:Tar95);

var sex:tsex;
    a,m:integer;

begin
  for sex:=men to fem do
  begin
   for a:=0 to 5 do
    eenars[sex,a]:=vijfars[sex,0];
   eenars[sex,disaggmax]:=vijfars[sex,aggmax];
  end;
  for sex:=men to fem do
  begin
   for a:=1 to aggmax-1 do
    for m:=0 to 4 do
    eenars[sex,a*5+m-2]:=eenars[sex,a*5+m-3]
          +(-vijfars[sex,a-1]+vijfars[sex,a])/5.0;
    a:=aggmax;
    for m:=0 to 2 do
    eenars[sex,a*5+m-2]:=eenars[sex,a*5+m-3]
          +(-vijfars[sex,a-1]+vijfars[sex,a])/3.0;
  end;
end;


Procedure Tipm.costdalydata;

begin
  if costbool then
  begin
    DisCost:=Tcostvardata.create('DiseaseCost',false);
    if DisCosttrendbool then
    begin
      DisCost.leesvarels('SELECT * FROM DiseaseCost where DiseaseName='+
       datasetform.psq(name)+' and ScenarioName='+
         datasetform.psq(DisCosttrendnaam)+' order by time, lage');
      DisCosttrendboth:=disopform.costboth.State=cbunchecked;
    end else
    begin
      DisCost.leesvarels('SELECT * FROM DiseaseCost where DiseaseName='+
       datasetform.psq(name)+' and ScenarioName='+
         datasetform.psq('Standard')+' order by time, lage');
      DisCosttrendboth:=false;
    end;
    DisCost.maakjaar(0);
  end;
  if dalybool then
  begin
    DisDaly:=Tcostvardata.create('DiseaseWeight',false);
    if DisDalytrendbool then
    begin
      DisDaly.leesvarels('SELECT * FROM DiseaseWeight where DiseaseName='+
       datasetform.psq(name)+' and ScenarioName='+
         datasetform.psq(DisDalytrendnaam)+' order by time, lage');
      DisDalytrendboth:=disopform.dalyboth.State=cbunchecked;
    end else
    begin
      DisDaly.leesvarels('SELECT * FROM DiseaseWeight where DiseaseName='+
       datasetform.psq(name)+' and ScenarioName='+
         datasetform.psq('Standard')+' order by time, lage');
      DisDalytrendboth:=false;
    end;
    DisDaly.maakjaar(0);
  end;
end;

Procedure Tipm.ziektedata;

var a:integer;
    sex:Tsex;

begin
  inherited ziektedata;
  for sex:=men to fem do
    readziektedata('Prevalence',sex,prevs1);
  for sex:=men to fem do
    readziektedata('Incidence',sex,Incis1);
{  interpol(morts[ref],morts1[ref]);
  morts1[intv]:=morts1[ref];
  interpol(prevs,prevs1[ref]);
  prevs1[intv]:=prevs1[ref];
  interpol(incis,incis1[ref]);}
  for sex:=men to fem do
   for a:=0 to disaggmax do
     incis1[ref,sex,a]:=1.0-exp(-incis1[ref,sex,a]);
  incis1[intv]:=incis1[ref];
  for sex:=men to fem do
   for a:=0 to disaggmax do
     if prevs1[ref,sex,a]>0 then cfat1[ref,sex,a]:=morts1[ref,sex,a]/prevs1[ref,sex,a]
                        else cfat1[ref,sex,a]:=0.0;
  cfat1[intv]:=cfat1[ref];
  costdalydata;
end;{ziektedata}

Procedure Tipm.RRinvoer;

begin
  ReadRRinvoer('Incidence');
end;{RRinvoer}


procedure Tipm.trendaanpas(tt:integer);
var av:integer;
    scen:Tscen;
    sex:Tsex;
begin

   if dismortrendbool then
   begin
     dismortrend.maakjaar(tt);
     for av:=disaggmax downto 0 do
       for sex:=men to fem do
       if dismortrendboth then
        for scen:=ref to intv do
           cfat1[scen,sex,av]:=cfat1[scen,sex,av]*(1.0+dismortrend.oneydata[sex,av])
       else cfat1[intv,sex,av]:=cfat1[intv,sex,av]*(1.0+dismortrend.oneydata[sex,av]);
   end;


   if disincitrendbool then
   begin
     disincitrend.maakjaar(tt);
     for av:=disaggmax downto 0 do
       for sex:=men to fem do
       if disincitrendboth then
        for scen:=ref to intv do
           incis1[scen,sex,av]:=incis1[scen,sex,av]*(1.0+disincitrend.oneydata[sex,av])
       else incis1[intv,sex,av]:=incis1[intv,sex,av]*(1.0+disincitrend.oneydata[sex,av]);
   end;

end;


procedure Tipm.paspiftoe(tt:integer);

var av:integer;
    scen:Tscen;
    sex:Tsex;

procedure ingewikkeld;

var interm:double;

begin
  interm:=incis1[scen,sex,av-1]*
    (pzlist.datavar[tt,sex,scen,av div 5]/pzlist.datavar[0,sex,scen,av div 5])*(1.0-prevs1[scen,sex,av-1]);
  prevs1[scen,sex,av]:=(prevs1[scen,sex,av-1]-morts1[scen,sex,av-1]+interm)/
    (1.0-morts1[scen,sex,av-1]);
(*  ozinci.datavar[tt,sex,scen,av div 5]:=ozinci.datavar[tt,sex,scen,av div 5]+{interm}
    incis1[scen,sex,av-1]*(pzlist.datavar[tt,sex,scen,av div 5]/pzlist.datavar[0,sex,scen,av div 5]);     *)
end;

begin
  trendaanpas(tt);
  for sex:=men to fem do
   for scen:=ref to intv do
   begin
     if tt=0 then
     begin
       prevs1[scen,sex,0]:=0.0;
       for av:=1 to disaggmax do
       begin
         morts1[scen,sex,av-1]:=prevs1[scen,sex,av-1]*cfat1[scen,sex,av-1];
         ingewikkeld;
       end;
     end else
     begin
       for av:=disaggmax downto 1 do ingewikkeld;
       prevs1[scen,sex,0]:=0.0;
     end;
   end;
   maakuitvoer(tt);
end;

procedure Tipm.maakuitvoer(tt:integer);
var av,tint:integer;
    scen:Tscen;
    sex:Tsex;

begin
  if rftoobool then
  for sex:=men to fem do
   for scen:=ref to intv do
     for av:=0 to disaggmax do
     begin
       prevrf[tt,sex,scen,0,av]:=1.0-prevs1[scen,sex,av];
       prevrf[tt,sex,scen,1,av]:=prevs1[scen,sex,av];
     end;
  for sex:=men to fem do
   for scen:=ref to intv do
   begin
     for av:=0 to disaggmax do
     begin
       if pzlist.datavar[0,sex,scen,av div 5]>0.0 then
          ozInci.datavar[tt,sex,scen,av div 5]:=ozInci.datavar[tt,sex,scen,av div 5]+
                  Incis1[scen,sex,av]*(pzlist.datavar[tt,sex,scen,av div 5]/pzlist.datavar[0,sex,scen,av div 5]);
       ozprev.datavar[tt,sex,scen,av div 5]:=
         ozprev.datavar[tt,sex,scen,av div 5]+prevs1[scen,sex,av];
       ozcfat.datavar[tt,sex,scen,av div 5]:=
         ozcfat.datavar[tt,sex,scen,av div 5]+cfat1[scen,sex,av];
       morts1[scen,sex,av]:=prevs1[scen,sex,av]*cfat1[scen,sex,av];
       ozmort.datavar[tt,sex,scen,av div 5]:=
         ozmort.datavar[tt,sex,scen,av div 5]+morts1[scen,sex,av];
     end;
    for av:=0 to aggmax-1 do
    begin
      ozInci.datavar[tt,sex,scen,av]:=
       ozInci.datavar[tt,sex,scen,av]/5.0;
     ozprev.datavar[tt,sex,scen,av]:=
       ozprev.datavar[tt,sex,scen,av]/5.0;
     ozcfat.datavar[tt,sex,scen,av]:=
       ozcfat.datavar[tt,sex,scen,av]/5.0;
     ozmort.datavar[tt,sex,scen,av]:=
       ozmort.datavar[tt,sex,scen,av]/5.0;
     end;
     ozInci.datavar[tt,sex,scen,aggmax]:=
       ozInci.datavar[tt,sex,scen,aggmax]/restagg;
     ozprev.datavar[tt,sex,scen,aggmax]:=
       ozprev.datavar[tt,sex,scen,aggmax]/restagg;
     ozcfat.datavar[tt,sex,scen,aggmax]:=
       ozcfat.datavar[tt,sex,scen,aggmax]/restagg;
     ozmort.datavar[tt,sex,scen,aggmax]:=
       ozmort.datavar[tt,sex,scen,aggmax]/restagg;
   end;
   if costbool then
   begin
     if discosttrendboth then   //beide scens met dezelfde rates, al dan niet met trend
     for sex:=men to fem do
       for scen:=ref to intv do
         for av:=0 to disaggmax do
         ozcost.datavar[tt,sex,scen,av div 5]:=
           ozcost.datavar[tt,sex,scen,av div 5]+
             discost.oneydata[sex,av]*prevs1[scen,sex,av]
     else  //de ref heeft oorspronkelijke rate, de intv de eventuele nieuwe
     for sex:=men to fem do
       for av:=0 to disaggmax do
       begin
         ozcost.datavar[tt,sex,ref,av div 5]:=
           ozcost.datavar[tt,sex,ref,av div 5]+
             discost.oneydatat0[sex,av]*prevs1[ref,sex,av];
        ozcost.datavar[tt,sex,intv,av div 5]:=
           ozcost.datavar[tt,sex,intv,av div 5]+
             discost.oneydata[sex,av]*prevs1[intv,sex,av];
       end;
     for sex:=men to fem do
       for scen:=ref to intv do
       begin
         for av:=0 to aggmax-1 do
         ozcost.datavar[tt,sex,scen,aggmax]:=
           ozcost.datavar[tt,sex,scen,aggmax]/restagg;
         ozcost.datavar[tt,sex,scen,aggmax]:=
           ozcost.datavar[tt,sex,scen,aggmax]/restagg;
       end;
   end;
   if dalybool then
   begin
     if disdalytrendboth then   //beide scens met dezelfde rates, al dan niet met trend
     for sex:=men to fem do
       for scen:=ref to intv do
         for av:=0 to disaggmax do
         ozyld.datavar[tt,sex,scen,av div 5]:=
           ozyld.datavar[tt,sex,scen,av div 5]+
             disdaly.oneydata[sex,av]*prevs1[scen,sex,av]
     else  //de ref heeft oorspronkelijke rate, de intv de eventuele nieuwe
     for sex:=men to fem do
       for av:=0 to disaggmax do
       begin
         ozyld.datavar[tt,sex,ref,av div 5]:=
           ozyld.datavar[tt,sex,ref,av div 5]+
             disdaly.oneydatat0[sex,av]*prevs1[ref,sex,av];
        ozyld.datavar[tt,sex,intv,av div 5]:=
           ozyld.datavar[tt,sex,intv,av div 5]+
             disdaly.oneydata[sex,av]*prevs1[intv,sex,av];
       end;
     for sex:=men to fem do
       for scen:=ref to intv do
       begin
         for av:=0 to aggmax-1 do
         ozyld.datavar[tt,sex,scen,av]:=
           ozyld.datavar[tt,sex,scen,av]/restagg;
         ozyld.datavar[tt,sex,scen,aggmax]:=
           ozyld.datavar[tt,sex,scen,aggmax]/restagg;
       end;
   end;
end;


destructor Tipm.destroy;

begin
  inherited destroy;
end;

{---------------------------------------------------------------------}

constructor Thazard3.create(n:string);
begin
  inherited create(n);
end;


procedure Thazard3.uitvoeropzet;

begin
  inherited uitvoeropzet;
  ozremi:=Tgenuitcfat.create(et,ozprev.datavar);
  if disremitrendbool then
  begin
    disremitrend:=Tmvardata.create('DiseaseInterventions',false);
    disremitrend.leesvarels('SELECT * FROM DiseaseInterventions where InterventionName='+
       datasetform.psq(disremitrendnaam)+' and DiseaseName='
       +datasetform.psq(name)+' and Param=''remission'' order by time, lage');
    disremitrendboth:=disopform.remiboth.State=cbunchecked;
  end;
end;


procedure Thazard3.uitvoerafbraak;

begin
  inherited uitvoerafbraak;
  ozremi.free;
  if disremitrendbool then
  begin
    disremitrend.free;
    disremitrendbool:=false;
  end;
end;

procedure Thazard3.curlijstvoegtoe(ind:integer);

begin
  inherited curlijstvoegtoe(ind);
  curdisremilist.add(Tdisease(diseaselist.items[ind]));
end;


procedure Thazard3.trendaanpas(tt:integer);
var av:integer;
    scen:Tscen;
    sex:Tsex;
begin
  inherited trendaanpas(tt);
   if disremitrendbool then
   begin
     disremitrend.maakjaar(tt);
     for av:=disaggmax downto 0 do
       for sex:=men to fem do
       if disremitrendboth then
        for scen:=ref to intv do
           remis1[scen,sex,av]:=remis1[scen,sex,av]*(1.0+disremitrend.oneydata[sex,av])
       else remis1[intv,sex,av]:=remis1[intv,sex,av]*(1.0+disremitrend.oneydata[sex,av]);
   end;

end;


function Thazard3.elfunc(scen:Tscen;sex:Tsex;ag:integer;tt:integer):Double;
begin
   if pzlist.datavar[0,sex,scen,ag div 5]>0.0 then
      elfunc := incis1[scen,sex,ag]*(pzlist.datavar[tt,sex,scen,ag div 5]/pzlist.datavar[0,sex,scen,ag div 5])+
             remis1[scen,sex,ag]+cfat1[scen,sex,ag] {+2.0*ovmor[cursex,ag]}
   else
      elfunc := remis1[scen,sex,ag]+cfat1[scen,sex,ag] {+2.0*ovmor[cursex,ag]};
end;

function Thazard3.qufunc(scen:Tscen;sex:Tsex;ag:integer;tt:integer):Double;
var tmp:Double;
begin
  tmp:=intpower(incis1[scen,sex,ag]*pzlist.datavar[tt,sex,scen,ag div 5],2)+
       intpower(remis1[scen,sex,ag],2)+
       2.0*cfat1[scen,sex,ag]*remis1[scen,sex,ag]+
       intpower(cfat1[scen,sex,ag],2);
  if pzlist.datavar[0,sex,scen,ag div 5]>0.0 then
    tmp := tmp +
       2.0*incis1[scen,sex,ag]*(pzlist.datavar[tt,sex,scen,ag div 5]/pzlist.datavar[0,sex,scen,ag div 5])*remis1[scen,sex,ag]-
       2.0*incis1[scen,sex,ag]*(pzlist.datavar[tt,sex,scen,ag div 5]/pzlist.datavar[0,sex,scen,ag div 5])*cfat1[scen,sex,ag];
  if tmp>=0.0 then qufunc:=sqrt(tmp) else qufunc:=0.0;
end;

function Thazard3.weefunc(scen:Tscen;sex:Tsex;ag:integer):Double;
begin
  weefunc:=exp(-0.5*(intermar[el,sex,ag]+intermar[qu,sex,ag]));
end;

function Thazard3.veefunc(scen:Tscen;sex:Tsex;ag:integer):Double;
begin
  veefunc:=exp(-0.5*(intermar[el,sex,ag]-intermar[qu,sex,ag]));
end;



procedure Thazard3.nexthealthy(scen:Tscen;sex:Tsex;ag:integer);
begin
  if intermar[qu,sex,ag]>0.0 then
    statesar[scen,healthy,sex,ag+1]:=(2.0*(intermar[vee,sex,ag]-intermar[wee,sex,ag])*
       (statesar[scen,healthy,sex,ag]*
         (cfat1[scen,sex,ag]+{ovmor[cursex,ag]+}remis1[scen,sex,ag])+
       statesar[scen,diseased,sex,ag]*remis1[scen,sex,ag])+
     statesar[scen,healthy,sex,ag]*
     (intermar[vee,sex,ag]*(intermar[qu,sex,ag]-intermar[el,sex,ag])+
      intermar[wee,sex,ag]*(intermar[qu,sex,ag]+intermar[el,sex,ag])))/
      (2.0*intermar[qu,sex,ag])
   else statesar[scen,healthy,sex,ag+1]:=statesar[scen,healthy,sex,ag];
end;

procedure Thazard3.nextdiseased(scen:Tscen;sex:Tsex;ag:integer);
begin
  if intermar[qu,sex,ag]>0.0 then
    statesar[scen,diseased,sex,ag+1]:=-((intermar[vee,sex,ag]-intermar[wee,sex,ag])*
       (2.0*((cfat1[scen,sex,ag]+{ovmor[cursex,ag]+}remis1[scen,sex,ag])*
             (statesar[scen,healthy,sex,ag]+statesar[scen,diseased,sex,ag])+
            statesar[scen,healthy,sex,ag]*({ovmor[cursex,ag]}-intermar[el,sex,ag]))
           -statesar[scen,diseased,sex,ag]*intermar[el,sex,ag])
          -statesar[scen,diseased,sex,ag]*intermar[qu,sex,ag]*
            (intermar[vee,sex,ag]+intermar[wee,sex,ag]))/
      (2.0*intermar[qu,sex,ag])
   else statesar[scen,diseased,sex,ag+1]:=statesar[scen,diseased,sex,ag];
end;

procedure Thazard3.nextdead(scen:Tscen;sex:Tsex;ag:integer);
begin
  if intermar[qu,sex,ag]>0.0 then
    statesar[scen,dead,sex,ag+1]:=((intermar[vee,sex,ag]-intermar[wee,sex,ag])*
       (2.0*(statesar[scen,diseased,sex,ag]*(cfat1[scen,sex,ag]{+ovmor[cursex,ag]}){+
              statesar[scen,healthy,cursex,ag]*ovmor[cursex,ag]})-
             intermar[el,sex,ag]*(statesar[scen,healthy,sex,ag]+statesar[scen,diseased,sex,ag]))-
            intermar[qu,sex,ag]*(statesar[scen,healthy,sex,ag]+statesar[scen,diseased,sex,ag])*
              (intermar[vee,sex,ag]+intermar[wee,sex,ag])+
             2.0*intermar[qu,sex,ag]*
             (statesar[scen,healthy,sex,ag]+statesar[scen,diseased,sex,ag]+statesar[scen,dead,sex,ag]))/
      (2.0*intermar[qu,sex,ag])
   else statesar[scen,dead,sex,ag+1]:=statesar[scen,dead,sex,ag];
end;


procedure Thazard3.mortprevfunc(scen:Tscen;sex:Tsex;ag:integer);

var py:Double;

begin
  py:=0.5*(statesar[scen,healthy,sex,ag]+statesar[scen,diseased,sex,ag]
    +statesar[scen,healthy,sex,ag+1]+statesar[scen,diseased,sex,ag+1]);
  intermar[mortotaal,sex,ag]:=
    (statesar[scen,dead,sex,ag+1]-statesar[scen,dead,sex,ag])/py;
  morts1[scen,sex,ag]:=intermar[mortotaal,sex,ag]{-ovmor[cursex,ag]};
{  if bewerkar[mort,cursex,ag]<0.0 then bewerkar[mort,cursex,ag]:=0.0;
  ovmor[cursex,ag]:=totmor[cursex,ag]-bewerkar[mort,cursex,ag];}
  prevs1[scen,sex,ag]:=0.5*(statesar[scen,diseased,sex,ag]
    +statesar[scen,diseased,sex,ag+1])/py;
end;


procedure Thazard3.nextprocs(scen:Tscen;sex:Tsex;ag:integer;tt:integer);
begin
  intermar[qu,sex,ag]:=qufunc(scen,sex,ag,tt);
  intermar[el,sex,ag]:=elfunc(scen,sex,ag,tt);
  intermar[wee,sex,ag]:=weefunc(scen,sex,ag);
  intermar[vee,sex,ag]:=veefunc(scen,sex,ag);
  nexthealthy(scen,sex,ag);
  nextdiseased(scen,sex,ag);
  nextdead(scen,sex,ag);
end;

procedure Thazard3.basiceen(scen:Tscen;sex:Tsex;ag:integer;tt:integer);

begin
  try
    nextprocs(scen,sex,ag,tt);
    mortprevfunc(scen,sex,ag);
  except
    on Ematherror do memoform.addmessage('Internal error: hazard3 equations');
  end;
end;


procedure Thazard3.paspiftoe(tt:integer);

var av:integer;
    scen:Tscen;
    sex:Tsex;

begin
  trendaanpas(tt);
  for scen:=ref to intv do
   for sex:=men to fem do
   if tt=0 then
   begin
     statesar[scen,healthy,sex,0]:=1000;
     for av:=0 to disaggmax do basiceen(scen,sex,av,tt);
   end
   else for av:=disaggmax downto 0 do basiceen(scen,sex,av,tt);
   maakuitvoer(tt);
end;


procedure Thazard3.maakuitvoer(tt:integer);
var av:integer;
    scen:Tscen;
    sex:Tsex;

begin
  inherited maakuitvoer(tt);
  for sex:=men to fem do
   for scen:=ref to intv do
   begin
     for av:=0 to disaggmax do
     begin
       ozremi.datavar[tt,sex,scen,av div 5]:=
         ozremi.datavar[tt,sex,scen,av div 5]+remis1[scen,sex,av];
      end;
      for av:=0 to aggmax-1 do
      begin
        ozremi.datavar[tt,sex,scen,av]:=
         ozremi.datavar[tt,sex,scen,av]/5.0;
     end;
      ozremi.datavar[tt,sex,scen,aggmax]:=
       ozremi.datavar[tt,sex,scen,aggmax]/restagg;
   end;
end;



Procedure Thazard3.ziektedata;

var sex:Tsex;

begin
  for sex:=men to fem do
    readziektedata('Incidence',sex,Incis1);
  for sex:=men to fem do
    readziektedata('Remission',sex,remis1);
  for sex:=men to fem do
    readziektedata('Case fatality',sex,cfat1);
  costdalydata;
end;{ziektedata}

destructor Thazard3.destroy;
begin
  inherited destroy;
end;

{---------------------------------------------------------------------}


constructor Trfdis.create(rf,di:Tgenentity);
begin
  inherited create;
  rfac:=rf;
  dis:=di;
end;

procedure Trfdis.zetpidr20(out pidr:Tpidr);
var
  scen:Tscen;
  sex:Tsex;
  ag:integer;
begin
  for scen:=ref to intv do
   for sex:=men to fem do
    for ag:=-1 to disaggmax do pidr[scen,sex,ag]:=0.0;
end;

function Trfdis.laglat(tdif:integer):double;
begin
  if tdif<=lat then
  begin
    result:=0.0;
  end else
  if tdif>lat+lag then
  begin
    result:=1.0;
  end else
  case lagfunc of
    lin:result:=((tdif-lat)/lag);
    expon:result:=(1.0-1.0/exp((tdif-lat)/(0.2*lag)));
    logis:result:=1.0/(1.0+999.0*exp((-15.0/lag)*(tdif-lat)));
  end;
end;

destructor Trfdis.destroy;
begin
  inherited destroy;
end;

constructor Trfdiscat.create(rf,di:Tgenentity);
var
  sex:Tsex;
  ag,cn:integer;
begin
  inherited create(rf,di);
  RelRis:=Tcatmvardata.create('CatrfRelRisk',false);
  relris.zetcatno(Tcategory(rf).catno);
  setlength(currr,Tcategory(rf).catno);
  RRinterv:=Tcategory(rf).Rrintervention;
  if Tcategory(rf).Rrintervention then
  begin
    for sex:=men to fem do
     for cn:=0 to Tcategory(rfac).catno-1 do
      for ag:=0 to disaggmax do currr[cn,sex,ag]:=1.0;
  end;
end;


procedure Trfdiscat.getpidr(var pidr:Tpidr;tt:Integer;nuleen:integer);
var
  scen:Tscen;
  sex:Tsex;
  ag,cn:integer;
begin
  if rrinterv then
  begin
    for sex:=men to fem do
     for cn:=0 to Tcategory(rfac).catno-1 do
       for ag:=0 to disaggmax do
       begin
         pidr[ref,sex,ag]:=pidr[ref,sex,ag]+
         Tcategory(rfac).prevrf[tt-nuleen,sex,ref,cn,ag]*RelRis.oneydata[cn,sex,ag];
         pidr[intv,sex,ag]:=pidr[intv,sex,ag]+
         Tcategory(rfac).prevrf[tt-nuleen,sex,intv,cn,ag]*currr[cn,sex,ag];
       end;
  end else
  for scen:=ref to intv do
   for sex:=men to fem do
    for cn:=0 to Tcategory(rfac).catno-1 do
    for ag:=0 to disaggmax do
      pidr[scen,sex,ag]:=pidr[scen,sex,ag]+
      Tcategory(rfac).prevrf[tt-nuleen,sex,scen,cn,ag]*RelRis.oneydata[cn,sex,ag];
  for sex:=men to fem do
    for scen:=ref to intv do pidr[scen,sex,-1]:=1.0;
end;

procedure Trfdiscat.readrrs(disvar,disname:string);
var
  num:integer;
begin
  RelRis.leesvarels('SELECT * FROM  CatrfRelrisk where Riskfactor='
  +datasetform.psq(rfac.name)+' and Disease='+datasetform.psq(disname)+
  {'and Disvar='+datasetform.psq(disvar)+}' and scenario='+
     datasetform.psq('Standard')+'and catno=0 order by time, lage');
  for num:=1 to Tcategory(rfac).catno-1 do
    RelRis.leesvarelscat('SELECT * FROM  CatrfRelrisk where Riskfactor='
    +datasetform.psq(rfac.name)+' and Disease='+datasetform.psq(disname)+
    {'and Disvar='+datasetform.psq(disvar)+}' and scenario='+
       datasetform.psq('Standard')+'and catno='+inttostr(num)+' order by time, lage',num);
  RelRis.maakjaar(0);
end;


destructor Trfdiscat.destroy;
begin
  RelRis.free;
  inherited destroy;
end;

constructor Trfdiscon.create(rf,di:Tgenentity);
begin
  inherited create(rf,di);
  Riskfunc:=Tmvarfunc.create('Conrfrelrisk',false);
end;

function Trfdiscon.intfunction(x:double):double;
begin
  result:=linkfunc[cursex,curag].lfcalc(x)*Tconrf(rfac).dist[curscen,cursex,curag].calc(x,Tconrf(rfac).dist[curscen,cursex,curag].curparams[curtt]);
end;

procedure Trfdiscon.getpidr(var pidr:Tpidr;tt:Integer;nuleen:integer);
var
  scen:Tscen;
  sex:Tsex;
  ag,ag2:integer;
  tmpfl:double;
begin
  if tt=1 then setthemin0;
  romberg.lokrfdis:=self;
  for scen:=ref to intv do
   for sex:=men to fem do
   begin
     curscen:=scen;
     cursex:=sex;
     curtt:=tt-nuleen;
     pidr[scen,sex,-1]:=themin0[sex];
     for ag:=0 to Tconrf(rfac).prevalen.agnum-1 do
     begin
       curag:=ag;
       with Tconrf(rfac) do
       begin
         dist[scen,sex,ag].zetlxhx(dist[scen,sex,ag].curparams[curtt],llx,lhx,lx,hx);
         tmpfl:=romberg.qromb(llx,lhx);
         for ag2:=dist[scen,sex,ag].lage to dist[scen,sex,ag].hage-1 do
           pidr[scen,sex,ag2]:=pidr[scen,sex,ag2]+tmpfl;
       end;
     end;
   end;
end;

function Trfdiscon.theminfunction(x:double):double;
begin
  result:=linkfunc[cursex,0].lfcalc(x)*Tconrf(rfac).dist[curscen,cursex,0].calc(x,Tconrf(rfac).dist[curscen,cursex,0].thminparams);
end;

procedure Trfdiscon.setthemin0;
var
  sex:Tsex;
begin
  theominromberg.lokrfdis:=self;
  for sex:=men to fem do
  begin
    curscen:=ref;
    cursex:=sex;
    with Tconrf(rfac) do
    begin
      dist[ref,sex,0].zetlxhx(dist[ref,sex,0].thminparams,llx,lhx,lx,hx);
      themin0[sex]:=theominromberg.qromb(llx,lhx);
    end;
  end;
end;


procedure Trfdiscon.readrrs(disvar,disname:string);
var
  ag,rc:integer;
  sex:Tsex;
begin
  Riskfunc.leesvarels('SELECT * FROM  ConrfRelrisk where Riskfactor='
  +datasetform.psq(rfac.name)+' and Disease='+datasetform.psq(disname)+
  {'and Disvar='+datasetform.psq(disvar)+}' and scenario='+
     datasetform.psq('Standard')+' order by time, lage');
  for sex:=men to fem do setlength(linkfunc[sex],riskfunc.agnum);
  for ag:=0 to riskfunc.agnum-1 do
  begin
    if riskfunc.varelrij[ag]^.funct='Linear' then
      for sex:=men to fem do linkfunc[sex,ag]:=Tlinear.create('Linear',disname)
    else
    if riskfunc.varelrij[ag]^.funct='PerunitRR' then
      for sex:=men to fem do linkfunc[sex,ag]:=Tperunit.create('PerunitRR',disname)
    else
    if riskfunc.varelrij[ag]^.funct='Loglinear' then
      for sex:=men to fem do linkfunc[sex,ag]:=Tloglinear.create('Loglinear',disname)
    else
    if riskfunc.varelrij[ag]^.funct='Linear2' then
      for sex:=men to fem do linkfunc[sex,ag]:=Tlinear2.create('Linear2',disname)
    else
    if riskfunc.varelrij[ag]^.funct='Logit' then
      for sex:=men to fem do linkfunc[sex,ag]:=Tlogit.create('Logit',disname);
    for sex:=men to fem do
     for rc:=0 to linkfunc[sex,ag].lfparanum-1 do
      linkfunc[sex,ag].lfparams[rc]:=riskfunc.varelrij[ag]^.mfwaarde[sex,rc];
{    if linkfunc[num2] is Tlinear2 then
      for rc:=0 to linkfunc[num2].lfparanum-1 do
        Tlinear2(linkfunc[num2]).lforigparams[rc]:=linkfunc[num2].lfparams[rc]; wat is speciaal aan linear2?}
  end;
end;




destructor Trfdiscon.destroy;
var
  sex:Tsex;
  ag:integer;
begin
  Riskfunc.free;
  for sex:=men to fem do
  begin
    for ag:=0 to length(linkfunc[sex])-1 do linkfunc[sex,ag].free;
    linkfunc[sex]:=nil;
  end;
  inherited destroy;
end;



{---------------------------------------------------------------------}
(*
constructor Tpidr.create(tt,terugt:integer;risfac:Triskfactor;risdis:Trfdis);

var toett,vertt,ag,agtoe:integer;
    scen:Tscen;
    sex:Tsex;

begin
  inherited create;
  with risfac do
  with risdis do
  begin
    for scen:=ref to intv do
     for sex:=men to fem do
      for ag:=0 to aggmax do
       for toett:=tt downto tt-cum do
       begin
         if toett>=0 then vertt:=toett else vertt:=0;
         agtoe:=ag*5-(tt-toett);
         if agtoe>=0 then
         begin
 {           pidrar[scen,sex,ag]:=pidrar[scen,sex,ag]+prev1[vertt,sex,scen,agtoe]*
               RelRis[sex,agtoe div 5]+(1.0-prev1[vertt,sex,scen,agtoe]);}
         end;{if agtoe}
       end;{for toett}
   end;
end;

  *)



    {
constructor Tpz.create;

var ag:integer;
  sex:Tsex;
  scen:Tscen;

begin
  inherited create;
  for scen:=ref to intv do
   for sex:=men to fem do
    for ag:=0 to aggmax do pz[scen,sex,ag]:=1.0;
end;
     }
(*

{versie met niet goed cum risk}
procedure Tdisease.pzaanpas;



var tt,tt0,toett,terugt,ind,ag,agtoe,rfind:integer;
    pidr:Tpidr;
    scen:Tscen;
    sex:Tsex;
    pif:double;


begin
  for ind:=0 to rflist.count-1 do
  with Trfdis(rflist.items[ind]) do
  begin
    for rfind:=0 to currflist.count-1 do
    if rfname=Triskfactor(currflist.items[rfind]).name then
    begin
      with Triskfactor(currflist.items[rfind]) do
      begin
        terugt:=lookback-lat-lag;
        pidrlist.clear;
        for tt:=0 to et+lookback do
        begin
          pidr:=Tpidr.create(tt,terugt,
              Triskfactor(currflist.items[rfind]),Trfdis(rflist.items[ind]));
          pidrlist.add(pidr);
        end;

        for tt:=0 to et+lookback-1 do
        begin
           for scen:=ref to intv do
            for sex:=men to fem do
            begin
             for ag:=0 to aggmax do
              for toett:=tt to et+lookback do
              begin
                agtoe:=ag+lat div 5{aglaglat(toett-tt)};
                tt0:=toett-lookback;
                if (agtoe<=aggmax) and (tt0>=0) then
                begin
                  pif:=(laglat(toett-tt)*
                    (Tpidr(pidrlist.items[tt]).pidrar[scen,sex,ag]-
                          Tpidr(pidrlist.items[tt+1]).pidrar[scen,sex,ag])/
                          Tpidr(pidrlist.items[tt]).pidrar[scen,sex,ag]);
                  pzlist.datavar[tt0,sex,scen,agtoe]:=pzlist.datavar[tt0,sex,scen,agtoe]*(1.0-pif);
                end;
              end;{toett}
            end;{sex}
        end;
     {normaliseren van tt=0 pz's naar 1}
        for tt:=et downto 0 do
         for scen:=ref to intv do
          for sex:=men to fem do
            for ag:=0 to aggmax do
              pzlist.datavar[tt,sex,scen,ag]:=
                 pzlist.datavar[tt,sex,scen,ag]/
                   pzlist.datavar[0,sex,scen,ag];
        for tt:=0 to et+lookback do Tpidr(pidrlist.items[tt]).free;
        pidrlist.clear;
      end;
    end;
  end;
end;

  *)
end.
