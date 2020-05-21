unit OutvarUnit;

interface
uses classes,StdCtrls, Dialogs,initial;

Type
  Tdisuitvars=(invr,prevr,cfatvr,remivr,morvr,dalvr,cosvr,pifvr);

  Tgenuit=class
    rateper:integer;
    tijds:integer;
    datavar,resultvar:Tdatavar;
    function ratesuit(dif:boolean):Tdatavar; virtual;
    function numsuit(dif:boolean):Tdatavar;  virtual;
    function totnumsuit(dif:boolean):Tdatavar; virtual;
    constructor create(tt:integer);
    destructor destroy; override;
  end;

  Tgenuitcost=class(Tgenuit)
    function numsuit(dif:boolean):Tdatavar;  override;
    function totnumsuit(dif:boolean):Tdatavar; override;
    constructor create(tt:integer);
  end;

  Tgenuittot=class(Tgenuit)
    function totnumsuit(dif:boolean):Tdatavar; override;
    constructor create(tt:integer);
  end;

  Tgenuitinci=class(Tgenuit)
    prev:Tdatavar;
    function numsuit(dif:boolean):Tdatavar;  override;
    function totnumsuit(dif:boolean):Tdatavar; override;
    constructor create(tt:integer;var pv:Tdatavar);
  end;

  Tgenuitcfat=class(Tgenuitinci)
    function numsuit(dif:boolean):Tdatavar;  override;
    function totnumsuit(dif:boolean):Tdatavar; override;
  end;

  Tgenuitpif=class(Tgenuit)
    function ratesuit(dif:boolean):Tdatavar; override;
    constructor create(tt:integer);
  end;

  Tgenuitexpec=class(Tgenuit)
    function totnumsuit(dif:boolean):Tdatavar; override;
  end;

  Tgenuitrf=class(Tgenuit)
    constructor create(tt:integer);
  end;

  Tgenuitconrf=class(Tgenuit)
    agnum,agno,rfnum:integer;
    distpars:Trfdatavar;
    function ratesuit(dif:boolean):Tdatavar; override;
    constructor create(tt:integer);
  end;

  Tgenuitpop60=class(Tgenuit)
    function totnumsuit(dif:boolean):Tdatavar; override;
  end;


  Toutvar=class
    uitvar:Tgenuit;
    kliklijst:Tlistbox;
    naam,uitnaam,ls1,ls2,ls3,ls4:string;
    tcol:array[0..6] of string;
    thead:array[0..3] of string;
    ratebool,dif,tabtotbool:boolean;
    nrcol,nrrow,nrhead,nr,deci:integer;
    lookback:integer;
    procedure clear;
    procedure laatzien; virtual;
    procedure laatdynlijnzien;
    procedure laatdyntabzien(lk:Tdatavar);
    procedure laatdynfilezien(lk:Tdatavar);
    procedure zettitels; virtual;
    procedure laatstatlijnzien;
    procedure zettabtitels; virtual;
    procedure laatstattabzien(lk:Tdatavar);
    procedure laatstatfilezien(lk:Tdatavar);
    constructor create(vn:string;var kl:Tlistbox;tl:Tlist);
    destructor destroy; override;
  end;

  TGloboutvarar=class(Toutvar)
    procedure laatzien; override;
    constructor create(vn:string;var kl:Tlistbox;tl:Tlist;uv:Tgenuit;df:boolean);
  end;

  TGlobTotoutvarar=class(TGloboutvarar)
    procedure laatzien; override;
  end;

  TGlobTotoutvararp60=class(TGloboutvarar)
    procedure laatzien; override;
  end;

  TGloboutvararcost=class(TGloboutvarar)
    procedure laatzien; override;
  end;

  TGlobTotoutvararcost=class(TGlobTotoutvarar)
    procedure laatzien; override;
  end;

  TGlobTotoutvararexpec=class(TGlobTotoutvarar)
    procedure laatzien; override;
  end;

  TGloboutvararpop=class(TGloboutvarar)
    procedure laatpopdifzien;
    procedure laatpoppyrzien;
    procedure laatzien; override;
  end;

  TGloboutvararsurv=class(TGloboutvarar)
    procedure laatzien; override;
  end;


  TDisoutvar=class(Toutvar)
    ziektenlijst:Tlist;
    soort:Tdisuitvars;
    disind:integer;
    disnaam:string;
    procedure laatzien; override;
    constructor create(vn:string;kl:Tlistbox;tl:Tlist;dtl:Tlist;srt:Tdisuitvars;df:boolean);
  end;

  TDisTotoutvar=class(TDisoutvar)
    procedure laatzien; override;
  end;

  TDisTotoutvarcost=class(TDisoutvar)
    procedure laatzien; override;
  end;

  TDisoutvarar=class(TDisoutvar)
    procedure laatzien; override;
  end;

  TDisoutvararcost=class(TDisoutvar)
    procedure laatzien; override;
  end;

  TDisoutvararpif=class(TDisoutvar)
    procedure zettitels; override;
    procedure laatzien; override;
  end;

  TRfoutvar=class(Toutvar)
    risfaclijst:Tlist;
    rfind:integer;
    rfnaam:string;
    procedure laatconrfzien(rfind:integer);
    procedure laatzien; override;
    constructor create(vn:string;kl:Tlistbox;tl:Tlist;rftl:Tlist;df:boolean);
  end;



var
  popstruc:TGloboutvararpop;
  popstrucdif:TGloboutvararpop;
  popprop60:TGlobTotoutvararp60;
  genuitpop60:Tgenuitpop60;
  numbirths:TGlobTotoutvarar;
  numbirthsdif:TGlobTotoutvarar;

  totalmort:TGlobTotoutvarar;
  totalmortred:TGlobTotoutvarar;
  dynmorag:TGloboutvarar;
  dynmoragdif:TGloboutvarar;

  totalyld:TGlobTotoutvarar;
  totalylddif:TGlobTotoutvarar;
  dynyldag:TGloboutvarar;
  dynyldagdif:TGloboutvarar;

  totalcost:TGlobtotoutvararcost;
  totalcostdif:TGlobtotoutvararcost;
  dyncostage:TGloboutvararcost;
  dyncostagedif:TGloboutvararcost;

  dynsurv:TGloboutvararsurv;
  expectant:TGlobTotoutvararexpec;
  expectantdif:TGlobTotoutvararexpec;
  dalexpectant:TGlobTotoutvararexpec;
  dalexpectantdif:TGlobTotoutvararexpec;
  disexpectant:TGlobTotoutvararexpec;
  disexpectantdif:TGlobTotoutvararexpec;

  disnumtotmor:TdisTotoutvar;
  disnumtotmortred:TdisTotoutvar;
  dismorage:Tdisoutvarar;
  dismoragedif:Tdisoutvarar;

  disnumtotinc:TdisTotoutvar;
  disnumtotincred:TdisTotoutvar;
  disincage:Tdisoutvarar;
  disincagedif:Tdisoutvarar;

  disnumtotprev:TdisTotoutvar;
  disnumtotprevred:TdisTotoutvar;
  disprevage:Tdisoutvarar;
  disprevagedif:Tdisoutvarar;

  disnumtotcfat:TdisTotoutvar;
  disnumtotcfatred:TdisTotoutvar;
  discfatage:Tdisoutvarar;
  discfatagedif:Tdisoutvarar;

  disnumtotremi:TdisTotoutvar;
  disnumtotremired:TdisTotoutvar;
  disremiage:Tdisoutvarar;
  disremiagedif:Tdisoutvarar;

  disnumtotyld:TdisTotoutvar;
  disnumtotyldred:TdisTotoutvar;
  disyldage:Tdisoutvarar;
  disyldagedif:Tdisoutvarar;

  distotalcost:TdisTotoutvarcost;
  distotalcostred:TdisTotoutvarcost;
  discostage:Tdisoutvararcost;
  discostagedif:Tdisoutvararcost;

  piftif:Tdisoutvararpif;
  rfprevuit:TRfoutvar;
  rfprevuitdif:TRfoutvar;


