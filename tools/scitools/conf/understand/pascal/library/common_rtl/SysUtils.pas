unit SysUtils;
interface
uses Windows;
type 
   UINT = LongWord;
   TSysLocale = packed record
      DefaultLCID: LCID;
      PriLangID: Integer;
      SubLangID: Integer;
      FarEast: Boolean;
      MiddleEast: Boolean;
   end;

   TFormatSettings = record
      CurrencyFormat: Byte;
      NegCurrFormat: Byte;
      ThousandSeparator: Char;
      DecimalSeparator: Char;
      CurrencyDecimals: Byte;
      DateSeparator: Char;
      TimeSeparator: Char;
      ListSeparator: Char;
      CurrencyString: string;
      ShortDateFormat: string;
      LongDateFormat: string;
      TimeAMString: string;
      TimePMString: string;
      ShortTimeFormat: string;
      LongTimeFormat: string;
      ShortMonthNames: array[1..12] of string;
      LongMonthNames: array[1..12] of string;
      ShortDayNames: array[1..7] of string;
      LongDayNames: array[1..7] of string;
      TwoDigitYearCenturyWindow: Word;
   end;

   TFloatFormat = (ffGeneral, ffExponent, ffFixed, ffNumber, ffCurrency);
   TFileName = type string;
   TFilenameCaseMatch = (mkNone, mkExactMatch, mkSingleMatch, mkAmbiguous);
   TFloatValue = (fvExtended, fvCurrency);
   TMbcsByteType = (mbSingleByte, mbLeadByte, mbTrailByte);
   TNameType = (ntContainsUnit, ntRequiresPackage, ntDcpBpiName);

   TPackageInfoProc = procedure (const Name: string; NameType: TNameType; Flags: Byte; Param: Pointer);
   TProcedure = procedure;
   TReplaceFlags = set of (rfReplaceAll, rfIgnoreCase);
   TSysCharSet = set of Char;

   TSearchRec = record
      Time: Integer;
      Size: Integer;
      Attr: Integer;
      Name: TFileName;
      ExcludeAttr: Integer;
{$IFDEF LINUX}
      Mode: mode_t;
{$ENDIF}
      FindHandle: THandle;
{$IFDEF LINUX}
      PathOnly: string;
      Pattern: string;
{$ENDIF}
{$IFDEF WINDOWS}
      FindData: TWin32FindData;
{$ENDIF}
   end;

   TFloatRec = record
      Exponent: Smallint;
      Negative: Boolean;
      Digits: array[0..20] of Char;
   end;

   TTimeStamp = record
      Time: Integer;
      Date: Integer;
   end;

   PByteArray = ^TByteArray;
   TByteArray = array[0..32767] of Byte;

var CurrencyString: string;
var CurrencyFormat: Byte;
var NegCurrFormat: Byte;
var ThousandSeparator: Char;
var DecimalSeparator: Char;
var CurrencyDecimals: Byte;
var DateSeparator: Char;
var ShortDateFormat: string;
var LongDateFormat: string;
var TimeSeparator: Char;
var TimeAMString: string;
var TimePMString: string;
var ShortTimeFormat: string;
var LongTimeFormat: string;

var ShortMonthNames: array[1..12] of string;
var LongMonthNames: array[1..12] of string;
var ShortDayNames: array[1..7] of string;
var LongDayNames: array[1..7] of string;
var SysLocale: TSysLocale;
var EraNames: array[1..7] of string;
var EraYearOffsets: array[1..7] of Integer;
var TwoDigitYearCenturyWindow: Word = 50;

var ListSeparator: Char;

var FalseBoolStrs: array of String;

var LeadBytes: set of Char = [];

var TrueBoolStrs: array of String;

var Win32Platform: Integer = 0;

const DateDelta = 693594;
  const

    fmCreate         = $FFFF;
    fmOpenRead       = $0000;
    fmOpenWrite      = $0001;
    fmOpenReadWrite  = $0002;

    fmShareCompat    = $0000 platform;
    fmShareExclusive = $0010;
    fmShareDenyWrite = $0020;
    fmShareDenyRead  = $0030 platform;
    fmShareDenyNone  = $0040;

