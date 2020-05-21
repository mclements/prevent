unit dynlijns;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, dynchart, ComCtrls, StdCtrls, ExtCtrls, TAGraph, TASeries,
  TeEngine, Series, TeeProcs, Chart, INITIAL;

type
  Tdynlijnen = class(Tdyngraf)
    Chart1: TChart;
    LineSeries1: TLineSeries;
    LineSeries2: TLineSeries;
    LineSeries3: TLineSeries;
    LineSeries4: TLineSeries;
    procedure FormCreate(Sender: TObject); override;
  private
    { Private declarations }
 public
    { Public declarations }
    nrlok:integer;
    procedure doen(ymin,ymax:double;uitnaam,ls1,ls2,ls3,ls4:string); override;
    procedure enkeljaar(tt:integer); override;
  end;

var
  dynlijnen: Tdynlijnen;

implementation

{$R *.lfm}

uses GESCALE,WINGLOB,OUTOP,math;



procedure Tdynlijnen.doen(ymin,ymax:double;uitnaam,ls1,ls2,ls3,ls4:string);


begin
  inherited;
  chart1.leftaxis.automatic:=false;
  chart1.leftaxis.maximum:=ymax*1.05;
  chart1.leftaxis.minimum:=ymin*1.05;  
  trackbar1.position:=trackbar1.max;
  chart1.Title.text[0]:=uitnaam;
  LineSeries1.Title:=ls1;
  LineSeries2.Title:=ls2;
  LineSeries3.Title:=ls3;
  LineSeries4.Title:=ls4;
  if nrlok=2 then
  begin
    LineSeries2.active:=false;
    LineSeries4.active:=false;
  end;

  show;
  trackbar1.setfocus;
end;


procedure Tdynlijnen.enkeljaar(tt:integer);

var ag:integer;

begin
  inherited;
  case nrlok of 2:
  begin
    for ag:=0 to length(lokaal[tt,men,ref])-1 do
    begin
      LineSeries1.yvalues.value[ag]:=lokaal[tt,men,ref,ag];
      LineSeries3.yvalues.value[ag]:=lokaal[tt,fem,ref,ag];
    end;
   end;
           4:
   begin
     for ag:=0 to length(lokaal[tt,men,ref])-1 do
     begin
       LineSeries1.yvalues.value[ag]:=lokaal[tt,men,ref,ag];
       LineSeries2.yvalues.value[ag]:=lokaal[tt,men,intv,ag];
       LineSeries3.yvalues.value[ag]:=lokaal[tt,fem,ref,ag];
       LineSeries4.yvalues.value[ag]:=lokaal[tt,fem,intv,ag];
     end;
   end;
 end;{case}
 chart1.repaint;
end;


procedure Tdynlijnen.FormCreate(Sender: TObject);
begin
  inherited;
  chart1.Color:=clBtnFace;
end;


end.
