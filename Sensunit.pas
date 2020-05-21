unit Sensunit;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, CheckLst, Grids, DBGrids,INITIAL;

type
  TSensForm = class(TForm)
    CheckListBox1: TCheckListBox;
    BotPanel: TPanel;
    StartBut: TButton;
    CancBut: TButton;
    procedure CancButClick(Sender: TObject);
    procedure CheckListBox1Click(Sender: TObject);
    procedure StartButClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    procedure runspecif;
    procedure varspecif;
    procedure sensspecif;
    procedure outputspecif;
    procedure outputdestspecif;
    procedure SensMessage(inr1,inr2:integer);
  public
    { Public declarations }
    RRrandcor:Double;
    rangelist:Tlist;
    function uniform_01(g: INTEGER): DOUBLE;
    function gamma_exp(g: INTEGER;
                    alpha, beta: DOUBLE): DOUBLE;
  end;

  Tsensnum=class  {een enkel nummer, geen afwijking=1}
    nummer:Double;
    tekst:string;
    constructor Create(nn:integer);
  end;


  Tsensinstance=class    {een exemplaar van de reeks tests, ze gaan in senserunlist}
    nummer:integer;
    sensvars: Tlist;
    constructor Create(nn:integer);
    destructor destroy; override;
  end;


  Tsensobj=class         {een exemplaar van een test variabele, lijst: sensvars}
    titel:string;
    procedure getorig; virtual;
    procedure aanpas(nummer:double); virtual;
    constructor Create(n:string);
    destructor destroy; override;
  end;

{-----------------------------------------------------------------}
{Types voor RF disease relatie sensitiviteit}


  TRFsensdisease=class         {Analoog aan Tdisease}
    SName:string;
    Srflist:Tlist;
    constructor create(n:string);
    destructor destroy; override;
  end;

{-----------------------------------------------------------------}
{Types voor RR sensitiviteit}

  TRRsensrfdis=class             {Analoog aan Trfdis}
    Srfname:string;
    SRelRis:TRelRis;
    StdDev:Tlist;
    constructor create(n:string);
    destructor destroy; override;
  end;


  TRRsens=class(Tsensobj)    {afgeleide van Tsensobj, specifiek gemaakt voor de variabele}
                                    {bevat o.a. een datastructuur voor de uitgangswaarden}
    sensdislist:Tlist;
    procedure getorig; override;
    procedure aanpas(nummer:double); override;
    constructor Create(n:string);
    destructor destroy; override;
  end;


{---------------------------------------------------------------------}
{types for lag times}


  TLAGSsensrfdis=class             {Analoog aan Trfdis}
    Srfname:string;
    SLAG:integer;
    StdDev:Double;
    constructor create(n:string);
    destructor destroy; override;
  end;


  TLAGSsens=class(Tsensobj)    {afgeleide van Tsensobj, specifiek gemaakt voor de variabele}
    sensdislist:Tlist;              {wordt gelijk aan curdislist}
    constructor Create(n:string);
    destructor destroy; override;
  end;

  TCUMsens=class(TLAGSsens)    {afgeleide van TLAGSsens, een voor ieder van de lags}
    procedure getorig; override;
    procedure aanpas(nummer:double); override;
  end;

  TLATsens=class(TLAGSsens)    {afgeleide van TLAGSsens, een voor ieder van de lags}
    procedure getorig; override;
    procedure aanpas(nummer:double); override;
  end;

  TLAGsens=class(TLAGSsens)    {afgeleide van TLAGSsens, een voor ieder van de lags}
    procedure getorig; override;
    procedure aanpas(nummer:double); override;
  end;

{---------------------------------------------------------------------}
{types for risk factor}

  TRF1svarsens=class      {effect 1 risk factor}
    srfname:string;
    svar:Tlist;
    StdDev:Tlist;
    constructor Create(n:string);
    destructor destroy; override;
  end;






var
  SensForm: TSensForm;

implementation

{$R *.lfm}

uses math,WINGLOB, datmod1, RUNOP, parasel, Permusens,PREVMAIN,DisUnit,
  memomes, ABOUTUN, Fkies, OUTOP, DATASET;

