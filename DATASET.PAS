unit DATASET;

{$MODE Delphi}

interface

uses
  SysUtils, LCLIntf, LCLType, {LMessages, Messages,} Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, inifiles, ComCtrls, Menus;

const GDPstring:string='GDP per capita';
      Totalmortstring:string='Total mortality';
      birthstring:string='Births';
      smokingstring:string='Smoking';

type
  TdatasetForm = class(TForm)
    Panel1: TPanel;
    closebut: TButton;
    DataPage: TPageControl;
    CurrentTab: TTabSheet;
    DatasetList: TListBox;
    NewTab: TTabSheet;
    FileOpenDialog: TOpenDialog;
    InstallBox: TGroupBox;
    setnameEdit: TLabeledEdit;
    BestandEdit: TLabeledEdit;
    BrowseBut: TButton;
    SaveBut: TButton;
    UninstallBox: TGroupBox;
    UninstallCombo: TComboBox;
    UninstBut: TButton;
    procedure closebutClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BrowseButClick(Sender: TObject);
    procedure SaveButClick(Sender: TObject);
    procedure CurrentTabEnter(Sender: TObject);
    procedure UninstButClick(Sender: TObject);
   private
    { Private declarations }
   procedure openset;
   procedure closeset;
   procedure datainisets;
  public
    { Public declarations }
    function d2s(drijf:double):string;
    function psq(instring:string):string;
    procedure currentset;
    procedure namen;
    procedure leescurset;
    procedure leescurrfdis;
    procedure verlaatset;
    procedure putquery1(qstring:string);
    procedure putquery2(qstring:string);
    procedure execquery1(qstring:string);
    procedure execuitquery1(qstring:string);
  end;

var
  datasetForm: TdatasetForm;


implementation

{$R *.lfm}

uses GESCALE,WINGLOB, datmod1,sqlite3conn,sqldb,db,{PREVMAIN,} INITIAL,DisUnit,BEVOLUN,
  RUNOP,math;

const
  rlijnhoogte=30;

function Tdatasetform.psq(instring:string):string;

begin
  instring:='"'+instring+'"';
  result:=instring;
end;

function Tdatasetform.d2s(drijf:double):string;
var
  tmpstr:string;
begin
  str(drijf,tmpstr);
  result:=tmpstr;
end;


procedure tdatasetform.currentset;

begin
  if not nodata then
  with datasetlist do
    currentdataset:=items[itemindex];
end;

procedure TdatasetForm.CurrentTabEnter(Sender: TObject);
begin
  namen;
end;


procedure tdatasetform.namen;

var ind:integer;

begin
  with datasetlist do
  begin
   items.clear;
   for ind:=0 to bestandenlist.count-1 do
     items.add(Tbestandtype(bestandenlist.items[ind]).naam);
   ind:=0;
   while (Tbestandtype(bestandenlist.items[ind]).naam<>currentdataset)
   and  (ind<bestandenlist.count-1) do inc(ind);
   currentpad:=Tbestandtype(bestandenlist.items[ind]).pad;
   itemindex:=ind;
  end;
  with uninstallcombo do
  begin
   items.clear;
   for ind:=0 to bestandenlist.count-1 do
     items.add(Tbestandtype(bestandenlist.items[ind]).naam);
   itemindex:=-1;
   text:='Choose dataset to uninstall';
  end;
end;

procedure TdatasetForm.BrowseButClick(Sender: TObject);
var
  tmpstr:string;
  ind:integer;
  albool:boolean;
begin
  with FileOpenDialog do
  begin
    initialdir:=currentpad;
    title:='File name for database';
    if execute then
    begin
      tmpstr:=filename;
      albool:=false;
      for ind:=0 to bestandenlist.count-1 do
         albool:=(tmpstr=Tbestandtype(bestandenlist.items[ind]).pad) or albool;
      if albool then MessageDlg('File is already installed.', mtError, [mbOK], 0)
      else
      begin
        bestandedit.Text:=filename;
        if setnameedit.Text='' then
        begin
          tmpstr:=extractfilename(filename);
          setnameedit.Text:=copy(tmpstr,0,length(tmpstr)-4);
        end;
      end;
    end;
  end;
