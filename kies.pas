unit kies;

{$MODE Delphi}

interface

uses
  SysUtils, LCLIntf, LCLType, {LMessages, Messages,} Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,DisUnit;

type
  Tkiesform = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    ListBox1: TListBox;
    CancelBut: TButton;
    procedure ListBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function currfkiezen:integer;
    function curdiskiezen(zlijst:Tlist):integer;
    function lftkiezen:integer;
    function jaarkiezen(lb:integer):integer;
    function rfjaarkiezen(lookback:integer):integer;
    function rflftkiezen(ags:Tstrings):integer;
    function rfcatkiezen(rfcat:Tcategory):integer;
    function scenkiezen:integer;
  end;

var
  kiesform: Tkiesform;

implementation

{$R *.lfm}

uses GESCALE,INITIAL;

procedure Tkiesform.ListBox1Click(Sender: TObject);
begin
  close;
  modalresult:=mrOK;
end;

function Tkiesform.currfkiezen:integer;

var ind:integer;

begin
  listbox1.clear;
  listbox1.columns:=1;
  label2.caption:='Choose one of the risk factors';
  for ind:=0 to currflist.count-1 do
   listbox1.items.add(Tgenentity(currflist.items[ind]).name);
  showmodal;
  if modalresult=mrCancel then result:=-1 else result:=listbox1.itemindex;
end;{currfkiezen}

function Tkiesform.curdiskiezen(zlijst:Tlist):integer;

var ind:integer;

begin
  listbox1.clear;
  listbox1.columns:=1;
  label2.caption:='Choose one from the list';
  for ind:=0 to zlijst.count-1 do
   listbox1.items.add(Tgenentity(zlijst.items[ind]).name);
  showmodal;
  if modalresult=mrCancel then result:=-1 else result:=listbox1.itemindex;
end;{curdiskiezen}


function Tkiesform.lftkiezen:integer;

var ind:integer;

begin
  listbox1.clear;
  listbox1.columns:=2;
  label2.caption:='Choose one of the age groups';
  for ind:=0 to aggmax do
   listbox1.items.add(age2str(ind));
  showmodal;
  if modalresult=mrCancel then result:=-1 else result:=listbox1.itemindex;
end;{lftkiezen}

function Tkiesform.jaarkiezen(lb:integer):integer;

var ind:integer;

begin
  listbox1.clear;
  listbox1.columns:=4;
  label2.caption:='Choose a year';
  for ind:=0 to et+lb do
   listbox1.items.add(inttostr(beginjaar+ind-lb));
  showmodal;
  if modalresult=mrCancel then result:=-1 else result:=listbox1.itemindex;
end;{jaarkiezen}

function Tkiesform.rfjaarkiezen(lookback:integer):integer;

var ind:integer;

begin
  listbox1.clear;
  listbox1.columns:=4;
  label2.caption:='Choose a year';
  for ind:=-lookback to et do
   listbox1.items.add(inttostr(beginjaar+ind));
  showmodal;
  if modalresult=mrCancel then result:=-1 else result:=listbox1.itemindex;
end;{jaarkiezen}

function Tkiesform.scenkiezen:integer;

begin
  listbox1.clear;
  listbox1.columns:=1;
  label2.caption:='Choose a scenario';
  listbox1.items.add('Reference scenario');
  listbox1.items.add('Intervention scenario');
  showmodal;
  if modalresult=mrCancel then result:=-1 else result:=listbox1.itemindex;
end;{scenkiezen}

function Tkiesform.rflftkiezen(ags:Tstrings):integer;

begin
  listbox1.clear;
  listbox1.columns:=1;
  label2.caption:='Choose one of the age groups';
  listbox1.items:=ags;
  showmodal;
  if modalresult=mrCancel then result:=-1 else result:=listbox1.itemindex;
end;{lftkiezen}

function Tkiesform.rfcatkiezen(rfcat:Tcategory):integer;
var ind:integer;
begin
  listbox1.clear;
  listbox1.columns:=1;
  label2.caption:='Choose one of the categories';
  for ind:=0 to rfcat.catno-1 do listbox1.items.add(rfcat.catnames[ind]);;
  showmodal;
  if modalresult=mrCancel then result:=-1 else result:=listbox1.itemindex;
end;{lftkiezen}


procedure Tkiesform.FormCreate(Sender: TObject);
begin
  geautoscale(kiesform);
end;

procedure Tkiesform.FormActivate(Sender: TObject);
begin
  kiesform.caption:='Prevent - '+currentdataset;
end;

end.