const

  MinDateTime: TDateTime = -657434.0; 
  MaxDateTime: TDateTime = 2958465.99999;

const EmptyStr: String = '';
const NullStr: PString = @EmptyStr;

const UnixDateDelta = 25569;


const
   HoursPerDay   = 24;
   MinsPerHour   = 60;
   SecsPerMin    = 60;
   MSecsPerSec   = 1000;
   MinsPerDay    = HoursPerDay * MinsPerHour;
   SecsPerDay    = MinsPerDay * SecsPerMin;
   MSecsPerDay   = SecsPerDay * MSecsPerSec;

type
   TCompareTextProc = function(const AText, AOther: string): Boolean;
   TSoundExLength = 1..MaxInt;
   TSoundExIntLength = 1..8;
   TStringSearchOption = (soDown, soMatchCase, soWholeWord);
   TStringSearchOptions = set of TStringSearchOption;
   TTerminateProc = function: Boolean;

   PExceptionRecord = ^TExceptionRecord;
   TExceptionRecord = record
      ExceptionCode: Cardinal;
      ExceptionFlags: Cardinal;
      ExceptionRecord: PExceptionRecord;
      ExceptionAddress: Pointer;
      NumberParameters: Cardinal;
      ExceptionInformation: array[0..14] of Cardinal;
   end;

   TLanguages = class(TObject)
      constructor Create;
      function IndexOf(ID: LCID): Integer;
      property Count: Integer;
      property Ext[Index: Integer]: string;
      property ID[Index: Integer]: string;
      property LocaleID[Index: Integer]: LCID;
      property Name[Index: Integer]: string;
      property NameFromLCID[const ID: string]: string;
      property NameFromLocaleID[ID: LCID]: string;
   end;

   TMultiReadExclusiveWriteSynchronizer = class(TInterfacedObject)
      property RevisionLevel: Cardinal;
      procedure BeginRead;
      function BeginWrite: Boolean;
      constructor Create;
      destructor Destroy; override;
      procedure EndRead;
      procedure EndWrite;
   end;


   Exception = class(TObject)
      property HelpContext: integer;      
      property Message: string
      constructor Create (const Msg: string);
      constructor CreateFmt (const Msg: string; const Args: array of const);
      constructor CreateFmtHelp (const Msg: string; 
                                 const Args: array of const; 
                                 AHelpContext: Integer);
      constructor CreateHelp (const Msg: string; AHelpContext: Integer);
      constructor CreateRes (Ident: Integer); overload;
      constructor CreateRes(ResStringRec: PResStringRec); overload;
      constructor CreateResFmt(Ident: Integer; const Args: array of const); overload;
      constructor CreateResFmt(ResStringRec: PResStringRec; const Args: array of const); overload;
      constructor CreateResFmtHelp(Ident: Integer; const Args: array of const; AHelpContext: Integer); overload;
      constructor CreateResFmtHelp(ResStringRec: PResStringRec; const Args: array of const; AHelpContext: Integer); overload;
      constructor CreateResHelp(Ident: Integer; AHelpContext: Integer); overload;
      constructor CreateResHelp(ResStringRec: PResStringRec; AHelpContext: Integer); overload;
   end;

   EAbort = class(Exception);
   EAbstractError = class(Exception);

   EExternal = class(Exception)
{$IFDEF MSWINDOWS}
      ExceptionRecord: PExceptionRecord;
{$ENDIF}
{$IFDEF LINUX}
      ExceptionAddress: LongWord;
      AccessAddress: LongWord;
      SignalNumber: Integer;
{$ENDIF}
   end;

   EAccessViolation = class(EExternal);

   EAssertionFailed = class(Exception);
   ECodesetConversion = class(Exeption);
   EControlC = class(EExternal);
   EConversionError = class(Exception);
   EConvertError = class(Exception);
 
   EIntError = class(EExternal);
   EDivByZero = class(EIntError);
   EExternalExeption = class(EExternal);
   EHeapException = class(Exception)
      procedure FreeInstance; override;
   end;
   EInOutError = class(Exception);
   EIntError = class(EExternal);
   EIntfCastError = class(Exception);
   EIntOverflow = class(EIntError);
   EInvalidCast = class(Exception);

   EMathError = class(EExternal);
   EInvalidOp = class(EMathError);

   EInvalidPointer = class(EHeapException);
   EOSError = class(Exception);
   EOutOfMemory = class(EHeapException);
   EOverflow = class(EMathError);
   EPackageError = class(Exception);
   EPrivilege = class(EExternal);
   EPropReadOnly = class(Exception);
   EPropWriteOnly = class(Exception);
   EQuit = class(Exception);
   ERangeError = class(EIntError);
   ESafecallException = class(Exception);
   EStackOverflow = class(EExternal);
   EUnderflow = class(EMathError);
   EVariantError = class(Exception);
   EWin32Error = class(EOSError);
   EZeroDivide = class(EMathError);

