unit Popoptions;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, {LMessages, Messages,} SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TPopopForm = class(TForm)
    OKBut: TButton;
    EscBut: TButton;
    Panel3: TPanel;
    realpop: TRadioGroup;
    MigrGroup: TGroupBox;
    MigratieCheck: TCheckBox;
    Migrboth: TCheckBox;
    OtherMorGroup: TGroupBox;
    OvMortTrendCheck: TCheckBox;
    Trendboth: TCheckBox;
    FertGroup: TGroupBox;
    FertCheck: TCheckBox;
    fertBoth: TCheckBox;
    procedure OKButClick(Sender: TObject);
    procedure EscButClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure realpopClick(Sender: TObject);
    procedure MigratieCheckClick(Sender: TObject);
    procedure OvMortTrendCheckClick(Sender: TObject);
    procedure FertCheckClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure selectscen(check:boolean;tafel,kop,fout:string;var scennaam:string;var scenbool:boolean);
    procedure setpopop;
  end;

var
  PopopForm: TPopopForm;

implementation

{$R *.lfm}
uses GESCALE,{WINGLOB,}INITIAL,PredefintUnit, DATASET, datmod1,BEVOLUN, PREVMAIN;


procedure TPopopForm.OKButClick(Sender: TObject);
begin
  close;
end;

procedure TPopopForm.EscButClick(Sender: TObject);
begin
  close;
end;

procedure TPopopForm.FormActivate(Sender: TObject);
begin
  caption:='Prevent population options - '+currentdataset;
end;

procedure TPopopForm.FormCreate(Sender: TObject);
begin
  geautoscale(popopForm);
end;

procedure TPopopForm.realpopClick(Sender: TObject);
begin
  with mainform do
  begin
    if repeatrun then delcur;
    repeatrun:=False;
  end;
  if realpop.itemindex=0 then
  begin
    migratiecheck.enabled:=true;
  end else
  begin
    migratiecheck.state:=cbunchecked;
    migratiecheck.enabled:=false;
  end;
end;


procedure TPopopForm.selectscen(check:boolean;tafel,kop,fout:string;var scennaam:string;var scenbool:boolean);
var
  predefresult:integer;

begin
  if check then
  begin
    PredefintForm.predefchecklist.clear;
    with datasetform do
    begin
      putquery1('SELECT distinct Interventionname FROM '+tafel);
      with datamodule2.inputQ1 do
      begin
        first;
        while not eof do
        begin
          PredefintForm.predefchecklist.Items.Add(fields[0].asstring);
          next;
        end;
        close;
      end;
      datamodule2.SQLTransaction1.Commit;
    end;{with datasetform}
    if PredefintForm.predefchecklist.items.count>0 then
    begin
      PredefintForm.caption:=kop;
      Predefresult:=PredefintForm.showmodal;
      if predefresult=mrOK then
      begin
        scenbool:=true;
        scennaam:=PredefintForm.predefchecklist.items[PredefintForm.predefchecklist.itemindex];
      end else MessageDlg(fout, mtError, [mbOK], 0);
    end;
  end;
end;


procedure TPopopForm.MigratieCheckClick(Sender: TObject);

begin
  selectscen(migratiecheck.state=cbchecked,'Migration','Migration scenarios',
     'No migration scenarios defined',population.migrationnaam,population.migrationbool);
end;

procedure TPopopForm.OvMortTrendCheckClick(Sender: TObject);

begin
  selectscen(ovmorttrendcheck.state=cbchecked,'Othermortalitytrend','Other mortality trend scenarios',
   'No other mortality trend scenarios defined',population.ovmortrendnaam,population.ovmortrendbool);
end;

procedure TPopopForm.FertCheckClick(Sender: TObject);
begin
  selectscen(fertcheck.state=cbchecked,'Birthrates','Birth rates trend scenarios',
   'No birth rates trend scenarios defined',population.BirthRatenaam,population.birthratebool);
end;

procedure TPopopForm.setpopop;
begin
  ovmorttrendcheck.state:=cbunchecked;
  trendboth.state:=cbunchecked;
  population.ovmortrendbool:=false;
  migratiecheck.state:=cbunchecked;
  migrboth.state:=cbunchecked;
  population.migrationbool:=false;
  fertcheck.state:=cbunchecked;
  fertboth.state:=cbunchecked;
  population.birthratebool:=false;
end;


end.
