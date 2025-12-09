unit dynbars;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, {LMessages, Messages,} SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, dynchart, ComCtrls, StdCtrls, ExtCtrls, TAGraph, TASeries,
  {TeEngine, Series, TeeProcs, Chart,} INITIAL;

type
  Tdynbarren = class(Tdyngraf)
    Chart1: TChart;
    ManSeries: TBarSeries;
    VroSeries: TBarSeries;
    procedure FormCreate(Sender: TObject); override;
  private
    { Private declarations }
    ymax,ymin:double;
    lokeindpunt:integer;
    nrlok:integer;
 public
    { Public declarations }
    procedure doen(ymin,ymax:double;uitnaam,ls1,ls2,ls3,ls4:string); override;
    procedure enkeljaar(tt:integer); override;
  end;

var
  dynbarren: Tdynbarren;

implementation

{$R *.lfm}

uses GESCALE{,WINGLOB,OUTOP,math};



procedure Tdynbarren.doen(ymin,ymax:double;uitnaam,ls1,ls2,ls3,ls4:string);

var t:integer;

begin
  inherited;
  {chart1.leftaxis.automatic:=false;}
  chart1.leftaxis.Range.Max:=ymax*1.05;
  chart1.leftaxis.Range.Min:=ymin*1.05;
  trackbar1.width:=panel2.width-15;
  jaarlab.caption:=inttostr(beginjaar);
  caption:='Prevent - '+currentdataset+' output';
  chart1.Title.text[0]:=uitnaam;
  trackbar1.position:=trackbar1.max;
  show;
  trackbar1.setfocus;
end;


procedure Tdynbarren.enkeljaar(tt:integer);

var ag:integer;

begin
  jaarlab.caption:=inttostr(beginjaar+tt);
  for ag:=0 to aggmax do
  begin
    Manseries.yvalue[ag]:=lokaal[tt,men,ref,ag];
    Vroseries.yvalue[ag]:=lokaal[tt,fem,ref,ag];
  end;
   trackbar1.position:=et-tt;
   jaarlab.repaint;
   chart1.repaint;
 end;


procedure Tdynbarren.FormCreate(Sender: TObject);
begin
  geautoscale(dynbarren);
  timer1.enabled:=false;
  dynchartlist.add(dynbarren);
end;


end.