procedure Abort;
procedure AddExitProc(Proc: TProcedure);
procedure AddTerminateProc(TermProc: TTerminateProc);
{$IFDEF WINDOWS}
  function AdjustLineBreaks(const S: string; Style: TTextLineBreakStyle = tlbsCRLF): string;
{$ENDIF}
{$IFDEF LINUX}
  function AdjustLineBreaks(const S: string; Style: TTextLineBreakStyle = tlbsLF): string;
{$ENDIF}
function AllocMem(Size: Cardinal): Pointer;
function AnsiCompareFileName(const S1, S2: string): Integer;
function AnsiCompareStr(const S1, S2: string): Integer;
function AnsiCompareText(const S1, S2: string): Integer;
function AnsiDequotedStr(const S: string; AQuote: Char): string;
function AnsiExtractQuotedStr(var Src: PChar; Quote: Char): string;
function AnsiLastChar(const S: string): PChar;
function AnsiLowerCase(const S: string): string;
function AnsiLowerCaseFileName(const S: string): string;
function AnsiPos(const Substr, S: string): Integer;
function AnsiQuotedStr(const S: string; Quote: Char): string;
function AnsiSameStr(const S1, S2: string): Boolean;
function AnsiSameText(const S1, S2: string): Boolean;
function AnsiStrComp(S1, S2: PChar): Integer;
function AnsiStrIComp(S1, S2: PChar): Integer;
function AnsiStrLastChar(P: PChar): PChar;
function AnsiStrLComp(S1, S2: PChar; MaxLen: Cardinal): Integer;
function AnsiStrLIComp(S1, S2: PChar; MaxLen: Cardinal): Integer;
function AnsiStrLower(Str: PChar): PChar;
function AnsiStrPos(Str, SubStr: PChar): PChar;
function AnsiStrRScan(Str: PChar; Chr: Char): PChar;
function AnsiStrScan(Str: PChar; Chr: Char): PChar;
function AnsiStrUpper(Str: PChar): PChar;
function AnsiUpperCase(const S: string): string;
function AnsiUpperCaseFileName(const S: string): string;
procedure AppendStr(var Dest: string; const S: string); deprecated;
procedure AssignStr(var P: PString; const S: string); deprecated;
procedure Beep;
function BoolToStr(B: Boolean; UseBoolStrs: Boolean = False): string;
function ByteToCharIndex(const S: string; Index: Integer): Integer;
function ByteToCharLen(const S: string; MaxLen: Integer): Integer;
function ByteType(const S: string; Index: Integer): TMbcsByteType;
function CallTerminateProcs: Boolean;
function ChangeFileExt(const FileName, Extension: string): string;
function CharLength(const S: String; Index: Integer): Integer;
function CharToByteIndex(const S: string; Index: Integer): Integer;
function CharToByteLen(const S: string; MaxLen: Integer): Integer;
function CompareMem(P1, P2: Pointer; Length: Integer): Boolean; assembler;
function CompareStr(const S1, S2: string): Integer;
function CompareText(const S1, S2: string): Integer;
function CreateDir(const Dir: string): Boolean;
function CreateGUID(out Guid: TGUID): HResult;
function CurrentYear: Word;
function CurrToStr(Value: Currency): string; overload;
function CurrToStr(Value: Currency; const FormatSettings: TFormatSettings): string; overload;
function CurrToStrF(Value: Currency; Format: TFloatFormat; Digits: Integer): string; overload;
function CurrToStrF(Value: Currency; Format: TFloatFormat; Digits: Integer; const FormatSettings: TFormatSettings): string; overload;
function Date: TDateTime;
function DateTimeToFileDate(DateTime: TDateTime): Integer;
function DateTimeToStr(DateTime: TDateTime): string; overload;
function DateTimeToStr(DateTime: TDateTime; const FormatSettings: TFormatSettings): string; overload;
procedure DateTimeToString(var Result: string; const Format: string; DateTime: TDateTime
); overload;
procedure DateTimeToString(var Result: string; const Format: string; DateTime: TDateTime
; const FormatSettings: TFormatSettings); overload;
procedure DateTimeToSystemTime(DateTime: TDateTime; var SystemTime: TSystemTime);
function DateTimeToTimeStamp(DateTime: TDateTime): TTimeStamp;
function DateToStr(Date: TDateTime): string; overload;
function DateToStr(const DateTime: TDateTime; const FormatSettings: TFormatSettings): string; overload;
function DayOfWeek(Date: TDateTime): Integer;
procedure DecodeDate(Date: TDateTime; var Year, Month, Day: Word);
function DecodeDateFully(const DateTime: TDateTime; var Year, Month, Day, DOW: Word): Boolean;
procedure DecodeTime(Time: TDateTime; var Hour, Min, Sec, MSec: Word);
function DeleteFile(const FileName: string): Boolean;
function DirectoryExists(const Directory: string): Boolean;
function DiskFree(Drive: Byte): Int64;
function DiskSize(Drive: Byte): Int64;
procedure DisposeStr(P: PString); deprecated;
function EncodeDate(Year, Month, Day: Word): TDateTime;
function EncodeTime(Hour, Min, Sec, MSec: Word): TDateTime;
function ExceptionErrorMessage(ExceptObject: TObject; ExceptAddr: Pointer; Buffer: PChar; Size: Integer): Integer;
function ExcludeTrailingBackslash(const S: string): string;
function ExcludeTrailingPathDelimiter(const S: string): string;
function ExpandFileName(const FileName: string): string;
function ExpandFileNameCase(const FileName: string; out MatchFound: TFilenameCaseMatch
): string;
function ExpandUNCFileName(const FileName: string): string;
function ExtractFileDir(const FileName: string): string;
function ExtractFileDrive(const FileName: string): string;
function ExtractFileExt(const FileName: string): string;
function ExtractFileName(const FileName: string): string;
function ExtractFilePath(const FileName: string): string;
function ExtractRelativePath(const BaseName, DestName: string): string;
function ExtractShortPathName(const FileName: string): string;
function FileAge(const FileName: string): Integer;
procedure FileClose(Handle: Integer);
function FileCreate(const FileName: string): Integer; overload;
function FileCreate(const FileName: string; Rights: Integer): Integer; overload;
function FileDateToDateTime(FileDate: Integer): TDateTime;
function FileExists(const FileName: string): Boolean;
function FileGetAttr(const FileName: string): Integer;
function FileGetDate(Handle: Integer): Integer;
function FileIsReadOnly(const FileName: string): Boolean;
function FileOpen(const FileName: string; Mode: LongWord): Integer;
function FileRead(Handle: Integer; var Buffer; Count: Integer): Integer;
function FileSearch(const Name, DirList: string): string;
function FileSeek(Handle, Offset, Origin: Integer): Integer; overload;
function FileSeek(Handle: Integer; const Offset: Int64; Origin: Integer): Int64; overload;
function FileSetAttr(const FileName: string; Attr: Integer): Integer;
function FileSetDate(Handle: Integer; Age: Integer): Integer; overload;
function FileSetReadOnly(const FileName: string; ReadOnly: Boolean): Boolean;
function FileWrite(Handle: Integer; const Buffer; Count: Integer): Integer;
procedure FinalizePackage(Module: HMODULE);
procedure FindClose(var F: TSearchRec);
function FindCmdLineSwitch(const Switch: string; Chars: TSysCharSet; IgnoreCase: Boolean): Boolean; overload;
function FindCmdLineSwitch(const Switch: string; IgnoreCase: Boolean): Boolean; overload
;
function FindCmdLineSwitch(const Switch: string): Boolean; overload;
function FindFirst(const Path: string; Attr: Integer; var F: TSearchRec): Integer;
function FindNext(var F: TSearchRec): Integer;
function FloatToCurr(const Value: Extended): Currency;
function FloatToDateTime(const Value: Extended): TDateTime;
procedure FloatToDecimal(var DecVal: TFloatRec; const Value; ValueType: TFloatValue; Precision, Decimals: Integer);
function FloatToStr(Value: Extended): string; overload;
function FloatToStr(Value: Extended; const FormatSettings: TFormatSettings): string; overload;
function FloatToStrF(Value: Extended; Format: TFloatFormat; Precision, Digits: Integer): string; overload;
function FloatToStrF(Value: Extended; Format: TFloatFormat; Precision, Digits: Integer; const FormatSettings: TFormatSettings): string; overload;
function FloatToText(Buffer: PChar; const Value; ValueType: TFloatValue; Format: TFloatFormat; Precision, Digits: Integer): Integer; overload;
function FloatToText(Buffer: PChar; const Value; ValueType: TFloatValue; Format: TFloatFormat; Precision, Digits: Integer; const FormatSettings: TFormatSettings): Integer; overload;
function FmtLoadStr(Ident: Integer; const Args: array of const): string;
procedure FmtStr(var StrResult: string; const Format: string; const Args: array of const
); overload;
procedure FmtStr(var StrResult: string; const Format: string; const Args: array of const
; const FormatSettings: TFormatSettings); overload;
function ForceDirectories(Dir: string): Boolean;
function Format(const Format: string; const Args: array of const): string; overload;
function Format(const Format: string; const Args: array of const; const FormatSettings: TFormatSettings): string; overload;
function FormatBuf(var Buffer; BufLen: Cardinal; const Format; FmtLen: Cardinal; const
 Args: array of const): Cardinal; overload;
