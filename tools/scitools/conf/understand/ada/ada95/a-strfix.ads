------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                    A D A . S T R I N G S . F I X E D                     --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 2 $                              --
--                                                                          --
-- This specification is adapted from the Ada Reference Manual for use with --
-- GNAT.  In accordance with the copyright of that document, you can freely --
-- copy and modify this specification,  provided that if you redistribute a --
-- modified version,  any changes that you have made are clearly indicated. --
--                                                                          --
------------------------------------------------------------------------------


with Ada.Strings.Maps;
with Ada.Strings.Search;

package Ada.Strings.Fixed is
pragma Preelaborate (Fixed);

   --------------------------------------------------------------
   -- Copy Procedure for Strings of Possibly Different Lengths --
   --------------------------------------------------------------

   procedure Move
     (Source  : in  String;
      Target  : out String;
      Drop    : in  Truncation := Error;
      Justify : in  Alignment  := Left;
      Pad     : in  Character  := Space);

   ------------------------
   -- Search Subprograms --
   ------------------------

   --  Note: in this implementation, these search subprograms are in a
   --  separate package Ada.Strings.Search. The declarations are thus
   --  replaced by renamings of these routines (which is perfectly valid
   --  since it is semantically undetectable that we have renamings here
   --  rather than "real" subprogram declarations).

   function Index
     (Source   : in String;
      Pattern  : in String;
      Going    : in Direction := Forward;
      Mapping  : in Maps.Character_Mapping := Maps.Identity)
      return     Natural
   renames Ada.Strings.Search.Index;

   function Index
     (Source   : in String;
      Pattern  : in String;
      Going    : in Direction := Forward;
      Mapping  : in Maps.Character_Mapping_Function)
      return     Natural
   renames Ada.Strings.Search.Index;

   function Index
     (Source : in String;
      Set    : in Maps.Character_Set;
      Test   : in Membership := Inside;
      Going  : in Direction  := Forward)
      return   Natural
   renames Ada.Strings.Search.Index;

   function Index_Non_Blank
     (Source : in String;
      Going  : in Direction := Forward)
      return   Natural
   renames Ada.Strings.Search.Index_Non_Blank;

   function Count
     (Source   : in String;
      Pattern  : in String;
      Mapping  : in Maps.Character_Mapping := Maps.Identity)
      return     Natural
   renames Ada.Strings.Search.Count;

   function Count
     (Source   : in String;
      Pattern  : in String;
      Mapping  : in Maps.Character_Mapping_Function)
      return     Natural
   renames Ada.Strings.Search.Count;

   function Count
     (Source   : in String;
      Set      : in Maps.Character_Set)
      return     Natural
   renames Ada.Strings.Search.Count;

   procedure Find_Token
     (Source : in String;
      Set    : in Maps.Character_Set;
      Test   : in Membership;
      First  : out Positive;
      Last   : out Natural)
   renames Ada.Strings.Search.Find_Token;

   ------------------------------------
   -- String Translation Subprograms --
   ------------------------------------

   function Translate
     (Source  : in String;
      Mapping : in Maps.Character_Mapping)
      return    String;

   procedure Translate
     (Source  : in out String;
      Mapping : in Maps.Character_Mapping);

   function Translate
     (Source  : in String;
      Mapping : in Maps.Character_Mapping_Function)
      return    String;

   procedure Translate
     (Source  : in out String;
      Mapping : in Maps.Character_Mapping_Function);

   ---------------------------------------
   -- String Transformation Subprograms --
   ---------------------------------------

   function Replace_Slice
     (Source : in String;
      Low    : in Positive;
      High   : in Natural;
      By     : in String)
      return   String;

   procedure Replace_Slice
     (Source  : in out String;
      Low     : in Positive;
      High    : in Natural;
      By      : in String;
      Drop    : in Truncation := Error;
      Justify : in Alignment  := Left;
      Pad     : in Character  := Space);

   function Insert
     (Source   : in String;
      Before   : in Positive;
      New_Item : in String)
      return     String;

   procedure Insert
     (Source   : in out String;
      Before   : in Positive;
      New_Item : in String;
      Drop     : in Truncation := Error);

   function Overwrite
     (Source   : in String;
      Position : in Positive;
      New_Item : in String)
      return     String;

   procedure Overwrite
     (Source   : in out String;
      Position : in Positive;
      New_Item : in String;
      Drop     : in Truncation := Right);

   function Delete
     (Source  : in String;
      From    : in Positive;
      Through : in Natural)
      return    String;

   procedure Delete
     (Source  : in out String;
      From    : in Positive;
      Through : in Natural;
      Justify : in Alignment := Left;
      Pad     : in Character := Space);

   ---------------------------------
   -- String Selector Subprograms --
   ---------------------------------

   function Trim
     (Source : in String;
      Side   : in Trim_End)
      return   String;

   procedure Trim
     (Source  : in out String;
      Side    : in Trim_End;
      Justify : in Alignment := Left;
      Pad     : in Character := Space);

   function Trim
     (Source : in String;
      Left   : in Maps.Character_Set;
      Right  : in Maps.Character_Set)
      return   String;

   procedure Trim
     (Source  : in out String;
      Left    : in Maps.Character_Set;
      Right   : in Maps.Character_Set;
      Justify : in Alignment := Strings.Left;
      Pad     : in Character := Space);

   function Head
     (Source : in String;
      Count  : in Natural;
      Pad    : in Character := Space)
      return   String;

   procedure Head
     (Source  : in out String;
      Count   : in Natural;
      Justify : in Alignment := Left;
      Pad     : in Character := Space);

   function Tail
     (Source : in String;
      Count  : in Natural;
      Pad    : in Character := Space)
      return   String;

   procedure Tail
     (Source  : in out String;
      Count   : in Natural;
      Justify : in Alignment := Left;
      Pad     : in Character := Space);

   ----------------------------------
   -- String Constructor Functions --
   ----------------------------------

   function "*"
     (Left  : in Natural;
      Right : in Character)
      return  String;

   function "*"
     (Left  : in Natural;
      Right : in String)
      return  String;

end Ada.Strings.Fixed;
