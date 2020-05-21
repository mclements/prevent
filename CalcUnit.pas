unit CalcUnit;

interface
uses disunit;
Type

  Tnar=array of Double;

  Tpolinomint=class
    n:integer;
    dy:Double;
    xa,ya:Tnar;
    ns:integer;
    den,dif,dift,ho,hp,w:Double;
    c,d:Tnar;

    procedure polint(x:Double;var y:Double);
    constructor Create(numdim:integer);
    destructor destroy; override;
  end;




const

  defsimplex=0.05;
  defitmax=1000;
  defftol=1.0E-9;
  defalpha=1.0;
  defbeta=0.5;
  defgamma=2.0;

type
  Tndimvec=array of double;

  Tamoeba=class
    ftol:Double;
    itmax:integer;
    alpha,beta,gamma,simplex:Double;
    ndim,ndimp1:integer;
    iter,ilo,ihi,inhi:integer;
    ypr,yprr,rtol:double;
    done,reached:boolean;
    uitvec,inivec,pr,prr,pbar:Tndimvec;
    vecnaam:array of string;
    y:array of Double;
    p:array of Tndimvec;

    function haalstraf(ndimvec:Tndimvec):Double; virtual; abstract;
    procedure minmaxy;
    procedure face;
    procedure extralpha;
    procedure extragamma;
    procedure secondbest;
    procedure middling;
    function amrun(init:Tndimvec):Tndimvec;

    constructor Create(numdim:integer);
    destructor destroy; override;
  end;

  Tamoeba1=class(Tamoeba)
    function haalstraf(ndimvec:Tndimvec):Double; override;
  end;

const
  jmax=20;
  jmaxp=jmax+1;

type

  Tromberg=class
    lokrfdis:Trfdiscon;
    eps,dss:double;
    jvar,kvar,kmvar:integer;
    har,sar:array[1..jmaxp] of double;
    polinomint:Tpolinomint;
    function defunctie(x:double):double; virtual;
    function qromb(const A, B:double):double;
    procedure trapzd(const A, B:double; var surf:double;num:integer);
    constructor Create;
    destructor destroy; override;
  end;

  Ttheominromberg=class(Tromberg)
    function defunctie(x:double):double; override;
  end;


var
  romberg:Tromberg;
  amoeba:Tamoeba1;
  theominromberg:Ttheominromberg;
  
function gammaln(xx:double):double;


implementation

uses sysutils,math, Dialogs;

{---------------------------Gamma functie------------------}

function gammaln(xx:double):double;
{From Numerical Recipes, an implementation of the Lanczos approximation}
const
  cof:array[0..5] of double=(76.18009172947146,-86.50532032941677,
          24.01409824083091,-1.231739572450155,0.1208650973866179E-2,
          -0.5395239384953E-5);
  stp=2.5066282746310005;

var
  j:integer;
  ser,tmp,x,y:double;

begin
  x:=xx;
  y:=x;
  tmp:=x+5.5;
  tmp:=(x+0.5)*ln(tmp)-tmp;
  ser:=1.000000000190015;
  for j:=0 to 5 do
  begin
    y:=y+1.0;
    ser:=ser+cof[j]/y;
  end;
  gammaln:=tmp+ln(stp*ser/x);
end;


{---------------------------Romberg integration------------------}


constructor Tromberg.Create;
begin
  inherited create;
  kvar:=5;
  kmvar:=kvar-1;
  eps:=1.0e-6;
  polinomint:=Tpolinomint.Create(jmax);
end;

procedure Tromberg.trapzd(const A, B:double; var surf:double;num:integer);
var
  jvar,it:integer;
  del,sum,tnm,xxx:double;
begin
  if num=1 then surf:=0.5*(b-a)*(defunctie(a)+defunctie(b))
  else
  begin
    it:=round(intpower(2,num-2));
    tnm:=it;
    del:=(b-a)/tnm;
    xxx:=a+0.5*del;
    sum:=0.0;
    for jvar:=1 to it do
    begin
      sum:=sum+defunctie(xxx);
      xxx:=xxx+del;
    end;
    surf:=0.5*(surf+(b-a)*sum/tnm);
  end;
