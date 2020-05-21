unit Tabeluit;

{$MODE Delphi}

interface

uses
  SysUtils, LCLIntf, LCLType, LMessages, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, Grids, StdCtrls,INITIAL, HgHGrid, HgGrid;

type
  Ttableuitform = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    closebut: TButton;
    HyperGrid1: THyperGrid;
    procedure closebutClick(Sender: TObject);
    procedure wclose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure HyperGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure copy2clbrd(copygrid:THyperGrid);
    procedure dicht;
    procedure opzet(nr,nrcol,nrrow,nrhead:integer);
    procedure doen(uitnaam:string);

  end;

var
  tableuitform: Ttableuitform;
  dumpfijl:text;

implementation

{$R *.lfm}

uses GESCALE,WINGLOB, PREVMAIN,Clipbrd;

const col0=70;
      colmid=75;
      collast=50;

var
    formwijd:integer;

procedure Ttableuitform.opzet(nr,nrcol,nrrow,nrhead:integer);

var
    nrind:integer;

begin
  with Hypergrid1 do
  begin
    columns.clear;
    headings.clear;
    for nrind:=0 to nrhead do headings.add;
    rowcount:=nrrow+3;
    colcount:=nrcol+2;
    for nrind:=0 to colcount-1 do columns.add;
    columns[0].headingindex:=0;
    colwidths[0]:=col0;
    formwijd:=colwidths[0];
    for nrind:=1 to nrcol do
    begin
      columns[nrind].headingindex:=round(int(1+(nrind-1)/(nrcol/nrhead)));
      columns[nrind].columnhalignment:=taRightJustify;
      colwidths[nrind]:=colmid;
      formwijd:=formwijd+colwidths[nrind];
    end;
    width:=formwijd;
    colwidths[nrcol+1]:=collast;
  end;
  tableuitform.width:=formwijd+collast;
  if tableuitform.width>750 then tableuitform.width:=750;
end;


procedure Ttableuitform.doen(uitnaam:string);
begin
  caption:='Prevent - '+currentdataset+' output';
  panel1.caption:=uitnaam;
  show;
end;

procedure Ttableuitform.dicht;
begin
  close;
  release;
end;

procedure Ttableuitform.closebutClick(Sender: TObject);
begin
  tablelist.remove(self);
  dicht;
end;


procedure Ttableuitform.wclose(Sender: TObject; var Action: TCloseAction);
begin
  tablelist.remove(self);
  Action := caFree;
end;

procedure Ttableuitform.FormCreate(Sender: TObject);
begin
  geautoscale(tableuitform);
  tablelist.add(self);
end;

procedure Ttableuitform.copy2clbrd(copygrid:THyperGrid);

var tmp:string;
    row,col:integer;

begin
  tmp:='';
  for row:=copygrid.selection.top to copygrid.selection.bottom do
  begin
    for col:=copygrid.selection.left to copygrid.selection.Right-1 do
       tmp:=tmp+copygrid.cells[col,row]+chr(9);
    col:=copygrid.selection.Right;
    tmp:=tmp+copygrid.cells[col,row]+chr(13)+chr(10);
  end;
  Clipboard.SetTextBuf(PChar(tmp));
end;


procedure Ttableuitform.HyperGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssCtrl in shift) and (key=67) then copy2clbrd(hypergrid1); {CTRL C}
end;

end.
