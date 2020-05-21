unit dynpyra;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  dynchart, ComCtrls, StdCtrls, ExtCtrls, TeEngine, Series, TeeProcs, Chart,
  initial;

type
  Tdynpyramid = class(Tdyngraf)
    ChartPan: TPanel;
    MenChart: TChart;
    Mshared: THorizBarSeries;
    Mloss: THorizBarSeries;
    Mgain: THorizBarSeries;
    WomenChart: TChart;
    Wshared: THorizBarSeries;
    Wloss: THorizBarSeries;
    Wgain: THorizBarSeries;
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

{$R *.DFM}
uses gescale,winglob,outop;


procedure Tdynpyramid.doen(ymin,ymax:double;uitnaam,ls1,ls2,ls3,ls4:string);

begin
  inherited;
  caption:='Prevent - '+currentdataset+' output';
  jaarlab.caption:=inttostr(beginjaar);
  Menchart.bottomaxis.automatic:=false;
  Womenchart.bottomaxis.automatic:=false;
  Menchart.bottomaxis.maximum:=(ymax/deeldoor)*1.05;
  Womenchart.bottomaxis.maximum:=(ymax/deeldoor)*1.05;
  Womenchart.bottomaxis.increment:=Menchart.bottomaxis.increment;
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
      Wshared.xvalues.value[ag]:=lokaal[tt,fem,ref,ag]/deeldoor;
      Wgain.xvalues.value[ag]:=(lokaal[tt,fem,intv,ag]-lokaal[tt,fem,ref,ag])/deeldoor;
      Wloss.xvalues.value[ag]:=0.0;
    end else
    begin
      Wshared.xvalues.value[ag]:=lokaal[tt,fem,intv,ag]/deeldoor;
      Wgain.xvalues.value[ag]:=0.0;
      Wloss.xvalues.value[ag]:=(lokaal[tt,fem,ref,ag]-lokaal[tt,fem,intv,ag])/deeldoor;
    end;
    if lokaal[tt,men,ref,ag]<lokaal[tt,men,intv,ag] then
    begin
      Mshared.xvalues.value[ag]:=lokaal[tt,men,ref,ag]/deeldoor;
      Mgain.xvalues.value[ag]:=(lokaal[tt,men,intv,ag]-lokaal[tt,men,ref,ag])/deeldoor;
      Mloss.xvalues.value[ag]:=0.0;
    end else
    begin
      Mshared.xvalues.value[ag]:=lokaal[tt,men,intv,ag]/deeldoor;
      Mgain.xvalues.value[ag]:=0.0;
      Mloss.xvalues.value[ag]:=(lokaal[tt,men,ref,ag]-lokaal[tt,men,intv,ag])/deeldoor;
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
