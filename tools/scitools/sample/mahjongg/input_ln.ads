   --------------------------------------------------------------------
--|  Package :  Input_Line                        Version :  
   --------------------------------------------------------------------
--|  Abstract : This package handles everything concerning a user's input.
--|             The raw user input is converted into a command or a move.
--|             Command is one letter (from the list below).
--|             Move is four characters which specify two board positions,
--|                 for example: B2E7 
   --------------------------------------------------------------------
--|  Compiler/System :                                                 
--|  Author          : John Dalbey                  Date :  1/93      
--|  References      :                                                 
   --------------------------------------------------------------------
--|  NOTES           : 
--|                  :
--|  Version History : 
   -------------------------------------------------------------------- 
PACKAGE Input_Line IS

TYPE  Command IS (load, save, hint, undo, help, quit);  
Legal_Commands : CONSTANT STRING(1..6) := "LSHU?Q";
Prompt         : CONSTANT STRING(1..47) := 
                 "L)oad, S)ave, H)int, U)ndo, Q)uit, ?, or move: ";

PROCEDURE Get;
-- Purpose:  A line of user's input (terminated by Enter) is read from keyboard.
-- Assumes:  At least one character must be typed.  
-- Exception:     Constraint Error is raised if length > 80.

FUNCTION IsCommand RETURN BOOLEAN;
-- Purpose: Determine if the user's input was a legal command.
-- Assumes: Get has been completed.
-- Returns: TRUE if only a single character was entered and it's a legal command

FUNCTION IsMove RETURN BOOLEAN;
-- Purpose: Determine if the user's input was a move (2 board locations).
--          E.g., D3H8
-- Assumes: Get has been completed.
-- Returns: TRUE if user input is syntactically correct for a move.
-- Returns FALSE if
--    a) columns are not valid COL type
--    b) rows are not valid ROW type
--    c) length of user input /= 4

FUNCTION Get_Command RETURN Command;
-- Purpose:  Converts the user input into a value of command type.
-- Assumes:  Get has been completed, and Is_Command is TRUE.
-- Returns:  the command type value corresponding to user's input.
 
FUNCTION Validate_Move RETURN BOOLEAN;
-- Purpose: Determine if the users_input is really a valid move. I.e., the
--          tiles are matching and removable.
-- Assumes: Get has been completed, and Is_Move is true.
-- Return:  TRUE if it is a valid move. 
--          Otherwise, display appropriate error msg and return FALSE.
-- Note:    Valid move means 
--          1) both locations really contain a tile
--          2) both tiles can match and can be removed
--          3) the tiles are in two different locations (they aren't
--             the same tile).


PROCEDURE   Make_Move;
-- Purpose: Process the player's move, remove the tiles from the board.
--          Take the two matching tiles off the board and update the screen
-- Assumes: Validate_Move is TRUE.
-- Returns: nothing.  The Board and screen are updated.
-- PSEUDOCODE:
--        Reset hints.
--        Remove the matching tiles from the board.
--        display the updated board.
--        Decrement tiles remaining.
--        add tiles to move history.
--        If no tiles left, display win message.
 

PROCEDURE   Undo_Move;
-- Purpose: Undo the previous move
-- Assumes: nothing.
-- Returns: nothing.  The most recent move is "undone" and the board
--          and screen restored to their previous state.
-- Note:    Undo can be invoked multiple times, backing up until the
--          board is in it's original state.   
 END Input_Line;
