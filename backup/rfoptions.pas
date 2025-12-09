unit rfoptions;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,DisUnit, ComCtrls;

type
  TRFOpForm = class(TForm)
    Panel1: TPanel;
    OKBut: TButton;
    EscBut: TButton;
    Panel2: TPanel;
    Panel3: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure EscButClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure OKButClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
   risfac:Tgenentity;
  end;

var
  RFOpForm: TRFOpForm;

implementation

{$R *.lfm}
uses GESCALE,{WINGLOB,}INITIAL;

procedure TRFOpForm.FormCreate(Sender: TObject);
begin
  geautoscale(RFOpForm);
  caption:='Prevent - '+currentdataset;
end;

procedure TRFOpForm.EscButClick(Sender: TObject);
begin
  close;
end;

procedure TRFOpForm.FormActivate(Sender: TObject);
begin
  panel2.caption:='Options for the risk factor '+risfac.name;
end;

procedure TRFOpForm.OKButClick(Sender: TObject);
begin
  close;
end;

end.
