unit winglob;

interface

uses initial;

var
  uitbool:boolean;
  graphbool:boolean;
  nodata:boolean;
  pixelschaal:double;


  function butplaats(no,formbreed:integer):integer;

implementation

function butplaats(no,formbreed:integer):integer;

const eerst=110;
      volgend=100;

begin
  if no=1 then butplaats:=formbreed-eerst
     else butplaats:=formbreed-eerst-(no-1)*volgend;
end;



end.
 