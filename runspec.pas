unit RUNSPEC;

{$MODE Delphi}

interface

uses
  SysUtils, LCLIntf, LCLType, {LMessages, Messages,} Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, StdCtrls, {Spin, Grids,} CheckLst;

type
  TrunForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    rfGroupBox: TGroupBox;
    cancelbut: TButton;
    Donebut: TButton;
    Label1: TLabel;
    RisFacListBox: TCheckListBox;
    procedure cancelbutClick(Sender: TObject);
    procedure DonebutClick(Sender: TObject);
    procedure RisFacListBoxClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure butposities;
  public
    { Public declarations }
    rfchoice:boolean;
    procedure datsetlabelset;
    procedure filrisfaclist;
    procedure fildislist;
  end;

var
  runForm: TrunForm;

implementation

{$R *.lfm}

uses GESCALE,WINGLOB, INITIAL, DisUnit, PREVMAIN{, BEVOLUN};

procedure TrunForm.datsetlabelset;
begin
  caption:='Prevent - '+currentdataset;
end;

{procedure TrunForm.filrfdislist(var lijst:Tlist);
  var ind,ind2: integer;
begin
  risfaclistbox.clear;
  rfgroupbox.caption:='Current risk factors for this disease:';
  for ind:=0 to lijst.count-1 do
  begin
    risfaclistbox.items.add(Trfdis(lijst.items[ind]).rfname);
    for ind2:=0 to currflist.count-1 do
     if Triskfactor(riskfactorlist.items[ind]).name=
       Triskfactor(currflist.items[ind2]).name then
        risfaclistbox.state[ind]:=cschecked;
  end;
  butposities;
end;}


procedure TrunForm.filrisfaclist;
  var ind,ind2: integer;
begin
  risfaclistbox.clear;
  rfgroupbox.caption:='Risk factors currently included:';
  for ind:=0 to riskfactorlist.count-1 do
  begin
    risfaclistbox.items.add(Tgenentity(riskfactorlist.items[ind]).name);
    for ind2:=0 to currflist.count-1 do
     if Tgenentity(riskfactorlist.items[ind]).name=
       Tgenentity(currflist.items[ind2]).name then
        risfaclistbox.state[ind]:=cbchecked;
  end;
  butposities;
end;


procedure TrunForm.fildislist;
  var ind,ind2: integer;
begin
  risfaclistbox.clear;
  rfgroupbox.caption:='Diseases currently included:';
  for ind:=0 to diseaselist.count-1 do
  begin
    risfaclistbox.items.add(Tdisease(diseaselist.items[ind]).name);
    for ind2:=0 to curdislist.count-1 do
     if Tdisease(diseaselist.items[ind]).name=
       Tdisease(curdislist.items[ind2]).name then
        risfaclistbox.state[ind]:=cbchecked;
  end;
  butposities;
end;


procedure TrunForm.cancelbutClick(Sender: TObject);

begin
  Close;
end;


procedure TrunForm.DonebutClick(Sender: TObject);

var ind:integer;
begin
  close;
  if rfchoice then
  begin
    currflist.clear;
    with risfaclistbox do
      for ind:=0 to items.count-1 do
       if state[ind]=cbchecked then
        currflist.add(Tgenentity(riskfactorlist.items[ind]))
  end else
  begin
    curdislist.clear;
    curipmlist.clear;
    curdisdalylist.clear;
    with risfaclistbox do
      for ind:=0 to items.count-1 do
       if state[ind]=cbchecked then
           Tdisease(diseaselist.items[ind]).curlijstvoegtoe(ind);
  end;
  with mainform do
  begin
    if repeatrun then delcur;
    repeatrun:=False;
  end;
end;

procedure TrunForm.butposities;
begin
  donebut.left:=butplaats(1,width);
  cancelbut.left:=butplaats(2,width);
end;


procedure TrunForm.RisFacListBoxClick(Sender: TObject);

begin
  with risfaclistbox do
  begin
    if state[itemindex]=cbunchecked then state[itemindex]:=cbchecked
       else state[itemindex]:=cbunchecked;
  end;{with}
end;


procedure TrunForm.FormResize(Sender: TObject);
begin
  butposities;
end;

procedure TrunForm.FormCreate(Sender: TObject);
begin
  geautoscale(runform);
end;

end.