end;

procedure TdatasetForm.SaveButClick(Sender: TObject);
var
  inifile:Tinifile;
  bestandtype:Tbestandtype;

begin
  bestandtype:=Tbestandtype.create(setnameedit.Text,bestandedit.Text);
  bestandenlist.Add(bestandtype);
  IniFile := TIniFile.Create(extractfilepath(paramstr(0))+'Prevent.ini');
  with inifile do
  begin
    WriteString('Data Sets','x'+inttostr(bestandenlist.Count),bestandtype.naam);
    WriteString('Set paden','xp'+inttostr(bestandenlist.Count),bestandtype.pad);
  end;
  inifile.Free;
  setnameedit.Text:='';
  bestandedit.Text:='';
end;

procedure TdatasetForm.UninstButClick(Sender: TObject);
var
  inifile:Tinifile;
  ind:integer;

begin
  if uninstallcombo.itemindex>-1 then
  if MessageDlg('Are you sure you want to uninstall dataset '+uninstallcombo.items[uninstallcombo.itemindex], mtConfirmation, [mbYes, mbCancel], 0)
    =mrYes then
    begin
      bestandenlist.Delete(uninstallcombo.itemindex);
      IniFile := TIniFile.Create(extractfilepath(paramstr(0))+'Prevent.ini');
      with inifile do
      begin
        erasesection('Data Sets');
        for ind:=0 to bestandenlist.count-1 do
          WriteString('Data Sets','x'+inttostr(ind+1),Tbestandtype(bestandenlist.items[ind]).naam);
        erasesection('Set paden');
        for ind:=0 to bestandenlist.count-1 do
          WriteString('Set paden','xp'+inttostr(ind+1),Tbestandtype(bestandenlist.items[ind]).pad);
      end;
      inifile.Free;
      uninstallcombo.itemindex:=-1;
      uninstallcombo.text:='Choose dataset to uninstall';
    end;
end;


procedure TdatasetForm.openset;
begin
  with datamodule2 do
  begin
   preventInput := TSQLite3Connection.Create(nil);
   SQLTransaction1 := TSQLTransaction.Create(nil);
   preventInput.Transaction := SQLTransaction1;
   preventinput.DatabaseName := currentpad;
   InputQ1 := TSQLQuery.Create(nil);
   InputQ1.Database := preventInput;
   InputQ2 := TSQLQuery.Create(nil);
   InputQ2.Database := preventInput;
   InputQ1.PacketRecords := -1; // !#?
   InputQ2.PacketRecords := -1; // !#?
   preventInput.open;
  end;
end;

procedure TdatasetForm.closeset;
begin
  with datamodule2 do
  begin
    preventinput.connected:=false;
  end;
end;

procedure TdatasetForm.putquery1(qstring:string);

begin
  qstring:=qstring+';';
  with datamodule2.inputQ1 do
  begin
    Active:=false;
    SQL.clear;
    SQL.Add(qstring);
    datamodule2.SQLTransaction1.StartTransaction;
    try
      Active:=true;
    except
      on E:Edatabaseerror do begin ShowMessage(e.message); datamodule2.SQLTransaction1.Rollback; end;
    end;
  end;
end;

procedure TdatasetForm.execquery1(qstring:string);

begin
  qstring:=qstring+';';
  with datamodule2.inputQ1 do
  begin
    Active:=false;
    SQL.clear;
    SQL.Add(qstring);
    try
      {execute(7);}
      Open;
    except
      on E:Edatabaseerror do ShowMessage(e.message);
    end;
  end;
end;

procedure TdatasetForm.execuitquery1(qstring:string);

begin
  qstring:=qstring+';';
  with datamodule2.outputQ1 do
  begin
    Active:=false;
    SQL.clear;
    SQL.Add(qstring);
    try
      {execute(7);}
      Open;
    except
      on E:Edatabaseerror do ShowMessage(e.message);
    end;
  end;
end;

procedure TdatasetForm.putquery2(qstring:string);

begin
  qstring:=qstring+';';
  with datamodule2.inputQ2 do
  begin
    Active:=false;
    SQL.clear;
    SQL.Add(qstring);
    Active:=true;
  end;
end;


