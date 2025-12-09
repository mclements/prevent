unit GESCALE;

{$MODE Delphi}

{This will rescale both the form size and also reform small vs. large fonts.
Call it in Form.FormCreate.}

interface
uses Forms, Controls;

procedure geAutoScale(MForm: TForm);

implementation

{uses WINGLOB;}

Type

TFooClass = class(TControl); { needed to get at protected }
                               { font property }


procedure geAutoScale(MForm: TForm);
const
     cScreenWidth :longint = 1024;
     cScreenHeight:longint = 768;
     cPixelsPerInch:longint= 96;
     cFontHeight:longint   = -13;  {Design-time value of From.Font.Height}
     matig=0.5;
var
  i: longint;

begin
     {
     IMPORTANT!! : Set Scaled Property of TForm to FALSE with Object Inspector.

     The following routine will scale the form such that it looks the same
     regardless of the screen size or pixels per inch.  The following section
     determines if the screen width differs from the design-time screen size.
     If it differs, Scaled is set true and component positions are rescaled such
     that they appear in the same screen location as the design-time location.
     }
{     if (Screen.width <> cScreenWidth)or(Screen.PixelsPerInch <> cPixelsPerInch) then
     begin
          MForm.scaled := TRUE;
          tijd:=screen.Height/cScreenHeight;
          tijd:=1+matig*(tijd-1);
          MForm.height := round(MForm.height * tijd);
          tijd:=screen.width/cScreenWidth;
          tijd:=1+matig*(tijd-1);
          MForm.width  := round(MForm.width  * tijd);
          MForm.ScaleBy(screen.width, cScreenWidth);
          winglob.pixelschaal:=tijd;
     end;

     {
      This section determines if the run-time font size differs from the design-
      time font size.  If the run-time pixelsperinch differs form the design-time
      pixelsperinch, the fonts must be rescaled in order for the form to appear
      as designed.  Scaling is calculated as the ratio of the design-time font.height
      to run-time font.height.  Font.size will not work as it may equal the design-
      time value yet appear physically larger crowding and overrunning other
      components.    For instance, a form designed in 800x600 small fonts
      has a font.size of 8.  When you run the form on in 800x600 large fonts,
      font.size is also 8 but the text is noticably larger than when run in small
      font mode. This scaling will make them both appear to be the same size.
     }

     if (Screen.PixelsPerInch <> cPixelsPerInch) then
     begin

         for i := MForm.ControlCount - 1 downto 0 do
              TFooClass(MForm.Controls[i]).Font.Height :=
               round(((((MForm.Font.Height/cFontHeight))) *
                 TFooClass(MForm.Controls[i]).Font.Height));

     end;

end;

end.
