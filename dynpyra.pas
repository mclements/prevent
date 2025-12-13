unit dynpyra;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  dynchart, ComCtrls, StdCtrls, ExtCtrls, TASeries, TASources,
  INITIAL, TAGraph, TAStyles;

type

  Tdynpyramid = class(Tdyngraf)
    ChartPan: TPanel;
    WChartStyles: TChartStyles;
    MenChart: TChart;
    Mshared: TBarSeries;
    MChartStyles: TChartStyles;
    WomenChart: TChart;
    Wshared: TBarSeries;
    MSource, WSource: TListChartSource;
    procedure FormCreate(Sender: TObject); override;
    procedure closebutplaats(Sender: TObject);override;
  private
    deeldoor:integer;
  public
    procedure doen(ymin,ymax:double;uitnaam,ls1,ls2,ls3,ls4:string); override;
    procedure enkeljaar(tt:integer); override;
  end;

var
  dynpyramid: Tdynpyramid;

implementation

{$R *.lfm}
uses GESCALE;


procedure Tdynpyramid.doen(ymin,ymax:double;uitnaam,ls1,ls2,ls3,ls4:string);

begin
  inherited;
  caption:='Prevent - '+currentdataset+' output';
  jaarlab.caption:=inttostr(beginjaar);
  Menchart.leftaxis.Range.Max :=(ymax/deeldoor)*1.05;
  Womenchart.leftaxis.Range.Max:=(ymax/deeldoor)*1.05;
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
      Wsource.addXYList(ag*5+2.5, [lokaal[tt,fem,ref,ag]/deeldoor,
        (lokaal[tt,fem,intv,ag]-lokaal[tt,fem,ref,ag])/deeldoor,
        0.0]);
    end else
    begin
      Wsource.addXYList(ag*5+2.5,
      [lokaal[tt,fem,intv,ag]/deeldoor,
      0.0,
      (lokaal[tt,fem,ref,ag]-lokaal[tt,fem,intv,ag])/deeldoor]);
    end;
    if lokaal[tt,men,ref,ag]<lokaal[tt,men,intv,ag] then
    begin
      Msource.addXYList(ag*5+2.5, [lokaal[tt,men,ref,ag]/deeldoor,
        (lokaal[tt,men,intv,ag]-lokaal[tt,men,ref,ag])/deeldoor,
        0.0]);
    end else
    begin
      Msource.addXYList(ag*5+2.5,
      [lokaal[tt,men,intv,ag]/deeldoor,
      0.0,
      (lokaal[tt,men,ref,ag]-lokaal[tt,men,intv,ag])/deeldoor]);
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
