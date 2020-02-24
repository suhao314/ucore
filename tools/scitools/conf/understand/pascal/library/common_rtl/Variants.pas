unit Variants;
interface
   uses SysUtils, Classes;
type 
   TBooleanToStringRule = (bsrAsIs, bsrLower, bsrUpper);
   TNullCompareRule = (ncrError, ncrStrict, ncrLoose);
   TVarDispProc = procedure (Dest: PVariant; const Source: Variant;
                              CallDesc: PCallDesc; Params: Pointer); cdecl;
   TVarCompareResult = (crLessThan, crEqual, crGreaterThan);
   TVarDataArray = array of TVarData;

   EVariantError = class(EVariantError);
   EVariantArrayCreateError = class(EVariantError);
   EVariantArrayLockedError = class(EVariantError);
   EVariantBadIndexError = class(EVariantError);
   EVariantBadVarTypeError = class(EVariantError);
   EVariantDispatchError = class(EVariantError);
   EVariantInvalidArgError = class(EVariantError);
   EVariantInvalidOpError = class(EVariantError);
   EVariantInvalidNullOpError = class(EVariantInvalidOpError);
   EVariantNotAnArrayError = class(EVariantError);
   EVariantNotImplError = class(EVariantError);
   EVariantOutOfMemoryError = class(EVariantError);
   EVariantOverflowError = class(EVariantError);
   EVariantRangeCheckError = class(EVariantError);
   EVariantTypeCastError = class(EVariantError);
   EVariantUnexpectedError = class(EVariantError);

   TCustomVariantType = class(TObject)
   public
      property VarType: TVarType;
      procedure BinaryOp(var Left: TVarData; const Right: TVarData; const Operator: TVarOp); virtual;
      procedure Cast(var Dest: TVarData; const Source: TVarData); virtual;
      procedure CastTo(var Dest: TVarData; const Source: TVarData; const AVarType: TVarType); virtual;
      procedure CastToOle(var Dest: TVarData; const Source: TVarData); virtual;
      procedure Clear(var V: TVarData); virtual; abstract;
      procedure Compare(const Left, Right: TVarData; var Relationship: TVarCompareResult); virtual;
      function CompareOp(const Left, Right: TVarData; const Operator: TVarOp): Boolean; virtual;
      procedure Copy(var Dest: TVarData; const Source: TVarData; 
                     const Indirect: Boolean); virtual; abstract;
      constructor Create;
      constructor Create(RequestedVarType: TVarType);
      destructor Destroy; override;
      function IsClear(const V: TVarData): Boolean; virtual;
      procedure UnaryOp(var Right: TVarData; const Operator: Integer); virtual;
   protected
      function _AddRef: Integer; stdcall;
      function _Release: Integer; stdcall;
      procedure DispInvoke(var Dest: TVarData; const Source: TVarData; CallDesc: PCallDesc; Params: Pointer); virtual;
      function LeftPromotion(const V: TVarData; const Operator: TVarOp; out RequiredVarType: TVarType): Boolean; virtual;
      function OlePromotion(const V: TVarData; out RequiredVarType: TVarType): Boolean; virtual;
      function QueryInterface(const IID: TGUID; out Obj): HResult; virtual; stdcall;
      procedure RaiseCastError;
      procedure RaiseDispError;
      procedure RaiseInvalidOp;
      function RightPromotion(const V: TVarData; const Operator: TVarOp; out RequiredVarType: TVarType): Boolean; virtual;
      procedure SimplisticClear(var V: TVarData);
      procedure SimplisticCopy(var Dest: TVarData; const Source: TVarData; const Indirect: Boolean = False);
      procedure VarDataCast(var Dest: TVarData; const Source: TVarData);
      procedure VarDataCastTo(var Dest: TVarData; const Source: TVarData; const VarType: TVarType); overload;
      procedure VarDataCastTo(var Dest: TVarData; const VarType: TVarType); overload;
      procedure VarDataCastToOleStr(var Dest: TVarData);
      procedure VarDataClear(var Dest: TVarData);
      procedure VarDataCopy(var Dest: TVarData; const Source: TVarData);
      procedure VarDataCopyNoInd(var Dest: TVarData; const Source: TVarData);
      procedure VarDataFromOleStr(var V: TVarData; const Value: WideString);
      procedure VarDataFromStr(var V: TVarData; const Value: string);
      procedure VarDataInit(var Dest: TVarData);
      function VarDataIsArray(const V: TVarData): Boolean;
      function VarDataIsByRef(const V: TVarData): Boolean;
      function VarDataIsEmptyParam(const V: TVarData): Boolean;
      function VarDataIsFloat(const V: TVarData): Boolean;
      function VarDataIsNumeric(const V: TVarData): Boolean;
      function VarDataIsOrdinal(const V: TVarData): Boolean;
      function VarDataIsStr(const V: TVarData): Boolean;
      function VarDataToStr(const V: TVarData): string;
   end;

   TInvokeableVariantType = class(TCustomVariantType)
   public
      function DoFunction(var Dest: TVarData; const V: TVarData; const Name: string; const Arguments: TVarDataArray): Boolean; virtual;
      function DoProcedure(const V: TVarData; const Name: string; const Arguments: TVarDataArray): Boolean; virtual;
      function FixupIdent(const AText: string): string; virtual;
      function GetProperty(var Dest: TVarData; const V: TVarData; const Name: string): Boolean; virtual;
      function SetProperty(const V: TVarData; const Name: string; const Value: TVarData): Boolean; virtual;
   protected
      procedure DispInvoke(Dest: TVarData; const Source: TVarData; CallDesc: PCallDesc; Params: Pointer); override;
   end;