var sensinstance:Tsensinstance;
    testuit:Text;


function TSensForm.uniform_01(g: INTEGER): DOUBLE;
begin
  uniform_01:=Random;
end;

function TSensForm.gamma_exp(g: INTEGER;
                   alpha, beta: DOUBLE): DOUBLE;
(* Author:             F. Loeve
   Last modification:  12-02-1997
   Contents:           In this procedure a number from a gamma distribution
                       with parameters alpha and beta is drawn
   References:         Law and Kelton, 1991, p. 488
   Called procedures:  ln (System)
                       power (Math)
                       uniform_01 (ranlib)
   In:
     g: Number of the RNG that will be used to generate the onset of a
     new lesion
     alpha, beta: parameters of the gamma distribution
   Out:
     gamma_exp: generated number from the gamma distribution
*)
VAR
  r: DOUBLE;
  r_1: DOUBLE;
  r_2: DOUBLE;
  a: DOUBLE;
  b: DOUBLE;
  q: DOUBLE;
  theta: DOUBLE;
  d: DOUBLE;
  V: DOUBLE;
  Z: DOUBLE;
  W: DOUBLE;
  accepted: BOOLEAN;
  P: DOUBLE;
  Y: DOUBLE;

BEGIN (* gamma_exp *)
  IF (alpha < 1) THEN
  BEGIN
     b := (exp(1)+ alpha)/exp(1);
     accepted := FALSE;
     WHILE NOT accepted DO
     BEGIN
        r := uniform_01(g);
        P := b * r;
        IF (P > 1) THEN
        BEGIN
           Y := - ln((b - P)/alpha);
           r := uniform_01(g);
           IF r <= power(Y, alpha - 1) THEN
           BEGIN
              accepted := TRUE;
              gamma_exp := beta * Y;
           END (* IF *)
        END (* IF *)
        ELSE
        BEGIN
           Y := power(P, 1/alpha);
           r := uniform_01(g);
           IF r < exp(-Y) THEN
           BEGIN
              gamma_exp := beta * Y;
              accepted := TRUE;
           END (* IF *)
        END (* ELSE *)
     END (* WHILE *)
  END (* IF *)
  else IF alpha > 1 THEN
  BEGIN
     accepted := FALSE;
     WHILE NOT accepted DO
     BEGIN
        r_1 := uniform_01(g);
        r_2 := uniform_01(g);
        a := 1/SQRT(2*alpha - 1);
        V := a * ln(r_1/(1-r_2));
        Y := alpha * exp(V);
        Z := r_1*r_1*r_2;
        b := alpha - ln(4);
        q := alpha + 1/a;
        W := b + q * V - Y;
        theta := 4.5;
        d := 1 + ln(theta);
        IF W + d - theta*Z >= 0 THEN
        BEGIN
           gamma_exp := beta * Y;
           accepted := TRUE;
        END
        ELSE
        BEGIN
           IF W >= ln(Z) THEN
           BEGIN
              gamma_exp := beta * Y;
              accepted := TRUE;
           END; (* IF *)
        END; (* ELSE *)
     END; (* WHILE *)
  END (* IF *)
  else IF alpha = 1 THEN
  (* exponential distribution with parameter beta *)
  BEGIN
     r := uniform_01(g);
     gamma_exp := - beta*ln(r);
  END; (* IF *)
END; (* gamma_exp *)


constructor Tsensnum.Create(nn:integer);
begin
  nummer:=1.0+nn/100.0;
  tekst:=IntToStr(nn)+'%';
end;

constructor Tsensinstance.Create(nn:integer);
begin
  inherited Create;
  nummer:=nn;
  sensvars:=Tlist.create;
end;


destructor Tsensinstance.destroy;

var inr:integer;

begin
  for inr:=0 to sensvars.Count-1 do TObject(sensvars.Items[inr]).Free;
  sensvars.Free;
  inherited destroy;
end;

constructor Tsensobj.Create(n:string);
begin
  inherited Create;
  titel:=n;
end;

procedure Tsensobj.aanpas(nummer:double);

