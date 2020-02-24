unit System;
interface
type
   HRESULT = type Longint;

   // tbd - I couldn't find HMODULE in docs, but it is used as param
   // type. Added THandle to HMODULE from freeclx
   THandle = Longword;
   HRSRC = THandle;
   TResourceHandle = HRSRC;
   HINST = THandle;
   HMODULE = HINST;

   UCS4Char = type LongWord;
   UCS4String = array of UCS4Char;
   PUCS4Char = ^UCS4Char;
   UTF8String = type string;

   // tbd - not in help, but reffed in help 
   PLongint      = ^Longint;
   PInteger      = ^Integer;
   PCardinal     = ^Cardinal;
   PWord         = ^Word;
   PSmallInt     = ^SmallInt;
   PByte         = ^Byte;
   PShortInt     = ^ShortInt;
   PInt64        = ^Int64;
   PLongWord     = ^LongWord;
   PSingle       = ^Single;
   PDouble       = ^Double;
   PDate         = ^Double;
   PDispatch     = ^IDispatch;
   PPDispatch    = ^PDispatch;
   PError        = ^LongWord;
   PWordBool     = ^WordBool;
   PUnknown      = ^IUnknown;
   PPUnknown     = ^PUnknown;
   PPWideChar    = ^PWideChar;
   PPChar        = ^PChar;
   PPAnsiChar    = PPChar;
   PExtended     = ^Extended;
   PComp         = ^Comp;
   PCurrency     = ^Currency;
   PVariant      = ^Variant;
   POleVariant   = ^OleVariant;
   PPointer      = ^Pointer;
   PBoolean      = ^Boolean;

   PString = ^AnsiString;

   TDateTime = type Double;

   TVarOp = Integer;

   TTextLineBreakStyle = (tlbsLF, tlbsCRLF);

   TEnumModuleFunc = function (HInstance: Integer; Data: Pointer): Boolean;
   TEnumModuleFuncLW = function (HInstance: LongWord; Data: Pointer): Boolean;

   TThreadFunc = function(Parameter: Pointer): Integer;

   PMemoryManager = ^TMemoryManager;
   TMemoryManager = record 
      GetMem: function(Size: Integer): Pointer;
      FreeMem: function(P: Pointer): Integer;
      ReallocMem: function(P: Pointer; Size: Integer): Pointer;
   end;

   PLibModule = ^TLibModule;
   TLibModule = record
      Next: PLibModule;
      Instance: LongWord;
      CodeInstance: LongWord;
      DataInstance: LongWord;
      ResInstance: LongWord;
      Reserved: Integer;
    end;

   PGUID = ^TGUID;
   TGUID = packed record
      D1: Longword;
      D2: Word;
      D3: Word;
      D4: array[0..7] of Byte;
   end;

   PInterfaceEntry = ^TInterfaceEntry;
   TInterfaceEntry = packed record
      IID: TGUID;
      VTable: Pointer;
      IOffset: Integer;
      ImplGetter: Integer;
   end;

   PInterfaceTable = ^TInterfaceTable;
   TInterfaceTable = packed record
      EntryCount: Integer;
      Entries: array[0..9999] of TInterfaceEntry;
   end;

   PCallDesc = ^TCallDesc;
   TCallDesc = packed record
      CallType: Byte;
      ArgCount: Byte;
      NamedArgCount: Byte;
      ArgTypes: array[0..255] of Byte;
   end;

   PResStringRec = ^TResStringRec;
   TResStringRec = packed record
      Module: ^Cardinal;
      Identifier: Integer;
   end;


   PVarData = ^TVarData;
   TVarArrayBound = packed record
      ElementCount: Integer;
      LowBound: Integer;
   end;

   TVarArrayBoundArray = array [0..0] of TVarArrayBound;
   PVarArray = ^TVarArray;
   TVarArray = packed record
      DimCount: Word;
      Flags: Word;
      ElementSize: Integer;
      LockCount: Integer;
      Data: Pointer;
      Bounds: TVarArrayBoundArray;
   end;

   TVarType = Word;

