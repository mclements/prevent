unit Fkies;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FileCtrl, StdCtrls, ExtCtrls;

type
  TFkiesForm = class(TForm)
    DirectoryListBox1: TDirectoryListBox;
    DriveComboBox1: TDriveComboBox;
    FileListBox1: TFileListBox;
    Panel1: TPanel;
    OKBut: TButton;
    EscBut: TButton;
    FilterComboBox1: TFilterComboBox;
    AppendGroup: TRadioGroup;
    FileGroup: TGroupBox;
    Edit1: TEdit;
    procedure DirectoryListBox1Change(Sender: TObject);
    procedure DriveComboBox1Change(Sender: TObject);
    procedure EscButClick(Sender: TObject);
    procedure FileListBox1Change(Sender: TObject);
    procedure OKButClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DatabaseButClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


var
  FkiesForm: TFkiesForm;
  curnaam:string;


implementation

uses GESCALE,WINGLOB,OUTOP;

{$R *.lfm}

procedure TFkiesForm.DirectoryListBox1Change(Sender: TObject);
begin
  FileListBox1.Directory := DirectoryListBox1.Directory;
end;

procedure TFkiesForm.DriveComboBox1Change(Sender: TObject);
begin
  DirectoryListBox1.Drive := DriveComboBox1.Drive;
end;

procedure TFkiesForm.EscButClick(Sender: TObject);
begin
  outopform.terug:=true;
  close;
end;

procedure TFkiesForm.FileListBox1Change(Sender: TObject);
begin
  edit1.text:=FileListBox1.filename;
end;

procedure TFkiesForm.OKButClick(Sender: TObject);

var tmpstr,t2:string;

begin
  if edit1.Text='' then MessageDlg('No file name selected', mtError, [mbOK], 0)
  else
  begin
    tmpstr:=Copy(filtercombobox1.mask,2,5);
    t2:=Copy(edit1.Text,Length(edit1.Text)-3,4);
    if not (Copy(edit1.Text,Length(edit1.Text)-3,4)=tmpstr)
      then edit1.Text:=edit1.Text+tmpstr;
    outopform.padstring:=expandfilename(edit1.Text);
    outopform.terug:=false;
    close;
  end;
end;


procedure TFkiesForm.FormCreate(Sender: TObject);
begin
  geautoscale(FkiesForm);
  caption:='Prevent - Output file';
end;

procedure TFkiesForm.DatabaseButClick(Sender: TObject);
begin
  close;
end;

end.
