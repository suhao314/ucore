// tbd - The help for unit 'type' isn't in my delphi 7 help. I did
//  find a bad link to 'types' help, so it looks like it's just
//  missing.


unit Types;
interface
type
   // tbd - not in help
   PLongint = System.PLongint;
   PInteger = System.PInteger;
   PSmallInt = System.PSmallInt;
   PDouble = System.PDouble;
   PByte = System.PByte;

   TIntegerDynArray      = array of Integer;
   TCardinalDynArray     = array of Cardinal;
   TWordDynArray         = array of Word;
   TSmallIntDynArray     = array of SmallInt;
   TByteDynArray         = array of Byte;
   TShortIntDynArray     = array of ShortInt;
   TInt64DynArray        = array of Int64;
   TLongWordDynArray     = array of LongWord;
   TSingleDynArray       = array of Single;
   TDoubleDynArray       = array of Double;
   TBooleanDynArray      = array of Boolean;
   TStringDynArray       = array of string;
   TWideStringDynArray   = array of WideString;

   // tbd - PPoint not in help
   PPoint = ^TPoint;
   TPoint = packed record
      X: Longint;
      Y: Longint;
   end;

   TRect = packed record
      case Integer of
         0: (Left, Top, Right, Bottom: Integer);
         1: (TopLeft, BottomRight: TPoint);
      end;
   
   // tbd - not in help
   tagPOINT = TPoint;

   PSize = ^TSize;
   tagSIZE = packed record
     cx: Longint;
     cy: Longint;
   end;

   tagSIZE = packed record
      cx: Longint;
      cy: Longint;
   end;
   TSize = tagSIZE;

   // tbd - not in help
   SIZE = tagSIZE;

   // tbd - PSmallPoint not in help
   PSmallPoint = ^TSmallPoint;
   TSmallPoint = packed record
      x: SmallInt;
      y: SmallInt;
   end;

   DWORD = Longword;

   PDisplay = Pointer;

   // tbd - not in help
   PEvent = Pointer;
   TXrmOptionDescRec = record end;
   XrmOptionDescRec = TXrmOptionDescRec;
   PXrmOptionDescRec = ^TXrmOptionDescRec;
   Widget = Pointer;
   WidgetClass = Pointer;
   ArgList = Pointer;
   Region = Pointer;

   TValueRelationship = -1..1;

const
  LessThanValue = -1;
  EqualsValue = 0;
  GreaterThanValue = 1;

const
   // tbd - not in help
   RT_RCDATA       = PChar(10);
   STGTY_STORAGE   = 1;
   STGTY_STREAM    = 2;
   STGTY_LOCKBYTES = 3;
   STGTY_PROPERTY  = 4;
   STREAM_SEEK_SET = 0;
   STREAM_SEEK_CUR = 1;
   STREAM_SEEK_END = 2;
   LOCK_WRITE     = 1;
   LOCK_EXCLUSIVE = 2;
   LOCK_ONLYONCE  = 4;

   E_FAIL = HRESULT($80004005);
   STG_E_INVALIDFUNCTION = HRESULT($80030001);
   STG_E_FILENOTFOUND = HRESULT($80030002);
   STG_E_PATHNOTFOUND = HRESULT($80030003);
   STG_E_TOOMANYOPENFILES = HRESULT($80030004);
   STG_E_ACCESSDENIED = HRESULT($80030005);

   // tbd - not in help
   STG_E_INVALIDHANDLE = HRESULT($80030006);

   STG_E_INSUFFICIENTMEMORY = HRESULT($80030008);
   STG_E_INVALIDPOINTER = HRESULT($80030009);
   STG_E_NOMOREFILES = HRESULT($80030012);
   STG_E_DISKISWRITEPROTECTED = HRESULT($80030013);
   STG_E_SEEKERROR = HRESULT($80030019);
   STG_E_WRITEFAULT = HRESULT($8003001D);
   STG_E_READFAULT = HRESULT($8003001E);

   // tbd - not in help
   STG_E_SHAREVIOLATION = HRESULT($80030020);

   STG_E_LOCKVIOLATION = HRESULT($80030021);
   STG_E_FILEALREADYEXISTS = HRESULT($80030050);
   STG_E_INVALIDPARAMETER = HRESULT($80030057);
   STG_E_MEDIUMFULL = HRESULT($80030070);

   // tbd - not in help
   STG_E_PROPSETMISMATCHED = HRESULT($800300F0);
   STG_E_ABNORMALAPIEXIT = HRESULT($800300FA);
   STG_E_INVALIDHEADER = HRESULT($800300FB);

   STG_E_INVALIDNAME = HRESULT($800300FC);

   // tbd - not in help
   STG_E_UNKNOWN = HRESULT($800300FD);
   STG_E_UNIMPLEMENTEDFUNCTION = HRESULT($800300FE);

   STG_E_INVALIDFLAG = HRESULT($800300FF);

   // tbd - not in help
   STG_E_INUSE = HRESULT($80030100);

   STG_E_NOTCURRENT = HRESULT($80030101);
   STG_E_REVERTED = HRESULT($80030102);
   STG_E_CANTSAVE = HRESULT($80030103);

   // tbd - not in help
   STG_E_OLDFORMAT = HRESULT($80030104);
   STG_E_OLDDLL = HRESULT($80030105);
   STG_E_SHAREREQUIRED = HRESULT($80030106);
   STG_E_NOTFILEBASEDSTORAGE = HRESULT($80030107);
   STG_E_EXTANTMARSHALLINGS = HRESULT($80030108);
   STG_E_DOCFILECORRUPT = HRESULT($80030109);
   STG_E_BADBASEADDRESS = HRESULT($80030110);
   STG_E_INCOMPLETE = HRESULT($80030201);
   STG_E_TERMINATED = HRESULT($80030202);
   STG_S_CONVERTED = $00030200;
   STG_S_BLOCK = $00030201;
   STG_S_RETRYNOW = $00030202;
   STG_S_MONITORING = $00030203;
   GUID_NULL: TGUID = '{00000000-0000-0000-0000-000000000000}';

