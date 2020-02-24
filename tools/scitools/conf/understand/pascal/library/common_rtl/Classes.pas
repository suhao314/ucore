unit Classes;
interface
   uses SysUtils, Types;
const
   MaxListSize = Maxint div 16;
type 
   THelpContext = -MaxLongInt..MaxLongInt;
   THelpType = (htKeyword, htContext);

   EBitsError = class(Exception);
   EComponentError = class(Exception);
   EInvalidOperation = class(Exception);
   EListError = class(Exception);
   EParserError = class(Exception);
   EResNotFound = class(Exception);
   EStreamError = class(Exception);
   EStringListError = class(Exception);
   EThread = class(Exception);
   
   EOutOfResources = class(EOutOfMemory);

   EFilerError = class(EStreamError);
   EClassNotFound = class(EFilerError);
   EReadError = class(EFilerError);
   EWriteError = class(EFilerError);

   EFileStreamError = class(EStreamError);
   EFCreateError = class(EFileStreamError);
   EFOpenError = class(EFileStreamError);
   
   EInvalidImage = class(EFilerError);

   HResult = Longint;

   TAlignment = (taLeftJustify, taRightJustify, taCenter);
   TLeftRight = taLeftJustify..taRightJustify;

   TPointerList = array[0..MaxListSize-1] of Pointer;
   PPointerList = ^TPointerList;

   TActiveXRegType = (axrComponentOnly, axrIncludeDescendants);
   TBiDiMode = (bdLeftToRight, bdRightToLeft, bdRightToLeftNoAlign, bdRightToLeftReadingOnly);

   TIdentMapEntry = record
      Value: Integer;
      Name: String;
   end;

   TListAssignOp = (laCopy, laAnd, laOr, laXor, laSrcUnique, laDestUnique);
   TStreamOwnership = (soReference, soOwned);
   TCollectionNotification = (cnAdded, cnExtracting, cnDeleting);
   TComponentName = type string;
   TComponentState = set of (csLoading, csReading, csWriting, csDestroying, csDesigning, csAncestor, csUpdating, csFixups, csFreeNotification, csInline, csDesignInstance);
   TComponentStyle = set of (csInheritable, csCheckPropAvail, csSubComponent, csTransient); 
   TCreateComponentEvent = procedure(Reader: TReader; 
                                     ComponentClass: TComponentClass; 
                                     var Component: TComponent) of object;
   TDuplicates = (dupIgnore, dupAccept, dupError);

   TFilerFlag = (ffInherited, ffChildPos, ffInline);
   TFilerFlags = set of TFilerFlag;
   TOperation = (opInsert, opRemove);
   TSeekOrigin = (soBeginning, soCurrent, soEnd);
   TShiftState = set of (ssShift, ssAlt, ssCtrl, ssLeft, ssRight, ssMiddle, ssDouble);
   TShortCut = Low(Word) .. High(Word);
   TStreamOriginalFormat = (sofUnknown, sofBinary, sofText);
   TThreadPriority = (tpIdle, tpLowest, tpLower, tpNormal, tpHigher, tpHighest, tpTimeCritical);
   TValueType = (vaNull, vaList, vaInt8, vaInt16, vaInt32, vaExtended, vaString, vaIdent, vaFalse, vaTrue, vaBinary, vaSet, vaLString, vaNil, vaCollection, vaSingle, vaCurrency, vaDate, vaWString, vaInt64, vaUTF8String);
   TVariantRelationship = (vrEqual, vrLessThan, vrGreaterThan, vrNotEqual);

   TBasicAction = class;
   TBasicActionLink = class;
   TCollectionItem = class;
   TComponent = class;
   TFiler = class;
   TCollectionItem = class;
   TCollectionItemClass = class of TCollectionItem;
   TPersistent = class;
   TReader = class;
   TStream = class;
   TStringList = class;
   TStrings = class;
   TWriter = class;

   TComponentClass = class of TComponent;
   TPersistentClass = class of TPersistent;

   TAncestorNotFoundEvent = procedure(Reader: TReader; 
                               const ComponentName: string; 
                               ComponentClass: TPersistentClass; 
                               var Component: TComponent) of object;
   TFindAncestorEvent = procedure(Writer: TWriter; 
                           Component: TComponent; 
                           const Name: string; 
                           var Ancestor, RootAncestor: TComponent) of object;
   TFindComponentClassEvent = procedure(Reader: TReader; 
                                 const ClassName: string; 
                                 var ComponentClass: TComponentClass) of object;
   TGetChildProc = procedure (Child: TComponent) of object;
   TFindMethodEvent = procedure(Reader: TReader; const MethodName: string; var Address: Pointer; var Error: Boolean) of object;
   TIdentToInt = function(const Ident: string; var Int: Longint): Boolean;
   TIntToIdent = function(Int: Longint; var Ident: string): Boolean;
   TListSortCompare = function (Item1, Item2: Pointer): Integer;
   TNotifyEvent = procedure (Sender: TObject) of object;
   TReadComponentsProc = procedure(Component: TComponent) of object;
   TReaderError = procedure(Reader: TReader; const Message: string; var Handled: Boolean) of object;
   TReaderProc = procedure(Reader: TReader) of object;
   TReferenceNameEvent = procedure(Reader: TReader; var Name: string) of object;
   TSetNameEvent = procedure(Reader: TReader; Component: TComponent; var Name: string) of object;
   TStreamProc = procedure(Stream: TStream) of object;
   TStringListSortCompare = function(List: TStringList; Index1, Index2: Integer): Integer;
   TThreadMethod = procedure of object;
   // tbd - can't tell what TMessage is - using string instead
   //   TWndMethod = procedure(var Message: TMessage) of object;
   TWndMethod = procedure(var Message: string) of object;
   TWriterProc = procedure(Writer: TWriter) of object;

   // tbd - not in docs, but referenced in TStrings class   
   IStringsAdapter = interface
       procedure ReferenceStrings(S: TStrings);
       procedure ReleaseStrings;
    end;

   IDesignerNotify = interface(IInterface)
   public
      procedure Modified;
      procedure Notification(AComponent: TComponent; Operation: TOperation);
   end;

   IInterfaceList = interface(IInterface)
   public
      property Capacity: Integer;
      property Count: Integer;
      property Items[Index: Integer]: IInterface; default;
      function Add(const Item: IInterface): Integer; 
      procedure Clear;
      procedure Delete(Index: Integer);
      procedure Exchange(Index1, Index2: Integer);
      function First: IInterface;
      function Get(Index: Integer): IInterface;
      function GetCapacity: Integer;
      function GetCount: Integer;
      function IndexOf(const Item: IInterface): Integer;
      procedure Insert(Index: Integer; const Item: IInterface);
      function Last: IInterface;
      procedure Lock;
      procedure Put(Index: Integer; const Item: IInterface);
      function Remove(const Item: IInterface): Integer;
      procedure SetCapacity(NewCapacity: Integer);
      procedure SetCount(NewCount: Integer);
      procedure Unlock;
   end;


   IVarStreamable = interface(IInterface)
   public
      procedure StreamIn(var Dest: TVarData; const Stream: TStream);
      procedure StreamOut(const Source: TVarData; const Stream: TStream);
   end;

   TPersistent = class(TObject)
   public
      procedure Assign(Source: TPersistent); virtual;
      function  GetNamePath: string; dynamic;
   protected
      procedure AssignTo(Dest: TPersistent); virtual;
      procedure DefineProperties(Filer: TFiler); virtual;
      function  GetOwner: TPersistent; dynamic;
   end;


   TComponent = class(TPersistent)
   published
      property Name: TComponentName;
      property Tag: Longint;
   public
{$IF WINDOWS}
      property ComObject: IUnknown;
{$ENDIF}
      property ComponentCount: Integer;
      property ComponentIndex: Integer;
      property Components[Index: Integer]: TComponent;
      property ComponentState: TComponentState;
      property ComponentStyle: TComponentStyle;
      property DesignInfo: Longint;
      property Owner: TComponent;
{$IF WINDOWS}
      property VCLComObject: Pointer;
{$ENDIF}
      procedure BeforeDestruction; override;
      constructor Create(AOwner: TComponent); virtual;
      destructor Destroy; override;
      procedure DestroyComponents;
      procedure Destroying;
      procedure WriteState(Writer: TWriter); virtual;
      function ExecuteAction(Action: TBasicAction): Boolean; dynamic;
      function FindComponent(const AName: string): TComponent;
      procedure FreeNotification(AComponent: TComponent);
{$IF WINDOWS}
      procedure FreeOnRelease;
{$ENDIF}
      function GetNamePath: string; override;
      function GetParentComponent: TComponent; dynamic;
      function HasParent: Boolean; dynamic;
      procedure InsertComponent(AComponent: TComponent);
      function IsImplementorOf(const I: IInterface): Boolean;
      function ReferenceInterface(const I: IInterface; Operation: TOperation): Boolean;
      procedure RemoveComponent(AComponent: TComponent);
      procedure RemoveComponent(AComponent: TComponent);
      procedure RemoveFreeNotification(AComponent: TComponent);
      function SafeCallException(ExceptObject: TObject; ExceptAddr: Pointer): HResult; override;
      procedure SetSubComponent(IsSubComponent: Boolean);
      function UpdateAction(Action: TBasicAction): Boolean; dynamic;
   protected
      function _AddRef: Integer; stdcall;
      function _Release: Integer; stdcall;
      procedure ChangeName(const NewName: TComponentName);
      procedure DefineProperties(Filer: TFiler); override;
      function GetChildOwner: TComponent; dynamic;
      function GetChildParent: TComponent; dynamic;
      procedure GetChildren(Proc: TGetChildProc; Root: TComponent); dynamic;
{$IF WINDOWS}
      function GetIDsOfNames(const IID: TGUID; Names: Pointer; NameCount,
            LocaleID: Integer; DispIDs: Pointer): HResult; stdcall;
{$ENDIF}
      function GetOwner: TPersistent; override;
{$IF WINDOWS}
      function GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult; stdcall;
      function GetTypeInfoCount(out Count: Integer): HResult; stdcall;
      function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult; stdcall;
{$ENDIF}
      procedure Loaded; virtual;
      procedure Notification(AComponent: TComponent; Operation: TOperation); virtual;
      procedure PaletteCreated; dynamic;
      function QueryInterface(const IID: TGUID; out Obj): HResult; virtual; stdcall;
      procedure ReadState(Reader: TReader); virtual;
      procedure SetAncestor(Value: Boolean);
      procedure SetChildOrder(Child: TComponent; Order: Integer); dynamic;
      procedure SetDesigning(Value: Boolean; SetChildren: Boolean=True);
      procedure SetDesignInstance(Value: Boolean);
      procedure SetInline(Value: Boolean);
      procedure SetName(const NewName: TComponentName); virtual;
      procedure SetParentComponent(Value: TComponent); dynamic;
      procedure Updated; dynamic;
      class procedure UpdateRegistry(Register: Boolean; const ClassID, ProgID: string); virtual;
      procedure Updating; dynamic;
      procedure ValidateContainer(AComponent: TComponent); dynamic;
      procedure ValidateInsert(AComponent: TComponent); dynamic;
      procedure ValidateRename(AComponent: TComponent; const CurName, NewName: string); virtual;
      procedure WriteState(Writer: TWriter); virtual;
   end;

   TBasicAction = class(TComponent)
   public
      property ActionComponent: TComponent;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      function Execute: Boolean; dynamic;
      procedure ExecuteTarget(Target: TObject); virtual;
      function HandlesTarget(Target: TObject): Boolean; virtual;
      procedure RegisterChanges(Value: TBasicActionLink);
      procedure UnRegisterChanges(Value: TBasicActionLink);
      function Update: Boolean; virtual;
      procedure UpdateTarget(Target: TObject); virtual;
      property OnExecute: TNotifyEvent;
      property OnUpdate: TNotifyEvent;
   protected
      procedure Change; virtual;
      procedure Notification(AComponent: TComponent; Operation: TOperation); override;
      procedure SetOnExecute(Value: TNotifyEvent); virtual;
      property OnChange: TNotifyEvent;
   end;

   TBasicActionLink = class(TObject)
   public
      property Action: TBasicAction;
      property OnChange: TNotifyEvent;
      constructor Create(AClient: TObject); virtual;
      destructor Destroy; override;
      function Execute(AComponent: TComponent = nil): Boolean; virtual;
      function Update: Boolean; virtual;
   end;

   TBits = class(TObject)
   public
      property Bits[Index: Integer]: Boolean; default;
      property Size: Integer;
      destructor Destroy; override;
      function OpenBit: Integer;
   end;

   TCollection = class(TPersistent)
   public
      property Count: Integer;
      property ItemClass: TCollectionItemClass;
      property Items[Index: Integer]: TCollectionItem;
      function Add: TCollectionItem;
      procedure Assign(Source: TPersistent); override;
      procedure BeginUpdate; virtual;
      procedure Clear;
      constructor Create(ItemClass: TCollectionItemClass);
      procedure Delete(Index: Integer);
      destructor Destroy; override;
      procedure EndUpdate; virtual;
      function FindItemID(ID: Integer): TCollectionItem;
      function GetNamePath: string; override;
      function Insert(Index: Integer): TCollectionItem;
      function Owner: TPersistent;
   protected
      property NextID: Integer;
      property PropName: string;
      property UpdateCount: Integer;
      procedure Added(var Item: TCollectionItem); virtual; deprecated;
      procedure Changed;
      procedure Deleting(Item: TCollectionItem); virtual; deprecated;
      function GetAttr(Index:Integer): string; dynamic;
      function GetAttrCount: Integer; dynamic;
      function GetItem(Index:Integer): TCollectionItem;
      function GetItemAttr(Index, ItemIndex :Integer): string; dynamic;
      procedure Notify(Item: TCollectionItem; Action: TCollectionNotification); virtual;
      procedure SetItem(Index:Integer; Value: TCollectionItem);
      procedure SetItemName(Item: TCollectionItem); virtual;
      procedure Update(Item: TCollectionItem); virtual;
   end;

   TCollectionItem = class(TPersistent)
   public
      property Collection: TCollection;
      property DisplayName: string;
      property ID: Integer;
      property Index: Integer;
      constructor Create(Collection: TCollection); virtual;
      destructor Destroy; override;
   protected
      procedure Changed(AllItems: Boolean);
      function GetDisplayName: string; virtual;
      function GetNamePath: string; override;
      function GetOwner: TPersistent; override;
      procedure SetCollection(Value: TCollection); virtual;
      procedure SetDisplayName(const Value: string); virtual;
      procedure SetIndex(Value: Integer); virtual;
   end;

   TStream = class(TObject)
   public
      property Position: Int64;
      property Size: Int64;
      function CopyFrom(Source: TStream; Count: Int64): Int64;
      procedure FixupResourceHeader(FixupInfo: Integer);
      function Read(var Buffer; Count: Longint): Longint; virtual; abstract;
      procedure ReadBuffer(var Buffer; Count: Longint);
      function ReadComponent(Instance: TComponent): TComponent;
      function ReadComponentRes(Instance: TComponent): TComponent;
      procedure ReadResHeader;
      function Seek(Offset: Longint; Origin: Word): Longint; overload; virtual;
      function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; overload; virtual;
      function Write(const Buffer; Count: Longint): Longint; virtual; abstract;
      procedure WriteBuffer(const Buffer; Count: Longint);
      procedure WriteComponent(Instance: TComponent);
      procedure WriteComponentRes(const ResName: string; Instance: TComponent);
      procedure WriteDescendent(Instance, Ancestor: TComponent); virtual;
      procedure WriteDescendentRes(const ResName: string; Instance, Ancestor: TComponent);
      procedure WriteResourceHeader(const ResName: string; out FixupInfo: Integer);
   protected
      procedure SetSize(NewSize: Longint); overload; virtual;
      procedure SetSize(const NewSize: Int64); overload; virtual;
   end;
  

   TCustomMemoryStream = class(TStream)
   public
      property Memory: Pointer;
      function Read(var Buffer; Count: Longint): Longint; override;
      procedure SaveToFile(const FileName: string);
      procedure SaveToStream(Stream: TStream);
      function Seek(Offset: Longint; Origin: Word): Longint; override;
   protected
      procedure SetPointer(Ptr: Pointer; Size: Longint);
   end;


   TDataModule = class(TComponent)
   public
      property DesignOffset: TPoint;
      property DesignSize: TPoint;
      procedure AfterConstruction; override;
      procedure BeforeDestruction; override;
      constructor Create(AOwner: TComponent);
      constructor CreateNew(AOwner: TComponent; Dummy: Integer = 0); virtual;
      destructor Destroy;
   protected
      property OldCreateOrder: Boolean;
      property OnCreate: TNotifyEvent;
      property OnDestroy: TNotifyEvent;
   end;

   TFiler = class(TObject)
   public
      property Ancestor: TPersistent;
      property IgnoreChildren: Boolean;
      property LookupRoot: TComponent;
      property Root: TComponent;
      constructor Create(Stream: TStream; BufSize: Integer);
      procedure DefineBinaryProperty(const Name: string; ReadData, WriteData: TStreamProc; HasData: Boolean); virtual; abstract;
      procedure DefineProperty(const Name: string; ReadData: TReaderProc; WriteData: TWriterProc; HasData: Boolean); virtual; abstract;
      destructor Destroy; override;
      procedure FlushBuffer; virtual; abstract;
   end;

   THandleStream = class(TStream)
   public
      property Handle: Integer;
      constructor Create(AHandle: Integer);
      function Read(var Buffer; Count: Longint): Longint; override;
      function Seek(Offset: Longint; Origin: Word): Longint; overload; virtual;
      function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; override;
      function Write(const Buffer; Count: Longint): Longint; override;
   protected
      procedure SetSize(NewSize: Longint); override;
      procedure SetSize(const NewSize: Int64); override;
   end;



   TFileStream = class(THandleStream)
   public
      property Handle: Integer;
      constructor Create(AHandle: Integer);
      function Read(var Buffer; Count: Longint): Longint; override;
      function Seek(Offset: Longint; Origin: Word): Longint; overload; virtual;
      function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; override;
      function Write(const Buffer; Count: Longint): Longint; override;
   protected
      procedure SetSize(NewSize: Longint); override;
      procedure SetSize(const NewSize: Int64); override;
   end;


   TInterfacedPersistent = class(TPersistent)
   public
      procedure AfterConstruction; override;
      function QueryInterface(const IID: TGUID; out Obj): HResult; virtual; stdcall;
   protected
      function _AddRef: Integer; stdcall;
      function __Release: Integer; stdcall;
   end;

   TInterfaceList = class(TInterfacedObject)
   public
      property Capacity: Integer;
      property Count: Integer;
      property Items[Index: Integer]: IInterface; default;
      function Add(const Item: IInterface): Integer;
      procedure Clear;
      constructor Create;
      procedure Delete(Index: Integer);
      procedure Exchange(Index1, Index2: Integer);
      function Expand: TInterfaceList;
      function First: IInterface;
      function IndexOf(const Item: IInterface): Integer; 
      procedure Insert(Index: Integer; const Item: IInterface);
      function Last: IInterface; 
      procedure Lock;
      function Remove(const Item: IInterface): Integer; 
      procedure Unlock;
   end;

   TList = class(TObject)
   public
      property Capacity: Integer;
      property Count: Integer;
      property Items[Index: Integer]: Pointer; default;
      property List: PPointerList;
      function Add(Item: Pointer): Integer;
      procedure Assign(ListA: TList; AOperator: TListAssignOp = laCopy; ListB: TList = nil);
      procedure Clear; virtual;
      procedure Delete(Index: Integer);
      destructor Destroy; override;
      class procedure Error(const Msg: string; Data: Integer); overload; virtual;
      class procedure Error(Msg: PResStringRec; Data: Integer); overload;
      procedure Exchange(Index1, Index2: Integer);
      function Expand: TList;
      function Extract(Item: Pointer): Pointer;
      function First: Pointer;
      function IndexOf(Item: Pointer): Integer;
      procedure Insert(Index: Integer; Item: Pointer);
      function Last: Pointer;
      procedure Move(CurIndex, NewIndex: Integer);
      procedure Pack;
      function Remove(Item: Pointer): Integer;
      procedure Sort(Compare: TListSortCompare);
   end;

   TMemoryStream = class(TCustomMemoryStream)
   public
      procedure Clear;
      destructor Destroy; override;
      procedure LoadFromFile(const FileName: string);
      procedure LoadFromStream(Stream: TStream);
      procedure SetSize(NewSize: Longint); override;
      function Write(const Buffer; Count: Longint): Longint; override;
   end;

   TCollectionItemClass = class of TCollectionItem;
   TOwnedCollection = class(TCollection)
   public
      constructor Create(AOwner: TPersistent; ItemClass: TCollectionItemClass);
   end;


   TReader = class(TFiler)
   public
      property Owner: TComponent;
      property Parent: TComponent;
      property Position: Longint;
      property OnAncestorNotFound: TAncestorNotFoundEvent;
      property OnCreateComponent: TCreateComponentEvent;
      property OnError: TReaderError;
      property OnFindComponentClass: TFindComponentClassEvent;
      property OnFindMethod: TFindMethodEvent;
      property OnReferenceName: TReferenceNameEvent;
      property OnSetName: TSetNameEvent;
      procedure BeginReferences;
      procedure CheckValue(Value: TValueType);
      procedure DefineBinaryProperty(const Name: string; ReadData, WriteData: TStreamProc; HasData: Boolean); override;
      procedure DefineProperty(const Name: string; ReadData: TReaderProc; WriteData: TWriterProc; HasData: Boolean); override;
      destructor Destroy; override;
      function EndOfList: Boolean;
      procedure EndReferences;
      procedure FixupReferences;
      procedure FlushBuffer; override;
      function NextValue: TValueType;
      procedure Read(var Buf; Count: Longint);
      function ReadBoolean: Boolean;
      function ReadChar: Char;
      procedure ReadCollection(Collection: TCollection);
      function ReadComponent(Component: TComponent): TComponent;
      procedure ReadComponents(AOwner, AParent: TComponent; Proc: TReadComponentsProc);
      function ReadCurrency: Currency;
      function ReadDate: TDateTime;
      function ReadFloat: Extended;
      function ReadIdent: string;
      function ReadInt64: Int64;
      function ReadInteger: Longint;
      procedure ReadListBegin;
      procedure ReadListEnd;
      procedure ReadPrefix(var Flags: TFilerFlags; var AChildPos: Integer); virtual;
      function ReadRootComponent(Root: TComponent): TComponent;
      procedure ReadSignature;
      function ReadSingle: Single;
      function ReadStr: string;
      function ReadString: string;
      function ReadValue: TValueType;
      function ReadVariant: Variant;
      function ReadWideString: WideString;
      procedure SkipValue;
   end;

   TRecall = class(TObject)
   public
      property Reference: TPersistent;
      constructor Create(AStorage, AReference: TPersistent);
      procedure Destroy; override;
      procedure Forget;
      procedure Store;
   end;

   TResourceStream = class(TCustomMemoryStream)
      constructor Create(Instance: THandle; const ResName: string; ResType: PChar);
      constructor CreateFromID(Instance: THandle; ResID: Integer; ResType: PChar);
      destructor Destroy; override;
   end;


   TStreamAdapter = class(TInterfacedObject)
   public
      property Stream: TStream;
      property StreamOwnership: TStreamOwnership;
      function Clone(out stm: IStream): HResult; virtual; stdcall;
      function Commit(grfCommitFlags: Longint): HResult; virtual; stdcall;
      function CopyTo(stm: IStream; cb: Largeint; out cbRead: Largeint; out cbWritten: Largeint): HResult; virtual; stdcall;
      constructor Create(Stream: TStream; Ownership: TStreamOwnership = soReference);
      destructor Destroy; override;
      function LockRegion(libOffset: Largeint; cb: Largeint; dwLockType: Longint): HResult; virtual; stdcall;
      function Read(pv: Pointer; cb: Longint; pcbRead: PLongint): HResult; virtual; stdcall;
      function Revert(grfRevertFlags: Longint): HResult; virtual; stdcall;
      function Seek(dlibMove: Largeint; dwOrigin: Longint; out libNewPosition: Largeint): HResult; virtual; stdcall;
      function SetSize(libNewSize: Largeint): HResult; virtual; stdcall;
      function Stat(out statstg: TStatStg; grfStatFlag: Longint): HResult; virtual; stdcall;
      function UnlockRegion(libOffset: Largeint; cb: Largeint; dwLockType: Longint): HResult; virtual; stdcall;
      function Write(pv: Pointer; cb: Longint; pcbWritten: PLongint): HResult; virtual; stdcall;
   end;

   TStrings = class(TPersistent)
   public
      property Capacity: Integer;
      property CommaText: string;
      property Count: Integer;
      property DelimitedText: string;
      property Delimiter: Char;
      property Names[Index: Integer]: string;
      property NameValueSeparator: Char;
      property Objects[Index: Integer]: TObject;
      property QuoteChar: Char;
      property Strings[Index: Integer]: string; default;
      property StringsAdapter: IStringsAdapter;
      property Text: string;
      property ValueFromIndex[Index: Integer]: string;
      property Values[const Name: string]: string;
      function Add(const S: string): Integer; virtual;
      function AddObject(const S: string; AObject: TObject): Integer; virtual;
      procedure AddStrings(Strings: TStrings); virtual;
      procedure Append(const S: string);
      procedure Assign(Source: TPersistent); override;
      procedure BeginUpdate;
      procedure Clear; virtual; abstract;
      procedure Delete(Index: Integer); virtual; abstract;
      destructor Destroy; override;
      procedure EndUpdate;
      function Equals(Strings: TStrings): Boolean;
      procedure Exchange(Index1, Index2: Integer); virtual;
      function GetText: PChar; virtual;
      function IndexOf(const S: string): Integer; virtual;
      function IndexOfName(const Name: string): Integer; virtual;
      procedure Insert(Index: Integer; const S: string); virtual; abstract;
      procedure InsertObject(Index: Integer; const S: string; AObject: TObject) virtual;
      procedure LoadFromFile(const FileName: string); virtual;
      procedure LoadFromStream(Stream: TStream); virtual;
      procedure Move(CurIndex, NewIndex: Integer); virtual;
      procedure SaveToFile(const FileName: string); virtual;
      procedure SaveToStream(Stream: TStream); virtual;
      procedure SetText(Text: PChar); virtual;
   protected
      property UpdateCount: Integer;
      function CompareStrings(const S1, S2: string): Integer; virtual;
      procedure DefineProperties(Filer: TFiler); override;
      procedure Error(Msg: PResStringRec; Data: Integer); overload;
      procedure Error(const Msg: string; Data: Integer); overload;
      function ExtractName(const S: string): string;
      function Get(Index: Integer): string; virtual; abstract;
      function GetCapacity: Integer; virtual;
      function GetCount: Integer; virtual; abstract;
      function GetObject(Index: Integer): TObject; virtual;
      function GetTextStr: string; virtual;
      procedure Put(Index: Integer; const S: string); virtual;
      procedure PutObject(Index: Integer; AObject: TObject); virtual;
      procedure SetCapacity(NewCapacity: Integer); virtual;
      procedure SetTextStr(const Value: string); virtual;
      procedure SetUpdateState(Updating: Boolean); virtual;
   end;


   TStringList = class(TStrings)
   public
      property Capacity: Integer;
      property CaseSensitive: Boolean;
      property Count: Integer;
      property Duplicates: TDuplicates;
      property Objects[Index: Integer]: TObject;
      property Sorted: Boolean;
      property Strings[Index: Integer]: string; default;
      property OnChange: TNotifyEvent;
      property OnChanging: TNotifyEvent;
      function Add(const S: string): Integer; override;
      function AddObject(const S: string; AObject: TObject): Integer; override;
      procedure Clear; override;
      procedure CustomSort(Compare: TStringListSortCompare); virtual;
      procedure Delete(Index: Integer); override;
      destructor Destroy; override;
      procedure Exchange(Index1, Index2: Integer); override;
      function Find(const S: string; var Index: Integer): Boolean; virtual;
      function IndexOf(const S: string): Integer; override;
      procedure Insert(Index: Integer; const S: string); override;
      procedure InsertObject(Index: Integer; const S: string; AObject: TObject); override;
      procedure Sort; virtual;
   end;


   TStringStream = class(TStream)
   public
      property DataString: string;
      property Size: Longint;
      constructor Create(AString: string);
      function Read(var Buffer; Count: Longint): Longint; override;
      function ReadString(Count: Longint): string;
      function Seek(Offset: Longint; Origin: Word): Longint; override;
      function Write(const Buffer; Count: Longint): Longint; override;
      procedure WriteString(const AString: string);
   end;

   TThread = class(TObject)
   public
      property FatalException: TObject;
      property FreeOnTerminate: Boolean;
{$IF WINDOWS}
      property Handle: THandle;
{$ENDIF}
{$IF LINUX}
      property Policy: Integer;
{$ENDIF}
      property Priority: TThreadPriority;
      property Suspended: Boolean;
      property ThreadID: THandle;
      property OnTerminate: TNotifyEvent;
      procedure AfterConstruction; override;
      constructor Create(CreateSuspended: Boolean);
      destructor Destroy; override;
      procedure Resume;
      procedure Suspend;
      procedure Terminate;
      function WaitFor: LongWord;
   protected
      property ReturnValue: Integer
      property Terminated: Boolean;
      procedure DoTerminate; virtual;
      procedure Execute; virtual; abstract;
      procedure Synchronize(Method: TThreadMethod);
   end;

   TThreadList = class(TObject)
   public
      property Duplicates: TDuplicates;
      procedure Add(Item: Pointer);
      procedure Clear;
      constructor Create;
      destructor Destroy; override;
      function  LockList: TList;
      procedure Remove(Item: Pointer);
      procedure UnlockList;
   end;

   TWriter = class(TFiler)
   public
      property Position: Longint;
      property RootAncestor: TComponent;
      property UseQualifiedNames: Boolean;
      property OnFindAncestor: TFindAncestorEvent;
      procedure DefineBinaryProperty(const Name: string; ReadData, WriteData: TStreamProc; HasData: Boolean); override;
      procedure DefineProperty(const Name: string; ReadData: TReaderProc; WriteData: TWriterProc; HasData: Boolean); override;
      destructor Destroy; override;
      procedure FlushBuffer; override;
      procedure Write(const Buf; Count: Longint);
      procedure WriteBoolean(Value: Boolean);
      procedure WriteChar(Value: Char);
      procedure WriteCollection(Value: TCollection);
      procedure WriteComponent(Component: TComponent);
      procedure WriteCurrency(const Value: Currency);
      procedure WriteDate(const Value: TDateTime);
      procedure WriteDescendent(Root: TComponent; AAncestor: TComponent);
      procedure WriteFloat(const Value: Extended);
      procedure WriteIdent(const Ident: string);
      procedure WriteInteger(Value: Longint); overload;
      procedure WriteInteger(Value: Int64); overload;
      procedure WriteListBegin;
      procedure WriteListEnd;
      procedure WriteRootComponent(Root: TComponent);
      procedure WriteSignature;
      procedure WriteSingle(const Value: Single);
      procedure WriteStr(const Value: string);
      procedure WriteString(const Value: string);
      procedure WriteVariant(const Value: Variant);
      procedure WriteWideString(const Value: WideString);
   end;

   var CreateVCLComObjectProc: procedure(Component: TComponent) = nil;
   var CurrentGroup: Integer;
   var WakeMainThread: TNotifyEvent = nil;

   function ActivateClassGroup(AClass: TPersistentClass): TPersistentClass;
   function AllocateHWnd(Method: TWndMethod): Integer;
   procedure BinToHex(Buffer, Text: PChar; BufSize: Integer);
   function CheckSynchronize(Timeout: Integer = 0): Boolean;
   function CollectionsEqual(C1, C2: TCollection; Owner1, Owner2: TComponent): Boolean;
   function CountGenerations(Ancestor, Descendant: TClass): Integer;
   procedure DeallocateHWnd(Wnd: Integer);
   function EqualRect(const R1, R2: TRect): Boolean;
   function ExtractStrings(Separators, WhiteSpace: TSysCharSet; Content: PChar; Strings: TStrings): Integer;
   function FindClass(const ClassName: string): TPersistentClass;
   function FindGlobalComponent(const Name: string): TComponent;
   function GetClass(const ClassName: string): TPersistentClass;
   procedure GroupDescendantsWith(AClass, AClassGroup: TPersistentClass);
   function HexToBin(Text, Buffer: PChar; BufSize: Integer): Integer
   function IdentToInt(const Ident: string; var Int: Longint; const Map: array of TIdentMapEntry): Boolean;
   function InitInheritedComponent(Instance: TComponent; RootAncestor: TClass): Boolean;
   function IntToIdent(Int: Longint; var Ident: string; const Map: array of TIdentMapEntry): Boolean;
   function InvalidPoint(const At: TPoint): Boolean; overload;
   function InvalidPoint(const At: TSmallPoint): Boolean; overload;
   function InvalidPoint(X, Y: Integer): Boolean; overload;
   function IsUniqueGlobalComponentName(const Name: string): Boolean;
   function LineStart(Buffer, BufPos: PChar): PChar;
   procedure ObjectBinaryToText(Input, Output: TStream); overload;
   procedure ObjectBinaryToText(Input, Output: TStream; var OriginalFormat: TStreamOriginalFormat); overload;
   procedure ObjectResourceToText(Input, Output: TStream); overload;
   procedure ObjectResourceToText(Input, Output: TStream; var OriginalFormat: TStreamOriginalFormat); overload;
   procedure ObjectTextToBinary(Input, Output: TStream); overload;
   procedure ObjectTextToBinary(Input, Output: TStream; var OriginalFormat: TStreamOriginalFormat); overload;
   procedure ObjectTextToResource(Input, Output: TStream); overload;
   procedure ObjectTextToResource(Input, Output: TStream; var OriginalFormat: TStreamOriginalFormat); overload;
   function PointsEqual(const P1, P2: TPoint): Boolean; overload;
   function PointsEqual(const P1, P2: TSmallPoint): Boolean; overload;
   function ReadComponentRes(const ResName: string; Instance: TComponent): TComponent;
   function ReadComponentResEx(HInstance: THandle; const ResName: string): TComponent;
   function ReadComponentResFile(const FileName: string; Instance: TComponent): TComponent;
   procedure RegisterClass(AClass: TPersistentClass);
   procedure RegisterClassAlias(AClass: TPersistentClass; const Alias: string);
   procedure RegisterClasses(AClasses: array of TPersistentClass);
   procedure RegisterComponents(const Page: string; const ComponentClasses: array of TComponentClass);
   procedure RegisterIntegerConsts(AIntegerType: Pointer; AIdentToInt: TIdentToInt; AIntToIdent: TIntToIdent);
   procedure RegisterNoIcon(const ComponentClasses: array of TComponentClass);
   procedure RegisterNonActiveX(const ComponentClasses: array of TComponentClass; AxRegType: TActiveXRegType);
   function SmallPoint(AX, AY: SmallInt): TSmallPoint;
   procedure StartClassGroup(AClass: TPersistentClass);
   function TestStreamFormat(Stream: TStream): TStreamOriginalFormat;
   procedure UnRegisterClass(AClass: TPersistentClass);
   procedure UnRegisterClasses(AClasses: array of TPersistentClass);
   procedure UnregisterIntegerConsts(AIntegerType: Pointer; AIdentToInt: TIdentToInt; AIntToIdent: TIntToIdent);
   procedure UnRegisterModuleClasses(Module: HMODULE);
   procedure WriteComponentResFile(const FileName: string; Instance: TComponent);
implementation
end.