const
   varEmpty    = $0000;
   varNull     = $0001;
   varSmallint = $0002;
   varInteger  = $0003;
   varSingle   = $0004;
   varDouble   = $0005;
   varCurrency = $0006;
   varDate     = $0007;
   varOleStr   = $0008;
   varDispatch = $0009;
   varError    = $000A;
   varBoolean  = $000B;
   varVariant  = $000C;
   varUnknown  = $000D;
   varShortInt = $0010;
   varByte     = $0011;
   varWord     = $0012;
   varLongWord = $0013;
   varInt64    = $0014;
   varStrArg   = $0048;
   varString   = $0100;
   varAny      = $0101; 
   varTypeMask = $0FFF;
   varArray    = $2000;
   varByRef    = $4000;

type
   TVarData = packed record
    case Integer of
      0: (VType: TVarType;
          case Integer of
            0: (Reserved1: Word;
                case Integer of
                  0: (Reserved2, Reserved3: Word;
                      case Integer of
                        varSmallInt: (VSmallInt: SmallInt);
                        varInteger:  (VInteger: Integer);
                        varSingle:   (VSingle: Single);
                        varDouble:   (VDouble: Double);

                        varCurrency: (VCurrency: Currency);
                        varDate:     (VDate: TDateTime);
                        varOleStr:   (VOleStr: PWideChar);
                        varDispatch: (VDispatch: Pointer);
                        varError:    (VError: HRESULT);
                        varBoolean:  (VBoolean: WordBool);
                        varUnknown:  (VUnknown: Pointer);
                        varShortInt: (VShortInt: ShortInt);
                        varByte:     (VByte: Byte);

                        varWord:     (VWord: Word);
                        varLongWord: (VLongWord: LongWord);
                        varInt64:    (VInt64: Int64);
                        varString:   (VString: Pointer);
                        varAny:      (VAny: Pointer);
                        varArray:    (VArray: PVarArray);
                        varByRef:    (VPointer: Pointer);
                     );
                  1: (VLongs: array[0..2] of LongInt);

               );
            2: (VWords: array [0..6] of Word);
            3: (VBytes: array [0..13] of Byte);
          );
      1: (RawData: array [0..3] of LongInt);
   end;

   // tbd - couldn't find IDispatch in docs. Used one from freeclx. 
   IDispatch = interface(IUnknown)
      ['{00020400-0000-0000-C000-000000000046}']
      function GetTypeInfoCount(out Count: Integer): HResult; stdcall;
      function GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult; stdcall;
      function GetIDsOfNames(const IID: TGUID; Names: Pointer;
        NameCount, LocaleID: Integer; DispIDs: Pointer): HResult; stdcall;
      function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
        Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult; stdcall;
   end;

   PVariantManager = ^TVariantManager;
   TVariantManager = record
      VarClear: procedure(var V : Variant);
      VarCopy: procedure(var Dest: Variant; const Source: Variant);
      VarCopyNoInd: procedure;
      VarCast: procedure(var Dest: Variant; const Source: Variant; VarType: Integer);
      VarCastOle: procedure(var Dest: Variant; const Source: Variant; VarType: Integer);
      VarToInt: function(const V: Variant): Integer;
      VarToInt64: function(const V: Variant): Int64;
      VarToBool: function(const V: Variant): Boolean;
      VarToReal: function(const V: Variant): Extended;
      VarToCurr: function(const V: Variant): Currency;
      VarToPStr: procedure(var S; const V: Variant);
      VarToLStr: procedure(var S: string; const V: Variant);
      VarToWStr: procedure(var S: WideString; const V: Variant);
      VarToIntf: procedure(var Unknown: IInterface; const V: Variant);
      VarToDisp: procedure(var Dispatch: IDispatch; const V: Variant);
      VarToDynArray: procedure(var DynArray: Pointer; const V: Variant; TypeInfo: Pointer);
      VarFromInt: procedure(var V: Variant; const Value: Integer; 
                            const Range: ShortInt);
      VarFromInt64: procedure(var V: Variant; const Value: Int64);
      VarFromBool: procedure(var V: Variant; const Value: Boolean);
      VarFromReal: procedure;
      VarFromTDateTime: procedure;
      VarFromCurr: procedure;
      VarFromPStr: procedure(var V: Variant; const Value: ShortString);
      VarFromLStr: procedure(var V: Variant; const Value: string);
      VarFromWStr: procedure(var V: Variant; const Value: WideString);
      VarFromIntf: procedure(var V: Variant; const Value: IInterface);
      VarFromDisp: procedure(var V: Variant; const Value: IDispatch);
      VarFromDynArray: procedure(var V: Variant; const DynArray: Pointer; TypeInfo: Pointer);
      OleVarFromPStr: procedure(var V: OleVariant; const Value: ShortString);
      OleVarFromLStr: procedure(var V: OleVariant; const Value: string);
      OleVarFromVar: procedure(var V: OleVariant; const Value: Variant);
      OleVarFromInt: procedure(var V: OleVariant; const Value, Range: Integer);
      VarOp: procedure(var Left: Variant; const Right: Variant; OpCode: TVarOp);
      VarCmp: procedure(const Left, Right: TVarData; const OpCode: TVarOp);
      VarNeg: procedure(var V: Variant);
      VarNot: procedure(var V: Variant);
      DispInvoke: procedure(Dest: PVarData; const Source: TVarData; CallDesc: PCallDesc; Params: Pointer); cdecl;
      VarAddRef: procedure(var V: Variant);
      VarArrayRedim: procedure(var A : Variant; HighBound: Integer);
      VarArrayGet: function(var A: Variant; IndexCount: Integer; Indices: Integer): Variant; cdecl;
      VarArrayPut: procedure(var A: Variant; const Value: Variant;
                             IndexCount: Integer; Indices: Integer); cdecl;
      WriteVariant: function(var T: Text; const V: Variant; Width: Integer): Pointer;
      Write0Variant: function(var T: Text; const V: Variant): Pointer; 
   end;


   TObject = class;
   TClass = class of TObject;
   TObject = class
      procedure AfterConstruction; virtual;
      procedure BeforeDestruction; virtual;
      class function ClassInfo: Pointer;
      class function ClassName: ShortString;
      class function ClassNameIs(const Name: string): Boolean;
      class function ClassParent: TClass;
      function ClassType: TClass;
      procedure CleanupInstance;
      constructor Create;
      procedure DefaultHandler(var Message); virtual;
      destructor Destroy; virtual;
      procedure Dispatch(var Message); virtual;
      function FieldAddress(const Name: ShortString): Pointer;
      procedure Free;
      procedure FreeInstance; virtual;
      function GetInterface(const IID: TGUID; out Obj): Boolean;
      class function GetInterfaceEntry(const IID: TGUID): PInterfaceEntry;
      class function GetInterfaceTable: PInterfaceTable;
      class function InheritsFrom(aClass: TClass): Boolean;
      class function InitInstance(Instance: Pointer): TObject;
      class function InstanceSize: Longint;
      class function MethodAddress(const Name: ShortString): Pointer;
      class function MethodName(Address: Pointer): ShortString;
      class function NewInstance: TObject; virtual;
      function SafeCallException(ExceptObject: TObject; ExceptAddr: Pointer): HResult; virtual;
   end;

   IInterface = interface
      function _AddRef: Integer; stdcall;      
      function _Release: Integer; stdcall;
      function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
   end;

   IInvokable = interface(IInterface)
   end;

   IUnknown = interface(IInterface)
   end;

   IAggregatedObject = class(TObject)
      constructor Create(const Controller: IInterface);
      property Controller: IInterface;
   end;

   IContainedObject = class(IAggregatedObject)
   end;
   
   TInterfacedObject = class(TObject)
      procedure AfterConstruction; override;
      procedure BeforeDestruction; override;
      class function NewInstance: TObject; override;
      property RefCount: Integer;
   protected
      function _AddRef: Integer; stdcall;
      function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
      function _Release: Integer; stdcall;
   end;

