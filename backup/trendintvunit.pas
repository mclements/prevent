unit trendintvunit;

{$MODE Delphi}

interface
uses classes,INITIAL;

Type
  Tvarel=record
    jaar,lage,hage:integer;
    mfwaarde:array[tsex] of double;
  end;

  Tcatvarel=record
    jaar,lage,hage:integer;
    mfwaarde:array of array[tsex] of double;
  end;

  Tconvarel=record
    jaar,lage,hage:integer;
    mfwaarde:array[tsex] of Tdisparams;
  end;

  PVarel=^Tvarel;
  PCatVarel=^Tcatvarel;
  PConVarel=^Tconvarel;

  Tmvarbase=class
    tablenaam:string;
    nummers:boolean;
    procedure leesvarels(selectstring:string); virtual; abstract;
    procedure maakjaar(tt:integer); virtual; abstract;
    constructor create(tn:string;numrs:boolean);
    destructor destroy; override;
  end;

  Tcatmvardata=class(Tmvarbase)
    oneydata:Tcatar95;
    catno:integer;
    varelrij:array of PCatvarel;
    procedure zetcatno(cn:integer); virtual;
    procedure leesvarels(selectstring:string); override;
    procedure leesvarelscat(selectstring:string;cn:integer); virtual;
    procedure maakjaar(tt:integer); override;
    constructor create(tn:string;numrs:boolean);
    destructor destroy; override;
  end;

  Tcatcohortmvardata=class(Tcatmvardata)
    oneydata:Tcatarinit;
    procedure zetcatno(cn:integer); override;    
    procedure leesvarels(selectstring:string); override;
    procedure leesvarelscat(selectstring:string;cn:integer); override;
    procedure maakjaar(tt:integer); override;
  end;

  Tcatintervens=class(Tcatmvardata)
    RRintervens:boolean;
    procedure leesvarelscat(selectstring:string;cn:integer); override;
  end;



  Tconmvardata=class(Tmvarbase)
    oneydata:Tcatar;
    parno:integer;
    interventionname:string;
    distris:Tcondists;
    varelrij:array of PConvarel;
    procedure zetparno(dist:Tcondists);
    procedure leesvarels(selectstring:string); override;
    procedure maakjaar(tt:integer); override;
    constructor create(tn:string;numrs:boolean);
    destructor destroy; override;
  end;


  Tmvardata=class(Tmvarbase)
    oneydata:Tar95;
    varelrij:array of Pvarel;
    procedure leesvarels(selectstring:string); override;
    procedure maakjaar(tt:integer); override;
    constructor create(tn:string;numrs:boolean);
    destructor destroy; override;
  end;

  Tbirthvardata=class(Tmvardata)
    oneydatat0:Tar95;
    procedure maakjaar(tt:integer); override;
  end;

  TCosTvardata=class(Tbirthvardata)
    procedure maakjaar(tt:integer); override;
  end;

  Tvardist=record
    jaar,lage,hage:integer;
    distri:string;
    mfwaarde:array[tsex,0..1,0..2] of double;
  end;

  PVardist=^Tvardist;

  Tmvarddist=class(Tmvarbase)
    oneydata:Tcatar;
    varelrij:array of Pvardist;
    agnum:integer;
    procedure leesvarels(selectstring:string); override;
    procedure zetoneydata;
    procedure maakjaar(tt:integer); override;
    constructor create(tn:string;numrs:boolean);
    destructor destroy; override;
  end;

  Tvarfunc=record
    jaar,lage,hage:integer;
    funct,disvar:string;
    mfwaarde:array[tsex,0..2] of double;
  end;

  PVarfunc=^Tvarfunc;

  Tmvarfunc=class(Tmvarbase)
    varelrij:array of Pvarfunc;
    agnum:integer;
    procedure leesvarels(selectstring:string); override;
    procedure maakjaar(tt:integer); override;
    constructor create(tn:string;numrs:boolean);
    destructor destroy; override;
  end;



implementation

Uses
  DATASET,datmod1,sysutils;


constructor Tmvarbase.create(tn:string;numrs:boolean);
begin
  inherited create;
  tablenaam:=tn;
  nummers:=numrs;
