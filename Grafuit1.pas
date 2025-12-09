unit Grafuit1;

{$MODE Delphi}

interface

uses
  SysUtils, LCLIntf, LCLType, {LMessages, Messages,} Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, StdCtrls, TAGraph, TASeries,
  {TeEngine,TeeProcs,Teeprevi}{editpro,editchar,}INITIAL;

type
  Tgraphuit1 = class(TForm)
    Chart1: TChart;
    LineSeries1: TLineSeries;
    LineSeries2: TLineSeries;
    LineSeries3: TLineSeries;
    LineSeries4: TLineSeries;
    Panel1: TPanel;
    CloseBut: TButton;
    printBut: TButton;
    procedure CloseButClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure printButClick(Sender: TObject);
    procedure wclose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    nrlok:integer;
    procedure doen(uitnaam,ls1,ls2,ls3,ls4:string);
    procedure dicht;
  end;

var
  graphuit1: Tgraphuit1;
 
implementation

{$R *.lfm}
uses GESCALE,{WINGLOB,} OUTOP,math;

procedure Tgraphuit1.doen(uitnaam,ls1,ls2,ls3,ls4:string);
begin
  caption:='Prevent - '+currentdataset+' output';
  {Chart1.ZoomPercent(98);}
  chart1.Title.text[0]:=uitnaam;
  if outopform.y0check.State=cbchecked then
      chart1.leftaxis.Range.Min:=min(0.0,chart1.leftaxis.Range.Min);
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
end;

procedure Tgraphuit1.dicht;
begin
  close;
  release;
end;

procedure Tgraphuit1.closebutClick(Sender: TObject);
begin
  statchartlist.remove(self);
  dicht;
end;


procedure Tgraphuit1.wclose(Sender: TObject; var Action: TCloseAction);
begin
  statchartlist.remove(self);
  Action := caFree;
end;

procedure Tgraphuit1.FormCreate(Sender: TObject);
begin
  chart1.Color:=clBtnFace;
  geautoscale(self);
  statchartlist.add(self);
end;

procedure Tgraphuit1.printButClick(Sender: TObject);
begin
  {chartpreview(self,chart1);}
end;

end.