procedure TdatasetForm.datainisets;

var
    ind,cn:integer;
    cohortrf:boolean;
    field:TField;

begin
  population:=Tpopulation.create;
  with population do
  begin
    putquery1('SELECT Baseyear,HiAge,PopulationProjection,ProjectionMax,IncidenceOnly,Disability,costs, costunit FROM GENERALTAB');
    with datamodule2.inputQ1 do
    begin
      first;
      beginjaar:=Fieldbyname('BaseYear').AsInteger;
      disaggmax:=Fieldbyname('HiAge').AsInteger;
      readpopproj:=Fieldbyname('PopulationProjection').Asboolean ;
      if readpopproj then projmax:=Fieldbyname('ProjectionMax').AsInteger
         else projmax:=750;
      incionlybool:=Fieldbyname('IncidenceOnly').Asboolean ;
      dalebool:=Fieldbyname('Disability').Asboolean ;
      costbool:=Fieldbyname('Costs').Asboolean;
      if costbool then
      begin
        costunit:=trim(Fieldbyname('Costunit').AsString);
        hdnumstancost[true]:=' ('+costunit+' per person)';
        hdnumstancost[false]:=' (millons of '+costunit+')';
      end;
      close;
    end;
    datamodule2.SQLTransaction1.Commit;
  aggmax:=disaggmax div 5;
  restagg:=disaggmax-aggmax*5+1;
  disaggmax1:=disaggmax+1;
  end;{with population}
  runopform.spinrun.maxvalue:=projmax;
  runopform.spinrun.Value:=min(projmax,75);
  et:=runopform.spinrun.value;

  putquery1('SELECT * FROM DiseasesAndRiskFactors');
  with datamodule2.inputQ1 do
  begin
    first;
    while not eof do
    begin
      if fieldbyname('Disease').Asboolean then {Het is een ziekte}
      begin
        if Fieldbyname('MortalityOnly').Asboolean then {alleen sterfte}
        begin
          disease:=Tdisease.Create(Fieldbyname('Name').asstring);
          diseaselist.add(disease);
        end else
        if incionlybool then {alleen incidentie}
        begin
          disease:=Tincionly.Create(Fieldbyname('Name').asstring);
          diseaselist.add(disease);
        end else
        begin
          if Fieldbyname('Remission').Asboolean then
          begin
            disease:=Thazard3.Create(Fieldbyname('Name').asstring);
            disremilist.add(disease);
          end else disease:=Tipm.Create(Fieldbyname('Name').asstring);
          diseaselist.add(disease);
          ipmlist.add(disease);
          Tipm(disease).costbool:=Fieldbyname('Costs').Asboolean; {Costs?}
          if Tipm(disease).costbool then discostlist.add(disease);
          Tipm(disease).dalybool:=Fieldbyname('Disability').Asboolean; {Disability?}
          if Tipm(disease).dalybool then disdalylist.add(disease);
          Tipm(disease).rftoobool:=Fieldbyname('Riskfactortoo').Asboolean; {Ziekte als risicofactor?}
          if Tipm(disease).rftoobool then
          begin
            disease.lookback:=Fieldbyname('Lookback').Asinteger;
            disease.catno:=2;
            setlength(disease.catnames,2);
            disease.catnames[0]:='Non-diseased';
            disease.catnames[1]:='Diseased';
          end;
        end;
      end else {het is een risicofactor}
      begin
        field := FindField('CohortPrev');
        if Assigned(field) then
          cohortrf:=field.Asboolean
        else cohortrf := false;
        if Fieldbyname('Continuous').Asboolean then {continue rf}
          riskfactor:=Tconrf.Create(Fieldbyname('Name').asstring)
        else {het is een category rf}
          if cohortrf then riskfactor:=Tcatrfcohort.Create(Fieldbyname('Name').asstring)
          else riskfactor:=Tcatrf.Create(Fieldbyname('Name').asstring);
        riskfactor.lookback:=Fieldbyname('Lookback').Asinteger;
        riskfactorlist.add(riskfactor);
      end;
      next;
    end;
    close;
  end; {with inputq1}
  datamodule2.SQLTransaction1.Commit;

  for ind:=0 to riskfactorlist.count-1 do
    if Tgenentity(riskfactorlist.items[ind]) is Tcatrf then
    begin
      putquery1('SELECT * FROM CatrfCats where Riskfactorname='
        +psq(Tcatrf(riskfactorlist.items[ind]).name)+' order by Catno');
      with datamodule2.inputQ1 do
      begin
        with Tcatrf(riskfactorlist.items[ind]) do
        begin
          first;
          cn:=0;
          catno:=recordcount;
          setlength(catnames,catno);
          while not eof do
          begin
            catnames[cn]:=Fieldbyname('CatName').asstring;
            inc(cn);
            next;
          end;
        end;
        close;
      end; {with inputq1}
      datamodule2.SQLTransaction1.Commit;
    end;

  for ind:=0 to riskfactorlist.count-1 do
    genentitylist.add(Tgenentity(riskfactorlist.items[ind]));
  for ind:=0 to diseaselist.count-1 do
    genentitylist.add(Tgenentity(diseaselist.items[ind]));
