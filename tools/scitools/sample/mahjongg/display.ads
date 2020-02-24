   --------------------------------------------------------------------
--|  Package :  DISPLAY                           Version : 1.0
   --------------------------------------------------------------------
--|  Abstract :  Provides a display object for the Mahjongg game.
--|              This package handles hardware dependent details of
--|              displaying tiles on the screeen.
   --------------------------------------------------------------------
--|  Compiler/System : Alsys Ada 
--|  Author          : John Dalbey                  Date :  1/93      
   --------------------------------------------------------------------
--|  NOTES           : 
--|                  :
--|  Version History : 
   -------------------------------------------------------------------- 
WITH TileADT;  USE TileADT;
PACKAGE Display IS

PROCEDURE ShowTile(TheTile : Tile);
-- Assumes : TheTile has a position and a value.
-- Uses    : TheTile.
-- Results : TheTile is displayed on the screen in its appropriate place.

PROCEDURE SayTile(TheTile:Tile);
-- For debugging, it just dumps the tile fields to the screen.

PROCEDURE ShowTilesLeft;
-- Assumes: A board has been loaded
-- Results: the current number of tiles remaining is displayed

END Display;

