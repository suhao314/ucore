   --------------------------------------------------------------------
--|  Package : Board                              Version : 1.0
   --------------------------------------------------------------------
--|  Abstract :  Provides a Board object for a Mahjongg game.
   --------------------------------------------------------------------
--|  Compiler/System : Alsys Ada
--|  Author          : John Dalbey                  Date :  1/93
   --------------------------------------------------------------------
--|  NOTES           :
--|                  :
--|  Version History :
   --------------------------------------------------------------------
WITH TileADT;  USE TileADT;
WITH Text_IO;
PACKAGE Board IS

PROCEDURE Clear;
-- Assumes : nothing.

-- Uses    : nothing.
-- Results : The Board is initialized to all empty spots.

PROCEDURE Load (Mah_Num: String);
-- Assumes : There is a file named MAH.SAV in the current directory
-- Uses    : Mah_Num, and the .SAV file (an ascii text file)
-- Results : The Board is loaded from the text file.
-- Exceptions: END_ERROR or DATA_ERROR if .SAV file is not in
--             proper format.

PROCEDURE Show (Version: IN STRING);
-- Assumes : nothing.
-- Results : The contents of the entire board is displayed.
--           Column and Row titles are displayed around the board.
--           The board number and tiles left are displayed.
--           The Version string is displayed.

FUNCTION  GetTop (TheCol : Col;  TheRow : Row) RETURN Tile;
-- Assumes : TheCol, TheRow have values.
-- Uses    : TheRow indicates which row on the board.
--           TheCol indicates which column on the board.
-- Results : The Tile on top of the pile at position TheCol,TheRow is returned.

PROCEDURE RemoveTop (TheCol : Col;  TheRow : Row);
-- Assumes : TheCol, TheRow have values.
-- Uses    : TheRow indicates which row on the board.
--           TheCol indicates which column on the board.
-- Results : The Tile on top of the pile at position TheCol,TheRow is removed
--           from the board.

PROCEDURE ReplaceTop (TheCol : Col;  TheRow : Row; Value: TileValue);
-- Assumes : TheCol, TheRow, Value have values.
-- Uses    : TheRow indicates which row on the board.
--           TheCol indicates which column on the board.
--           Value  is the value of the tile.
-- Results : The Tile on top of the pile at position TheCol,TheRow is
--           assigned Value.

FUNCTION IsPositionRemovable (TheCol : Col;  TheRow : Row) RETURN BOOLEAN;
-- Assumes : TheCol, TheRow have values.
-- Uses    : TheRow indicates which row on the board.
--           TheCol indicates which column on the board.
-- Results : RETURNS TRUE if the Tile on top of the pile at position
--           TheCol,TheRow is removable.
--           RETURNS FALSE if it is blocked on either side by other tiles.

FUNCTION IsEmpty (TheCol : Col;  TheRow : Row) RETURN BOOLEAN;
-- Assumes : TheCol, TheRow have values.
-- Uses    : TheRow indicates which row on the board.
--           TheCol indicates which column on the board.
-- Results : RETURNS TRUE if the pile at position TheCol,TheRow has no
--           tiles in it.
--           RETURNS FALSE if there are any tiles in this pile.

PROCEDURE Inc_Tiles_Left;
-- Assumes : a board has been loaded
-- Results : Tiles Remaining is incremented by 2.

PROCEDURE Dec_Tiles_Left;
-- Assumes : a board has been loaded
-- Results : Tiles Remaining is decremented by 2.
-- Exceptions: constraint_error if Tiles Remaining goes negative?

FUNCTION Get_Tiles_Left RETURN NATURAL;
-- Assumes : a board has been loaded
-- Results : Tiles Remaining is returned

PROCEDURE Give_Hint;
-- Assumes : a board has been loaded
--           there are tiles on the board
-- Results : Displays a pair of tiles that are candidates for removal.
--           Can be called consequtively to display all possible hints.
--           If no moves are possible, a message is displayed to that effect.

PROCEDURE Reset_Hints;
-- Assumes: nothing
-- Results: the hint stack is reset.  This should be called after every move.
--          if you don't then give hint will be working from an outdated stack.

PROCEDURE Save;
-- Stub for Save game.

PROCEDURE Create_New;
-- Stub for New game.

END Board;

