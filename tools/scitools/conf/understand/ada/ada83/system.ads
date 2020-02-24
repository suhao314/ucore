--******************************************************************************
--
--	package SYSTEM
--
--******************************************************************************

package SYSTEM is

    type NAME is (VAX_VMS);

    SYSTEM_NAME   : constant NAME := VAX_VMS;
    STORAGE_UNIT  : constant := 8;
    MEMORY_SIZE   : constant := 2**31-1;
    MAX_INT       : constant := 2**31-1;
    MIN_INT       : constant := -(2**31);
    MAX_DIGITS    : constant := 33;
    MAX_MANTISSA  : constant := 31;
    FINE_DELTA    : constant := 2.0**(-30);
    TICK          : constant := 1.0**(-2);

    subtype PRIORITY is INTEGER range 0 .. 15;

    --  Address type
    --
    type ADDRESS is private;

   type interrupt_vector is array(1..100) of address;

    function "+"  (LEFT : ADDRESS; RIGHT : INTEGER) return ADDRESS;
    function "+"  (LEFT : INTEGER; RIGHT : ADDRESS) return ADDRESS;
    function "-"  (LEFT : ADDRESS; RIGHT : ADDRESS) return INTEGER;
    function "-"  (LEFT : ADDRESS; RIGHT : INTEGER) return ADDRESS;

    function "<"  (LEFT, RIGHT : ADDRESS) return BOOLEAN;
    function "<=" (LEFT, RIGHT : ADDRESS) return BOOLEAN;
    function ">=" (LEFT, RIGHT : ADDRESS) return BOOLEAN;

    ADDRESS_ZERO : constant ADDRESS;

    generic
        type TARGET is private;
    function FETCH_FROM_ADDRESS (A : ADDRESS) return TARGET;

    generic
        type TARGET is private;
    procedure ASSIGN_TO_ADDRESS (A : ADDRESS; T : TARGET);

    type TYPE_CLASS is (TYPE_CLASS_ENUMERATION,
                        TYPE_CLASS_INTEGER,
                        TYPE_CLASS_FIXED_POINT,
                        TYPE_CLASS_FLOATING_POINT,
                        TYPE_CLASS_ARRAY,
                        TYPE_CLASS_RECORD,
                        TYPE_CLASS_ACCESS,
                        TYPE_CLASS_TASK,
                        TYPE_CLASS_ADDRESS);

    --  VAX Ada floating point type declarations for the VAX
    --  hardware floating point data types
                                                                        
    type D_FLOAT is digits 14 range -1.7014118346047E+38 .. 1.7014118346047E+38;
    type F_FLOAT is digits 6 range -1.70141E+38 .. 1.70141E+38;
    type G_FLOAT is digits 13 range -8.988465674312E+307 .. 8.988465674312E+307;
    type H_FLOAT is digits 31 range -5.948657467861588254287966331400E+4931 .. 5.948657467861588254287966331400E+4931;

    --  AST handler type

    type AST_HANDLER is limited private;

    NO_AST_HANDLER : constant AST_HANDLER;

    --  Non-Ada exception

    NON_ADA_ERROR : exception;

    --  VAX hardware-oriented types and functions

    type    BIT_ARRAY is array (INTEGER range <>) of BOOLEAN;
    pragma  PACK(BIT_ARRAY);

    subtype BIT_ARRAY_8 is BIT_ARRAY   (0 ..  7);
    subtype BIT_ARRAY_16 is BIT_ARRAY  (0 .. 15);
    subtype BIT_ARRAY_32 is BIT_ARRAY  (0 .. 31);
    subtype BIT_ARRAY_64 is BIT_ARRAY  (0 .. 63);

    type UNSIGNED_BYTE is range 0 .. 255;
    for  UNSIGNED_BYTE'SIZE use 8;

    function "not" (LEFT         : UNSIGNED_BYTE) return UNSIGNED_BYTE;
    function "and" (LEFT, RIGHT  : UNSIGNED_BYTE) return UNSIGNED_BYTE;
    function "or"  (LEFT, RIGHT  : UNSIGNED_BYTE) return UNSIGNED_BYTE;
    function "xor" (LEFT, RIGHT  : UNSIGNED_BYTE) return UNSIGNED_BYTE;

    function TO_UNSIGNED_BYTE (LEFT : BIT_ARRAY_8) return UNSIGNED_BYTE;
    function TO_BIT_ARRAY_8 (LEFT : UNSIGNED_BYTE) return BIT_ARRAY_8;

    type UNSIGNED_BYTE_ARRAY is array (INTEGER range <>) of UNSIGNED_BYTE;

    type UNSIGNED_WORD is range 0 .. 65535;
    for  UNSIGNED_WORD'SIZE use 16;

    function "not" (LEFT        : UNSIGNED_WORD) return UNSIGNED_WORD;
    function "and" (LEFT, RIGHT : UNSIGNED_WORD) return UNSIGNED_WORD;
    function "or"  (LEFT, RIGHT : UNSIGNED_WORD) return UNSIGNED_WORD;
    function "xor" (LEFT, RIGHT : UNSIGNED_WORD) return UNSIGNED_WORD;

    function TO_UNSIGNED_WORD (LEFT : BIT_ARRAY_16) return UNSIGNED_WORD;
    function TO_BIT_ARRAY_16 (LEFT : UNSIGNED_WORD) return BIT_ARRAY_16;

    type UNSIGNED_WORD_ARRAY is array (INTEGER range <>) of UNSIGNED_WORD;

    type UNSIGNED_LONGWORD is range MIN_INT .. MAX_INT;

    function "not" (LEFT        : UNSIGNED_LONGWORD) return UNSIGNED_LONGWORD;
    function "and" (LEFT, RIGHT : UNSIGNED_LONGWORD) return UNSIGNED_LONGWORD;
    function "or"  (LEFT, RIGHT : UNSIGNED_LONGWORD) return UNSIGNED_LONGWORD;
    function "xor" (LEFT, RIGHT : UNSIGNED_LONGWORD) return UNSIGNED_LONGWORD;

    function TO_UNSIGNED_LONGWORD (LEFT : BIT_ARRAY_32)
       return UNSIGNED_LONGWORD;
    function TO_BIT_ARRAY_32 (LEFT : UNSIGNED_LONGWORD) return BIT_ARRAY_32;

    type UNSIGNED_LONGWORD_ARRAY is
       array (INTEGER range <>) of UNSIGNED_LONGWORD;

    type UNSIGNED_QUADWORD is
       record
         L0 : UNSIGNED_LONGWORD;
         L1 : UNSIGNED_LONGWORD;
       end record;

    function "not" (LEFT        : UNSIGNED_QUADWORD) return UNSIGNED_QUADWORD;
    function "and" (LEFT, RIGHT : UNSIGNED_QUADWORD) return UNSIGNED_QUADWORD;
    function "or"  (LEFT, RIGHT : UNSIGNED_QUADWORD) return UNSIGNED_QUADWORD;
    function "xor" (LEFT, RIGHT : UNSIGNED_QUADWORD) return UNSIGNED_QUADWORD;

    function TO_UNSIGNED_QUADWORD (LEFT : BIT_ARRAY_64)
       return UNSIGNED_QUADWORD;
    function TO_BIT_ARRAY_64 (LEFT : UNSIGNED_QUADWORD) return BIT_ARRAY_64;

    type UNSIGNED_QUADWORD_ARRAY is
       array (INTEGER range <>) of UNSIGNED_QUADWORD;

    function TO_ADDRESS  (X : INTEGER)           return ADDRESS;
    function TO_ADDRESS  (X : UNSIGNED_LONGWORD) return ADDRESS;

    function TO_INTEGER           (X : ADDRESS)  return INTEGER;
    function TO_UNSIGNED_LONGWORD (X : ADDRESS)  return UNSIGNED_LONGWORD;

    --  Conventional names for static subtypes of type UNSIGNED_LONGWORD

    subtype UNSIGNED_1  is UNSIGNED_LONGWORD range 0 .. 2** 1-1;
    subtype UNSIGNED_2  is UNSIGNED_LONGWORD range 0 .. 2** 2-1;
    subtype UNSIGNED_3  is UNSIGNED_LONGWORD range 0 .. 2** 3-1;
    subtype UNSIGNED_4  is UNSIGNED_LONGWORD range 0 .. 2** 4-1;
    subtype UNSIGNED_5  is UNSIGNED_LONGWORD range 0 .. 2** 5-1;

    subtype UNSIGNED_6  is UNSIGNED_LONGWORD range 0 .. 2** 6-1;
    subtype UNSIGNED_7  is UNSIGNED_LONGWORD range 0 .. 2** 7-1;
    subtype UNSIGNED_8  is UNSIGNED_LONGWORD range 0 .. 2** 8-1;
    subtype UNSIGNED_9  is UNSIGNED_LONGWORD range 0 .. 2** 9-1;
    subtype UNSIGNED_10 is UNSIGNED_LONGWORD range 0 .. 2**10-1;

    subtype UNSIGNED_11 is UNSIGNED_LONGWORD range 0 .. 2**11-1;
    subtype UNSIGNED_12 is UNSIGNED_LONGWORD range 0 .. 2**12-1;
    subtype UNSIGNED_13 is UNSIGNED_LONGWORD range 0 .. 2**13-1;
    subtype UNSIGNED_14 is UNSIGNED_LONGWORD range 0 .. 2**14-1;
    subtype UNSIGNED_15 is UNSIGNED_LONGWORD range 0 .. 2**15-1;

    subtype UNSIGNED_16 is UNSIGNED_LONGWORD range 0 .. 2**16-1;
    subtype UNSIGNED_17 is UNSIGNED_LONGWORD range 0 .. 2**17-1;
    subtype UNSIGNED_18 is UNSIGNED_LONGWORD range 0 .. 2**18-1;
    subtype UNSIGNED_19 is UNSIGNED_LONGWORD range 0 .. 2**19-1;
    subtype UNSIGNED_20 is UNSIGNED_LONGWORD range 0 .. 2**20-1;

    subtype UNSIGNED_21 is UNSIGNED_LONGWORD range 0 .. 2**21-1;
    subtype UNSIGNED_22 is UNSIGNED_LONGWORD range 0 .. 2**22-1;
    subtype UNSIGNED_23 is UNSIGNED_LONGWORD range 0 .. 2**23-1;
    subtype UNSIGNED_24 is UNSIGNED_LONGWORD range 0 .. 2**24-1;
    subtype UNSIGNED_25 is UNSIGNED_LONGWORD range 0 .. 2**25-1;

    subtype UNSIGNED_26 is UNSIGNED_LONGWORD range 0 .. 2**26-1;
    subtype UNSIGNED_27 is UNSIGNED_LONGWORD range 0 .. 2**27-1;
    subtype UNSIGNED_28 is UNSIGNED_LONGWORD range 0 .. 2**28-1;
    subtype UNSIGNED_29 is UNSIGNED_LONGWORD range 0 .. 2**29-1;
    subtype UNSIGNED_30 is UNSIGNED_LONGWORD range 0 .. 2**30-1;
    subtype UNSIGNED_31 is UNSIGNED_LONGWORD range 0 .. 2**31-1;

private
    -- Not shown
   type AST_HANDLER is new integer;
   type ADDRESS is new integer;
end SYSTEM;
