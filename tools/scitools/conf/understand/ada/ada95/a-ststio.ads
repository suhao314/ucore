------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                A D A . S T R E A M S . S T R E A M _ I O                 --
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


with Text_IO;
with Ada.IO_Exceptions;

package Ada.Streams.Stream_IO is

   type Stream_Access is access Root_Stream_Type'Class;

   type File_Type is limited private;

   type File_Mode is (In_File, Out_File, Append_File);

   type Count is new Stream_Element_Offset;

   subtype Positive_Count is Count range 1 .. Count'Last;
   --  Index into file, in stream elements

   ---------------------
   -- File Management --
   ---------------------

   procedure Create
     (File : in out File_Type;
      Mode : in File_Mode := Out_File;
      Name : in String := "";
      Form : in String := "");

   procedure Open
     (File : in out File_Type;
      Mode : in File_Mode;
      Name : in String;
      Form : in String := "");

   procedure Close  (File : in out File_Type);
   procedure Delete (File : in out File_Type);
   procedure Reset  (File : in out File_Type; Mode : in File_Mode);
   procedure Reset  (File : in out File_Type);

   function Mode (File : in File_Type) return File_Mode;
   function Name (File : in File_Type) return String;
   function Form (File : in File_Type) return String;

   function Is_Open     (File : in File_Type) return Boolean;
   function End_Of_File (File : in File_Type) return Boolean;

   function Stream  (File : in File_Type) return Stream_Access;

   -----------------------------
   -- Input-Output Operations --
   -----------------------------

   procedure Read
     (File : in  File_Type;
      Item : out Stream_Element_Array;
      Last : out Stream_Element_Offset;
      From : in  Positive_Count);

   procedure Read
     (File : in  File_Type;
      Item : out Stream_Element_Array;
      Last : out Stream_Element_Offset);

   procedure Write
     (File : in File_Type;
      Item : in Stream_Element_Array;
      To   : in Positive_Count);

   procedure Write
     (File : in File_Type;
      Item : in Stream_Element_Array);

   ----------------------------------------
   -- Operations on Position within File --
   ----------------------------------------

   procedure Set_Index (File : in File_Type; To : in Positive_Count);

   function Index (File : in File_Type) return Positive_Count;
   function Size  (File : in File_Type) return Count;

   procedure Set_Mode (File : in out File_Type; Mode : in File_Mode);

   procedure Flush (File : in out File_Type);

   ----------------
   -- Exceptions --
   ----------------

   Status_Error : exception renames IO_Exceptions.Status_Error;
   Mode_Error   : exception renames IO_Exceptions.Mode_Error;
   Name_Error   : exception renames IO_Exceptions.Name_Error;
   Use_Error    : exception renames IO_Exceptions.Use_Error;
   Device_Error : exception renames IO_Exceptions.Device_Error;
   End_Error    : exception renames IO_Exceptions.End_Error;
   Data_Error   : exception renames IO_Exceptions.Data_Error;

private
   type File_Type is new Text_IO.File_Type;
   --  Stream_IO is implemented using Text_IO

   --  Inline everything, since we just call corresponding Text_IO routines

   pragma Inline (Create);
   pragma Inline (Open);
   pragma Inline (Close);
   pragma Inline (Delete);
   pragma Inline (Reset);
   pragma Inline (Stream);
   pragma Inline (Mode);
   pragma Inline (Name);
   pragma Inline (Form);
   pragma Inline (Is_Open);
   pragma Inline (End_Of_File);
   pragma Inline (Read);
   pragma Inline (Write);
   pragma Inline (Set_Index);
   pragma Inline (Index);
   pragma Inline (Size);
   pragma Inline (Set_Mode);
   pragma Inline (Flush);

end Ada.Streams.Stream_IO;
