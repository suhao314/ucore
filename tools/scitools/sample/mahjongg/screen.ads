   --------------------------------------------------------------------
--|  Program/Package : SCREEN                  Version : 1.0           |
   --------------------------------------------------------------------
--|  Abstract : ANSI screen manipulation                               |
   --------------------------------------------------------------------
--|  File            : screenpkg.ads                                   |
--|  Compiler/System : IBM AIX/6000 Ada                                |
--|  Author          : John Dalbey             Date : 9/28/93          |
--|  References      : Feldman textbook                                |
   --------------------------------------------------------------------
--|  Limitations     : To work properly, must be run on VT100 terminal.|
   --------------------------------------------------------------------

PACKAGE Screen IS

  Screen_Depth : CONSTANT Integer := 24;
  Screen_Width : CONSTANT Integer := 80;

  SUBTYPE Depth IS Integer RANGE 1..Screen_Depth;
  SUBTYPE Width IS Integer RANGE 1..Screen_Width;

  TYPE Attribute IS (normal, bold, inverse, blink);

PROCEDURE Beep; 
   -- assumes    : nothing
   -- results    : the terminal issues a beep tone.
 
PROCEDURE ClearScreen;
   -- assumes    : nothing
   -- results    : the screen is cleared.

PROCEDURE MoveCursor (Row : Depth;  Column : Width);
   -- assumes    : Row and Column have a value.
   -- results    : The cursor is moved to position (Row, Column).
   -- exceptions : Constraint_error can be raised

PROCEDURE SetAttribute (The_Attribute: Attribute);
   -- assumes    : The_Attribute has a value.
   -- results    : Subsequent text will be displayed using The_Attribute.

PROCEDURE SaveCursor;
   -- assumes    : nothing
   -- results    : the current position of the cursor is saved.

PROCEDURE RestoreCursor;
   -- assumes    : nothing
   -- results    : the cursor is restored to it's previously saved position.

END Screen;