implementation

uses forms,math,sysutils,teengine,controls,prevmain,kies,bevolun,disunit,outop,dynlijns,grafuit1,
     dynpyra,dynbars,tabeluit;

constructor Tgenuit.create(tt:integer);
var
  sex:Tsex;
  scen:tscen;
  t:integer;
begin
  inherited create;
  tijds:=tt;
  setlength(datavar,tijds+1);  //tijdstippen
  for t:=0 to tijds do
   for sex:=men to fem do
    for scen:=ref to intv do
      setlength(datavar[t,sex,scen],aggmax+1);
  rateper:=100000;
end;

constructor Tgenuitcost.create(tt:integer);
begin
  inherited create(tt);
  rateper:=1;
end;

constructor Tgenuittot.create(tt:integer);
var
  sex:Tsex;
  scen:tscen;
  t:integer;
begin
  inherited create(tt);
  for t:=0 to tijds do
   for sex:=men to fem do
    for scen:=ref to intv do
      setlength(datavar[t,sex,scen],1);
end;

constructor Tgenuitinci.create(tt:integer;var pv:Tdatavar);
begin
  inherited create(tt);
  prev:=pv;
end;

constructor Tgenuitpif.create(tt:integer);
var
  sex:Tsex;
  scen:tscen;
  ag,t:integer;
begin
  inherited create(tt);
  for t:=0 to tijds do
   for sex:=men to fem do
    for scen:=ref to intv do
      for ag:=0 to aggmax do
        datavar[t,sex,scen,ag]:=1.0;
end;

constructor Tgenuitrf.create(tt:integer);
begin
  inherited create(tt);
  rateper:=100;
end;



function Tgenuitpif.ratesuit(dif:boolean):Tdatavar;
var
  sex:Tsex;
  scen:tscen;
  ag,t:integer;
begin
  resultvar:=nil;
  setlength(resultvar,tijds+1);  //alleen tijdstippen, additionele dimensies afhankelijk van nodig
  for t:=0 to tijds do
   for sex:=men to fem do
    for scen:=ref to intv do
      setlength(resultvar[t,sex,scen],aggmax+1);
  for t:=0 to tijds do
   for sex:=men to fem do
    for ag:=0 to aggmax do
    begin
      resultvar[t,sex,ref,ag]:=(1.0-datavar[t,sex,ref,ag])*100.0;
      resultvar[t,sex,intv,ag]:=(1.0-datavar[t,sex,intv,ag]/datavar[t,sex,ref,ag])*100.0;
    end;
  result:=resultvar;
end;


function Tgenuit.ratesuit(dif:boolean):Tdatavar;
var
  sex:Tsex;
  scen:tscen;
  t,ag:integer;
begin
  resultvar:=nil;
  setlength(resultvar,tijds+1);  //alleen tijdstippen, additionele dimensies afhankelijk van nodig
  for t:=0 to tijds do
   for sex:=men to fem do
   if dif then setlength(resultvar[t,sex,ref],aggmax+1)
    else for scen:=ref to intv do
      setlength(resultvar[t,sex,scen],aggmax+1);
  for t:=0 to tijds do
   for sex:=men to fem do
   if dif then
     for ag:=0 to aggmax do
      resultvar[t,sex,ref,ag]:=round((datavar[t,sex,intv,ag]-datavar[t,sex,ref,ag])*rateper)
   else
    for scen:=ref to intv do
     for ag:=0 to aggmax do
      resultvar[t,sex,scen,ag]:=datavar[t,sex,scen,ag]*rateper;
  result:=resultvar;
end;

function Tgenuit.numsuit(dif:boolean):Tdatavar;
var
  sex:Tsex;
  scen:tscen;
  t,ag:integer;
begin
  resultvar:=nil;
  setlength(resultvar,tijds+1);  //alleen tijdstippen, additionele dimensies afhankelijk van nodig
  for t:=0 to tijds do
   for sex:=men to fem do
   if dif then setlength(resultvar[t,sex,ref],aggmax+1)
    else for scen:=ref to intv do
      setlength(resultvar[t,sex,scen],aggmax+1);
  for t:=0 to tijds do
   for sex:=men to fem do
   if dif then
     for ag:=0 to aggmax do
      resultvar[t,sex,ref,ag]:=round(datavar[t,sex,intv,ag]*
        population.tpopu.datavar[t,sex,intv,ag]
          -datavar[t,sex,ref,ag]*population.tpopu.datavar[t,sex,ref,ag])
   else
    for scen:=ref to intv do
     for ag:=0 to aggmax do
      resultvar[t,sex,scen,ag]:=datavar[t,sex,scen,ag]*
      population.tpopu.datavar[t,sex,scen,ag];
  result:=resultvar;
end;

function Tgenuit.totnumsuit(dif:boolean):Tdatavar;
var
  sex:Tsex;
  scen:tscen;
  t,ag:integer;
begin
  resultvar:=nil;
  setlength(resultvar,tijds+1);  //alleen tijdstippen, additionele dimensies afhankelijk van nodig
  for t:=0 to tijds do
   for sex:=men to fem do
   if dif then setlength(resultvar[t,sex,ref],1)
    else for scen:=ref to intv do
      setlength(resultvar[t,sex,scen],1);
  for t:=0 to tijds do
   for sex:=men to fem do
   if dif then
     for ag:=0 to aggmax do
      resultvar[t,sex,ref,0]:=resultvar[t,sex,ref,0]+round(datavar[t,sex,intv,ag]*
        population.tpopu.datavar[t,sex,intv,ag]
        -datavar[t,sex,ref,ag]*population.tpopu.datavar[t,sex,ref,ag])
   else
    for scen:=ref to intv do
     for ag:=0 to aggmax do
      resultvar[t,sex,scen,0]:=resultvar[t,sex,scen,0]+datavar[t,sex,scen,ag]*
        population.tpopu.datavar[t,sex,scen,ag];
  result:=resultvar;