begin
end;

procedure Tsensobj.getorig;

begin
end;

destructor Tsensobj.destroy;

begin
  inherited destroy;
end;

constructor TRFsensdisease.create(n:string);
begin
  inherited Create;
  SName:=n;
  Srflist:=Tlist.create;
end;


destructor TRFsensdisease.destroy;

var inr:integer;

begin
  for inr:=0 to Srflist.Count-1 do
     TObject(Srflist.Items[inr]).Free;
  Srflist.Free;
  inherited destroy;
end;

constructor TRRsensrfdis.create(n:string);
var
  sex:Tsex;
begin
  inherited Create;
  Srfname:=n;
  for sex:=men to fem do
    setlength(Srelris[sex],aggmax);
  if mainform.uncertbool then StdDev:=Tlist.Create;
end;

destructor TRRsensrfdis.destroy;

var inr:integer;
  sex:Tsex;

begin
  for sex:=men to fem do
    SRelRis[sex]:=nil;
  if mainform.uncertbool then
  begin
    for inr:=0 to StdDev.Count-1 do TObject(StdDev.Items[inr]).Free;
    StdDev.Free;
  end;
  inherited destroy;
end;

constructor TRRsens.Create(n:string);

var inr1,inr2,catinr:integer;
    RRsensdisease:TRFsensdisease;
    RRsensrfdis:TRRsensrfdis;
    expocat:Texpocat;

begin                                    {bevat o.a. een datastructuur voor de uitgangswaarden}
  inherited Create(n);
  sensdislist:=Tlist.Create;
  for inr1:=0 to curdislist.Count-1 do
  with Tdisease(curdislist.Items[inr1]) do
  begin
    RRsensdisease:=TRFsensdisease.Create(Name);
    for inr2:=0 to rflist.Count-1 do
    with Trfdis(rflist.Items[inr2]) do
    begin
      RRsensrfdis:=TRRsensrfdis.Create(rfac.name);
      RRsensdisease.Srflist.Add(RRsensrfdis);
    end;
    sensdislist.Add(RRsensdisease);
  end;{for curdislist}
  getorig;
  sensinstance.sensvars.Add(self);
end;


destructor TRRsens.destroy;

var inr1,inr2:integer;

begin
  for inr1:=0 to sensdislist.Count-1 do
    TRFsensdisease(sensdislist.Items[inr1]).free;
  sensdislist.free;
  inherited destroy;
end;


procedure TRRsens.getorig;

var inr1,inr2,inr3,catinr,cc,ag:integer;
    sex:Tsex;

begin
  for inr1:=0 to curdislist.Count-1 do
  with Tdisease(curdislist.Items[inr1]) do
  with TRFsensdisease(sensdislist.Items[inr1]) do
  begin
    for inr2:=0 to rflist.Count-1 do
    with Trfdis(rflist.Items[inr2]) do
    with TRRsensrfdis(Srflist.Items[inr2]) do
{       SRelRis:=RelRis;}
  end;{for curdislist}
  if mainform.uncertbool then
  begin
    with datasetform do
    for inr3:=0 to curdislist.Count-1 do
    with TRFsensdisease(sensdislist.Items[inr3]) do
     for inr1:=0 to srflist.count-1 do
      with TRRsensrfdis(srflist.items[inr1]) do
       begin
         putquery1('SELECT * FROM RelriskStDev '+
                'where RelRiskStDev.RiskfactorAndDisease='
                +psq(srfname+' '+Tdisease(curdislist.Items[inr3]).Name));
         with datamodule2.inputQ1 do
         begin
           first;
           cc:=1;
           for sex:=men to fem do
            for ag:=0 to aggmax do
            begin
              Texpocat(StdDev.Items[inr2]).prevs[sex,ag]:=Fields[cc].Asfloat;
              Inc(cc);
            end;
         end;
      end;
  end;{if uncertbool}
end;


procedure TRRsens.aanpas(nummer:double);

var ag,inr1,inr2,catinr:integer;
    sex:Tsex;
    gamma,afstand,beta:Double;
    eerste:Boolean;

