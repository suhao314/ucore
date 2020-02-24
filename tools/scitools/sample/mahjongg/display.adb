WITH TileADT, Text_IO; 
USE TileADT,  Text_IO;
PACKAGE BODY Display IS
--
--  Implementation of Display ADT for Mahjongg solitaire game
--

PROCEDURE SayTile(TheTile : Tile) IS
BEGIN
null;
END SayTile;

PROCEDURE ShowTile(TheTile : Tile) IS
-- Assumes : TheTile has a position and a value.
-- Uses    : TheTile.
-- Results : TheTile is displayed on the screen in its appropriate place.
Symbols : ARRAY (1..4) of  CHARACTER := (' ','.','+','#');
BEGIN
null;
END ShowTile;

PROCEDURE ShowTilesLeft IS
-- Display number of tiles remaining
BEGIN
null;
END ShowTilesLeft;

END Display;

