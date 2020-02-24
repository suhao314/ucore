WITH Board, Input_Line, Screen;
WITH Text_IO;

PROCEDURE   Mahjongg   IS
   --------------------------------------------------------------------
--|  Program :    Mah Jongg                         Version : 1.0a
   --------------------------------------------------------------------
--|  Abstract :   Main Driver for Mahjongg game.
   --------------------------------------------------------------------
--|  Compiler/System : Meridian Ada
--|  Author          : John Dalbey                  Date :  5/95       
--|  References      : Requirements Document and Specification
   --------------------------------------------------------------------
--|  Useage          : Uses a data file: mah.sav
   -------------------------------------------------------------------- 
Version: constant STRING := "1";

GameOver: BOOLEAN := FALSE; -- global variable set in Dispatch_Command

-------------------------------------------------------------------------------
PROCEDURE   Provide_Help   IS

-- PURPOSE: Provide a page of help text explaining how to play the game.
--
-- USED BY: Dispatch_Command
-- PSEUDOCODE:
--         Display a screen of help text.
--         Pause until user presses Enter.
--         Redisplay the game board.

BEGIN
null;
END Provide_Help;


-------------------------------------------------------------------------------
PROCEDURE   Load_Game  IS

-- PURPOSE: Load the board from a saved game file.
--
-- USED BY: Dispatch_Command
BEGIN
   Board.Load(" ");  
   Board.Show(Version);
END Load_Game;


 ------------------------------------------------------------------------------
 PROCEDURE   Dispatch_Command IS

 -- PURPOSE:  Dispatch the command.
 --
 -- USED BY: Take_Turn
 package IL renames Input_Line;     -- IL is shorthand for Input_Line

 BEGIN
      CASE (IL.Get_Command) IS
          WHEN IL.Load => Load_Game;
          WHEN IL.Quit => GameOver := TRUE;
	  WHEN Others  => null;
     END CASE;
 END Dispatch_Command;


------------------------------------------------------------------------------
PROCEDURE   Take_Turn   IS
-- PURPOSE:  Allow the user to enter a move or a command and then do it.
--
-- USED BY: Main Driver 


BEGIN  -- Take Turn

   -- Display prompt
   Screen.MoveCursor(22,1);
   Text_io.PUT (Input_Line.Prompt);

   Input_Line.Get ;   -- Obtain user input

   -- Loop until is command or is move

   -- Determine if Command or Move
   IF Input_Line.IsCommand THEN
          Dispatch_Command;
          
   ELSE -- must be move
		-- if move is valid then make it
     null;
   END IF;
END Take_Turn;


--=======================================================================
-- PURPOSE: Main driver module.  It orchestrates the entire system.

-- USED BY: None.  This is the top dog on the structure chart.


BEGIN
       Board.Clear;
       Board.Show (Version);

       LOOP
	       Take_Turn;
               EXIT WHEN  GameOver ;
               
       END LOOP;
END Mahjongg;