begin
  for inr1:=0 to curdislist.Count-1 do
  with Tdisease(curdislist.Items[inr1]) do
  with TRFsensdisease(sensdislist.Items[inr1]) do
  begin
    for inr2:=0 to rflist.Count-1 do
    with Trfdiscat(rflist.Items[inr2]) do
    with TRRsensrfdis(Srflist.Items[inr2]) do
    begin
       for sex:=men to fem do
       begin
         eerste:=True;
         for ag:=0 to aggmax do
         if mainform.sensbool then
         begin
           RelRis.oneydata[0,sex,ag]:=1.0+
               (SRelRis[sex,ag]-1.0)*nummer;
         end else
         begin
           if Texpocat(StdDev.Items[catinr]).prevs[sex,ag]>0.0 then
           begin
             beta:=power(Texpocat(StdDev.Items[catinr]).prevs[sex,ag],2)
                /(SRelRis[sex,ag]-1.0);
             gamma:=sensform.gamma_exp(0,(SRelRis[sex,ag]-1.0)/beta,beta);
             if eerste then
             begin
               RelRis.oneydata[0,sex,ag]:=1.0+gamma;
               writeln(testuit,RelRis.oneydata[0,sex,ag]);
               afstand:=gamma/(SRelRis[sex,ag]-1.0);
               eerste:=False;
             end else RelRis.oneydata[0,sex,ag]:=1.0+
                 sensform.RRrandcor*afstand*SRelRis[sex,ag]+
                 (1.0-sensform.RRrandcor)*gamma;
           end else RelRis.oneydata[0,sex,ag]:=
             SRelRis[sex,ag];
         end;
       end;
    end;                      {het excess risk}
  end;{for curdislist}
end;






constructor TLAGSsensrfdis.create(n:string);
begin
  inherited Create;
  Srfname:=n;
end;

destructor TLAGSsensrfdis.destroy;
begin
  inherited destroy;
end;


constructor TLAGSsens.Create(n:string);

var inr1,inr2:integer;
    LAGSsensdisease:TRFsensdisease;
    LAGSsensrfdis:TLAGSsensrfdis;

begin
  inherited Create(n);
  sensdislist:=Tlist.Create;
  for inr1:=0 to curdislist.Count-1 do
  with Tdisease(curdislist.Items[inr1]) do
  begin
    LAGSsensdisease:=TRFsensdisease.Create(Name);
    for inr2:=0 to rflist.Count-1 do
    with Trfdis(rflist.Items[inr2]) do
    begin
      LAGSsensrfdis:=TLAGSsensrfdis.Create(rfac.name);
      LAGSsensdisease.Srflist.Add(LAGSsensrfdis);
    end;
    sensdislist.Add(LAGSsensdisease);
  end;{for curdislist}
  getorig;
  sensinstance.sensvars.Add(self);
end;


destructor TLAGSsens.destroy;

var inr1,inr2:integer;

begin
  for inr1:=0 to sensdislist.Count-1 do
    TRFsensdisease(sensdislist.Items[inr1]).free;
  sensdislist.free;
  inherited destroy;
end;


procedure TLAGsens.getorig;

var inr1,inr2:integer;

begin
  for inr1:=0 to curdislist.Count-1 do
  with Tdisease(curdislist.Items[inr1]) do
  with TRFsensdisease(sensdislist.Items[inr1]) do
  begin
    for inr2:=0 to rflist.Count-1 do
    with Trfdis(rflist.Items[inr2]) do
    begin
      with TLAGSsensrfdis(Srflist.Items[inr2]) do SLAG:=LAG;
      with datasetform do
        putquery1('SELECT LAGStdDev FROM DiseaseRiskfactorRelation '+
              'where DiseaseRiskfactorRelation.DiseaseName='
               +psq(TRFsensdisease(sensdislist.Items[inr1]).SName)+
              'and DiseaseRiskfactorRelation.RiskFactorName='+psq(rfac.Name));
      with datamodule2.inputQ1 do
      with TLAGSsensrfdis(Srflist.Items[inr2]) do StdDev:=Fields[0].asfloat;
    end;
  end;{for curdislist}