var AllocMemCount: Integer;
var AllocMemSize: Integer;
var AssertErrorProc: Pointer;
var CmdLine: PChar platform;
var CmdShow: Integer;
const CompilerVersion = 15.0;
var Default8087CW: Word;
var DefaultTextLineBreakStyle: TTextLineBreakStyle;
var ErrorAddr: Pointer = nil;
var  ErrorProc: procedure (ErrorCode: Byte; ErrorAddr: Pointer); 
var ErrOutput: Text;
var ExceptProc: Pointer;
var ExitCode: Integer = 0;
var ExitProc: Pointer;
var ExitProcessProc: procedure;
const fmClosed = $D7B0;  
const fmInput  = $D7B1;
const fmOutput = $D7B2;
const fmInOut  = $D7B3;
const fmCRLF   = $8;
const fmMask   = $D7B3;
var FileAccessRights: Integer platform;
var FileMode: Byte = 2;
var HeapAllocFlags: Word platform = 2;
var InitProc: Pointer;
var Input: Text;
var IsConsole: Boolean;
var IsLibrary: Boolean;
var IsMultiThread: Boolean;
var JITEnable: Byte = 0;
var LibModuleList: PLibModule = nil;
var MainInstance: LongWord;
var MainThreadID: LongWord;
const MaxInt = High(Integer);
const MaxLongint = High(Longint);
var NoErrMsg: Boolean=False;
var Output: Text;
var RandSeed: LongInt = 0;