end;

function Tgenuitcost.totnumsuit(dif:boolean):Tdatavar;
var
  sex:Tsex;
  scen:tscen;
  t:integer;

begin
  inherited totnumsuit(dif);
  for t:=0 to tijds do
   for sex:=men to fem do
   if dif then
      resultvar[t,sex,ref,0]:=resultvar[t,sex,ref,0]/outopform.eenheid
   else
    for scen:=ref to intv do
      resultvar[t,sex,scen,0]:=resultvar[t,sex,scen,0]/outopform.eenheid;
  result:=resultvar;
end;

function Tgenuitcost.numsuit(dif:boolean):Tdatavar;
var
  sex:Tsex;
  scen:tscen;
  t,ag:integer;

begin
  inherited numsuit(dif);
  for t:=0 to tijds do
   for sex:=men to fem do
   if dif then
     for ag:=0 to aggmax do
      resultvar[t,sex,ref,ag]:=resultvar[t,sex,ref,ag]/outopform.eenheid
   else
    for scen:=ref to intv do
     for ag:=0 to aggmax do
      resultvar[t,sex,scen,ag]:=resultvar[t,sex,scen,ag]/outopform.eenheid;
  result:=resultvar;
end;

function Tgenuittot.totnumsuit(dif:boolean):Tdatavar;
var
  sex:Tsex;
  t:integer;
begin
  resultvar:=nil;
  if dif then
  begin
    setlength(resultvar,tijds+1);
    for t:=0 to tijds do
     for sex:=men to fem do
      setlength(resultvar[t,sex,ref],1);
    for t:=0 to tijds do
     for sex:=men to fem do
      resultvar[t,sex,ref,0]:=round(datavar[t,sex,intv,0]
        -datavar[t,sex,ref,0])
  end else resultvar:=datavar;
  result:=resultvar;
end;


function Tgenuitinci.numsuit(dif:boolean):Tdatavar;
var
  sex:Tsex;
  scen:tscen;
  t,ag:integer;
begin
  resultvar:=nil;
  setlength(resultvar,tijds+1);
  for t:=0 to tijds do
   for sex:=men to fem do
   if dif then setlength(resultvar[t,sex,ref],aggmax+1)
    else for scen:=ref to intv do
      setlength(resultvar[t,sex,scen],aggmax+1);
  for t:=0 to tijds do
   for sex:=men to fem do
   if dif then
     for ag:=0 to aggmax do
      resultvar[t,sex,ref,ag]:=round(datavar[t,sex,intv,ag]*
        population.tpopu.datavar[t,sex,intv,ag]*(1.0-prev[t,sex,intv,ag])
          -datavar[t,sex,ref,ag]*population.tpopu.datavar[t,sex,ref,ag]*(1.0-prev[t,sex,ref,ag]))
   else
    for scen:=ref to intv do
     for ag:=0 to aggmax do
      resultvar[t,sex,scen,ag]:=datavar[t,sex,scen,ag]*
      population.tpopu.datavar[t,sex,scen,ag]*(1.0-prev[t,sex,scen,ag]);
  result:=resultvar;
end;

function Tgenuitinci.totnumsuit(dif:boolean):Tdatavar;
var
  sex:Tsex;
  scen:tscen;
  t,ag:integer;
begin
  resultvar:=nil;
  setlength(resultvar,tijds+1);  //alleen tijdstippen, additionele dimensies afhankelijk van nodig
  for t:=0 to tijds do
   for sex:=men to fem do
   if dif then setlength(resultvar[t,sex,ref],1)
    else for scen:=ref to intv do
      setlength(resultvar[t,sex,scen],1);
  for t:=0 to tijds do
   for sex:=men to fem do
   if dif then
     for ag:=0 to aggmax do
      resultvar[t,sex,ref,0]:=resultvar[t,sex,ref,0]+round(datavar[t,sex,intv,ag]*
        population.tpopu.datavar[t,sex,intv,ag]*(1.0-prev[t,sex,intv,ag])
        -datavar[t,sex,ref,ag]*population.tpopu.datavar[t,sex,ref,ag]*(1.0-prev[t,sex,ref,ag]))
   else
    for scen:=ref to intv do
     for ag:=0 to aggmax do
      resultvar[t,sex,scen,0]:=resultvar[t,sex,scen,0]+datavar[t,sex,scen,ag]*
        population.tpopu.datavar[t,sex,scen,ag]*(1.0-prev[t,sex,scen,ag]);
  result:=resultvar;
end;

function Tgenuitcfat.numsuit(dif:boolean):Tdatavar;
var
  sex:Tsex;
  scen:tscen;
  t,ag:integer;
begin
  resultvar:=nil;
  setlength(resultvar,tijds+1);
  for t:=0 to tijds do
   for sex:=men to fem do
   if dif then setlength(resultvar[t,sex,ref],aggmax+1)
    else for scen:=ref to intv do
      setlength(resultvar[t,sex,scen],aggmax+1);
  for t:=0 to tijds do
   for sex:=men to fem do
   if dif then
     for ag:=0 to aggmax do
      resultvar[t,sex,ref,ag]:=round(datavar[t,sex,intv,ag]*
        population.tpopu.datavar[t,sex,intv,ag]*prev[t,sex,intv,ag]
          -datavar[t,sex,ref,ag]*population.tpopu.datavar[t,sex,ref,ag]*prev[t,sex,ref,ag])
   else
    for scen:=ref to intv do
     for ag:=0 to aggmax do
      resultvar[t,sex,scen,ag]:=datavar[t,sex,scen,ag]*
      population.tpopu.datavar[t,sex,scen,ag]*prev[t,sex,scen,ag];
  result:=resultvar;
end;

function Tgenuitcfat.totnumsuit(dif:boolean):Tdatavar;
var
  sex:Tsex;
  scen:tscen;
  t,ag:integer;
begin
  resultvar:=nil;
  setlength(resultvar,tijds+1);  //alleen tijdstippen, additionele dimensies afhankelijk van nodig
  for t:=0 to tijds do
   for sex:=men to fem do
   if dif then setlength(resultvar[t,sex,ref],1)
    else for scen:=ref to intv do
      setlength(resultvar[t,sex,scen],1);
  for t:=0 to tijds do
   for sex:=men to fem do
   if dif then
     for ag:=0 to aggmax do
      resultvar[t,sex,ref,0]:=resultvar[t,sex,ref,0]+round(datavar[t,sex,intv,ag]*
        population.tpopu.datavar[t,sex,intv,ag]*prev[t,sex,intv,ag]
        -datavar[t,sex,ref,ag]*population.tpopu.datavar[t,sex,ref,ag]*prev[t,sex,ref,ag])
   else
    for scen:=ref to intv do
     for ag:=0 to aggmax do
      resultvar[t,sex,scen,0]:=resultvar[t,sex,scen,0]+datavar[t,sex,scen,ag]*
        population.tpopu.datavar[t,sex,scen,ag]*prev[t,sex,scen,ag];
  result:=resultvar;
