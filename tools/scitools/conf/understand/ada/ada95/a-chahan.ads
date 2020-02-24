-----------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--              A D A . C H A R A C T E R S . H A N D L I N G               --
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


package Ada.Characters.Handling is
pragma Preelaborate (Handling);

   ----------------------------------------
   -- Character Classification Functions --
   ----------------------------------------

   function Is_Control           (Item : in Character) return Boolean;
   function Is_Graphic           (Item : in Character) return Boolean;
   function Is_Letter            (Item : in Character) return Boolean;
   function Is_Lower             (Item : in Character) return Boolean;
   function Is_Upper             (Item : in Character) return Boolean;
   function Is_Basic             (Item : in Character) return Boolean;
   function Is_Digit             (Item : in Character) return Boolean;
   function Is_Decimal_Digit     (Item : in Character) return Boolean
                                                          renames Is_Digit;
   function Is_Hexadecimal_Digit (Item : in Character) return Boolean;
   function Is_Alphanumeric      (Item : in Character) return Boolean;
   function Is_Special           (Item : in Character) return Boolean;

   ---------------------------------------------------
   -- Conversion Functions for Character and String --
   ---------------------------------------------------

   function To_Lower (Item : in Character) return Character;
   function To_Upper (Item : in Character) return Character;
   function To_Basic (Item : in Character) return Character;

   function To_Lower (Item : in String) return String;
   function To_Upper (Item : in String) return String;
   function To_Basic (Item : in String) return String;

   ----------------------------------------------------------------------
   -- Classifications of and Conversions Between Character and ISO 646 --
   ----------------------------------------------------------------------

   subtype ISO_646 is
     Character range Character'Val (0) .. Character'Val (127);

   function Is_ISO_646 (Item : in Character) return Boolean;
   function Is_ISO_646 (Item : in String)    return Boolean;

   function To_ISO_646
     (Item       : in Character;
      Substitute : in ISO_646 := ' ')
      return       ISO_646;

   function To_ISO_646
     (Item      : in String;
      Substitute : in ISO_646 := ' ')
      return       String;

   ------------------------------------------------------
   -- Classifications of Wide_Character and Characters --
   ------------------------------------------------------

   function Is_Character (Item : in Wide_Character) return Boolean;
   function Is_String    (Item : in Wide_String)    return Boolean;

   ------------------------------------------------------
   -- Conversions between Wide_Character and Character --
   ------------------------------------------------------

   function To_Character
     (Item       : in Wide_Character;
      Substitute : in Character := ' ')
      return       Character;

   function To_String
     (Item       : in Wide_String;
      Substitute : in Character := ' ')
      return       String;

   function To_Wide_Character (Item : in Character) return Wide_Character;
   function To_Wide_String    (Item : in String)    return Wide_String;

private
   pragma Inline (Is_Control);
   pragma Inline (Is_Graphic);
   pragma Inline (Is_Letter);
   pragma Inline (Is_Lower);
   pragma Inline (Is_Upper);
   pragma Inline (Is_Basic);
   pragma Inline (Is_Digit);
   pragma Inline (Is_Hexadecimal_Digit);
   pragma Inline (Is_Alphanumeric);
   pragma Inline (Is_Special);
   pragma Inline (To_Lower);
   pragma Inline (To_Upper);
   pragma Inline (To_Basic);
   pragma Inline (Is_ISO_646);
   pragma Inline (Is_Character);
   pragma Inline (To_Character);
   pragma Inline (To_Wide_Character);

end Ada.Characters.Handling;
