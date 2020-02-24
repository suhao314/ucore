unit Contnrs;
interface
   uses Classes;
type

   TBucketItem = record
      Item, Data: Pointer;
   end;
   TBucketItemArray = array of TBucketItem;

   TBucket = record
      Count: Integer;
      Items: TBucketItemArray;
   end;
   TBucketArray = array of TBucket;
   TBucketListSizes = (bl2, bl4, bl8, bl16, bl32, bl64, bl128, bl256);
   TBucketProc = procedure(AInfo, AItem, AData: Pointer; out AContinue: Boolean);

   TCustomBucketList = class(TObject)
   public
      property Data[AItem: Pointer]: Pointer; default;
      function Add(AItem, AData: Pointer): Pointer;
      procedure Assign(AList: TCustomBucketList);
      procedure Clear;
      destructor Destroy; override;
      function Exists(AItem: Pointer): Boolean;
      function Find(AItem: Pointer; out AData: Pointer): Boolean;
      function ForEach(AProc: TBucketProc; AInfo: Pointer=nil): Boolean;
      function Remove(AItem: Pointer): Pointer;
   protected
      property BucketCount: Integer;
      property Buckets: TBucketArray;
      function AddItem(ABucket: Integer; AItem, AData: Pointer): Pointer; virtual;
      function BucketFor(AItem: Pointer): Integer; virtual; abstract;
      function DeleteItem(ABucket: Integer; AIndex: Integer): Pointer; virtual;
      function FindItem(AItem: Pointer; out ABucket, AIndex: Integer): Boolean; virtual;
   end;

   TBucketList = class(TCustomBucketList)
   public
      constructor Create(ABuckets: TBucketListSizes = bl16);
   protected
      function BucketFor(AItem: Pointer): Integer; override;
   end;

   TClassList = class(TList)
   public
      property Items[Index: Integer]: TClass; default;
      function Add(aClass: TClass): Integer;
      function Extract(Item: TClass): TClass;
      function First: TClass;
      function IndexOf(aClass: TClass): Integer;
      procedure Insert(Index: Integer; aClass: TClass);
      function Last: TClass;
      function Remove(aClass: TClass): Integer;
   end;

   TObjectList = class(TList)
   public
      property Items[Index: Integer]: TObject; default;
      property OwnsObjects: Boolean;
      function Add(AObject: TObject): Integer;
      constructor Create; overload;
      constructor Create(AOwnsObjects: Boolean); overload;
      function Extract(Item: TObject): TObject;
      function First: TObject;
      function FindInstanceOf(AClass: TClass; AExact: Boolean = True; AStartAt: Integer = 0): Integer;
      function IndexOf(AObject: TObject): Integer;
      procedure Insert(Index: Integer; AObject: TObject);
      function Last: TObject;
      function Remove(AObject: TObject): Integer;
   end;

   TComponentList = class(TObjectList)
   public
      property Items[Index: Integer]: TComponent; default;
      function Add(AComponent: TComponent): Integer;
      destructor Destroy; override;
      function Extract(Item: TComponent): TComponent;
      function First: TComponent;
      function IndexOf(AComponent: TComponent): Integer;
      procedure Insert(Index: Integer; AComponent: TComponent);
      function Last: TComponent;
      function Remove(AComponent: TComponent): Integer;
   end;

   TObjectBucketList = class(TBucketList)
   public
      function Add(AItem, AData: TObject): TObject;
      function Remove(AItem: TObject): TObject;
   end;


   TQueue = class(TOrderedList)
   end;

   TObjectQueue = class(TQueue)
   public
      function Peek: TObject;
      function Pop: TObject;
      function Push(AObject: TObject): TObject;
   end;

   TStack = class(TOrderedList)
   end;

   TObjectStack = class(TStack)
   public
      function Peek: TObject;
      function Pop: TObject;
      function Push(AObject: TObject): TObject;
   end;

   TOrderedList = class(TObject)
   public
      function AtLeast(ACount: Integer): Boolean;
      function Count: Integer;
      constructor Create;
      destructor Destroy; override;
      function Peek: Pointer;
      function Pop: Pointer;
      function Push(AItem: Pointer): Pointer;
   protected
      property List: TList;
      function PeekItem: Pointer; virtual;
      function PopItem: Pointer; virtual;
      procedure PushItem(AItem: Pointer); virtual; abstract;
   end;


implementation
end.




