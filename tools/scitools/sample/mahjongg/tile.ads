   --------------------------------------------------------------------
--|  Package  : TileADT                             Version :  
   --------------------------------------------------------------------
--|  Abstract : Provides an ADT for a TILE in the Mahjongg game.
   --------------------------------------------------------------------
--|  Compiler/System : IBM AIX/Ada 6000                                
--|  Author          : John Dalbey                  Date :  1/93      
--|  References      :                                                 
   --------------------------------------------------------------------
--|  NOTES           : 
--|                  :
--|  Version History : 
   -------------------------------------------------------------------- 
PACKAGE TileADT IS

TYPE Tile IS PRIVATE;

TYPE TilePair is record
    Alpha: Tile;
    Bravo: Tile;
        end record;

RowBound   : Constant INTEGER   := 9;
ColBound   : Constant CHARACTER := 'O';
LayerBound : Constant INTEGER   := 5;

SUBTYPE Row       is INTEGER   RANGE 1 .. RowBound;      -- Row Positions
SUBTYPE Col       is CHARACTER RANGE 'A' .. ColBound;  -- Column positions
SUBTYPE Layer     is INTEGER   RANGE 1 .. LayerBound;   -- Layers high 
                                                     --(1 is bottom, 5 is top)
SUBTYPE TileValue is INTEGER   RANGE -1 .. 42;     -- Legal tile values

FUNCTION  Create (TheCol: Col;  TheRow : Row;  TheLayer : Layer) RETURN TILE;
-- Assumes : TheCol, TheRow, TheLayer have values.
-- Uses    : TheRow indicates which row on the board.
--           TheCol indicates which column on the board.
--           TheLayer indicates which layer on the board.
-- Results : A Tile is created and assigned a position TheCol,TheRow,TheLayer.

PROCEDURE SetValue (TheTile : IN OUT Tile;  Value : TileValue);
-- Assumes : nothing (though it makes sense that it have been created).
-- Uses    : TheTile and Value
-- Results : TheTile is assigned Value

FUNCTION  GetValue (TheTile : Tile) RETURN TileValue;
-- Assumes : TheTile has a value
-- Uses    : TheTile
-- Results : Returns the current value of TheTile.

FUNCTION  GetLayer (TheTile : Tile) RETURN Layer;
-- Assumes : TheTile has a value
-- Uses    : TheTile
-- Results : Returns TheTile's layer.

FUNCTION  GetRow  (TheTile : Tile) RETURN Row;
-- Assumes : TheTile has a value
-- Uses    : TheTile
-- Results : Returns TheTile's Row.

FUNCTION  GetCol  (TheTile : Tile) RETURN Col;
-- Assumes : TheTile has a value
-- Uses    : TheTile
-- Results : Returns TheTile's Col.

FUNCTION  IsMatch (Tile1, Tile2 : Tile) RETURN BOOLEAN;
-- Assumes : Tile1, Tile2 have values.
-- Uses    : Tile1, Tile2.
-- Results : Returns TRUE if Tile1 has the same value as Tile2, FALSE otherwise.
-- Notes   : TRUE only on exact match.  Doesn't deal with seasons or other
--           "suit" type tiles.

PRIVATE
   TYPE Tile is RECORD
      Col_Pos  : Col;
      Row_Pos  : Row;
      Layer_Pos: Layer;
      Value    : TileValue;
    END RECORD;
END TileADT;