end;


function Tgenuitexpec.totnumsuit(dif:boolean):Tdatavar;
var
  sex:Tsex;
  scen:tscen;
  t:integer;

begin
  resultvar:=nil;
  setlength(resultvar,tijds+1);
  for t:=0 to tijds do
   for sex:=men to fem do
   if dif then setlength(resultvar[t,sex,ref],1)
    else for scen:=ref to intv do
      setlength(resultvar[t,sex,scen],1);
  for t:=0 to tijds do
   for sex:=men to fem do
   if dif then
      resultvar[t,sex,ref,0]:=datavar[t,sex,intv,outopform.expecleeft div 5]
        -datavar[t,sex,ref,outopform.expecleeft div 5]
   else
    for scen:=ref to intv do
      resultvar[t,sex,scen,0]:=datavar[t,sex,scen,outopform.expecleeft div 5];
  result:=resultvar;
end;

constructor Tgenuitconrf.create(tt:integer);
var
  sex:Tsex;
  scen:Tscen;
  t,pp:integer;
begin
  inherited create(tt);
  resultvar:=nil;
  tijds:=tt;
  setlength(distpars,tijds+1);  //tijdstippen
  for t:=0 to tijds do
   for scen:=ref to intv do
    for sex:=men to fem do
     for pp:=0 to 2 do
      setlength(distpars[t,scen,sex,pp],aggmax+1);
  rateper:=1;
end;

function Tgenuitconrf.ratesuit(dif:boolean):Tdatavar;
var
  sex:Tsex;
  scen:tscen;
  t,pp,pmax:integer;
  dp,dpi:Tdisparams;
begin
  resultvar:=nil;
  setlength(resultvar,tijds+1);  //alleen tijdstippen, additionele dimensies afhankelijk van nodig
  with Tconrf(currflist.Items[self.rfnum]) do
  begin
    step:=(hx-lx)/100.0;
    pmax:=round((hx-lx)/step);
    setlength(dp,dist[ref,men,0].paramnum);
    setlength(dpi,dist[ref,men,0].paramnum);
    for t:=0 to tijds do
     for sex:=men to fem do
     if dif then setlength(resultvar[t,sex,ref],pmax)
      else for scen:=ref to intv do
        setlength(resultvar[t,sex,scen],pmax);
    for t:=0 to tijds do
     for sex:=men to fem do
     if dif then
       begin
         for pp:=0 to dist[ref,sex,self.agnum].paramnum-1 do
               dp[pp]:=distpars[t,ref,sex,pp,self.agnum];
         for pp:=0 to dist[ref,sex,self.agnum].paramnum-1 do
               dpi[pp]:=distpars[t,intv,sex,pp,self.agnum];
         for pp:=0 to pmax-1 do
         resultvar[t,sex,ref,pp]:=
           dist[intv,sex,self.agnum].calc(lx+step*pp,dpi)-
           dist[ref,sex,self.agnum].calc(lx+step*pp,dp);
       end
     else
      for scen:=ref to intv do
       begin
         for pp:=0 to dist[scen,sex,self.agnum].paramnum-1 do dp[pp]:=distpars[t,scen,sex,pp,self.agnum];
         for pp:=0 to pmax-1 do
         resultvar[t,sex,scen,pp]:=
           dist[scen,sex,self.agnum].calc(lx+step*pp,dp);
       end;
  end;
  dp:=nil;
  dpi:=nil;
  result:=resultvar;
end;


function Tgenuitpop60.totnumsuit(dif:boolean):Tdatavar;
var
  sex:Tsex;
  scen:tscen;
  t,ag:integer;
  tot,tot60:double;
begin
  resultvar:=nil;
  setlength(resultvar,tijds+1);
  for t:=0 to tijds do
   for sex:=men to fem do
    for scen:=ref to intv do
      setlength(resultvar[t,sex,scen],1);
  for t:=0 to tijds do
   for sex:=men to fem do
    for scen:=ref to intv do
    begin
      tot:=0.0;
      tot60:=0.0;
      for ag:=0 to aggmax do tot:=tot+population.tpopu.datavar[t,sex,scen,ag];
      for ag:=(outopform.proppopSpin.Value div 5) to aggmax do tot60:=tot60+population.tpopu.datavar[t,sex,scen,ag];
      resultvar[t,sex,scen,0]:=(tot60/tot)*100.0;
    end;
  result:=resultvar;
end;


destructor Tgenuit.destroy;
begin
  datavar:=nil;
  resultvar:=nil;
  inherited destroy;
end;



constructor Toutvar.create(vn:string;var kl:Tlistbox;tl:Tlist);
begin
  inherited create;
  naam:=vn;
  deci:=0;
  tabtotbool:=true;
  kliklijst:=kl;
  kliklijst.items.add('  '+naam);
  tl.add(self);
end;

procedure Toutvar.laatzien;

begin
  ratebool:=outopform.hdpop.itemindex=0;
  tabtotbool:=not ratebool;
end;

procedure Toutvar.laatdynlijnzien;

var sex:tsex;
    scen:Tscen;
    tijd,ymin,ymax:double;
    tt,ag:integer;

begin
  if outopform.chartGroup.ItemIndex=0 then
  begin
    Application.CreateForm(Tdynlijnen, dynlijnen);
    zettitels;
    with dynlijnen do
    begin
      offsett:=lookback;
      if dif then nrlok:=2 else nrlok:=4;
      if ratebool
        then lokaal:=uitvar.ratesuit(dif)
        else lokaal:=uitvar.numsuit(dif);
      ymax:=0.0;
      ymin:=0.0;
      for tt:=0 to et do
      begin
        for sex:=men to fem do
        if dif then
          begin
            tijd:=maxvalue(lokaal[tt,sex,ref]);
            if ymax<tijd then ymax:=tijd;
            tijd:=minvalue(lokaal[tt,sex,ref]);
            if ymin>tijd then ymin:=tijd;
        end
        else
         for scen:=ref to intv do
          begin
            tijd:=maxvalue(lokaal[tt,sex,scen]);
            if ymax<tijd then ymax:=tijd;
            tijd:=minvalue(lokaal[tt,sex,scen]);
            if ymin>tijd then ymin:=tijd;
        end;
      end;
      for ag:=0 to aggmax do
      if dif then
      begin
        LineSeries1.AddXY(ag*5,lokaal[0,men,ref,ag], '' , clTeeColor );
        LineSeries3.AddXY(ag*5,lokaal[0,fem,ref,ag], '' , clTeeColor );
      end else
      begin
        LineSeries1.AddXY(ag*5,lokaal[0,men,ref,ag], '' , clTeeColor );
        LineSeries2.AddXY(ag*5,lokaal[0,men,intv,ag], '' , clTeeColor );
        LineSeries3.AddXY(ag*5,lokaal[0,fem,ref,ag], '' , clTeeColor );
        LineSeries4.AddXY(ag*5,lokaal[0,fem,intv,ag], '' , clTeeColor );
      end;
      doen(ymin,ymax,uitnaam,ls1,ls2,ls3,ls4);
    end;
  end else
  if ratebool
    then laatdyntabzien(uitvar.ratesuit(dif))
    else laatdyntabzien(uitvar.numsuit(dif));