end;

procedure TLAGsens.aanpas(nummer:double);

var inr1,inr2:integer;
    beta,tmp:Double;

begin
  for inr1:=0 to curdislist.Count-1 do
  with Tdisease(curdislist.Items[inr1]) do
  with TRFsensdisease(sensdislist.Items[inr1]) do
  begin
    for inr2:=0 to rflist.Count-1 do
    with Trfdis(rflist.Items[inr2]) do
    with TLAGSsensrfdis(Srflist.Items[inr2]) do
    begin
      if mainform.sensbool then tmp:=SLAG*nummer
      else
      begin
        if StdDev>0 then
        begin
          beta:=power(StdDev,2);
          tmp:=sensform.gamma_exp(0,SLAG/beta,beta);
        end else tmp:=SLAG;
      end;
      if tmp<1.0 then Lag:=1 else lag:=round(tmp);
    end;                      {LAG is minstens 1, en integer}
  end;{for curdislist}
end;


procedure TLATsens.getorig;

var inr1,inr2:integer;

begin
  for inr1:=0 to curdislist.Count-1 do
  with Tdisease(curdislist.Items[inr1]) do
  with TRFsensdisease(sensdislist.Items[inr1]) do
  begin
    for inr2:=0 to rflist.Count-1 do
    with Trfdis(rflist.Items[inr2]) do
    begin
      with TLAGSsensrfdis(Srflist.Items[inr2]) do SLAG:=LAT;
      with datasetform do
        putquery1('SELECT LATStdDev FROM DiseaseRiskfactorRelation '+
              'where DiseaseRiskfactorRelation.DiseaseName='
               +psq(TRFsensdisease(sensdislist.Items[inr1]).SName)+
              'and DiseaseRiskfactorRelation.RiskFactorName='+psq(rfac.Name));
      with datamodule2.inputQ1 do
      with TLAGSsensrfdis(Srflist.Items[inr2]) do StdDev:=Fields[0].asfloat;
    end;
  end;{for curdislist}
end;


procedure TLATsens.aanpas(nummer:double);

var inr1,inr2:integer;
    tmp,beta:Double;

begin
  for inr1:=0 to curdislist.Count-1 do
  with Tdisease(curdislist.Items[inr1]) do
  with TRFsensdisease(sensdislist.Items[inr1]) do
  begin
    for inr2:=0 to rflist.Count-1 do
    with Trfdis(rflist.Items[inr2]) do
    with TLAGSsensrfdis(Srflist.Items[inr2]) do
    begin
      if mainform.sensbool then tmp:=SLAG*nummer
      else
      begin
        if StdDev>0 then
        begin
          beta:=power(StdDev,2);
          tmp:=sensform.gamma_exp(0,SLAG/beta,beta);
        end else tmp:=SLAG;
      end;
      if tmp<0.0 then LAT:=0 else LAT:=round(tmp);
    end;                      {LAT is minstens 0, en integer}
  end;{for curdislist}
end;

procedure TCUMsens.getorig;

var inr1,inr2:integer;

begin
  for inr1:=0 to curdislist.Count-1 do
  with Tdisease(curdislist.Items[inr1]) do
  with TRFsensdisease(sensdislist.Items[inr1]) do
  begin
    for inr2:=0 to rflist.Count-1 do
    with Trfdis(rflist.Items[inr2]) do
    begin
      with TLAGSsensrfdis(Srflist.Items[inr2]) do SLAG:=CUM;
      with datasetform do
        putquery1('SELECT CUMStdDev FROM DiseaseRiskfactorRelation '+
              'where DiseaseRiskfactorRelation.DiseaseName='
               +psq(TRFsensdisease(sensdislist.Items[inr1]).SName)+
              'and DiseaseRiskfactorRelation.RiskFactorName='+psq(rfac.Name));
      with datamodule2.inputQ1 do
      with TLAGSsensrfdis(Srflist.Items[inr2]) do StdDev:=Fields[0].asfloat;
    end;
  end;{for curdislist}
end;


procedure TCUMsens.aanpas(nummer:double);

