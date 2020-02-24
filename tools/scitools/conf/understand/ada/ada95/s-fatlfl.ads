------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                      S Y S T E M . F A T _ L F L T                       --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 2 $                              --
--                                                                          --
-- This  specification comes from the Generic Primitive Functions standard. --
-- In accordance  with the copyright of that document,  you can freely copy --
-- and modify this specification,  provided that if you do redistribute it, --
-- then any changes that you have made must be clearly indicated.           --
--                                                                          --
------------------------------------------------------------------------------

--  This package contains an instantiation of the floating-point attribute
--  runtime routines for the type Long_Float.

with System.Fat_Gen;

package System.Fat_LFlt is

   --  Note the only entity from this package that is acccessed by Rtsfind
   --  is the name of the package instantiation. Entities within this package
   --  (i.e. the individual floating-point attribute routines) are accessed
   --  by name using selected notation.

   package Fat_Long_Float is new System.Fat_Gen (Long_Float);

end System.Fat_LFlt;
