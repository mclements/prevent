unit INITIAL;

{$MODE Delphi}

interface

uses classes,sysutils;

const
  disaggmaxmax=110;
  aggmaxmax=disaggmaxmax div 5;
  disaggmaxmax1=disaggmaxmax+1;
  hdnumstan:array[boolean] of string[16]=(' (numbers)',' (rates*100,000)');


Type
  Tsex=(men,fem);
  Tscen=(ref,intv);
  Texpose=(cur,ex,non);
  Tdistpar=0..2;
  Tcurex=cur..ex;
  Tnon=non..non;
  Tar20=array[Tsex,0..aggmaxmax] of double;
  Tar95=array[Tsex,0..disaggmaxmax] of double;
  Tpidrbase=array[Tsex,-1..disaggmaxmax] of double;
  Tar951=array[Tsex,0..disaggmaxmax1] of double;
  Tscenar20=array[tscen] of Tar20;
  Tscenar95=array[tscen] of Tar95;
  Tpidr=array[tscen] of Tpidrbase;
  Texpar95=array[texpose,Tsex] of array of double;

  Trfprevabase=array[Tscen,Texpose,Tsex] of array of double;
  TRelRis=array[tsex] of array of double;

  Tdatavar=array of array[Tsex,Tscen] of array of double;
          {tijd,sex,scen,age}
  Trfdatavar=array of array[Tscen,Tsex,Tdistpar] of array of double;
          {tijd,scen,sex,parameters,age, met age in 1 of 5 jaars klassen}
  Tcatdatavar=array of array[Tsex,Tscen] of array of array of double;
          {tijd,sex,scen,category,age}
  Tcatar95=array of array[Tsex,0..disaggmaxmax] of double;
            {category, sex, age}
  Tcatarinit=array of array[Tsex] of double;
            {category, sex}

  {parameter arrays for continuous distributions}
  Tdisparams=array of double;
  Ttdisparams=array of Tdisparams;
  Tcatar=array[Tsex] of array of Tdisparams;
                {sex, agegroup, parametervalues}
const
  sexnaam:array[Tsex] of string[7]=('Males','Females');

Type

  Tdistribution=class
    distname:string;
{    lx,hx,step:double;           }
    paramnum:integer;
    lage,hage:integer;
    oriparams,thminparams:Tdisparams; //defined in initial
    curparams:Ttdisparams;
    disparamnames:array of string;
    function calc(x:double;dp:Tdisparams):double; virtual; abstract;
    procedure zetlxhx(dp:Tdisparams;var llx,lhx,lx,hx:double); virtual; abstract;
    procedure paspiftoe(depif:double;dp:Tdisparams); virtual; abstract;
    constructor create(n:string);
    destructor destroy; override;
  end;

  Tcondists=array[Tscen,Tsex] of array of Tdistribution;


  Texpocat=class
    name:string;
    prevs:tar20;
    constructor create(n:string);
  end;


  Ttota=class
    totaal:array[Tsex] of double;
    constructor create;
  end;

  Tscentota=class
    scentotaal:array[Tscen,Tsex] of double;
    constructor create;
  end;

  Tscenbevol=class
    scenbevol:Tscenar20;
    constructor create;
  end;

  Tbevol=class
    bevolking:Tar20;
  end;

  Teenage=class
    age1:tar95;
    lowage:array[tsex] of integer;
  end;

  Tvijfage=class
    age5:tar20;
    lowage:array[tsex] of integer;
  end;


  Tcurexrec=class
    prevs:array[Tcurex] of Tscenar20;
  end;

 Tbestandtype=class
   naam,pad:string;
   constructor create(n,p:string);
 end;

  Ttrend=class
    perjaar:integer;
    trendar:Tscenar20;
    constructor create(jaar:integer);
  end;

function age2str(ag:integer):string;


const
  hd=100000;


var
  bestandenlist:Tlist;
  tablelist,dynchartlist,statchartlist:Tlist;
  currentdataset,currentpad,dbtemplatepad:string;
  restagg,aggmax,disaggmax1,disaggmax,beginjaar,et:integer;
  hdnumstancost:array[boolean] of shortstring;
  globdeeldoor:integer;  //voor de populatieplaatjes
  readpopproj,incionlybool:boolean;
  projmax:integer;

{----------------------------------------------------------------------}
implementation

uses {WINGLOB,Teengine} tagraph,taseries
     {Grafuit1,dynlijns,Tabeluit,BEVOLUN,math};

constructor Tdistribution.create(n:string);
begin
  inherited create;
  distname:=n;
end;

destructor Tdistribution.destroy;
begin
  oriparams:=nil;
  thminparams:=nil;
  disparamnames:=nil;
  inherited destroy;
end;



function age2str(ag:integer):string;
begin
  if ag=aggmax then result:=inttostr(ag*5)+'+'
  else result:=inttostr(ag*5)+'-'+inttostr(ag*5+4);
end;


constructor Ttrend.create(jaar:integer);

var sex:tsex;
    scen:Tscen;
    ag:integer;

begin
  inherited create;
  perjaar:=jaar;
  for scen:=ref to intv do
   for sex:=men to fem do
    for ag:=0 to aggmax do
      trendar[scen,sex,ag]:=1.0;
end;

constructor Ttota.create;

var sex:tsex;

begin
  inherited create;
  for sex:=men to fem do totaal[sex]:=0.0;
end;


constructor Tscentota.create;

var sex:tsex;
    scen:Tscen;

begin
  inherited create;
  for scen:=ref to intv do
   for sex:=men to fem do scentotaal[scen,sex]:=0.0;
end;


constructor Tscenbevol.create;

begin
  inherited create;
end;


constructor Texpocat.create(n:string);
begin
  inherited create;
  name:=n;
end;


Constructor Tbestandtype.create(n,p:string);
begin
  inherited create;
  naam:=n;
  pad:=p;
end;


end.
