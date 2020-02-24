WITH Text_Io;  USE Text_Io;

PROCEDURE ShowBrd IS

   --------------------------------------------------------------------
--|  Program :    ShowBrd                         
     Version :    Constant STRING := "0.2";
   --------------------------------------------------------------------
--|  Abstract :   Read a Mah Jongg SAV file and display the first level.
   --------------------------------------------------------------------
--|  Library         : (none)                                   
--|  Compiler/System : Meridian Ada                       
--|  Author          : John Dalbey                  Date :  3/95       
--|  References      : Mah Jongg Requirements Document and Specification
   --------------------------------------------------------------------
--  VERSION HISTORY:
--      Version 0.1: Prototype.
--      Version 0.2: Modularized. 
--                   Asks user for a level, but this version ignores it.
   --------------------------------------------------------------------
        
   PACKAGE My_Int_Io   IS NEW Text_Io.Integer_Io (Integer);

   RowBound   : Constant INTEGER   := 9;
   ColBound   : Constant CHARACTER := 'O';
   LayerBound : Constant INTEGER   := 5;
   FileName   : Constant STRING (1..7) := "mah.sav";  -- the OS filename

   SUBTYPE Rows      is INTEGER   RANGE   1 .. RowBound;   -- Row range    
   SUBTYPE Cols      is CHARACTER RANGE 'A' .. ColBound;   -- Column range 
   SUBTYPE Layers    is INTEGER   RANGE   1 .. LayerBound; -- Layers high (1 is bottom, 5 is top)
   SUBTYPE TileValue is INTEGER   RANGE  -1 .. 42;         -- Legal tile values

   TYPE Boards IS ARRAY (Rows, Cols) OF TileValue;

   PROCEDURE Load_Board 
             (TilesLeft: OUT Natural;  -- tiles left to remove from board
              BoardNum : OUT Natural;  -- the board sequence number
              TheBoard : OUT Boards    -- the structure to store the tiles in
              ) IS
   --
   --       Load the array with tile values from the saved file.
   --
   Sav_File: Text_Io.File_Type;  -- the file type for the saved file
   TheSeed : Integer;       -- an input seed (ignored)
   Tile    : TileValue;     -- an input tile value
   
   BEGIN
      -- Open the .SAV file
      Text_Io.Open (Sav_File, Text_Io.In_File, FileName);

      -- The file has a header of four numbers which must be read first.
      My_Int_IO.Get   (Sav_File, TilesLeft);
      My_Int_IO.Get (Sav_File, BoardNum);

      My_Int_IO.Get (Sav_File, Tile);   -- Read and ignore 2 unknown values
      My_Int_IO.Get (Sav_File, TheSeed);

      FOR dummy in Rows LOOP  -- Read and ignore the first column 
        My_Int_IO.Get(Sav_File, Tile);
      END LOOP;

      -- Now read the first layer of tiles (9 rows by 17 columns) into 
      -- the array.
      FOR Col IN Cols LOOP

            FOR Row IN Rows LOOP

               -- Read a tile value from the file into the board
               My_Int_IO.Get (Sav_File, TheBoard (Row, Col));

            END LOOP;

      END LOOP;

      Text_Io.Close (Sav_File);

   END Load_Board;

   PROCEDURE Show_Labels 
             (TilesLeft: IN Natural;  -- tiles left to remove from board
              BoardNum : IN Natural;  -- the board sequence number
              LayerNum : IN Layers    -- The layer number 
              ) IS
   --
   --  clear the screen, show header info and column labels
   --
   BEGIN
         Put (Ascii.Esc); 
         Put ("[2J");
         
         Put ("Board number: ");
         My_Int_Io.Put (BoardNum);
         New_Line;

         Put ("Tiles left: ");
         My_Int_Io.Put (TilesLeft);
         New_Line;

         Put ("Layer : ");
         My_Int_Io.Put (LayerNum, 2);
         New_Line;

         Put ("      col  A   B   C   D   E   F   G   H   I   J   K   L   M   "&
            "N   O");
         New_Line;
         Put ("           -   -   -   -   -   -   -   -   -   -   -   -   -   "&
            "-   -");
         New_Line;

         Put ("row");
         New_Line;
         
   END Show_Labels;         


   PROCEDURE Show_Layer (LayerNum: IN Layers; TheBoard: IN Boards) IS
   --
   --  Display the tiles from the specified layer 
   --
   BEGIN
         -- Consider each row in turn 
         FOR Row IN Rows LOOP
            My_Int_Io.Put (Row, 2);   -- display the row label
            Put (" |     ");

            -- loop through columns, showing each tile value on this row
            FOR Col IN Cols LOOP
               My_Int_Io.Put (TheBoard (Row, Col), Width=>3);
               Put (" ");
            END LOOP;
            New_Line;

         END LOOP;
         New_Line;
   END Show_Layer;


PROCEDURE Do_Main  IS
--
--  Control obtaining input and calling output routines
--
TilesLeft : Natural; -- tiles left to remove from board
BoardNum  : Natural;  -- the board sequence number
TheBoard  : Boards;   -- the structure to store the tiles in
              
Layer     : INTEGER RANGE 0 .. LayerBound;   -- which layer user wants to see

BEGIN -- main
   Put ("Show Board V");
   Put_Line (Version);
   
   Load_Board (TilesLeft, BoardNum, TheBoard);  -- go load the board

   -- Ask user what layer they want to see
   Put ("Layer? (1 - 5, 0 to quit) ");
   My_Int_Io.Get (Layer);

   -- repeat until user enters a zero or > 5
   WHILE Layer > 0 LOOP

         Show_Labels(TilesLeft, BoardNum, Layer); -- Show the label markers
         Show_Layer (Layer, TheBoard);       -- Go display the layer

         Put ("Layer? (1 - 5, 0 to quit) "); -- Prompt for another display
         My_Int_Io.Get (Layer);              -- obtain user's choice

   END LOOP;

EXCEPTION
   WHEN Text_Io.Name_Error =>
      Text_Io.Put (" Error - File 'mah.sav' doesn't exist in this directory!");
      Text_Io.New_Line;
END Do_Main;
      
BEGIN       
    Do_Main;
END ShowBrd;