end;


procedure Trfoutvar.laatconrfzien(rfind:integer);

var sex:tsex;
    scen:Tscen;
    tijd,ymin,ymax:double;
    tt,ag:integer;

begin
  if outopform.chartGroup.ItemIndex=0 then
  begin
    Application.CreateForm(Tdynlijnen, dynlijnen);
    zettitels;
    with Tconrf(currflist.Items[rfind]) do
    with dynlijnen do
    begin
      offsett:=lookback;
      if dif then nrlok:=2 else nrlok:=4;
      lokaal:=uitvar.ratesuit(dif);
      ymax:=0.0;
      ymin:=0.0;
      for tt:=0 to et do
      begin
        for sex:=men to fem do
        if dif then
          begin
            tijd:=maxvalue(lokaal[tt,sex,ref]);
            if ymax<tijd then ymax:=tijd;
            tijd:=minvalue(lokaal[tt,sex,ref]);
            if ymin>tijd then ymin:=tijd;
        end
        else
         for scen:=ref to intv do
          begin
            tijd:=maxvalue(lokaal[tt,sex,scen]);
            if ymax<tijd then ymax:=tijd;
            tijd:=minvalue(lokaal[tt,sex,scen]);
            if ymin>tijd then ymin:=tijd;
        end;
      end;
      for ag:=0 to length(lokaal[0,men,ref])-1 do
      if dif then
      begin
        LineSeries1.AddXY(lx+step*ag,lokaal[0,men,ref,ag], '' , clTeeColor );
        LineSeries3.AddXY(lx+step*ag,lokaal[0,fem,ref,ag], '' , clTeeColor );
      end else
      begin
        LineSeries1.AddXY(lx+step*ag,lokaal[0,men,ref,ag], '' , clTeeColor );
        LineSeries2.AddXY(lx+step*ag,lokaal[0,men,intv,ag], '' , clTeeColor );
        LineSeries3.AddXY(lx+step*ag,lokaal[0,fem,ref,ag], '' , clTeeColor );
        LineSeries4.AddXY(lx+step*ag,lokaal[0,fem,intv,ag], '' , clTeeColor );
      end;
      doen(ymin,ymax,uitnaam,ls1,ls2,ls3,ls4);
    end;
  end else
  if ratebool
    then laatdyntabzien(uitvar.ratesuit(dif))
    else laatdyntabzien(uitvar.numsuit(dif));
end;



procedure Toutvar.laatdyntabzien(lk:Tdatavar);
var
  tt,ag:integer;
  lok:Tdatavar;
  ind:integer;


begin
  zettabtitels;
  if outopform.chartGroup.ItemIndex=1 then
  begin
    tt:=kiesform.jaarkiezen(lookback);
    if tt>-1 then
    begin
      lok:=lk;
      Application.CreateForm(Ttableuitform,tableuitform);
      with tableuitform do
      begin
        nrrow:=aggmax+1;
        opzet(nr,nrcol,nrrow,nrhead);
        uitnaam:=uitnaam+', '+inttostr(beginjaar+tt-lookback);
        with Hypergrid1 do
        begin
          cells[0,1]:='Age';
          for ind:=0 to nrcol do columns[ind].caption:=tcol[ind];
          for ind:=0 to nrhead do headings[ind].caption:=thead[ind];
          if dif then
          for ag:=0 to aggmax do
          begin
            cells[0,ag+2]:=age2Str(ag);
            cells[1,ag+2]:=FloatToStrF(lok[tt,men,ref,ag],ffnumber,9,deci);
            cells[2,ag+2]:=FloatToStrF(lok[tt,fem,ref,ag],ffnumber,9,deci);
            if tabtotbool then
              cells[3,ag+2]:=FloatToStrF(lok[tt,men,ref,ag]+lok[tt,fem,ref,ag],ffnumber,9,deci);
          end else
          for ag:=0 to aggmax do
          begin
            cells[0,ag+2]:=age2Str(ag);
            cells[1,ag+2]:=FloatToStrF(lok[tt,men,ref,ag],ffnumber,9,deci);
            cells[2,ag+2]:=FloatToStrF(lok[tt,men,intv,ag],ffnumber,9,deci);
            cells[3,ag+2]:=FloatToStrF(lok[tt,fem,ref,ag],ffnumber,9,deci);
            cells[4,ag+2]:=FloatToStrF(lok[tt,fem,intv,ag],ffnumber,9,deci);
            if tabtotbool then
            begin
              cells[5,ag+2]:=FloatToStrF(lok[tt,men,ref,ag]+lok[tt,fem,ref,ag],ffnumber,9,deci);
              cells[6,ag+2]:=FloatToStrF(lok[tt,men,intv,ag]+lok[tt,fem,intv,ag],ffnumber,9,deci);
            end;
          end;
        end;
        doen(uitnaam);
      end;
      lok:=nil;
    end;  
  end else laatdynfilezien(lk);
end;

procedure Toutvar.laatdynfilezien(lk:Tdatavar);

const
  c=char(44);
var
  tt,ag:integer;
  lok:Tdatavar;
  ind:integer;
  tmpstr:string;