type
   // tbd - not in help
   TOleChar = WideChar;
   POleStr = PWideChar;
   PPOleStr = ^POleStr;
   PCLSID = PGUID;
   TCLSID = TGUID;
   Largeint = Int64;
   PDWORD = ^DWORD;
   PFileTime = ^TFileTime;
   _FILETIME = packed record
      dwLowDateTime: DWORD;
      dwHighDateTime: DWORD;
   end;
   TFileTime = _FILETIME;
   FILETIME = _FILETIME;
 
   tagSTATSTG = record
      pwcsName: POleStr;
      dwType: Longint;
      cbSize: Largeint;
      mtime: TFileTime;
      ctime: TFileTime;
      atime: TFileTime;
      grfMode: Longint;
      grfLocksSupported: Longint;
      clsid: TCLSID;
      grfStateBits: Longint;
      reserved: Longint;
   end;
   TStatStg = tagSTATSTG;

   // tbd - not in help
   PStatStg = ^TStatStg;
   STATSTG = TStatStg;

   // tbd - not in help
   IClassFactory = interface(IUnknown)
     ['{00000001-0000-0000-C000-000000000046}']
     function CreateInstance(const unkOuter: IUnknown; const iid: TGUID;
       out obj): HResult; stdcall;
     function LockServer(fLock: LongBool): HResult; stdcall;
   end;

   ISequentialStream = interface(IUnknown)
      function Read(pv: Pointer; cb: Longint; pcbRead: PLongint): HResult; virtual; stdcall;
      function Write(pv: Pointer; cb: Longint; pcbWritten: PLongint): HResult; virtual; stdcall;
   end;

   IStream = interface(ISequentialStream)
      function Clone(out stm: IStream): HResult; stdcall;
      function Commit(grfCommitFlags: Longint): HResult; stdcall;
      function CopyTo(stm: IStream; cb: Largeint; out cbRead: Largeint; out cbWritten: Largeint): HResult; stdcall;
      function LockRegion(libOffset: Largeint; cb: Largeint; dwLockType: Longint): HResult; stdcall;
      function Revert: HResult; stdcall;
      function Seek(dlibMove: Largeint; dwOrigin: Longint; out libNewPosition: Largeint): HResult; stdcall;
      function SetSize(libNewSize: Largeint): HResult; stdcall;
      function Stat(out statstg: TStatStg; grfStatFlag: Longint): HResult; virtual; stdcall;
      function UnlockRegion(libOffset: Largeint; cb: Largeint; dwLockType: Longint): HResult; stdcall;
   end;

  
   function Bounds(ALeft, ATop, AWidth, AHeight: Integer): TRect;
   function CenterPoint(const Rect: TRect): TPoint;
   function IntersectRect(out Rect: TRect; const R1, R2: TRect): Boolean;
   function IsRectEmpty(const Rect: TRect): Boolean;
   function IsRectEmpty(const Rect: TRect): Boolean;
   function OffsetRect(var Rect: TRect; DX: Integer; DY: Integer): Boolean;
   function Point(AX, AY: Integer): TPoint;
   function PtInRect(const Rect: TRect; const P: TPoint): Boolean;
   function Rect(ALeft, ATop, ARight, ABottom: Integer): TRect; overload;
   function Rect(const ATopLeft, ABottomRight: TPoint): TRect; overload;
   function UnionRect(out Rect: TRect; const R1, R2: TRect): Boolean;

implementation
end.