const RTLVersion = 15.0;

// System functions/procedures

function Abs(X);
function AcquireExceptionObject: Pointer;
function Addr(X): Pointer;
function AnsiToUtf8(const S: string): UTF8String;
procedure Append(var F: Text);
function ArcTan(X: Extended): Extended;
// tbd - Added default value for optional param msg.
procedure Assert(expr : Boolean; const msg: string = "");
function Assigned(const P): Boolean;
procedure AssignFile(var F; FileName: string);




function BeginThread(SecurityAttributes: Pointer; StackSize: LongWord; 
                     ThreadFunc: TThreadFunc; Parameter: Pointer; 
                     CreationFlags: LongWord; var ThreadId: LongWord): Integer;

// tbd adding default values for optionals
procedure BlockRead(var F: File; var Buf; Count: Integer; var AmtTransferred: Integer = 0);
procedure BlockWrite(var f: File; var Buf; Count: Integer; varAmtTransferred: Integer = 0);

procedure Break;

procedure ChDir(const S: string); overload;
procedure ChDir(P: PChar); overload;


function Chr(X: Byte): Char;
procedure Close(var F);
procedure CloseFile(var F);

function CompToCurrency(Value: Comp): Currency; cdecl;
function CompToDouble(Value: Comp): Double; cdecl;

// tbd - Changed to expect 2 parameters, should take n. 
function Concat(s1, s2 : string): string;

procedure Continue;

function Copy(S; Index, Count: Integer): string;
// function Copy(S; Index, Count: Integer): array;   tbd - syntax error on array

function Cos(X: Extended): Extended;

procedure CurrencyToComp(Value: Currency; var Result: Comp); cdecl;

procedure Delete(var S: string; Index, Count:Integer);
procedure Dispose(var P: Pointer);

function DoubleToComp(Value: Double; var Result: Comp); cdecl;
procedure EndThread(ExitCode: Integer);

procedure EnumModules(Func: TEnumModuleFunc; Data: Pointer); overload;
procedure EnumModules(Func: TEnumModuleFuncLW; Data: Pointer); overload;

procedure EnumResourceModules(Func: TEnumModuleFunc; Data: Pointer);
procedure EnumResourceModules(Func: TEnumModuleFuncLW; Data: Pointer);

function Eof(var F): Boolean;

function Eoln (var F: Text): Boolean;

procedure Erase(var F);

function ExceptAddr: Pointer;

function ExceptObject: TObject;

// tbd - this creates an unknown on T, for now using predeclared file
// procedure Exclude(var S: set of T;I:T);
procedure Exit;

function Exp(X: Real): Real;
function FilePos(var F): Longint;
function FileSize(var F): Integer;
procedure FillChar(var X; Count: Integer; Value: Byte);
function Flush(var t: Text): Integer;
function Frac(X: Extended): Extended;
procedure FreeMem(var P: Pointer; Size: Integer = 0);
function Get8087CW: Word;

procedure GetDir(D: Byte; var S: string);
function GetLastError: Integer; stdcall;
function GetLastError: Integer;

procedure GetMem(var P: Pointer; Size: Integer);
procedure GetMemoryManager(var MemMgr: TMemoryManager);
function GetModuleFileName(Module: HMODULE; Buffer: PChar; BufLen: Integer): Integer;
procedure GetVariantManager(var VarMgr: TVariantManager);
procedure Halt (Exitcode: Integer = 0);
function Hi(X): Byte;
function High(X);
procedure Inc(var X; N: Longint = 0);
// tbd - this creates an unknown on T, for now using predeclared file
// procedure Include(var S: set of T; I:T);
procedure Initialize(var V; Count: Integer = 0);
procedure Insert(Source: string; var S: string; Index: Integer);
function Int(X: Extended): Extended;
function IOResult: Integer;