begin
  mainform.bezigofniet(true);
  lok:=lk;
  with outopform do
  for tt:=0 to et+lookback do
  begin
    tmpstr:='"'+uitnaam+' '+inttostr(beginjaar+tt-lookback)+'"';
    tmpstr:=tmpstr+char(10);
    fstream.writebuffer(PChar(tmpstr)^,length(tmpstr));
    tmpstr:='';
    if dif then
    begin
      tmpstr:='"'+thead[0]+'"';
      for ind:=1 to nrhead do tmpstr:=tmpstr+c+'"'+thead[ind]+'"';
    end else
    begin
      tmpstr:='"'+thead[0]+'"';
      for ind:=1 to nrhead do tmpstr:=tmpstr+c+'"'+thead[ind]+'"'+c;
    end;
    tmpstr:=tmpstr+char(10);
    fstream.writebuffer(PChar(tmpstr)^,length(tmpstr));
    tmpstr:='"'+tcol[0]+'"';
    for ind:=1 to nrcol do tmpstr:=tmpstr+c+'"'+tcol[ind]+'"';
    tmpstr:=tmpstr+char(10);
    fstream.writebuffer(PChar(tmpstr)^,length(tmpstr));
    tmpstr:='"Age"';
    tmpstr:=tmpstr+char(10);
    fstream.writebuffer(PChar(tmpstr)^,length(tmpstr));
    if dif then
    for ag:=0 to aggmax do
    begin
      tmpstr:='"'''+age2Str(ag)+'"'+c;
      tmpstr:=tmpstr+FloatToStrF(lok[tt,men,ref,ag],fffixed,9,deci)+c;
      tmpstr:=tmpstr+FloatToStrF(lok[tt,fem,ref,ag],fffixed,9,deci)+c;
      if tabtotbool then
        tmpstr:=tmpstr+FloatToStrF(lok[tt,men,ref,ag]+lok[tt,fem,ref,ag],fffixed,9,deci);
      tmpstr:=tmpstr+char(10);
      fstream.writebuffer(PChar(tmpstr)^,length(tmpstr));
    end else
    for ag:=0 to aggmax do
    begin
      tmpstr:='"'''+age2Str(ag)+'"'+c;
      tmpstr:=tmpstr+FloatToStrF(lok[tt,men,ref,ag],fffixed,9,deci)+c;
      tmpstr:=tmpstr+FloatToStrF(lok[tt,men,intv,ag],fffixed,9,deci)+c;
      tmpstr:=tmpstr+FloatToStrF(lok[tt,fem,ref,ag],fffixed,9,deci)+c;
      tmpstr:=tmpstr+FloatToStrF(lok[tt,fem,intv,ag],fffixed,9,deci)+c;
      if tabtotbool then
      begin
        tmpstr:=tmpstr+FloatToStrF(lok[tt,men,ref,ag]+lok[tt,fem,ref,ag],fffixed,9,deci)+c;
        tmpstr:=tmpstr+FloatToStrF(lok[tt,men,intv,ag]+lok[tt,fem,intv,ag],fffixed,9,deci);
      end;
      tmpstr:=tmpstr+char(10);
      fstream.writebuffer(PChar(tmpstr)^,length(tmpstr));
    end;
    tmpstr:=char(10);
    fstream.writebuffer(PChar(tmpstr)^,length(tmpstr));
  end;
  lok:=nil;
  mainform.bezigofniet(false);
end;



procedure Toutvar.zettitels;
begin
  if dif then
  begin
    Ls1:='Men';
    LS3:='Women';
    LS2:='';
    Ls4:='';
  end else
  begin
    LS1:='Men, refer';
    LS2:='Men, interv';
    LS3:='Women, refer';
    LS4:='Women, interv';
  end;
end;

procedure Toutvar.laatstatlijnzien;
var tt:integer;
    lok:Tdatavar;
begin
  lok:=uitvar.totnumsuit(dif);
  if outopform.chartGroup.ItemIndex=0 then
  begin
    Application.CreateForm(Tgraphuit1, graphuit1);
    zettitels;
    with graphuit1 do
    begin
      if dif then nrlok:=2 else nrlok:=4;
      if dif then
      for tt:=0 to et do
      begin
        LineSeries1.AddXY(beginjaar+tt,lok[tt,men,ref,0], '' , clTeeColor );
        LineSeries3.AddXY(beginjaar+tt,lok[tt,fem,ref,0], '' , clTeeColor );
      end else
      for tt:=0 to et do
      begin
        LineSeries1.AddXY(beginjaar+tt,lok[tt,men,ref,0], '' , clTeeColor );
        LineSeries2.AddXY(beginjaar+tt,lok[tt,men,intv,0], '' , clTeeColor );
        LineSeries3.AddXY(beginjaar+tt,lok[tt,fem,ref,0], '' , clTeeColor );
        LineSeries4.AddXY(beginjaar+tt,lok[tt,fem,intv,0], '' , clTeeColor );
      end;
      doen(uitnaam,ls1,ls2,ls3,ls4);
    end;
    lok:=nil;
  end else laatstattabzien(lok);
end;

procedure Toutvar.zettabtitels;

begin
  if dif then
  begin
    if not tabtotbool then
    begin
      nrcol:=2;
      nrhead:=2;
      nr:=2;
    end else
    begin
      nrcol:=3;
      nrhead:=3;
      nr:=3;
    end;
    tcol[0]:='';
    tcol[1]:='Men';
    tcol[2]:='Women';
    tcol[3]:='Total';
    tcol[4]:='';
    tcol[5]:='';
    tcol[6]:='';
    thead[0]:='';
    thead[1]:='';
    thead[2]:='';
    thead[3]:='';
  end else
  begin
    if not tabtotbool then
    begin
      nrcol:=4;
      nrhead:=2;
      nr:=2;
    end else
    begin
      nrcol:=6;
      nrhead:=3;
      nr:=4;
    end;
    tcol[0]:='Scenario';
    tcol[1]:='trend';
    tcol[2]:='interv';
    tcol[3]:='trend';
    tcol[4]:='interv';
    tcol[5]:='trend';
    tcol[6]:='interv';
    thead[0]:='Sex';
    thead[1]:='Men';
    thead[2]:='Women';
    thead[3]:='Total';
  end;
end;


procedure Toutvar.laatstattabzien(lk:Tdatavar);
var
  tt:integer;
  lok:Tdatavar;
  ind:integer;


begin
  nrrow:=et+1;
  zettabtitels;
  if outopform.chartGroup.ItemIndex=1 then
  begin
    Application.CreateForm(Ttableuitform,tableuitform);
    lok:=lk;
    with tableuitform do
    begin
      opzet(nr,nrcol,nrrow,nrhead);
      with Hypergrid1 do
      begin
        cells[0,1]:='Year';
        for ind:=0 to nrcol do columns[ind].caption:=tcol[ind];
        for ind:=0 to nrhead do headings[ind].caption:=thead[ind];
        if dif then
        for tt:=0 to et do
        begin
          cells[0,tt+2]:=IntToStr(beginjaar+tt);
          cells[1,tt+2]:=FloatToStrF(lok[tt,men,ref,0],ffnumber,9,deci);
          cells[2,tt+2]:=FloatToStrF(lok[tt,fem,ref,0],ffnumber,9,deci);
          if tabtotbool then
            cells[3,tt+2]:=FloatToStrF(lok[tt,men,ref,0]+lok[tt,fem,ref,0],ffnumber,9,deci);
        end else
        for tt:=0 to et do
        begin
          cells[0,tt+2]:=IntToStr(beginjaar+tt);
          cells[1,tt+2]:=FloatToStrF(lok[tt,men,ref,0],ffnumber,9,deci);
          cells[2,tt+2]:=FloatToStrF(lok[tt,men,intv,0],ffnumber,9,deci);
          cells[3,tt+2]:=FloatToStrF(lok[tt,fem,ref,0],ffnumber,9,deci);
          cells[4,tt+2]:=FloatToStrF(lok[tt,fem,intv,0],ffnumber,9,deci);
          if tabtotbool then
          begin
            cells[5,tt+2]:=FloatToStrF(lok[tt,men,ref,0]+lok[tt,fem,ref,0],ffnumber,9,deci);
            cells[6,tt+2]:=FloatToStrF(lok[tt,men,intv,0]+lok[tt,fem,intv,0],ffnumber,9,deci);
          end;
        end;
      end;
      doen(uitnaam);
    end;
    lok:=nil;
  end else laatstatfilezien(lk);
