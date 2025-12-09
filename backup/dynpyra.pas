unit dynpyra;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, {LMessages, Messages,} SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  dynchart, ComCtrls, StdCtrls, ExtCtrls, {TeEngine, } TASeries, {TeeProcs, }
  INITIAL, TAGraph;

type
  Tdynpyramid = class(Tdyngraf)
    ChartPan: TPanel;
    MenChart: TChart;
    Mshared: TBarSeries;
    Mloss: TBarSeries;
    Mgain: TBarSeries;
    WomenChart: TChart;
    Wshared: TBarSeries;
    Wloss: TBarSeries;
    Wgain: TBarSeries;
    procedure FormCreate(Sender: TObject); override;
    procedure closebutplaats(Sender: TObject);override;
  private
    { Private declarations }
    deeldoor:integer;
  public
    { Public declarations }
    procedure doen(ymin,ymax:double;uitnaam,ls1,ls2,ls3,ls4:string); override;
    procedure enkeljaar(tt:integer); override;
  end;

var
  dynpyramid: Tdynpyramid;

implementation

{$R *.lfm}
uses GESCALE,WINGLOB,OUTOP;


procedure Tdynpyramid.doen(ymin,ymax:double;uitnaam,ls1,ls2,ls3,ls4:string);

begin
  inherited;
  caption:='Prevent - '+currentdataset+' output';
  jaarlab.caption:=inttostr(beginjaar);
  {Menchart.leftaxis.automatic:=false;
  Womenchart.leftaxis.automatic:=false;}
  Menchart.leftaxis.Range.Max :=(ymax/deeldoor)*1.05;
  Womenchart.leftaxis.Range.Max:=(ymax/deeldoor)*1.05;
  {Womenchart.leftaxis.Range.increment := Menchart.leftaxis.Range.increment;}
  trackbar1.position:=trackbar1.max;
  panel1.caption:='Numbers times '+inttostr(deeldoor);
  show;
  trackbar1.setfocus;
end;


procedure Tdynpyramid.enkeljaar(tt:integer);

var ag:integer;

begin
  jaarlab.caption:=inttostr(beginjaar+tt);
  for ag:=0 to aggmax do
  begin
    if lokaal[tt,fem,ref,ag]<lokaal[tt,fem,intv,ag] then
    begin
      Wshared.xvalue[ag]:=lokaal[tt,fem,ref,ag]/deeldoor;
      Wgain.xvalue[ag]:=(lokaal[tt,fem,intv,ag]-lokaal[tt,fem,ref,ag])/deeldoor;
      Wloss.xvalue[ag]:=0.0;
    end else
    begin
      Wshared.xvalue[ag]:=lokaal[tt,fem,intv,ag]/deeldoor;
      Wgain.xvalue[ag]:=0.0;
      Wloss.xvalue[ag]:=(lokaal[tt,fem,ref,ag]-lokaal[tt,fem,intv,ag])/deeldoor;
    end;
    if lokaal[tt,men,ref,ag]<lokaal[tt,men,intv,ag] then
    begin
      Mshared.xvalue[ag]:=lokaal[tt,men,ref,ag]/deeldoor;
      Mgain.xvalue[ag]:=(lokaal[tt,men,intv,ag]-lokaal[tt,men,ref,ag])/deeldoor;
      Mloss.xvalue[ag]:=0.0;
    end else
    begin
      Mshared.xvalue[ag]:=lokaal[tt,men,intv,ag]/deeldoor;
      Mgain.xvalue[ag]:=0.0;
      Mloss.xvalue[ag]:=(lokaal[tt,men,ref,ag]-lokaal[tt,men,intv,ag])/deeldoor;
    end;
  end;
  trackbar1.position:=et-tt;
  jaarlab.repaint;
  Menchart.repaint;
  Womenchart.repaint;
end;


procedure Tdynpyramid.FormCreate(Sender: TObject);
begin
  geautoscale(dynpyramid);
  dynchartlist.add(self);
  timer1.enabled:=false;
  deeldoor:=globdeeldoor;
end;


procedure Tdynpyramid.closebutplaats(Sender: TObject);
begin
  inherited;
  menchart.width:=chartpan.width div 2-50;
  womenchart.width:=chartpan.width div 2+50;
end;

end.