end;

destructor Tmvarbase.destroy;
begin
  inherited destroy;
end;

constructor Tcatmvardata.create(tn:string;numrs:boolean);
begin
  inherited create(tn,numrs);
end;

procedure Tcatmvardata.zetcatno(cn:integer);
begin
  catno:=cn;
  setlength(oneydata,cn);
end;

procedure Tcatmvardata.leesvarels(selectstring:string);
var
  num:integer;
begin
  with datasetform do
  begin
    putquery1(selectstring);
    with datamodule2.inputQ1 do
    begin
      setlength(varelrij,recordcount);
      first;
      for num:=0 to recordcount-1 do
      begin
        new(varelrij[num]);
        setlength(varelrij[num]^.mfwaarde,catno);
        varelrij[num]^.jaar:=fieldbyname('time').asinteger;
        varelrij[num]^.lage:=fieldbyname('lage').asinteger;
        varelrij[num]^.hage:=fieldbyname('hage').asinteger;
        varelrij[num]^.mfwaarde[0,men]:=fieldbyname('Males').asfloat;
        varelrij[num]^.mfwaarde[0,fem]:=fieldbyname('Females').asfloat;
        Next;
      end;
      close;
    end;
    datamodule2.SQLTransaction1.Commit;
  end;{with datasetform}
end;

procedure Tcatmvardata.leesvarelscat(selectstring:string;cn:integer);
var
  num:integer;
  nn:boolean;
begin
  with datasetform do
  begin
    putquery1(selectstring);
    with datamodule2.inputQ1 do
    begin
      if length(varelrij)=0 then
      begin
        setlength(varelrij,recordcount);
        nn:=true;
      end else nn:=false;
      first;
      for num:=0 to recordcount-1 do
      begin
        if nn then
        begin
          new(varelrij[num]);
          setlength(varelrij[num]^.mfwaarde,catno);
          varelrij[num]^.jaar:=fieldbyname('time').asinteger;
          varelrij[num]^.lage:=fieldbyname('lage').asinteger;
          varelrij[num]^.hage:=fieldbyname('hage').asinteger;
        end;
        varelrij[num]^.mfwaarde[cn,men]:=fieldbyname('Males').asfloat;
        varelrij[num]^.mfwaarde[cn,fem]:=fieldbyname('Females').asfloat;
        Next;
      end;
      close;
    end;
    datamodule2.SQLTransaction1.Commit;
  end;{with datasetform}
end;


procedure Tcatmvardata.maakjaar(tt:integer);
var
  num,ag,dd,cn:integer;
  sex:Tsex;
begin
  for num:=0 to length(varelrij)-1 do
  if varelrij[num]^.jaar=tt then
    for ag:=varelrij[num]^.lage to varelrij[num]^.hage-1 do
    begin
      if nummers then dd:=varelrij[num]^.hage-varelrij[num]^.lage
         else dd:=1;
      for sex:=men to fem do
       for cn:=0 to catno-1 do
       oneydata[cn,sex,ag]:=varelrij[num]^.mfwaarde[cn,sex]/dd;
    end;
end;

destructor Tcatmvardata.destroy;
var
  num:integer;
begin
  for num:=0 to length(varelrij)-1 do
  begin
    varelrij[num]^.mfwaarde:=nil;
    dispose(varelrij[num]);
  end;
  varelrij:=nil;
  oneydata:=nil;
  inherited destroy;
end;

procedure Tcatcohortmvardata.zetcatno(cn:integer);
begin
  catno:=cn;
  setlength(oneydata,cn);
end;

procedure Tcatcohortmvardata.leesvarels(selectstring:string);
var
  num:integer;
begin
  with datasetform do
  begin
    putquery1(selectstring);
    with datamodule2.inputQ1 do
    begin
      setlength(varelrij,recordcount);
      first;
      for num:=0 to recordcount-1 do
      begin
        new(varelrij[num]);
        setlength(varelrij[num]^.mfwaarde,catno);
        varelrij[num]^.jaar:=fieldbyname('time').asinteger;
        varelrij[num]^.lage:=fieldbyname('age').asinteger;
        varelrij[num]^.mfwaarde[0,men]:=fieldbyname('Males').asfloat;
        varelrij[num]^.mfwaarde[0,fem]:=fieldbyname('Females').asfloat;
        Next;
      end;
      close;
    end;
    datamodule2.SQLTransaction1.Commit;
  end;{with datasetform}