end;

procedure Toutvar.laatstatfilezien(lk:Tdatavar);

const
  c=char(44);
var
  tt:integer;
  lok:Tdatavar;
  ind:integer;
  tmpstr:string;

begin
  Screen.Cursor := crHourGlass;
  lok:=lk;
  with outopform do
  begin
    tmpstr:='"'+uitnaam+'"';
    tmpstr:=tmpstr+char(10);
    fstream.writebuffer(PChar(tmpstr)^,length(tmpstr));
    tmpstr:='';
    if dif then
    begin
      tmpstr:='"'+thead[0]+'"';
      for ind:=1 to nrhead do tmpstr:=tmpstr+c+'"'+thead[ind]+'"';
    end else
    begin
      tmpstr:='"'+thead[0]+'"';
      for ind:=1 to nrhead do tmpstr:=tmpstr+c+'"'+thead[ind]+'"'+c;
    end;
    tmpstr:=tmpstr+char(10);
    fstream.writebuffer(PChar(tmpstr)^,length(tmpstr));
    tmpstr:='"'+tcol[0]+'"';
    for ind:=1 to nrcol do tmpstr:=tmpstr+c+'"'+tcol[ind]+'"';
    tmpstr:=tmpstr+char(10);
    fstream.writebuffer(PChar(tmpstr)^,length(tmpstr));
    tmpstr:='"Year"';
    tmpstr:=tmpstr+char(10);
    fstream.writebuffer(PChar(tmpstr)^,length(tmpstr));
    if dif then
    for tt:=0 to et do
    begin
      tmpstr:=IntToStr(beginjaar+tt)+c;
      tmpstr:=tmpstr+FloatToStrF(lok[tt,men,ref,0],fffixed,9,deci)+c;
      tmpstr:=tmpstr+FloatToStrF(lok[tt,fem,ref,0],fffixed,9,deci)+c;
      if tabtotbool then
        tmpstr:=tmpstr+FloatToStrF(lok[tt,men,ref,0]+lok[tt,fem,ref,0],fffixed,9,deci);
      tmpstr:=tmpstr+char(10);
      fstream.writebuffer(PChar(tmpstr)^,length(tmpstr));
    end else
    for tt:=0 to et do
    begin
      tmpstr:=IntToStr(beginjaar+tt)+c;
      tmpstr:=tmpstr+FloatToStrF(lok[tt,men,ref,0],fffixed,9,deci)+c;
      tmpstr:=tmpstr+FloatToStrF(lok[tt,men,intv,0],fffixed,9,deci)+c;
      tmpstr:=tmpstr+FloatToStrF(lok[tt,fem,ref,0],fffixed,9,deci)+c;
      tmpstr:=tmpstr+FloatToStrF(lok[tt,fem,intv,0],fffixed,9,deci)+c;
      if tabtotbool then
      begin
        tmpstr:=tmpstr+FloatToStrF(lok[tt,men,ref,0]+lok[tt,fem,ref,0],fffixed,9,deci)+c;
        tmpstr:=tmpstr+FloatToStrF(lok[tt,men,intv,0]+lok[tt,fem,intv,0],fffixed,9,deci);
      end;
      tmpstr:=tmpstr+char(10);
      fstream.writebuffer(PChar(tmpstr)^,length(tmpstr));
    end;
    tmpstr:=char(10);
    fstream.writebuffer(PChar(tmpstr)^,length(tmpstr));
  end;
  lok:=nil;
  Screen.Cursor := crDefault;
end;




constructor TGloboutvarar.create(vn:string;var kl:Tlistbox;tl:Tlist;uv:Tgenuit;df:boolean);
begin
  inherited create(vn,kl,tl);
  uitvar:=uv;
  dif:=df;
end;

procedure TGloboutvarar.laatzien;
begin
  inherited laatzien;
  uitnaam:=naam+' '+hdnumstan[ratebool];
  laatdynlijnzien;
end;

procedure TGloboutvararsurv.laatzien;
begin
  ratebool:=true;
  tabtotbool:=false;
  uitnaam:=naam;
  laatdynlijnzien;
end;

procedure TGlobTotoutvarar.laatzien;
begin
  uitnaam:=naam;
  laatstatlijnzien;
end;

procedure TGlobTotoutvararp60.laatzien;
begin
  uitnaam:='Population age '+inttostr(outopform.proppopSpin.Value)+' and over (%)';
  deci:=2;
  tabtotbool:=false;
  laatstatlijnzien;
end;


procedure TGloboutvararcost.laatzien;
begin
  ratebool:=outopform.hdpop.itemindex=0;
  tabtotbool:=not ratebool;
  uitnaam:=naam+' '+hdnumstancost[ratebool];
  laatdynlijnzien;
end;


procedure TGlobTotoutvararcost.laatzien;
begin
  uitnaam:=naam+hdnumstancost[false];
  tabtotbool:=true;
  laatstatlijnzien;
end;

procedure TGlobTotoutvararexpec.laatzien;
begin
  tabtotbool:=false;
  deci:=2;
  uitnaam:=naam+' at age '+inttostr(outopform.expecleeft);
  laatstatlijnzien;
end;

procedure TGloboutvararpop.laatpoppyrzien;

var sex:tsex;
    scen:Tscen;
    tijd,ymin,ymax:double;
    tt,ag:integer;

begin
  if outopform.chartGroup.ItemIndex=0 then
  begin
    Application.CreateForm(Tdynpyramid, dynpyramid);
    with dynpyramid do
    begin
      ymax:=0.0;
      ymin:=0.0;
      lokaal:=population.tpopu.datavar;
      for tt:=0 to et do
      begin
        for sex:=men to fem do
         for scen:=ref to intv do
          begin
            tijd:=maxvalue(lokaal[tt,sex,scen]);
            if ymax<tijd then ymax:=tijd;
        end;
      end;
      with Wshared do
        for ag:=0 to aggmax do Addx(lokaal[0,fem,ref,ag]/globdeeldoor,  inttostr(ag*5) , clTeeColor) ;
      with Wloss do
         for ag:=0 to aggmax do Addx(0.0,  inttostr(ag*5) , clTeeColor) ;
      with Wgain do
        for ag:=0 to aggmax do Addx(0.0,  inttostr(ag*5) , clTeeColor) ;
      with Mshared do
        for ag:=0 to aggmax do Addx(lokaal[0,men,ref,ag]/globdeeldoor,  inttostr(ag*5) , clTeeColor) ;
      with Mloss do
        for ag:=0 to aggmax do Addx(0.0,  inttostr(ag*5) , clTeeColor) ;
      with Mgain do
        for ag:=0 to aggmax do Addx(0.0,  inttostr(ag*5) , clTeeColor) ;
      doen(ymin,ymax,uitnaam,ls1,ls2,ls3,ls4);
    end;
  end else laatdyntabzien(population.tpopu.datavar);
