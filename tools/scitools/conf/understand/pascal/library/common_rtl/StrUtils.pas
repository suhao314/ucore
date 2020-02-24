unit StrUtils;
interface
   uses SysUtils;
type
  TStringSearchOption = (soDown, soMatchCase, soWholeWord);
  TStringSearchOptions = set of TStringSearchOption;
  TCompareTextProc = function(const AText, AOther: string): Boolean;
  TSoundExIntLength = 1..8;


function AnsiContainsStr(const AText, ASubText: string): Boolean;
function AnsiContainsText(const AText, ASubText: string): Boolean;
function AnsiEndsStr(const ASubText, AText: string): Boolean;
function AnsiEndsText(const ASubText, AText: string): Boolean;
function AnsiIndexStr(const AText: string; const AValues: array of string): Integer;
function AnsiIndexText(const AText: string; const AValues: array of string): Integer;
function AnsiLeftStr(const AText: AnsiString; const ACount: Integer): AnsiString;
function AnsiMatchStr(const AText: string; const AValues: array of string): Integer;
function AnsiMatchText(const AText: string; const AValues: array of string): Boolean;

function AnsiMidStr(const AText: AnsiString; const AStart, ACount: Integer): AnsiString;
function AnsiReplaceStr(const AText, AFromText, AToText: string): string;
function AnsiReplaceText(const AText, AFromText, AToText: string): string;
function AnsiResemblesText(const AText, AOther: string): Boolean;

function AnsiResemblesText(const AText, AOther: string): Boolean;
function AnsiReverseString(const AText: AnsiString): AnsiString;

function AnsiRightStr(const AText: AnsiString; const ACount: Integer): AnsiString;
function AnsiStartsStr(const ASubText, AText: string): Boolean;

function AnsiStartsText(const ASubText, AText: string): Boolean;
function DecodeSoundExInt(AValue: Integer): string;
function DecodeSoundExWord(AValue: Word): string;

function DupeString(const AText: string; ACount: Integer): string;
function LeftBStr(const AText: AnsiString; const AByteCount: Integer): AnsiString;
function LeftStr(const AText: AnsiString; const ACount: Integer): AnsiString; overload;
function LeftStr(const AText: WideString; const ACount: Integer): WideString; overload;
function MidBStr(const AText: AnsiString; const AByteStart, AByteCount: Integer): AnsiString;

function MidStr(const AText: AnsiString; const AStart, ACount: Integer): AnsiString; overload;
function MidStr(const AText: WideString; const AStart, ACount: Integer): WideString; overload;

function PosEx(const SubStr, S: string; Offset: Cardinal = 1): Integer;
function ReverseString(const AText: string): string;

function RightBStr(const AText: AnsiString; const AByteCount: Integer): AnsiString;
function SearchBuf(Buf: PChar; BufLen: Integer; 
                   SelStart, SelLength: Integer; 
                   SearchString: String; 
                   Options: TStringSearchOptions = soDown): PChar;
function SoundEx(const AText: string; ALength: TSoundExLength  = 4): string;
function SoundExCompare(const AText, AOther: string; ALength: TSoundExLength = 4): Integer;
function SoundExInt(const AText: string; ALength: TSoundExIntLength = 4): Integer;
function SoundExProc(const AText, AOther: string): Boolean;
function SoundExSimilar(const AText, AOther: string; ALength: TSoundExLength = 4): Boolean;
function SoundExWord(const AText: string): Word;

function StuffString(const AText: string; AStart, ALength: Cardinal; 
                     const ASubText: string): string;

var 
   AnsiResemblesProc: TCompareTextProc = SoundExProc;

implementation
end.















