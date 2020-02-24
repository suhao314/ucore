PACKAGE BODY TileADT IS
--
--  Implementation of Tile ADT for Mahjongg solitaire game
--

FUNCTION  Create (TheCol: Col;  TheRow : Row;  TheLayer : Layer) RETURN Tile IS
-- Assumes : TheCol, TheRow, TheLayer have values.
-- Uses    : TheRow indicates which row on the board.
--           TheCol indicates which column on the board.
--           TheLayer indicates which layer on the board.
-- Results : A Tile is created and assigned a position TheCol,TheRow,TheLayer.
New_Tile: Tile := (TheCol, TheRow, TheLayer, 0);
BEGIN
   RETURN New_Tile;
END Create;

PROCEDURE SetValue (TheTile : IN OUT Tile;  Value : TileValue) IS
-- Assumes : nothing (though it makes sense that it have been created).
-- Uses    : TheTile and Value
-- Results : TheTile is assigned Value
BEGIN
   TheTile.Value := Value;
END SetValue;

FUNCTION  GetValue (TheTile : Tile) RETURN TileValue IS
-- Assumes : TheTile has a value
-- Uses    : TheTile
-- Results : Returns the current value of TheTile.
BEGIN
   RETURN (TheTile.Value);
END GetValue;

FUNCTION GetLayer (TheTile :Tile) RETURN Layer IS
BEGIN
   RETURN (theTile.Layer_Pos);
END GetLayer;

FUNCTION GetRow (TheTile :Tile) RETURN Row IS
BEGIN
   RETURN (theTile.Row_Pos);
END GetRow;

FUNCTION GetCol (TheTile :Tile) RETURN Col IS
BEGIN
   RETURN (theTile.Col_Pos);
END GetCol;
   
FUNCTION  IsMatch (Tile1, Tile2 : Tile) RETURN BOOLEAN IS
-- Assumes : Tile1, Tile2 have values.
-- Uses    : Tile1, Tile2.
-- Results : Returns TRUE if Tile1 has the same value as Tile2, FALSE otherwise.
-- Notes   : TRUE only on exact match.  Doesn't deal with seasons or other
--           "suit" type tiles.
BEGIN
   RETURN Tile1.Value = Tile2.Value;
END ISMatch;

END TileADT;