end;


procedure TGloboutvararpop.laatpopdifzien;

var sex:tsex;
    tijd,ymin,ymax:double;
    tt,ag:integer;
    lok:Tdatavar;

begin
  setlength(lok,population.tpopu.tijds+1);
  for tt:=0 to population.tpopu.tijds do
   for sex:=men to fem do
    setlength(lok[tt,sex,ref],aggmax+1);
  for tt:=0 to et do
   for sex:=men to fem do
    for ag:=0 to aggmax do
    lok[tt,sex,ref,ag]:=round(population.tpopu.datavar[tt,sex,intv,ag]-
      population.tpopu.datavar[tt,sex,ref,ag]);
  if outopform.chartGroup.ItemIndex=0 then
  begin
    Application.CreateForm(Tdynbarren, dynbarren);
    with dynbarren do
    begin
      ymax:=0.0;
      ymin:=0.0;
      lokaal:=lok;
      for tt:=0 to et do
        for sex:=men to fem do
        begin
          tijd:=maxvalue(lokaal[tt,sex,ref]);
          if ymax<tijd then ymax:=tijd;
          tijd:=minvalue(lokaal[tt,sex,ref]);
          if ymin>tijd then ymin:=tijd;
        end;
      with ManSeries do
      begin
        for ag:=0 to aggmax do
          Add(lokaal[0,men,ref,ag],inttostr(ag*5),clTeeColor);
        title:='Men';
      end;
      with VroSeries do
      begin
        for ag:=0 to aggmax do
           Add(lokaal[0,fem,ref,ag],inttostr(ag*5),clTeeColor);
        title:='Women';
      end;
      doen(ymin,ymax,uitnaam,ls1,ls2,ls3,ls4);
    end;
  end else laatdyntabzien(lok);
end;


procedure TGloboutvararpop.laatzien;
begin
  uitnaam:=naam;
  tabtotbool:=true;
  if dif then laatpopdifzien else laatpoppyrzien;
end;


constructor TDisoutvar.create(vn:string;kl:Tlistbox;tl:Tlist;dtl:Tlist;srt:Tdisuitvars;df:boolean);
begin
  inherited create(vn,kl,tl);
  ziektenlijst:=dtl;
  dif:=df;
  soort:=srt;
end;

procedure TDisoutvar.laatzien;
begin
  inherited laatzien;
  disind:=kiesform.curdiskiezen(ziektenlijst);
  if disind>-1 then
  begin
    disnaam:=Tgenentity(ziektenlijst.items[disind]).Name;
  {  lookback:=Tgenentity(ziektenlijst.items[disind]).lookback;}
    case soort of
      invr:uitvar:=Tipm(ziektenlijst.items[disind]).ozInci;
      prevr:uitvar:=Tipm(ziektenlijst.items[disind]).ozprev;
      cfatvr:uitvar:=Tipm(ziektenlijst.items[disind]).ozcfat;
      remivr:uitvar:=Thazard3(ziektenlijst.items[disind]).ozremi;
      morvr:uitvar:=Tdisease(ziektenlijst.items[disind]).ozmort;
      dalvr:uitvar:=Tipm(ziektenlijst.items[disind]).ozyld;
      cosvr:uitvar:=Tipm(ziektenlijst.items[disind]).ozcost;
      pifvr:uitvar:=Tgenentity(ziektenlijst.items[disind]).pzlist;
    end;
  end;  
end;


procedure TDisTotoutvar.laatzien;
begin
  inherited laatzien;
  tabtotbool:=true;
  uitnaam:=naam+', '+disnaam;
  laatstatlijnzien;
end;

procedure TDisTotoutvarcost.laatzien;
begin
  inherited laatzien;
  tabtotbool:=true;
  uitnaam:=naam+', '+disnaam+' '+hdnumstancost[false];
  laatstatlijnzien;
end;

procedure TDisoutvarar.laatzien;
begin
  inherited laatzien;
  uitnaam:=naam+', '+disnaam+' '+hdnumstan[ratebool];
  laatdynlijnzien;
end;

procedure TDisoutvararcost.laatzien;
begin
  inherited laatzien;
  uitnaam:=naam+', '+disnaam+' '+hdnumstancost[ratebool];
  laatdynlijnzien;
end;

procedure TDisoutvararpif.zettitels;
begin
  LS1:='Men, TIF';
  LS2:='Men, PIF';
  LS3:='Women, TIF';
  LS4:='Women, PIF';
end;


procedure TDisoutvararpif.laatzien;
begin
  inherited laatzien;
  tabtotbool:=false;
  ratebool:=true;
  uitnaam:=naam+', '+disnaam;
  laatdynlijnzien;
end;

constructor TRfoutvar.create(vn:string;kl:Tlistbox;tl:Tlist;rftl:Tlist;df:boolean);
begin
  inherited create(vn,kl,tl);
  risfaclijst:=rftl;
  dif:=df;
end;

procedure TRfoutvar.laatzien;
var
  distbool:boolean;

begin
  rfind:=kiesform.currfkiezen;
  if rfind>-1 then
  begin
    distbool:=Tgenentity(currflist.Items[rfind]) is Tconrf;
    rfnaam:=Tgenentity(currflist.Items[rfind]).name;
    lookback:=Tgenentity(currflist.Items[rfind]).lookback;
    if distbool then
    begin
      uitvar:=Tconrf(currflist.Items[rfind]).expouit;
      Tgenuitconrf(uitvar).rfnum:=rfind;
      Tgenuitconrf(uitvar).agnum:=kiesform.rflftkiezen(Tconrf(currflist.Items[rfind]).getagegroups);
      if Tgenuitconrf(uitvar).agnum>-1 then
      begin
        uitnaam:=naam+', '+rfnaam+', '+Tconrf(currflist.Items[rfind]).getagegroups[Tgenuitconrf(uitvar).agnum];
{        lx:=Tconrf(currflist.Items[rfind]).dist[ref,men,Tgenuitconrf(uitvar).agnum].lx;
        step:=Tconrf(currflist.Items[rfind]).dist[ref,men,Tgenuitconrf(uitvar).agnum].step;}
        laatconrfzien(rfind);
      end;  
    end else
    begin
      uitvar:=Tcatrf(currflist.Items[rfind]).expouit;
      deci:=2;
      uitnaam:=naam+', '+rfnaam;
      tabtotbool:=false;
      ratebool:=true;
      laatdynlijnzien;
    end;
  end;  
end;



procedure Toutvar.clear;
begin
end;

destructor Toutvar.destroy;
begin
  clear;
  inherited destroy;
end;


end.
