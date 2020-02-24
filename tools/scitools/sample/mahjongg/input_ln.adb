WITH TileADT, Text_IO;

PACKAGE BODY Input_Line IS

--
--  IMPLEMENTATION of Input_Line ADT
--
-- Maintenance Note
-- To add or modify commands, you'll need to change:
--    Case statement in Get_Command
--    enumerated type Command in specification
--    Legal_Commands constant in specification


TYPE Move is RECORD         -- an abstraction for a MOVE
      Col1: TileADT.Col;
      Row1: TileADT.Row;
      Col2: TileADT.Col;
      Row2: TileADT.Row;
   END RECORD;

The_Line    : STRING (1..80);    -- The user's input stored here by Get 
Line_Length : NATURAL;           -- Number of characters read

   FUNCTION Char_to_Int (Letter: CHARACTER) RETURN INTEGER IS
   -- Purpose: Local function to convert a digit to an integer
   -- Assumes: Letter is in range '0' to '9'
   -- Returns: Integer equivalent of digit.
   BEGIN
      RETURN CHARACTER'POS(Letter) - CHARACTER'POS('0');
   END Char_to_Int;

FUNCTION Convert_to_Move RETURN Move IS
-- Purpose: Local function to convert the user input into a move.
-- Assumes: IsMove is true.
-- Returns: a move.
BEGIN
RETURN (  The_Line(1),
          Char_to_Int(The_Line(2)),
          The_Line(3),
          Char_to_Int(The_Line(4))    );
END Convert_to_Move;

-------------------------------------------------------------------------------
PROCEDURE Get IS
-- Purpose:  A line of user's input (terminated by Enter) is read from keyboard.
-- Assumes:  At least one character must be typed.  
-- Exception:     Constraint Error is raised if length > 80.
BEGIN
   Text_IO.Get_Line ( The_Line, Line_Length);
END Get;

FUNCTION IsCommand RETURN BOOLEAN IS
-- Purpose: Determine if the user's input was a legal command.
-- Assumes: Get has been completed.
-- Returns: TRUE if only a single character was entered and it's a legal command
-- (More than one character will be assumed to be a move, not a command.)
BEGIN
            RETURN Line_Length = 1;
END IsCommand;


FUNCTION IsMove RETURN BOOLEAN IS
-- Purpose: Determine if the user's input was a move (2 board locations).
--          E.g., D3H8
-- Assumes: Get has been completed.
-- Returns: TRUE if user input is syntactically correct for a move.
-- Returns FALSE if
--    a) columns are not valid COL type
--    b) rows are not valid ROW type
--    c) length of user input /= 4
BEGIN
   RETURN Line_Length = 4;
END IsMove;


FUNCTION Get_Command RETURN Command IS
-- Purpose:  Converts the user input into a value of command type.
-- Assumes:  Get has been completed, and Is_Command is TRUE.
-- Returns:  the command type value corresponding to user's input.
-- This implementation assumes the letters in Legal_Commands are in same order
--    as corresponding values in Commands enumerated type.
 
BEGIN
       IF The_Line(1) = 'Q' THEN
            RETURN Quit;
	ELSE
            RETURN Load;
       END IF;
END Get_Command;



 FUNCTION   Validate_Move     RETURN BOOLEAN IS

-- Purpose: Determine if the users_input is really a valid move. I.e., the
--          tiles are matching and removable.
-- Assumes: Get has been completed, and Is_Move is true.
-- Return:  TRUE if it is a valid move. 
--          Otherwise, display error and return FALSE.
-- USED BY: Take_Turn
-- Note:    Valid move means
--          1) both locations really contain a tile
--          2) both tiles can match and can be removed
--          3) the tiles are in two different locations (they aren't
--             the same tile).

 BEGIN
	RETURN TRUE;
 END Validate_Move;

 -------------------------------------------------------------------------------
 PROCEDURE   Make_Move  IS

-- Purpose: Process the player's move, remove the tiles from the board.
--          Take the two matching tiles off the board and update the screen
-- Assumes: Validate_Move is TRUE.
-- Returns: nothing.  The Board and screen are updated.
 -- USED BY: Take_Turn
 -- PSEUDOCODE:
 --        Reset hints.
 --        Remove the matching tiles from the board.
 --        display the updated board.
 --        Decrement tiles remaining.
 --        add tiles to move history.
 --        If no tiles left, display win message.
 
 
 BEGIN
 null;
 END Make_Move;

--------------------------------------------------------------------------------
PROCEDURE   Undo_Move   IS

-- PURPOSE: Restore a pair of tiles to the board that were just removed.
--  Pop a move off the stack and return those two tiles to the board.
--  Update the display and # tiles remaining.
-- Assumes: nothing.
-- Returns: nothing.  The most recent move is "undone" and the board
--          and screen restored to their previous state.
-- Note:    Undo can be invoked multiple times, backing up until the
--          board is in it's original state.   
--
-- USED BY: Dispatch_Command
--

BEGIN
null;
END Undo_Move;

END Input_Line;

