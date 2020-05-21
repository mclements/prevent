unit Aboutun;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, GIFImage;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    ProgramIcon: TImage;
    Version: TLabel;
    Copyright: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure ProgramIconClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure VersionClick(Sender: TObject);
    procedure CopyrightClick(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;

implementation


{$R *.DFM}

procedure TAboutBox.FormCreate(Sender: TObject);
begin
  version.caption:='Version 3.01 (beta)';
end;

procedure TAboutBox.Panel1Click(Sender: TObject);
begin
  aboutbox.close;
end;

procedure TAboutBox.ProgramIconClick(Sender: TObject);
begin
  aboutbox.close;
end;

procedure TAboutBox.Image1Click(Sender: TObject);
begin
  aboutbox.close;
end;

procedure TAboutBox.VersionClick(Sender: TObject);
begin
  aboutbox.close;
end;

procedure TAboutBox.CopyrightClick(Sender: TObject);
begin
  aboutbox.close;
end;

procedure TAboutBox.Label3Click(Sender: TObject);
begin
  aboutbox.close;
end;

procedure TAboutBox.Label4Click(Sender: TObject);
begin
  aboutbox.close;
end;

procedure TAboutBox.Image2Click(Sender: TObject);
begin
  aboutbox.close;
end;

end.
 
