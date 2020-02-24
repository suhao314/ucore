------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                     G N A T . H E A P _ S O R T _ A                      --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 2 $                              --
--                                                                          --
--               Copyright (c) 1994 NYU, All Rights Reserved                --
--                                                                          --
-- The GNAT library is free software; you can redistribute it and/or modify --
-- it under terms of the GNU Library General Public License as published by --
-- the Free Software  Foundation; either version 2, or (at your option) any --
-- later version.  The GNAT library is distributed in the hope that it will --
-- be useful, but WITHOUT ANY WARRANTY;  without even  the implied warranty --
-- of MERCHANTABILITY  or  FITNESS FOR  A PARTICULAR PURPOSE.  See the  GNU --
-- Library  General  Public  License for  more  details.  You  should  have --
-- received  a copy of the GNU  Library  General Public License  along with --
-- the GNAT library;  see the file  COPYING.LIB.  If not, write to the Free --
-- Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.        --
--                                                                          --
------------------------------------------------------------------------------

--  This package provides a heapsort routine that works with access to
--  subprogram parameters, so that it can be used with different types with
--  shared sorting code (see also Gnat.Heapsort_G, the generic version)

package Gnat.Heap_Sort_A is
pragma Preelaborate (Heap_Sort_A);

   --  The data to be sorted is assumed to be indexed by integer values from
   --  1 to N, where N is the number of items to be sorted. In addition, the
   --  index value zero is used for a temporary location used during the sort.

   type Move_Procedure is access procedure (From : Natural; To : Natural);
   --  A pointer to a procedure that moves the data item with index From to
   --  the data item with index To. An index value of zero is used for moves
   --  from and to the single temporary location used by the sort.

   type Lt_Function is access function (Op1, Op2 : Natural) return Boolean;
   --  A pointer to a function that compares two items and returns True if
   --  the item with index Op1 is less than the item with index Op2, and False
   --  if the Op2 item is greater than or equal to the Op1 item.

   procedure Sort (N : Positive; Move : Move_Procedure; Lt : Lt_Function);
   --  This procedures sorts items indexed from 1 to N into ascending order
   --  making calls to Lt to do required comparisons, and Move to move items
   --  around. Note that, as described above, both Move and Lt use a single
   --  temporary location with index value zero. This sort is not stable,
   --  i.e. the order of equal elements in the input is not preserved.

end Gnat.Heap_Sort_A;