var inr1,inr2:integer;
    tmp,beta:Double;

begin
  for inr1:=0 to curdislist.Count-1 do
  with Tdisease(curdislist.Items[inr1]) do
  with TRFsensdisease(sensdislist.Items[inr1]) do
  begin
    for inr2:=0 to rflist.Count-1 do
    with Trfdis(rflist.Items[inr2]) do
    with TLAGSsensrfdis(Srflist.Items[inr2]) do
    begin
      if mainform.sensbool then tmp:=SLAG*nummer
      else
      begin
        if StdDev>0 then
        begin
          beta:=power(StdDev,2);
          tmp:=sensform.gamma_exp(0,SLAG/beta,beta);
        end else tmp:=SLAG;
      end;
      if tmp<0.0 then CUM:=0 else CUM:=round(tmp);
    end;                      {CUM is minstens 0, en integer}
  end;{for curdislist}
end;


constructor TRF1svarsens.Create(n:string);

begin
  inherited Create;
  srfname:=n;
  svar:=Tlist.Create;
  if mainform.uncertbool then StdDev:=Tlist.Create;
end;

destructor TRF1svarsens.destroy;

var inr:integer;

begin
  for inr:=0 to svar.Count-1 do
    Tobject(svar.Items[inr]).free;
  svar.free;
  if mainform.uncertbool then
  begin
  for inr:=0 to StdDev.Count-1 do
    TObject(StdDev.Items[inr]).free;
    StdDev.free;
  end;
  inherited destroy;
end;



procedure TSensForm.CancButClick(Sender: TObject);
begin
{  sensvelden:='';}
  Close;
end;

procedure TSensForm.runspecif;
begin
  runopform.showmodal;
  CheckListBox1.State[0]:=cbchecked;
{  if mainform.sensbool then
    sensvelden:='sensvar char(100), rangevar char(100), '
    else sensvelden:='';}
  mainform.uitvoeropzet;
end;

procedure TSensForm.varspecif;
begin
  paraselform.Caption:='Check variables for sensitivity';
  paraselform.showmodal;
  CheckListBox1.State[1]:=cbchecked;
end;

procedure TSensForm.sensspecif;
begin
  if mainform.sensbool then
  begin
    permuform.Caption:='Permutations and range';
    permuform.LabGroup.Visible:=true;
    permuform.choosebut.Visible:=true;
    permuform.rangegroup.Caption:='Range of sensitivity';
  end
  else if mainform.uncertbool then
  begin
    permuform.Caption:='Permutations and number of iterations';
    permuform.LabGroup.Visible:=False;
    permuform.choosebut.Visible:=False;
    permuform.rangegroup.Caption:='Number of iterations';
  end;
  permuform.showmodal;
  CheckListBox1.State[2]:=cbchecked;
end;

procedure TSensForm.outputspecif;
begin
  CheckListBox1.State[3]:=cbchecked;
end;

procedure TSensForm.outputdestspecif;
begin
  fkiesform.showmodal;
  CheckListBox1.State[4]:=cbchecked;
end;



procedure TSensForm.CheckListBox1Click(Sender: TObject);

var klaar:Boolean;
    Ind:integer;

begin
  with CheckListBox1 do
  begin
    if selected[0] then runspecif;
    if selected[1] then varspecif;
    if selected[2] then sensspecif;
    if selected[3] then outputspecif;
    if selected[4] then outputdestspecif;
    klaar:=True;
    for Ind:=0 to Items.Count-1 do klaar:=klaar and (state[Ind]=cbchecked);
  end;
  startbut.Enabled:=klaar;
end;

procedure TSensForm.SensMessage(inr1,inr2:integer);

var inr3:integer;
  sensstring:string;
