unit Disoptions;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  disunit, StdCtrls, ExtCtrls;

type
  TDisopForm=class(TForm)
    Panel1: TPanel;
    OKBut: TButton;
    EscBut: TButton;
    Panel3: TPanel;
    CfatGroup: TGroupBox;
    CfatCheck: TCheckBox;
    Cfatboth: TCheckBox;
    InciGroup: TGroupBox;
    InciCheck: TCheckBox;
    Inciboth: TCheckBox;
    RemiGroup: TGroupBox;
    RemiCheck: TCheckBox;
    Remiboth: TCheckBox;
    DisabGroup: TGroupBox;
    Dalycheck: TCheckBox;
    Dalyboth: TCheckBox;
    CostGroup: TGroupBox;
    CostCheck: TCheckBox;
    Costboth: TCheckBox;
    procedure OKButClick(Sender: TObject);
    procedure EscButClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure InciCheckClick(Sender: TObject);
    procedure CfatCheckClick(Sender: TObject);
    procedure RemiCheckClick(Sender: TObject);
  private
    { Private declarations }
    kop,qstr,mes:string;
    function haalpredef:integer;
  public
    { Public declarations }
    ziekte:Tdisease;
    procedure incienabled(aan:boolean);
    procedure setdisop;
  end;

var
  DisopForm: TDisopForm;

implementation

{$R *.DFM}
uses gescale,winglob,initial, PredefintUnit, Dataset, datmod1;


procedure TDisopForm.OKButClick(Sender: TObject);
begin
  close;
end;

procedure TDisopForm.EscButClick(Sender: TObject);
begin
  close;
end;

procedure TDisopForm.incienabled(aan:boolean);
begin
  InciCheck.enabled:=aan;
  Inciboth.enabled:=aan;
end;

procedure TDisopForm.setdisop;
begin
  InciCheck.state:=cbunchecked;
  Inciboth.state:=cbunchecked;
  remiCheck.state:=cbunchecked;
  remiboth.state:=cbunchecked;
  cfatCheck.state:=cbunchecked;
  cfatboth.state:=cbunchecked;
  dalyCheck.state:=cbunchecked;
  dalyboth.state:=cbunchecked;
  costCheck.state:=cbunchecked;
  costboth.state:=cbunchecked;
end;

procedure TDisopForm.FormCreate(Sender: TObject);
begin
  geautoscale(DisOpForm);
end;

procedure TDisopForm.InciCheckClick(Sender: TObject);

begin
  if incicheck.state=cbchecked then
  with datasetform do
  begin
    kop:='Incidence scenarios for '+ziekte.name;
    qstr:='SELECT distinct Interventionname FROM Diseaseinterventions where Diseasename='
         +psq(ziekte.name)+' and param='+psq('incidence');
    mes:='No incidence scenarios defined for '+ziekte.name;
    if haalpredef=mrOK then
    begin
      if incionlybool then
      begin
        ziekte.dismortrendbool:=true;
        ziekte.dismortrendnaam:=PredefintForm.predefchecklist.items[PredefintForm.predefchecklist.itemindex];
      end else
      begin
        Tipm(ziekte).disincitrendbool:=true;
        Tipm(ziekte).disincitrendnaam:=PredefintForm.predefchecklist.items[PredefintForm.predefchecklist.itemindex];
      end;
    end;
  end;
end;




function TDisopForm.haalpredef:integer;
begin
  PredefintForm.caption:=kop;
  PredefintForm.predefchecklist.clear;
  with datasetform do
  begin
    putquery1(qstr);
    with datamodule2.inputQ1 do
    begin
      first;
      while not eof do
      begin
        PredefintForm.predefchecklist.Items.Add(fields[0].asstring);
        next;
      end;
    end;
  end;{with}
  if PredefintForm.predefchecklist.items.count=0 then
  begin
    MessageDlg(mes, mtError, [mbOK], 0);
    incicheck.state:=cbunchecked;
    result:=-1;
  end else result:=PredefintForm.showmodal;
end;

procedure TDisopForm.CfatCheckClick(Sender: TObject);
var
  varstr:string;
begin
  if ziekte is Tipm then varstr:='case fatality' else varstr:='mortality';
  if cfatcheck.state=cbchecked then
  with datasetform do
  begin
    kop:=varstr+' scenarios for '+ziekte.name;
    qstr:='SELECT distinct Interventionname FROM Diseaseinterventions where Diseasename='
         +psq(ziekte.name)+' and param='+psq(varstr);
    mes:='No '+varstr+' scenarios defined for '+ziekte.name;
    if haalpredef=mrOK then
    begin
      ziekte.dismortrendbool:=true;
      ziekte.dismortrendnaam:=PredefintForm.predefchecklist.items[PredefintForm.predefchecklist.itemindex];
    end;
  end;
end;

procedure TDisopForm.RemiCheckClick(Sender: TObject);
begin
  if remicheck.state=cbchecked then
  with datasetform do
  begin
    kop:='Remission scenarios for '+ziekte.name;
    qstr:='SELECT distinct Interventionname FROM Diseaseinterventions where Diseasename='
         +psq(ziekte.name)+' and param='+psq('remission');
    mes:='No remission scenarios defined for '+ziekte.name;
    if haalpredef=mrOK then
    begin
      Thazard3(ziekte).disremitrendbool:=true;
      Thazard3(ziekte).disremitrendnaam:=PredefintForm.predefchecklist.items[PredefintForm.predefchecklist.itemindex];
    end;
  end;
end;

end.
