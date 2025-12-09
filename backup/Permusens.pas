unit Permusens;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Spin;

type
  TPermuForm = class(TForm)
    BotPanel: TPanel;
    CloseBut: TButton;
    PermuRadio: TRadioGroup;
    RangeGroup: TGroupBox;
    RangeSpin: TSpinEdit;
    ChooseBut: TButton;
    LabGroup: TGroupBox;
    Label1: TLabel;
    procedure ChooseButClick(Sender: TObject);
    procedure CloseButClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PermuForm: TPermuForm;

implementation

{$R *.lfm}

uses Sensunit;

procedure TPermuForm.ChooseButClick(Sender: TObject);

var sensnum:Tsensnum;

begin
  label1.Caption:=label1.Caption+' '+IntToStr(rangespin.Value);
  sensnum:=Tsensnum.Create(rangespin.Value);
  sensform.rangelist.Add(sensnum);
  if (rangespin.Value<100) and (rangespin.Value<>0) then
  begin
    sensnum:=Tsensnum.Create(-rangespin.Value);
    sensform.rangelist.Add(sensnum);
  end;
end;

procedure TPermuForm.CloseButClick(Sender: TObject);
begin
  Close;
end;

procedure TPermuForm.FormActivate(Sender: TObject);
var inr:integer;
begin
  label1.Caption:='';
  rangespin.Value:=0;
  for inr:=0 to sensform.rangelist.Count-1 do
    Tsensnum(sensform.rangelist.Items[inr]).Free;
end;

end.