var BooleanToStringRule: TBooleanToStringRule = bsrAsIs;
var EmptyParam: OleVariant;
var NullAsStringValue: String;
var NullEqualityRule: TNullCompareRule;
var NullMagnitudeRule: TNullCompareRule;
var NullStrictConvert: Boolean;
var PackVarCreation: Boolean;
var VarDispProc: TVarDispProc;



procedure DynArrayFromVariant(var DynArray: Pointer; const V: Variant; TypeInfo: Pointer);
procedure DynArrayToVariant(var V: Variant; const DynArray: Pointer; TypeInfo: Pointer);
function FindCustomVariantType(const TypeName: string; out CustomVariantType: TCustomVariantType): Boolean; overload;
function FindCustomVariantType(const AVarType: TVarType;  out CustomVariantType: TCustomVariantType): Boolean; overload;
function FindVarData(const V: Variant): PVarData;
procedure HandleConversionException(const ASourceType, ADestType: TVarType);
function Null: Variant;
function Unassigned: Variant;
function VarArrayCreate(const Bounds: array of Integer; VarType: TVarType): Variant;
procedure VarArrayCreateError;
function VarArrayDimCount(const A: Variant): Integer;
function VarArrayGet(const A: Variant; const Indices: array of Integer): Variant; 
function VarArrayHighBound(const A: Variant; Dim: Integer): Integer;
function VarArrayLock(const A: Variant): Pointer;
function VarArrayLowBound(const A: Variant; Dim: Integer): Integer;
function VarArrayOf(const Values: array of Variant): Variant;
procedure VarArrayPut(var A: Variant; const Value: Variant; const Indices: array of Integer); 
function VarArrayRef(const A: Variant): Variant;
procedure VarArrayUnlock(var A: Variant);
function VarAsError(AResult: HRESULT): Variant;
function VarAsType(const V: Variant; VarType: TVarType): Variant;
procedure VarCastError; overload;
procedure VarCastError(const ASourceType, ADestType: TVarType); overload;
procedure VarCheckEmpty(const V: Variant);
function VarCompareValue(const A, B: Variant): TVariantRelationship;
procedure VarCopyNoInd(var Dest: Variant; const Source: Variant);
function VarEnsureRange(const AValue, AMin, AMax: Variant): Variant;
function VarFromDateTime(DateTime: TDateTime): Variant;
function VarInRange(const AValue, AMin, AMax: Variant): Boolean;
procedure VarInvalidNullOp;
function VarIsArray(const A: Variant): Boolean; overload;
function VarIsArray(const A: Variant; AResolveByRef: Boolean): Boolean; overload;
function VarIsByRef(const V: Variant): Boolean;
function VarIsClear(const V: Variant): Boolean;
function VarIsCustom(const V: Variant): Boolean;
function VarIsEmpty(const V: Variant): Boolean;
function VarIsEmptyParam(const V: Variant): Boolean;
function VarIsError(const V: Variant): Boolean; overload;
function VarIsError(const V: Variant; out AResult: HRESULT): Boolean; overload;
function VarIsFloat(const V: Variant): Boolean;
function VarIsNull(const V: Variant): Boolean;
function VarIsNumeric(const V: Variant): Boolean;
function VarIsOrdinal(const V: Variant): Boolean;
function VarIsStr(const V: Variant): Boolean;
function VarIsType(const V: Variant; AVarType: TVarType): Boolean; overload;
function VarIsType(const V: Variant; const AVarTypes: array of TVarType): Boolean; overload;
procedure VarOverflowError(const ASourceType, ADestType: TVarType);
procedure VarRangeCheckError(const ASourceType, ADestType: TVarType);
procedure VarResultCheck(AResult: HRESULT); overload;
procedure VarResultCheck(AResult: HRESULT; ASourceType, ADestType: TVarType); overload;
function VarSameValue(const A, B: Variant): Boolean;
function VarSupports(const V: Variant; const IID: TGUID; out Intf): Boolean; overload;
function VarSupports(const V: Variant; const IID: TGUID): Boolean; overload;
function VarToDateTime(const V: Variant): TDateTime;
function VarToStr(const V: Variant): string;
function VarToStrDef(const V: Variant; const ADefault: string): string;
function VarToWideStr(const V: Variant): WideString;
function VarToWideStrDef(const V: Variant; const ADefault: WideString): WideString;
function VarType(const V: Variant): TVarType;
function VarTypeAsText(const AType: TVarType): string;
function VarTypeIsValidArrayType(const AVarType: TVarType): Boolean;
function VarTypeIsValidElementType(const AVarType: TVarType): Boolean;

implementation
end.