end;


procedure Tcatcohortmvardata.leesvarelscat(selectstring:string;cn:integer);
var
  num:integer;
  nn:boolean;
begin
  with datasetform do
  begin
    putquery1(selectstring);
    with datamodule2.inputQ1 do
    begin
      if length(varelrij)=0 then
      begin
        setlength(varelrij,recordcount);
        nn:=true;
      end else nn:=false;
      first;
      for num:=0 to recordcount-1 do
      begin
        if nn then
        begin
          new(varelrij[num]);
          setlength(varelrij[num]^.mfwaarde,catno);
          varelrij[num]^.jaar:=fieldbyname('time').asinteger;
        end;
        varelrij[num]^.mfwaarde[cn,men]:=fieldbyname('Males').asfloat;
        varelrij[num]^.mfwaarde[cn,fem]:=fieldbyname('Females').asfloat;
        Next;
      end;
      close;
    end;
    datamodule2.SQLTransaction1.Commit;
  end;{with datasetform}
end;


procedure Tcatcohortmvardata.maakjaar(tt:integer);
var
  num,cn:integer;
  sex:Tsex;
begin
  for num:=0 to length(varelrij)-1 do
  if varelrij[num]^.jaar=tt then
    for sex:=men to fem do
      for cn:=0 to catno-1 do
       oneydata[cn,sex]:=varelrij[num]^.mfwaarde[cn,sex];
end;

procedure Tcatintervens.leesvarelscat(selectstring:string;cn:integer);
var
  tmpstr:string;
begin
  inherited leesvarelscat(selectstring,cn);
  with datamodule2.inputQ1 do
  begin
    first;
    tmpstr:=fieldbyname('Param').asstring;
    RRintervens:=tmpstr='Relativerisk';
  end;  
end;


procedure Tconmvardata.zetparno(dist:Tcondists);
var
  sex:Tsex;
  ag:integer;
begin
  distris:=dist;
  for sex:=men to fem do
  begin
    setlength(oneydata[sex],length(dist[intv,sex]));
    for ag:=0 to length(dist[intv,sex])-1 do
      setlength(oneydata[sex,ag],distris[intv,sex,ag].paramnum);
  end;
  parno:=distris[intv,men,0].paramnum;
end;

procedure Tconmvardata.leesvarels(selectstring:string);
var
  num,par:integer;
  sex:Tsex;
begin
  with datasetform do
  begin
    putquery1(selectstring);
    with datamodule2.inputQ1 do
    begin
      setlength(varelrij,recordcount);
      first;
      for num:=0 to recordcount-1 do
      begin
        new(varelrij[num]);
        for sex:=men to fem do setlength(varelrij[num]^.mfwaarde[sex],parno);
        varelrij[num]^.jaar:=fieldbyname('time').asinteger;
        varelrij[num]^.lage:=fieldbyname('lage').asinteger;
        varelrij[num]^.hage:=fieldbyname('hage').asinteger;
        for par:=0 to parno-1 do
        begin
          varelrij[num]^.mfwaarde[men,par]:=fieldbyname('Mpar'+inttostr(par+1)).asfloat;
          varelrij[num]^.mfwaarde[fem,par]:=fieldbyname('Fpar'+inttostr(par+1)).asfloat;
        end;
        Next;
      end;
      close;
    end;
    datamodule2.SQLTransaction1.Commit;
  end;{with}
end;

procedure Tconmvardata.maakjaar(tt:integer);
var
  num,pnum,ag:integer;
  sex:Tsex;
begin
  ag:=0;
  for num:=0 to length(varelrij)-1 do
  if varelrij[num]^.jaar=tt then
  begin
    for sex:=men to fem do
     for pnum:=0 to length(oneydata[sex,ag])-1 do
       oneydata[sex,ag,pnum]:=varelrij[num]^.mfwaarde[sex,pnum];
    inc(ag);   
  end;
end;

