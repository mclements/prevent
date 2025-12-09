unit PredefintUnit;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, {LMessages, Messages,} SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CheckLst, ExtCtrls;

type
  TPredefintForm = class(TForm)
    PredefCheckList: TCheckListBox;
    BotPanel: TPanel;
    TopPanel: TPanel;
    DoneBut: TButton;
    CancelBut: TButton;
    procedure DoneButClick(Sender: TObject);
    procedure CancelButClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PredefintForm: TPredefintForm;

implementation

{$R *.lfm}


procedure TPredefintForm.DoneButClick(Sender: TObject);
begin
  close;
  modalresult:=mrOK;
end;

procedure TPredefintForm.CancelButClick(Sender: TObject);
begin
  close;
  modalresult:=mrCancel;
end;

end.
