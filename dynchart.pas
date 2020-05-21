unit dynchart;

{$MODE Delphi}

interface

uses
  SysUtils, LCLIntf, LCLType, LMessages, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Chart, Series, ExtCtrls, StdCtrls,
  TeEngine, TeeProcs,Teeprevi,{editpro,editchar,}INITIAL, ComCtrls;

type
  Tdyngraf = class(TForm)
    Panel1: TPanel;
    CloseBut: TButton;
    Panel2: TPanel;
    Panel3: TPanel;
    ReplayBut: TButton;
    Jaarlab: TLabel;
    TrackBar1: TTrackBar;
    Timer1: TTimer;
    procedure CloseButClick(Sender: TObject);
    procedure closebutplaats(Sender: TObject); virtual;
    procedure FormCreate(Sender: TObject); virtual;
    procedure ReplayButClick(Sender: TObject); virtual;
    procedure TrackBar1Change(Sender: TObject); virtual;
    procedure Timer1Timer(Sender: TObject); virtual;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    lokaal:Tdatavar;
    tott,formtt,offsett:integer;
    procedure wclose(Sender: TObject; var Action: TCloseAction);
    procedure dicht;
    procedure doen(ymin,ymax:double;uitnaam,ls1,ls2,ls3,ls4:string); virtual;
    procedure enkeljaar(tt:integer); virtual;
  end;

var
  dyngraf: Tdyngraf;


implementation

{$R *.lfm}
uses GESCALE,WINGLOB,OUTOP,math;


procedure Tdyngraf.doen(ymin,ymax:double;uitnaam,ls1,ls2,ls3,ls4:string);


begin
  caption:='Prevent - '+currentdataset+' output';
  jaarlab.caption:=inttostr(beginjaar-offsett);
  tott:=et+offsett;
  trackbar1.pagesize:=tott;
  trackbar1.linesize:=1;
  trackbar1.height:=round(panel2.height*0.75);
  trackbar1.max:=tott;
  trackbar1.width:=panel2.width-15;
end;


procedure Tdyngraf.dicht;
begin
  close;
  lokaal:=nil;
  release;
end;

procedure Tdyngraf.closebutClick(Sender: TObject);
begin
  dynchartlist.remove(self);
  dicht;
end;


procedure Tdyngraf.wclose(Sender: TObject; var Action: TCloseAction);
begin
  dynchartlist.remove(self);
  Action := caFree;
end;


procedure Tdyngraf.closebutplaats(Sender: TObject);
begin
  trackbar1.height:=round(panel2.height*0.75);
  trackbar1.repaint;
end;



procedure Tdyngraf.enkeljaar(tt:integer);

begin
  jaarlab.caption:=inttostr(beginjaar-offsett+tt);
  trackbar1.position:=tott-tt;
  jaarlab.repaint;
end;

procedure Tdyngraf.FormCreate(Sender: TObject);
begin
  geautoscale(self);
  dynchartlist.add(self);
  timer1.enabled:=false;
end;


procedure Tdyngraf.ReplayButClick(Sender: TObject);

begin
  timer1.enabled:=true;
  timer1.interval:=1+50*outopform.dynspeed.position;
  formtt:=0;
  Timer1timer(self);
  trackbar1.setfocus;
end;

procedure Tdyngraf.TrackBar1Change(Sender: TObject);

var tind:integer;

begin
  if outopform.syncheck.checked then
  begin
    for tind:=0 to dynchartlist.count-1 do
     if Tdyngraf(dynchartlist.items[tind]).tott-trackbar1.position>=0
       then Tdyngraf(dynchartlist.items[tind]).enkeljaar(Tdyngraf(dynchartlist.items[tind]).tott-trackbar1.position)
       else Tdyngraf(dynchartlist.items[tind]).enkeljaar(0);
  end else enkeljaar(tott-trackbar1.position);
end;

procedure Tdyngraf.Timer1Timer(Sender: TObject);

begin
  enkeljaar(formtt);
  if formtt<tott then inc(formtt) else timer1.enabled:=false;
end;

procedure Tdyngraf.FormActivate(Sender: TObject);
begin
  formtt:=0;
end;

end.