function IsMemoryManagerSet:Boolean;
function IsVariantManagerSet: Boolean;
function Length(S): Integer;
function Ln(X: Real): Real;
function Lo(X): Byte;
function Low(X);
procedure MkDir(const S: string); overload;
procedure MkDir(P: PChar); overload;
procedure Move(const Source; var Dest; Count: Integer);
procedure New(var P: Pointer);
function Odd(X: Longint): Boolean;
function OleStrToString(Source: PWideChar): string;
function Ord(X);
function ParamCount: Integer;
function Pi: Extended;
function Pos(Substr: string; S: string): Integer;
function Pred(X);
function Ptr(Address: Integer): Pointer;
function PUCS4Chars(const S: UCS4String): PUCS4Char;
function Random ( Range: Integer = 0);
procedure Randomize;
// tbd  - changed params on these Reads to just 1 value.
procedure Read(F , V1);
procedure Read( var F: Text = ""; V1);
procedure ReadLn(var F: Text = ""; V1);
procedure ReallocMem(var P: Pointer; Size: Integer);
procedure ReleaseExceptionObject;

procedure Rename(var F; Newname: string);
procedure Rename(var F; Newname: PChar);
procedure Reset(var F : File; RecSize: Word = 0);
procedure Rewrite(var F: File; Recsize: Word = 0);

procedure RmDir(const S: string); overload;
procedure RmDir(P: PChar); overload;
function Round(X: Extended): Int64;
procedure RunError ( Errorcode: Byte = 0);
procedure Seek(var F; N: Longint);
function SeekEof (var F: Text = ""): Boolean;
function SeekEoln (var F: Text = ""): Boolean;

procedure Set8087CW(NewCW: Word);
procedure SetLength(var S; NewLength: Integer);
procedure SetLineBreakStyle(var T: Text; Style: TTextLineBreakStyle);

procedure SetMemoryManager(const MemMgr: TMemoryManager);
procedure SetString(var s: string; buffer: PChar; len: Integer);
procedure SetTextBuf(var F: Text; var Buf; Size: Integer = 0 );
procedure SetVariantManager(const VarMgr: TVariantManager);
function Sin(X: Extended): Extended;

function SizeOf(X): Integer;

function Slice(var A: array; Count: Integer): array;
function Sqr(X: Extended): Extended;
function Sqr(X: Integer): Integer;
function Sqrt(X: Extended): Extended;

// tbd - uses types width, decimals, that are unknown - put this in
//   predeclared file for now
// procedure Str(X [: Width [: Decimals ]]; var S);

function StringOfChar(Ch: Char; Count: Integer): string;
function StringToOleStr(const Source: string): PWideChar;
function StringToWideChar(const Source: string; Dest: PWideChar; DestSize: Integer): PWideChar;

function Succ(X);
function Swap(X);
function Trunc(X: Extended): Int64;
procedure Truncate(var F);
function TypeInfo(TypeIdent): Pointer;
function UCS4StringToWideString(const S: UCS4String): WideString;
function UnicodeToUtf8(Dest: PChar; MaxDestBytes: Cardinal; Source: PWideChar; SourceChars: Cardinal): Cardinal; overload;
function UnicodeToUtf8(Dest: PChar; Source: PWideChar; MaxBytes: Integer): Integer; overload
; deprecated;

procedure UniqueString(var str: string); overload;
procedure UniqueString(var str: WideString); overload;
function UpCase(Ch: Char): Char;

function UTF8Decode(const S: UTF8String): WideString;
function UTF8Encode(const WS: WideString): UTF8String;
procedure Val(S; var V; var Code: Integer);
procedure VarArrayRedim(A: Variant; HighBound: Integer);
procedure VarClear(V: Variant);
function WideCharLenToString(Source: PWideChar; SourceLen: Integer): string;
procedure WideCharLenToStrVar(Source: PWideChar; SourceLen: Integer; var Dest: string);

function WideCharToString(Source: PWideChar): string;


procedure WideCharToStrVar(Source: PWideChar; var Dest: string);
function WideStringToUCS4String(const S: WideString): UCS4String;

// tbd - not sure how to represent params on these
procedure Write(var F : Text = ""; P1);
procedure Write(F,V1);
procedure WriteLn(var F : Text = ""; P1);

implementation

end.





