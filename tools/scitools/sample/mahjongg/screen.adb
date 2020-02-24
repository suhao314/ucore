
WITH Text_IO;  USE Text_IO;

PACKAGE BODY Screen IS

--  Implementation of package SCREEN

  PACKAGE My_Int_IO IS NEW Text_IO.Integer_IO(INTEGER);

  PROCEDURE Beep IS
  BEGIN
    Text_IO.Put (Item => ASCII.BEL);
  END Beep;

  PROCEDURE ClearScreen IS
  BEGIN
    Text_IO.Put (Item => ASCII.ESC);
    Text_IO.Put (Item => "[2J");
  END ClearScreen;

  PROCEDURE MoveCursor (Row : Depth; Column : Width ) IS
  BEGIN
    Text_IO.Put (Item => ASCII.ESC);
    Text_IO.Put ("[");
    My_Int_IO.Put (Item => Row, Width => 1);
    Text_IO.Put (Item => ';');
    My_Int_IO.Put (Item => Column, Width => 1);
    Text_IO.Put (Item => 'f');
  END MoveCursor;  

PROCEDURE SetAttribute (The_Attribute: Attribute) IS
BEGIN
   Put (ASCII.ESC); 
	CASE The_Attribute IS
		WHEN normal  => Put ("[0m");  
		WHEN bold    => Put ("[1m");  
		WHEN inverse => Put ("[7m");  
		WHEN blink   => Put ("[5m");  
	END CASE;
END SetAttribute;

PROCEDURE SaveCursor IS
BEGIN
    Text_IO.Put (Item => ASCII.ESC);
    Text_IO.Put (Item => "7");
END SaveCursor;

PROCEDURE RestoreCursor IS
BEGIN
    Text_IO.Put (Item => ASCII.ESC);
    Text_IO.Put (Item => "8");
END RestoreCursor;
	
END Screen;