constructor Tconmvardata.create(tn:string;numrs:boolean);
begin
  inherited create(tn,numrs);
end;

destructor Tconmvardata.destroy;
var
  num:integer;
  sex:Tsex;
begin
  for num:=0 to length(varelrij)-1 do
  begin
    for sex:=men to fem do varelrij[num]^.mfwaarde[sex]:=nil;
    dispose(varelrij[num]);
  end;
  varelrij:=nil;
  for sex:=men to fem do
  begin
    for num:=0 to length(oneydata[sex])-1 do
      oneydata[sex,num]:=nil;
    oneydata[sex]:=nil;
  end;
  inherited destroy;
end;

constructor Tmvardata.create(tn:string;numrs:boolean);
begin
  inherited create(tn,numrs);
end;


procedure Tmvardata.leesvarels(selectstring:string);
var
  num:integer;
begin
  with datasetform do
  begin
    putquery1(selectstring);
    with datamodule2.inputQ1 do
    begin
      setlength(varelrij,recordcount);
      first;
      for num:=0 to recordcount-1 do
      begin
        new(varelrij[num]);
        varelrij[num]^.jaar:=fieldbyname('time').asinteger;
        varelrij[num]^.lage:=fieldbyname('lage').asinteger;
        varelrij[num]^.hage:=fieldbyname('hage').asinteger;
        varelrij[num]^.mfwaarde[men]:=fieldbyname('Males').asfloat;
        varelrij[num]^.mfwaarde[fem]:=fieldbyname('Females').asfloat;
        Next;
      end;
      Close;
    end;
    datamodule2.SQLTransaction1.Commit;
  end;{with datasetform}
end;

procedure Tmvardata.maakjaar(tt:integer);
var
  num,ag,dd:integer;
  sex:Tsex;
begin
  for num:=0 to length(varelrij)-1 do
  if varelrij[num]^.jaar=tt then
    for ag:=varelrij[num]^.lage to varelrij[num]^.hage-1 do
    begin
      if nummers then dd:=varelrij[num]^.hage-varelrij[num]^.lage
         else dd:=1;
      for sex:=men to fem do
       oneydata[sex,ag]:=varelrij[num]^.mfwaarde[sex]/dd;
    end;
end;

procedure TBirthvardata.maakjaar(tt:integer);
begin
  inherited maakjaar(tt);
  if tt=0 then oneydatat0:=oneydata;
end;

procedure TCosTvardata.maakjaar(tt:integer);
begin
  inherited maakjaar(tt);
end;


destructor Tmvardata.destroy;
var
  num:integer;
begin
  for num:=0 to length(varelrij)-1 do dispose(varelrij[num]);
  varelrij:=nil;
  inherited destroy;
end;

constructor Tmvarddist.create(tn:string;numrs:boolean);
begin
  inherited create(tn,numrs);
end;

procedure Tmvarddist.leesvarels(selectstring:string);
var
  num,tt:integer;
begin
  with datasetform do
  begin
    putquery1(selectstring);
    with datamodule2.inputQ1 do
    begin
      setlength(varelrij,recordcount);
      first;
      agnum:=0;
      tt:=fieldbyname('time').asinteger;
      for num:=0 to recordcount-1 do
      begin
        new(varelrij[num]);
        varelrij[num]^.jaar:=fieldbyname('time').asinteger;
        varelrij[num]^.lage:=fieldbyname('lage').asinteger;
        varelrij[num]^.hage:=fieldbyname('hage').asinteger;
        varelrij[num]^.distri:=fieldbyname('distribution').asstring;
        varelrij[num]^.mfwaarde[men,0,0]:=fieldbyname('MPar1').asfloat;
        varelrij[num]^.mfwaarde[men,0,1]:=fieldbyname('MPar2').asfloat;
        varelrij[num]^.mfwaarde[men,0,2]:=fieldbyname('MPar3').asfloat;
        varelrij[num]^.mfwaarde[men,1,0]:=fieldbyname('MParmin1').asfloat;
        varelrij[num]^.mfwaarde[men,1,1]:=fieldbyname('MParmin2').asfloat;
        varelrij[num]^.mfwaarde[men,1,2]:=fieldbyname('MParmin3').asfloat;
        varelrij[num]^.mfwaarde[fem,0,0]:=fieldbyname('FPar1').asfloat;
        varelrij[num]^.mfwaarde[fem,0,1]:=fieldbyname('FPar2').asfloat;
        varelrij[num]^.mfwaarde[fem,0,2]:=fieldbyname('FPar3').asfloat;
        varelrij[num]^.mfwaarde[fem,1,0]:=fieldbyname('FParmin1').asfloat;
        varelrij[num]^.mfwaarde[fem,1,1]:=fieldbyname('FParmin2').asfloat;
        varelrij[num]^.mfwaarde[fem,1,2]:=fieldbyname('FParmin3').asfloat;
        if tt=varelrij[num]^.jaar then inc(agnum);
        Next;
      end;
    end;
    close;
  end;{with}
  datamodule2.SQLTransaction1.Commit;
