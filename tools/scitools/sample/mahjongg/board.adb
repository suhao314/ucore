-------------------------------------------------------------------------------
--
--       BOARD ADT (implementation)
--
-------------------------------------------------------------------------------

WITH TileADT, Display, Screen, stack_package, Queue_Package, Text_IO;
USE TileADT;

PACKAGE BODY Board IS

PACKAGE My_Int_IO IS new Text_IO.Integer_io (INTEGER);

-------------------------------------------------------------------------------
PROCEDURE Clear IS
BEGIN
null;
END Clear;

-------------------------------------------------------------------------------
PROCEDURE Reset_Hints IS
BEGIN
null;
END Reset_Hints;
   

-------------------------------------------------------------------------------
PROCEDURE Load (Mah_Num: STRING ) IS
BEGIN
Text_IO.Put("Stub for Board.Load");
Delay 1.0;
END Load;

-------------------------------------------------------------------------------
PROCEDURE Save   IS
BEGIN
   Text_IO.Put ("Stub for Board.Save");
END Save;
   
-------------------------------------------------------------------------------
PROCEDURE Create_New IS
BEGIN
   Text_IO.Put ("Stub for Board.Create_New");
END Create_New;
   
-------------------------------------------------------------------------------
PROCEDURE Show (Version: IN STRING)  IS
                        -- Display the entire board
BEGIN
--      Display Screen boundaries (columns and row headers)
Screen.ClearScreen;
Screen.MoveCursor(1,21);
Text_IO.Put_Line ("ASCII Mah Jongg by JD.  Version " & Version);
Text_IO.PUT ("    A    B    C    D    E    F    G    H    I    J    K    L    M    N   O");
Text_IO.New_Line;
Text_IO.New_Line;
FOR num in ROW LOOP
    My_Int_IO.PUT(num,width=>1);
    Text_IO.New_Line;
    Text_IO.New_Line;
END LOOP;

END Show;

-------------------------------------------------------------------------------
FUNCTION  GetTop (TheCol : TileADT.Col;  TheRow : Row) RETURN Tile IS
Top_Tile: TileADT.Tile;
BEGIN
RETURN Top_Tile;
END GetTop;


-------------------------------------------------------------------------------
PROCEDURE RemoveTop (TheCol : Col;  TheRow : Row) IS
BEGIN
null;
END REmoveTop;


-------------------------------------------------------------------------------
PROCEDURE ReplaceTop (TheCol : Col;  TheRow : Row; Value: TileValue) IS
BEGIN
null;
END ReplaceTop;


-------------------------------------------------------------------------------
FUNCTION IsPositionRemovable (TheCol : Col;  TheRow : Row) RETURN BOOLEAN IS
BEGIN
RETURN TRUE;
END IsPositionRemovable;


-------------------------------------------------------------------------------
FUNCTION IsEmpty (TheCol : Col;  TheRow : Row) RETURN BOOLEAN IS
BEGIN
RETURN TRUE;
END IsEmpty;


-------------------------------------------------------------------------------
procedure DumpBoard ( Layers : INTEGER) IS
BEGIN
null;
end DumpBoard;

-------------------------------------------------------------------------------
PROCEDURE Give_Hint IS
BEGIN
null;
END Give_Hint;

-------------------------------------------------------------------------------
PROCEDURE Inc_Tiles_Left IS
BEGIN
null;
END Inc_Tiles_Left;

PROCEDURE Dec_Tiles_Left IS
BEGIN
null;
END Dec_Tiles_Left;


FUNCTION Get_Tiles_Left RETURN NATURAL IS
BEGIN
RETURN 0;
END Get_Tiles_Left;

END Board;

