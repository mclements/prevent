unit memomes;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TMemoForm = class(TForm)
    Memo1: TMemo;
    BotPanel: TPanel;
    closebut: TButton;
    ClearBut: TButton;
    procedure FormCreate(Sender: TObject);
    procedure closebutClick(Sender: TObject);
    procedure ClearButClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function addmessage(bood:string):Boolean;
    procedure savememo2db;
  end;

var
  MemoForm: TMemoForm;

implementation

{$R *.lfm}

uses GESCALE,datmod1,DATASET;

procedure TMemoForm.FormCreate(Sender: TObject);
begin
  geautoscale(MemoForm);
  memo1.clear;
  caption:='Prevent - Messages';
end;

procedure TMemoForm.savememo2db;

var tmpstr,tmp2str:string;
     Index:integer;

begin
  tmpstr:='INSERT INTO Outputdescription (Runmessages) values (';
  tmp2str:='';
  for Index:=0 to memo1.Lines.Count-1 do
    tmp2str:=tmp2str+memo1.Lines[Index];
  tmpstr:=tmpstr+datasetform.psq(tmp2str);
  with datasetform do
  execuitquery1(tmpstr+')');
end;

function TMemoForm.addmessage(bood:string):Boolean;
begin
  memo1.lines.add(bood);
  result:=true;
end;

procedure TMemoForm.closebutClick(Sender: TObject);
begin
  close;
end;

procedure TMemoForm.ClearButClick(Sender: TObject);
begin
  memo1.clear;
end;

end.
