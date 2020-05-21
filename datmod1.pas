unit datmod1;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  sqldb, Db, DAODatabase, DAODataset, DAOQuery;

type
  TDataModule2 = class(TDataModule)
    DataSource1: TDataSource;
    Preventinput: TDAODatabase;
    InputQ1: TDAOQuery;
    InputQ2: TDAOQuery;
    Preventoutput: TDAODatabase;
    outputQ1: TDAOQuery;
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
