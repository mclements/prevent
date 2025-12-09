unit datmod1;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, {LMessages, Messages,} SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  sqldb, Db, sqlite3conn {,DAODatabase, DAODataset, DAOQuery};

type
  TDataModule2 = class(TDataModule)
    SQLTransaction1, SQLTransaction2: TSQLTransaction;
    DataSource1: TDataSource;
    Preventinput: TSQLite3Connection;
    InputQ1: TSQLQuery;
    InputQ2: TSQLQuery;
    Preventoutput: TSQLite3Connection;
    outputQ1: TSQLQuery;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule2: TDataModule2;

implementation



{$R *.lfm}

end.
