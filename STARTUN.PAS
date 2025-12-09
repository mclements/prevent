unit STARTUN;

{$MODE Delphi}

interface
Uses
  forms,dialogs,sysutils,inifiles,classes,
  INITIAL
  {,WINGLOB};

Procedure Opening;

implementation


Procedure Opening;

var xls:integer;
    xlsbestand:Tbestandtype;
    inifile:Tinifile;
    names,paden:tstringlist;

procedure geendata;


begin
 MessageDlg('There are no datasets installed', mtwarning,
    [mbOK], 0);
 currentdataset:='No data';
end;

procedure geeninst;

begin
  MessageDlg('Prevent cannot find the installation file', mterror,
    [mbOK], 0);
  Application.Terminate;
end;


begin
  IniFile := TIniFile.Create(extractfilepath(paramstr(0))+'Prevent.ini');
  names:=tstringlist.create;
  paden:=tstringlist.create;
  with inifile do
  begin
    currentdataset:=readstring('current set','current','ERROR');
    readsectionvalues('Data sets',names);
    readsectionvalues('Set paden',paden);
    for xls:=0 to names.count-1 do
    begin
      names.strings[xls]:=names.values['x'+inttostr(xls+1)];
      paden.strings[xls]:=paden.values['xp'+inttostr(xls+1)];
      xlsbestand:=Tbestandtype.create(names.strings[xls],paden.strings[xls]);
      bestandenlist.add(xlsbestand);
    end;
    dbtemplatepad:=readstring('Template pad','templatepad','ERROR');
  end;
  IniFile.Free;
  names.free;
  paden.free;
  Application.HelpFile:=extractfilepath(Application.ExeName)+'prevent.chm';
end;

end.
