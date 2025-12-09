unit GetnameUnit;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TGetnameform = class(TForm)
    NameEdit: TEdit;
    BotPanel: TPanel;
    OKBut: TButton;
    CancelBut: TButton;
    GetnameLabel: TLabel;
    procedure OKButClick(Sender: TObject);
    procedure CancelButClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Getnameform: TGetnameform;

implementation

{$R *.lfm}





procedure TGetnameform.OKButClick(Sender: TObject);
begin
  close;
  modalresult:=mrOK;
end;

procedure TGetnameform.CancelButClick(Sender: TObject);
begin
  close;
  modalresult:=mrCancel;
end;

end.
