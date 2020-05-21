unit parasel;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TParaselForm = class(TForm)
    BotPanel: TPanel;
    CloseBut: TButton;
    RiskfacGroup: TGroupBox;
    RFDisGroup: TGroupBox;
    DisGroup: TGroupBox;
    PopGroup: TGroupBox;
    RRCheck: TCheckBox;
    RemRRCheck: TCheckBox;
    CUMCheck: TCheckBox;
    LATCheck: TCheckBox;
    LAGCheck: TCheckBox;
    AgeCheck: TCheckBox;
    PeriodCheck: TCheckBox;
    ColevelCheck: TCheckBox;
    PrevlevelCheck: TCheckBox;
    CodistCheck: TCheckBox;
    PrevdistCheck: TCheckBox;
    procedure CloseButClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ParaselForm: TParaselForm;

implementation

{$R *.DFM}

procedure TParaselForm.CloseButClick(Sender: TObject);
begin
  Close;
end;

end.