end;

function Tromberg.qromb(const A, B:double):double;
var
  klaar:boolean;
  lnum:integer;
  ss:double;
begin
  jvar:=1;
  har[1]:=1.0;
  klaar:=false;
  while not klaar do
  begin
    trapzd(A, B,sar[jvar],jvar);
    if jvar>=kvar then
    with polinomint do
    begin
      for lnum:=0 to kvar-1 do
      begin
        xa[lnum]:=har[jvar-kmvar+lnum];
        ya[lnum]:=sar[jvar-kmvar+lnum];
      end;
      n:=kvar;
      polint(0.0,ss);
      klaar:=(jvar=jmax) or (abs(dy)<=(abs(ss)*eps));
    end;
    sar[jvar+1]:=sar[jvar];
    har[jvar+1]:=0.25*har[jvar];
    inc(jvar);
  end;
  result:=ss;
end;

function Tromberg.defunctie(x:double):double;
begin
  Result:=lokrfdis.intfunction(x);
end;

destructor Tromberg.destroy;
begin
  polinomint.Free;
  inherited destroy;
end;

function Ttheominromberg.defunctie(x:double):double;
begin
  Result:=lokrfdis.theminfunction(x);
end;



constructor Tpolinomint.Create(numdim:integer);
begin
  inherited Create;
  n:=numdim;
  setlength(xa,numdim);
  setlength(ya,numdim);
  setlength(c,numdim);
  setlength(d,numdim);
end;

destructor Tpolinomint.destroy;
begin
  xa:=nil;
  ya:=nil;
  c:=nil;
  d:=nil;
  inherited destroy;
end;


procedure Tpolinomint.polint(x:Double;var y:Double);

var i,m:integer;

begin
  ns:=1;
  dif:=abs(x-xa[0]);
  for i:=0 to n-1 do
  begin
    dift:=abs(x-xa[i]);
    if dift<dif then
    begin
      ns:=i+1;
      dif:=dift;
    end;
    c[i]:=ya[i];
    d[i]:=ya[i];
  end;
  y:=ya[ns-1];
  Dec(ns);
  for m:=1 to n-1 do
  begin
    for i:=1 to n-m do
    begin
      ho:=xa[i-1]-x;
      hp:=xa[i+m-1]-x;
      w:=c[i]-d[i-1];
      den:=w/(ho-hp);
      d[i-1]:=hp*den;
      c[i-1]:=ho*den;
    end;
    if (2*ns<(n-m)) then dy:=c[ns]
    else
    begin
      dy:=d[ns-1];
      Dec(ns);
    end;
    y:=y+dy;
  end;
end;




{---------------------------Amoebe------------------}

constructor Tamoeba.Create(numdim:integer);
begin
  inherited Create;
  ftol:=defftol;
  itmax:=defitmax;
  simplex:=defsimplex;
  alpha:=defalpha;
  beta:=defbeta;
  gamma:=defgamma;
  reached:=False;
  ndim:=numdim-1;
  ndimp1:=numdim;
  setlength(uitvec,numdim);
  setlength(inivec,numdim);
  setlength(pr,numdim);
  setlength(prr,numdim);
  setlength(pbar,numdim);
  setlength(vecnaam,numdim);
  setlength(y,numdim+1);
  setlength(p,numdim+1,numdim);
end;

destructor Tamoeba.destroy;
begin
  uitvec:=nil;
  inivec:=nil;
  pr:=nil;
  prr:=nil;
  pbar:=nil;
  vecnaam:=nil;
  y:=nil;
  p:=nil;
  inherited destroy;
end;


procedure Tamoeba.minmaxy;

var iind:integer;

begin
  ilo:=0;
  if y[0]>y[1] then
  begin
    ihi:=0;
    inhi:=1;
  end else
  begin
    ihi:=1;
    inhi:=0;
  end;
  for iind:=0 to ndimp1 do
  begin
    if y[iind]<y[ilo] then ilo:=iind;
    if y[iind]>y[ihi] then
    begin
      inhi:=ihi;
      ihi:=iind;
    end else
    if y[iind]>y[inhi] then if iind<>ihi then inhi:=iind;
  end;
  if (y[ihi]+y[ilo]>0) then
     rtol:=2.0*abs(y[ihi]-y[ilo])/(abs(y[ihi])+abs(y[ilo]))
     else rtol:=ftol/2.0;
  if rtol<ftol then
  begin
    done:=true;
    for iind:=0 to ndim do uitvec[iind]:=p[ilo,iind];
  end;