end;

procedure Tmvarddist.zetoneydata;
var
  ag:integer;
  sex:Tsex;
begin
  for sex:=men to fem do
  begin
    setlength(oneydata[sex],agnum);
    for ag:=0 to agnum-1 do
      setlength(oneydata[sex,ag],3);
  end;
end;


procedure Tmvarddist.maakjaar(tt:integer);
var
  num,pnum,ag:integer;
  sex:Tsex;
begin
  ag:=0;
  for num:=0 to length(varelrij)-1 do
  if varelrij[num]^.jaar=tt then
  begin
    for sex:=men to fem do
     for pnum:=0 to length(oneydata[sex,ag])-1 do
       oneydata[sex,ag,pnum]:=varelrij[num]^.mfwaarde[sex,0,pnum];
    inc(ag);
  end;     
end;

destructor Tmvarddist.destroy;
var
  num:integer;
  sex:Tsex;
begin
  for num:=0 to length(varelrij)-1 do dispose(varelrij[num]);
  varelrij:=nil;
  for sex:=men to fem do
  begin
    for num:=0 to agnum-1 do
      oneydata[sex,num]:=nil;
    oneydata[sex]:=nil;
  end;
  inherited destroy;
end;

constructor Tmvarfunc.create(tn:string;numrs:boolean);
begin
  inherited create(tn,numrs);
end;

procedure Tmvarfunc.leesvarels(selectstring:string);
var
  num,tt:integer;
begin
  with datasetform do
  begin
    putquery1(selectstring);
    with datamodule2.inputQ1 do
    begin
      setlength(varelrij,recordcount);
      first;
      agnum:=0;
      tt:=fieldbyname('time').asinteger;
      for num:=0 to recordcount-1 do
      begin
        new(varelrij[num]);
        varelrij[num]^.jaar:=fieldbyname('time').asinteger;
        varelrij[num]^.disvar:=fieldbyname('disvar').asstring;
        varelrij[num]^.lage:=fieldbyname('lage').asinteger;
        varelrij[num]^.hage:=fieldbyname('hage').asinteger;
        varelrij[num]^.funct:=fieldbyname('Riskfunc').asstring;
        varelrij[num]^.mfwaarde[men,0]:=fieldbyname('MPar1').asfloat;
        varelrij[num]^.mfwaarde[men,1]:=fieldbyname('MPar2').asfloat;
        varelrij[num]^.mfwaarde[men,2]:=fieldbyname('MPar3').asfloat;
        varelrij[num]^.mfwaarde[fem,0]:=fieldbyname('FPar1').asfloat;
        varelrij[num]^.mfwaarde[fem,1]:=fieldbyname('FPar2').asfloat;
        varelrij[num]^.mfwaarde[fem,2]:=fieldbyname('FPar3').asfloat;
        if tt=varelrij[num]^.jaar then inc(agnum);
        Next;
      end;
    end;
    close;
  end;{with}
  datamodule2.SQLTransaction1.Commit;
end;


procedure Tmvarfunc.maakjaar(tt:integer); 
begin
end;

destructor Tmvarfunc.destroy;
var
  num:integer;
begin
  for num:=0 to length(varelrij)-1 do dispose(varelrij[num]);
  varelrij:=nil;
  inherited destroy;
end;



end.
