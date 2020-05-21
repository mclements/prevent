unit OUTOP;

{$MODE Delphi}

interface

uses
  SysUtils, LCLIntf, LCLType, LMessages, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls,INITIAL, Spin, ComCtrls;

type
  Toutopform = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    chartGroup: TRadioGroup;
    closebut: TButton;
    hdpop: TRadioGroup;
    DynGroup: TGroupBox;
    syncheck: TCheckBox;
    ExpecGroup: TGroupBox;
    ExpecageSpin: TSpinEdit;
    ageLabel: TLabel;
    Dynspeed: TTrackBar;
    FastLabel: TLabel;
    SlowLabel: TLabel;
    PlaybackLabel: TLabel;
    fileSaveDialog: TSaveDialog;
    poppropbox: TGroupBox;
    AgLabel: TLabel;
    proppopSpin: TSpinEdit;
    deeldoorbox: TGroupBox;
    PopdivCombo: TComboBox;
    charty0box: TGroupBox;
    Y0Check: TCheckBox;
    MoneyBox: TGroupBox;
    MoneydivComboBox: TComboBox;
    procedure closebutClick(Sender: TObject);
    procedure chartGroupClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ExpecageSpinChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure proppopSpinChange(Sender: TObject);
    procedure PopdivComboChange(Sender: TObject);
    procedure MoneydivComboBoxChange(Sender: TObject);
  private
    { Private declarations }
    fileopen:boolean;
    function fileoverschrijf(FileName:string):boolean;
  public
    { Public declarations }
    FStream: TFileStream;
    padstring:string;
    eenheid:double;
    terug:boolean;
    expecleeft:integer;
    geensel,tijdgraf,aanplak:Boolean;
    incidentieuitvoer:boolean;
    incidentieziekte:integer;
  end;

var
  outopform: Toutopform;

implementation

{$R *.lfm}

uses GESCALE,WINGLOB,PREVMAIN,BEVOLUN,Tabeluit,DisUnit,OutvarUnit;


procedure Toutopform.closebutClick(Sender: TObject);
var
  tmpstr:string;

begin
  if chartgroup.itemindex=2 then
  begin
    if fileopen then
    begin
      FStream.Free;
      fileopen:=false;
    end;
    filesavedialog.DefaultExt:='csv';
    FilesaveDialog.Filter := 'Comma delimited files (*.csv)|*.csv';
    if filesavedialog.execute and fileoverschrijf(filesavedialog.FileName) then
    begin
      try
        FStream := TFileStream.Create(filesavedialog.FileName, fmCreate);
        fileopen:=true;
        tmpstr:='"Prevent results, date: ' + DateToStr(Date)+
          ', time: ' + TimeToStr(Time)+'"'+char(10);
        fstream.writebuffer(PChar(tmpstr)^,length(tmpstr));
        tmpstr:='"Input data set: '+currentdataset+'"'+char(10);
        fstream.writebuffer(PChar(tmpstr)^,length(tmpstr));
        tmpstr:=''+char(10);
        fstream.writebuffer(PChar(tmpstr)^,length(tmpstr));
        close;
      except
        on E:Exception do ShowMessage(e.message);
      end;
    end;
  end else
  begin
    if fileopen then
    begin
      FStream.Free;
      fileopen:=false;
    end;
    Close;
  end;
end;

function Toutopform.fileoverschrijf(FileName:string):boolean;
begin
  Result:=true;
  if FileExists(FileName) then
  if MessageDlg('File ' + ExtractFileName(FileName)+
     ' already exists. Do you want to overwrite it?', mtConfirmation, [mbYes, mbCancel], 0)=mrCancel
  then Result:=false;
end;


procedure Toutopform.chartGroupClick(Sender: TObject);
begin
  graphbool:=chartgroup.itemindex=0;
end;

procedure Toutopform.FormCreate(Sender: TObject);
begin
  closebut.left:=butplaats(1,width);
  geautoscale(outopform);
  eenheid:=1000000.0;
  globdeeldoor:=1000;
  expecleeft:=0;
  fileopen:=False;
  moneydivcombobox.Items.Add('units');
  moneydivcombobox.Items.Add('thousands');
  moneydivcombobox.Items.Add('millions');
  moneydivcombobox.Items.Add('billions');
  moneydivcombobox.ItemIndex:=2;
end;

procedure Toutopform.MoneydivComboBoxChange(Sender: TObject);
begin
  case moneydivcombobox.ItemIndex of
    0:begin
        eenheid:=1.0;
        hdnumstancost[false]:=' ('+population.costunit+')';
      end;
    1:begin
        eenheid:=1000.0;
        hdnumstancost[false]:=' (thousands of '+population.costunit+')';
      end;
    2:begin
        eenheid:=1000000.0;
        hdnumstancost[false]:=' (millions of '+population.costunit+')';
      end;
    3:begin
        eenheid:=1000000000.0;
        hdnumstancost[false]:=' (billions of '+population.costunit+')';
      end;
  end;
end;

procedure Toutopform.ExpecageSpinChange(Sender: TObject);
begin
  expecleeft:=expecagespin.value;
end;

procedure Toutopform.FormActivate(Sender: TObject);
begin
  proppopspin.MaxValue:=disaggmax;
  expecagespin.MaxValue:=disaggmax;
  popdivcombo.text:=inttostr(globdeeldoor);
end;

procedure Toutopform.proppopSpinChange(Sender: TObject);
begin
 { mainform.ListBoxpop.items.Strings[2]:=
    '  Population age '+inttostr(proppopSpin.Value)+' and over (%)'}
end;

procedure Toutopform.PopdivComboChange(Sender: TObject);
begin
  globdeeldoor:=strtoint(popdivcombo.text);
end;


end.