end;

procedure Tamoeba.face;

var iind,jind:integer;

begin
  for iind:=0 to ndim do pbar[iind]:=0.0;
  for iind:=0 to ndimp1 do
    if iind<>ihi then
      for jind:=0 to ndim do pbar[jind]:=pbar[jind]+p[iind,jind];
end;

procedure Tamoeba.extralpha;

var jind:integer;

begin
  for jind:=0 to ndim do
  begin
    pbar[jind]:=pbar[jind]/(ndim+1);
    pr[jind]:=(1.0+alpha)*pbar[jind]-alpha*p[ihi,jind];
  end;
end;

procedure Tamoeba.extragamma;

var jind:integer;

begin
  for jind:=0 to ndim do prr[jind]:=gamma*pr[jind]+(1.0-gamma)*pbar[jind];
  yprr:=haalstraf(prr);
  if yprr<y[ilo] then
  begin
    for jind:=0 to ndim do p[ihi,jind]:=prr[jind];
    y[ihi]:=yprr;
  end else
  begin
    for jind:=0 to ndim do p[ihi,jind]:=pr[jind];
    y[ihi]:=ypr;
  end;
end;

procedure Tamoeba.secondbest;

var iind,jind:integer;

begin
  if ypr<y[ihi] then
  begin
    for jind:=0 to ndim do p[ihi,jind]:=pr[jind];
    y[ihi]:=ypr;
  end;
  for jind:=0 to ndim do prr[jind]:=beta*p[ihi,jind]+(1.0-beta)*pbar[jind];
  yprr:=haalstraf(prr);
  if yprr<y[ihi] then
  begin
    for jind:=0 to ndim do p[ihi,jind]:=prr[jind];
    y[ihi]:=yprr;
  end else
  begin
    for iind:=0 to ndimp1 do
     if iind<>ilo then
     begin
       for jind:=0 to ndim do
       begin
         pr[jind]:=0.5*(p[iind,jind]+p[ilo,jind]);
         p[iind,jind]:=pr[jind];
       end;
       y[iind]:=haalstraf(pr);
     end;
  end;
end;


procedure Tamoeba.middling;

var jind:integer;

begin
  for jind:=0 to ndim do p[ihi,jind]:=pr[jind];
  y[ihi]:=ypr;
end;


function Tamoeba.amrun(init:Tndimvec):Tndimvec;

var jind,iind:integer;

begin
  iter:=0;
  done:=false;
  inivec:=init;

  for iind:=0 to ndimp1 do
   for jind:=0 to ndim do
      if iind=jind then
      begin
        if inivec[jind]<>0.0 then p[iind,jind]:=inivec[jind]*simplex
        else p[iind,jind]:=0.1;
      end else p[iind,jind]:=inivec[jind];
  for iind:=0 to ndimp1 do
  begin
    y[iind]:=haalstraf(p[iind]);
  end;
  try
    while not done do
    begin
      inc(iter);
      minmaxy;
      face;
      extralpha;
      ypr:=haalstraf(pr);
      if ypr<=y[ilo] then extragamma
         else if ypr>=y[inhi] then secondbest
              else middling;
      if iter=itmax then
      begin
        done:=true;
        reached:=True;
        for iind:=0 to ndim do uitvec[iind]:=p[ilo,iind];
      end;
    end;
  except
    on Ematherror do
    begin
      for iind:=0 to ndim do uitvec[iind]:=p[ilo,iind];
      MessageDlg('Internal error: downhill simplex method', mtError, [mbOK], 0);
    end;
  end;
  result:=uitvec;
end;

function Tamoeba1.haalstraf(ndimvec:Tndimvec):Double;
begin
{  Result:=mainform.straffunctie(ndimvec);}
end;


end.