end;

procedure TdatasetForm.leescurrfdis;
var
  ind, lokind:integer;
  tmpstr:string;


begin
  curgenentlist.clear;
  for ind:=0 to currflist.count-1 do
    curgenentlist.add(currflist.items[ind]);
  for ind:=0 to curdislist.count-1 do
    curgenentlist.add(curdislist.items[ind]);
  for ind:=0 to curgenentlist.count-1 do
   with Tgenentity(curgenentlist.items[ind]) do
   begin
     rflist.clear;
     putquery1('SELECT * FROM DiseaseRiskfactorRelation '+
              'where RiskfactorName='+psq(Name));
     with datamodule2.inputQ1 do
     begin
       first;
       while not eof do
       begin
         tmpstr:=trim(Fieldbyname('DiseaseName').AsString);
         lokind:=0;
         while (Tgenentity(curgenentlist.items[lokind]).name<>tmpstr)
           and (lokind<curgenentlist.count-1) do inc(lokind);
         if Tgenentity(curgenentlist.items[lokind]).name=tmpstr then
         begin
           if Tgenentity(curgenentlist.items[ind]) is Tconrf then
           rfdis:=Trfdiscon.Create(Tgenentity(curgenentlist.items[ind]),Tgenentity(curgenentlist.items[lokind]))
           else
           begin
             rfdis:=Trfdiscat.Create(Tgenentity(curgenentlist.items[ind]),Tgenentity(curgenentlist.items[lokind]));
             Trfdiscat(rfdis).RRinterv:=Tcategory(curgenentlist.items[ind]).Rrintervention;
           end;
           with rfdis do
           begin
             cum:=Fields[2].AsInteger;
             lat:=Fields[3].AsInteger;
             lag:=Fields[4].AsInteger;
             latplag:=lat+lag;
             try   //to trap errors that fields5 does not exist
               tmpstr:=trim(Fields[5].AsString);
               if tmpstr='linear' then lagfunc:=lin
               else if tmpstr='exponential' then lagfunc:=expon
               else if tmpstr='logistic' then lagfunc:=logis;
             except
               lagfunc:=lin;
             end;
           end;
           rflist.add(rfdis);
         end;  
         Next;
       end;
       close;
     end;
     datamodule2.SQLTransaction1.Commit;
   end;
end;


procedure TdatasetForm.leescurset;

begin
  namen;
  currentset;
  openset;
  datainisets;
end;

procedure TdatasetForm.verlaatset;

var tind:integer;

begin
  for tind:=0 to diseaselist.count-1 do
    with Tdisease(diseaselist.items[tind]) do  free;
  diseaselist.clear;
  ipmlist.clear;
  for tind:=0 to riskfactorlist.count-1 do
     Tgenentity(riskfactorlist.items[tind]).free;
  riskfactorlist.clear;
  genentitylist.clear;
  curgenentlist.clear;
  disdalylist.clear;
  discostlist.clear;
  population.Free;
  closeset;
end;



procedure TdatasetForm.closebutClick(Sender: TObject);
begin
  Close;
end;


procedure TdatasetForm.FormCreate(Sender: TObject);
begin
  geautoscale(datasetForm);
end;





initialization

finalization  

end.