begin
  with Tsensinstance(mainform.sensrunlist.Items[inr1]) do
  begin
    mainform.uitmesstring:='Run: ';
    sensstring:='';
    for inr3:=0 to sensvars.Count-1 do
     with Tsensobj(sensvars.Items[inr3]) do
     begin
       mainform.uitmesstring:=mainform.uitmesstring+titel+' ';
       sensstring:=sensstring+titel+' ';
     end;
    mainform.uitmesstring:=mainform.uitmesstring+Tsensnum(rangelist.Items[inr2]).tekst;
    sensstring:=datasetform.psq(sensstring)+', '
      +datasetform.psq(Tsensnum(rangelist.Items[inr2]).tekst)+', ';
  end;
  memoform.memo1.lines.Add(mainform.uitmesstring);
end;

procedure TSensForm.StartButClick(Sender: TObject);

var
    RRsens:TRRsens;
    CUMsens:Tcumsens;
    LATsens:TLATsens;
    LAGsens:TLAGsens;

    inr1,inr2,inr3:integer;
    keepint:Boolean;
    numrun:integer;

begin
  with mainform do
  begin
    beziglook;
    assignfile(testuit,'rruit.txt');
    rewrite(testuit);
    keepint:=keepinterventions1.Checked;
    keepinterventions1.Checked:=True;
    if sensbool then startboodschap('Prevent sensitivity run')
    else if uncertbool then startboodschap('Prevent uncertaintity run');
    crecur;
    sensrunlist:=Tlist.Create;
  {Hier zou een loop omheen kunnen voor verschillende voorgebakken runs}
    sensinstance:=Tsensinstance.Create(sensrunlist.count);
    with paraselform do
    begin
      if rrcheck.checked then rrsens:=Trrsens.Create('Relative Risks');
      if CUMcheck.checked then CUMsens:=TCUMsens.Create('CUM');
      if LATcheck.checked then LATsens:=TLATsens.Create('LAT');
      if LAGcheck.checked then LAGsens:=TLAGsens.Create('LAG');
    end;
    sensrunlist.Add(sensinstance);
  {einde voorgebakken loop}
    for inr1:=0 to sensrunlist.Count-1 do
    with Tsensinstance(sensrunlist.Items[inr1]) do
    begin
      if sensbool then numrun:=rangelist.Count-1
      else if uncertbool then numrun:=permuform.rangespin.Value-1;
      for inr2:=0 to numrun do
      begin
        if sensbool then Sensmessage(inr1,inr2);
        for inr3:=0 to sensvars.Count-1 do
         with Tsensobj(sensvars.Items[inr3]) do
         if sensbool then aanpas(Tsensnum(rangelist.Items[inr2]).nummer)
         else aanpas(0.0);
        if uitbool then deluit;
        creuit;
        dorun;
        outopform.aanplak:=True;
      end;
    end;
    if sensbool then stopboodschap('Sensitivity run')
    else if uncertbool then stopboodschap('Uncertaintity run');
    deluit;
    startlook;
    for inr1:=0 to sensrunlist.Count-1 do TObject(sensrunlist.Items[inr1]).Free;
    sensrunlist.Free;
    keepinterventions1.Checked:=keepint;
{    sensvelden:='';}
    sensbool:=false;
    uncertbool:=False;
    closefile(testuit);
  end;
  Close;
end;

procedure TSensForm.FormActivate(Sender: TObject);

var Ind:integer;
begin
  rangelist:=Tlist.Create;
  startbut.Enabled:=False;
  with CheckListBox1 do
  begin
    Items.Clear;
    Items.Add('Run specification');
    Items.Add('Selection of parameters');
    if mainform.sensbool then Items.Add('Specification of sensitivity')
    else if mainform.uncertbool then Items.Add('Number of iterations');
    Items.Add('Selection of output variables');
    Items.Add('Ouput destination');
    for Ind:=0 to Items.Count-1 do state[Ind]:=cbunchecked;
  end;
  if mainform.sensbool then  caption:='Prevent - Sensitivity run'
  else if mainform.uncertbool then
  begin
    caption:='Prevent - Uncertainty run';
    Randomize;
    rrrandcor:=1.0;
  end;
end;

procedure TSensForm.FormClose(Sender: TObject; var Action: TCloseAction);

var inr:integer;

begin
  for inr:=0 to rangelist.Count-1 do TObject(rangelist.Items[inr]).Free;
  rangelist.Free;
end;

end.
