------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                A D A . S T R I N G S . W I D E _ M A P S                 --
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

package Ada.Strings.Wide_Maps is
pragma Preelaborate (Wide_Maps);

   -------------------------------------
   -- Wide Character Set Declarations --
   -------------------------------------

   type Wide_Character_Set is private;
   --  Representation for a set of Wide_Character values:

   Null_Set : constant Wide_Character_Set;

   ------------------------------------------
   -- Constructors for Wide Character Sets --
   ------------------------------------------

   type Wide_Character_Range is record
      Low  : Wide_Character;
      High : Wide_Character;
   end record;
   --  Represents Wide_Character range Low .. High

   type Wide_Character_Ranges is
     array (Positive range <>) of Wide_Character_Range;

   function To_Set
     (Ranges : in Wide_Character_Ranges)
      return   Wide_Character_Set;

   function To_Set
     (Span : in Wide_Character_Range)
      return Wide_Character_Set;

   function To_Ranges
     (Set :  in Wide_Character_Set)
      return Wide_Character_Ranges;

   ---------------------------------------
   -- Operations on Wide Character Sets --
   ---------------------------------------

   function "=" (Left, Right : in Wide_Character_Set) return Boolean;

   function "not"
     (Right  : in Wide_Character_Set)
      return Wide_Character_Set;

   function "and"
     (Left, Right : in Wide_Character_Set)
      return        Wide_Character_Set;

   function "or"
     (Left, Right : in Wide_Character_Set)
      return        Wide_Character_Set;

   function "xor"
     (Left, Right : in Wide_Character_Set)
      return        Wide_Character_Set;

   function "-"
     (Left, Right : in Wide_Character_Set)
      return        Wide_Character_Set;

   function Is_In
     (Element : in Wide_Character;
      Set     : in Wide_Character_Set)
      return    Boolean;

   function Is_Subset
     (Elements : in Wide_Character_Set;
      Set      : in Wide_Character_Set)
      return     Boolean;

   function "<="
     (Left  : in Wide_Character_Set;
      Right : in Wide_Character_Set)
      return  Boolean
   renames Is_Subset;

   subtype Wide_Character_Sequence is Wide_String;
   --  Alternative representation for a set of character values

   function To_Set
     (Sequence  : in Wide_Character_Sequence)
      return      Wide_Character_Set;

   function To_Set
     (Singleton : in Wide_Character)
      return      Wide_Character_Set;

   function To_Sequence
     (Set  : in Wide_Character_Set)
      return Wide_Character_Sequence;

   -----------------------------------------
   -- Wide Character Mapping Declarations --
   -----------------------------------------

   type Wide_Character_Mapping is private;
   --  Representation for a wide character to wide character mapping:

   function Value
     (Map     : in Wide_Character_Mapping;
      Element : in Wide_Character)
      return    Wide_Character;

   Identity : constant Wide_Character_Mapping;

   ---------------------------------
   -- Operations on Wide Mappings --
   ---------------------------------

   function To_Mapping
     (From, To : in Wide_Character_Sequence)
      return     Wide_Character_Mapping;

   function To_Domain
     (Map  : in Wide_Character_Mapping)
      return Wide_Character_Sequence;

   function To_Range
     (Map  : in Wide_Character_Mapping)
      return Wide_Character_Sequence;

   type Wide_Character_Mapping_Function is
      access function (From : in Wide_Character) return Wide_Character;

private
   type Wide_Character_Set is access all Wide_Character_Ranges;
   --  The referenced value satisfies the following constraints:
   --
   --    The lower bound is 1
   --    The ranges are in order by increasing Low values
   --    The ranges are non-overlapping and discontiguous
   --
   --  This representation is chosen to facilitiate the coding of the
   --  Is_In, To_Ranges and logical functions, and is also canonical.

   Null_Set : constant Wide_Character_Set :=
                new Wide_Character_Ranges (1 .. 0);

   type Wide_Character_Sequence_Access is
     access all Wide_Character_Sequence;

   type Wide_Character_Mapping is record
      Domain : Wide_Character_Sequence_Access;
      Rangev : Wide_Character_Sequence_Access;
   end record;
   --  The two strings are of identical length, and corresponding positions
   --  define the mapping. The characters of From are sorted in ascending
   --  order to facilitate a binary search in the Value function. The lower
   --  bound of each string is always 1. A character that does not appear in
   --  From is mapped to itself, and corresponding character positions in
   --  From and To are always distinct. This representation is canonical.
   --  Note, Domain.all and Rangev.all are exactly the values returned by
   --  the functions To_Domain and To_Range.

   Null_String : aliased constant Wide_Character_Sequence := "";

   Identity : constant Wide_Character_Mapping :=
                (Domain => Null_String'Access,
                 Rangev => Null_String'Access);

end Ada.Strings.Wide_Maps;