function FormatBuf(var Buffer; BufLen: Cardinal; const Format; FmtLen: Cardinal; const
 Args: array of const; const FormatSettings: TFormatSettings): Cardinal; overload;
function FormatCurr(const Format: string; Value: Currency): string; overload;
function FormatCurr(const Format: string; Value: Currency; const FormatSettings: TFormatSettings): string; overload;
function FormatDateTime(const Format: string; DateTime: TDateTime): string; overload;
function FormatDateTime(const Format: string; DateTime: TDateTime; const FormatSettings: TFormatSettings): string; overload;
function FormatFloat(const Format: string; Value: Extended): string; overload;
function FormatFloat(const Format: string; Value: Extended; const FormatSettings: TFormatSettings): string; overload;
procedure FreeAndNil(var Obj);
function GetCurrentDir: string;
function GetEnvironmentVariable(Name: string): string; 
function GetFileVersion(const AFileName: string): Cardinal;
procedure GetFormatSettings;
procedure GetLocaleFormatSettings(LCID: Integer; var FormatSettings: TFormatSettings);
procedure GetLocaleFormatSettings(LCID: Integer; var FormatSettings: TFormatSettings);
function GetModuleName(Module: HMODULE): string;
function GetPackageDescription(ModuleName: PChar): string;
procedure GetPackageInfo(Module: HMODULE; Param: Pointer; var Flags: Integer; InfoProc: TPackageInfoProc);
function GUIDToString(const ClassID: TGUID): string;
procedure IncAMonth(var Year, Month, Day: Word; NumberOfMonths: Integer = 1);
function IncludeTrailingBackslash(const S: string): string;
function IncludeTrailingPathDelimiter(const S: string): string;
function IncMonth(const Date: TDateTime; NumberOfMonths: Integer = 1): TDateTime;
procedure InitializePackage(Module: HMODULE);
function InterlockedDecrement(var I: Integer): Integer;
function InterlockedExchange(var A: Integer; B: Integer): Integer;
function InterlockedExchangeAdd(var A: Integer; B: Integer): Integer;
function InterlockedIncrement(var I: Integer): Integer;
function IntToHex(Value: Integer; Digits: Integer): string; overload;
function IntToHex(Value: Int64; Digits: Integer): string; overload;
function IsDelimiter(const Delimiters, S: string; Index: Integer): Boolean;
function IsEqualGUID(const guid1, guid2: TGUID): Boolean;
function IsLeapYear(Year: Word): Boolean;
function IsPathDelimiter(const S: string; Index: Integer): Boolean;
function IsValidIdent(const Ident: string): Boolean;
function Languages: TLanguages;
function LastDelimiter(const Delimiters, S: string): Integer;
function LoadPackage(const Name: string): HMODULE;
function LoadStr(Ident: Integer): string;
function LowerCase(const S: string): string;
function MSecsToTimeStamp(MSecs: Comp): TTimeStamp;
function NewStr(const S: string): PString; deprecated;
function NextCharIndex(const S: String; Index: Integer): Integer;
function Now: TDateTime;
procedure OutOfMemoryError;
function QuotedStr(const S: string): string;
procedure RaiseLastOSError;
procedure RaiseLastWin32Error;
function RemoveDir(const Dir: string): Boolean;
function RenameFile(const OldName, NewName: string): Boolean;
procedure ReplaceDate(var DateTime: TDateTime; const NewDate: TDateTime);
procedure ReplaceTime(var DateTime: TDateTime; const NewTime:
TDateTime);
{$IFDEF WINDOWN}
function SafeLoadLibrary(const Filename: string; ErrorMode: UINT = SEM_NOOPENFILEERRORBOX): HMODULE;
{$ENDIF}
{IFDEF LINUX}
function SafeLoadLibrary(const FileName: string; Dummy: LongWord = 0): HMODULE;
{$ENDIF}
function SameFileName(const S1, S2: string): Boolean;
function SameText(const S1, S2: string): Boolean;
function SetCurrentDir(const Dir: string): Boolean;
procedure ShowException(ExceptObject: TObject; ExceptAddr: Pointer);
procedure Sleep(milliseconds: Cardinal);{$IFDEF MSWINDOWS} stdcall; {$ENDIF}
function StrAlloc(Size: Cardinal): PChar;
function StrBufSize(const Str: PChar): Cardinal;
function StrByteType(Str: PChar; Index: Cardinal): TMbcsByteType;
function StrCat(Dest: PChar; const Source: PChar): PChar;
function StrCharLength(const Str: PChar): Integer;
function StrComp(const Str1, Str2 : PChar): Integer;
procedure StrDispose(Str: PChar);
function StrECopy(Dest: PChar; const Source: PChar): PChar;
function StrEnd(const Str: PChar): PChar;
function StrFmt(Buffer, Format: PChar; const Args: array of const): PChar; overload;
function StrFmt(Buffer, Format: PChar; const Args: array of const; const FormatSettings: TFormatSettings): PChar; overload;
function StrIComp(const Str1, Str2:PChar): Integer;
function StringReplace(const S, OldPattern, NewPattern: string; Flags: TReplaceFlags): string;
function StringToGUID(const S: string): TGUID;
function StrLCat(Dest: PChar; const Source: PChar; MaxLen: Cardinal): PChar;
function StrLComp(const Str1, Str2: PChar; MaxLen: Cardinal): Integer;
function StrLCopy(Dest: PChar; const Source: PChar; MaxLen: Cardinal): PChar;
function StrLen(const Str: PChar): Cardinal;
function StrLFmt(Buffer: PChar; MaxLen: Cardinal; Format: PChar; const Args: array of const): PChar; overload;
function StrLFmt(Buffer: PChar; MaxLen: Cardinal; Format: PChar; const Args: array of const; const FormatSettings: TFormatSettings): PChar; overload;
function StrLIComp(const Str1, Str2: PChar; MaxLen: Cardinal): Integer;
function StrLower(Str: PChar): PChar;
function StrMove(Dest: PChar; const Source: PChar; Count: Cardinal): PChar;
function StrNew(const Str: PChar): PChar;
function StrNextChar(const Str: PChar): PChar;
function StrPas(const Str: PChar): string;
function StrPCopy(Dest: PChar; const Source: string): PChar;
function StrPos(const Str1, Str2: PChar): PChar;
function StrRScan(const Str: PChar; Chr: Char): PChar;
function StrScan(const Str: PChar; Chr: Char): PChar;
function StrToBool(const S: string): Boolean;
function StrToBoolDef(const S: string; const Default: Boolean): Boolean;
function StrToCurr(const S: string): Currency; overload;
function StrToCurr(const S: string; const FormatSettings: TFormatSettings): Currency; overload;
function StrToDate(const S: string): TDateTime; overload;
function StrToDate(const S: string; const FormatSettings: TFormatSettings): TDateTime; overload;
function StrToDateDef(const S: string; const Default: TDateTime): TDateTime; overload;
function StrToDateDef(const S: string; const Default: TDateTime; const FormatSettings: TFormatSettings): TDateTime; overload;
function StrToDateTime(const S: string): TDateTime; overload;
function StrToDateTime(const S: string; const FormatSettings: TFormatSettings): TDateTime; overload;
function StrToDateTimeDef(const S: string; const Default: TDateTime): TDateTime; overload;
function StrToDateTimeDef(const S: string; const Default: TDateTime; const FormatSettings: TFormatSettings): TDateTime; overload;
function StrToDateTime(const S: string): TDateTime; overload;
function StrToDateTime(const S: string; const FormatSettings: TFormatSettings): TDateTime; overload;
function StrToDateTimeDef(const S: string; const Default: TDateTime): TDateTime; overload;
function StrToDateTimeDef(const S: string; const Default: TDateTime; const FormatSettings: TFormatSettings): TDateTime; overload;
function StrToFloat(const S: string): Extended; overload;
function StrToFloat(const S: string; const FormatSettings: TFormatSettings): Extended; overload;
function StrToFloatDef(const S: string; const Default: Extended): Extended; overload;
function StrToFloatDef(const S: string; const Default: Extended; const FormatSettings: TFormatSettings): Extended; overload;
function StrToInt(const S: string): Integer;
function StrToInt64(const S: string): Int64;
function StrToInt64Def(const S: string; Default: Int64): Int64;
function StrToIntDef(const S: string; const Default: Integer): Integer;
function StrToTime(const S: string): TDateTime; overload;
function StrToTime(const S: string; const FormatSettings: TFormatSettings): TDateTime; overload;
function StrToTimeDef(const S: string; const Default: TDateTime; const FormatSettings: TFormatSettings): TDateTime; overload;
function StrToTimeDef(const S: string; const Default: TDateTime): TDateTime; overload;
function StrUpper(Str: PChar): PChar;
function Supports(const Instance: IInterface ; const IID: TGUID; out Intf): Boolean; overload;
function Supports(const Instance: TObject; const IID: TGUID; out Intf): Boolean; overload;
function Supports(const AClass: TClass; const IID: TGUID): Boolean; overload;
function SysErrorMessage(ErrorCode: Integer): string;
function SystemTimeToDateTime(const SystemTime: TSystemTime): TDateTime;
function TextToFloat(Buffer: PChar; var Value; ValueType: TFloatValue): Boolean; overload;
function TextToFloat(Buffer: PChar; var Value; ValueType: TFloatValue; const FormatSettings: TFormatSettings): Boolean; overload;
function Time: TDateTime;
function GetTime: TDateTime;
function TimeStampToDateTime(const TimeStamp: TTimeStamp): TDateTime;
function TimeStampToMSecs(const TimeStamp: TTimeStamp): Comp;
function TimeToStr(Time: TDateTime): string; overload;
function TimeToStr(Time: TDateTime; const FormatSettings: TFormatSettings): string; overload;
function Trim(const S: string): string; overload;
function Trim(const S: WideString): WideString; overload;
function TrimLeft(const S: string): string; overload;
function TrimLeft(const S: WideString): WideString; overload;
function TrimRight(const S: string): string; overload;
function TrimRight(const S: WideString): WideString; overload;
function TryEncodeDate(Year, Month, Day: Word; out Date: TDateTime): Boolean;
function TryEncodeTime(Hour, Min, Sec, MSec: Word; out Time: TDateTime): Boolean;
function TryFloatToCurr(const Value: Extended; out AResult: Currency): Boolean;
function TryStrToBool(const S: string; out Value: Boolean): Boolean;
function TryStrToCurr(const S: string; out Value: Currency): Boolean; overload;
function TryStrToCurr(const S: string; out Value: Currency; const FormatSettings: TFormatSettings): Boolean; overload;
function TryStrToDate(const S: string; out Value: TDateTime): Boolean; overload;
function TryStrToDate(const S: string; out Value: TDateTime; const FormatSettings: TFormatSettings): Boolean; overload;
function TryStrToDateTime(const S: string; out Value: TDateTime): Boolean; overload;
function TryStrToDateTime(const S: string; out Value: TDateTime; const FormatSettings: TFormatSettings): Boolean; overload;
function TryStrToFloat(const S: string; out Value: Extended): Boolean; overload;
function TryStrToFloat(const S: string; out Value: Double): Boolean; overload;
function TryStrToFloat(const S: string; out Value: Single): Boolean; overload;
function TryStrToFloat(const S: string; out Value: Extended; const FormatSettings: TFormatSettings): Boolean; overload;
function TryStrToFloat(const S: string; out Value: Double; const FormatSettings: TFormatSettings): Boolean; overload;
function TryStrToFloat(const S: string; out Value: Single; const FormatSettings: TFormatSettings): Boolean; overload;
function TryStrToInt(const S: string; out Value: Integer): Boolean;
function TryStrToInt64(const S: string; out Value: Int64): Boolean;
function TryStrToTime(const S: string; out Value: TDateTime): Boolean; overload;
function TryStrToTime(const S: string; out Value: TDateTime; const FormatSettings: TFormatSettings): Boolean; overload;
procedure UnloadPackage(Module: HMODULE);
function UpperCase(const S: string): string;
function WideCompareStr(const S1, S2: WideString): Integer;
function WideCompareText(const S1, S2: WideString): Integer;
procedure WideFmtStr(var Result: WideString; const Format: WideString; const Args: array
 of const); overload;
procedure WideFmtStr(var Result: WideString; const Format: WideString; const Args: array
 of const; const FormatSettings: TFormatSettings); overload;
function WideFormat(const Format: WideString; const Args: array of const): WideString; overload;
function WideFormat(const Format: WideString; const Args: array of const; const FormatSettings: TFormatSettings): WideString; overload;
function WideFormatBuf(var Buffer; BufLen: Cardinal; const Format; FmtLen: Cardinal; const Args: array of const): Cardinal; overload;
function WideFormatBuf(var Buffer; BufLen: Cardinal; const Format; FmtLen: Cardinal; const Args: array of const; const FormatSettings: TFormatSettings): Cardinal; overload;
function WideLowerCase(const S: WideString): WideString;
function WideSameStr(const S1, S2: WideString): Boolean;
function WideSameText(const S1, S2: WideString): Boolean;
function WideUpperCase(const S: WideString): WideString;
function Win32Check(RetVal: BOOL): BOOL;
function WrapText(const Line, BreakStr: string; nBreakChars: TSysCharSet; MaxCol: Integer):string; overload;
function WrapText(const Line, MaxCol: Integer = 45):string; overload;


implementation
end.















