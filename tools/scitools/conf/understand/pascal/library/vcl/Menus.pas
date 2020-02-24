unit Menus;
interface
   uses Windows, SysUtils, Types, Classes, Messages, ActnList,
         Graphics, ImgList;
type
   TFindItemKind = (fkCommand, fkHandle, fkShortCut);
   TMenuBreak = (mbNone, mbBreak, mbBarBreak);
   TMenuItemAutoFlag = (maAutomatic, maManual, maParent);
   TMenuAnimations = (maLeftToRight, maRightToLeft, maTopToBottom, maBottomToTop, maNone);
   TMenuAnimation = set of TMenuAnimations;
   TMenuAutoFlag = maAutomatic..maManual;
   TPopupAlignment = (paLeft, paRight, paCenter);
   TTrackButton = (tbRightButton, tbLeftButton);

   TAdvancedMenuDrawItemEvent = procedure (Sender: TObject; ACanvas: TCanvas; ARect: TRect; State: TOwnerDrawState) of object;
   TMenuChangeEvent = procedure (Sender: TObject; Source: TMenuItem; Rebuild: Boolean) of object;
   TMenuDrawItemEvent = procedure (Sender: TObject; ACanvas: TCanvas; ARect: TRect; Selected: Boolean) of object;
   TMenuMeasureItemEvent = procedure (Sender: TObject; ACanvas: TCanvas; var Width, Height: Integer) of object;

   HAccel = THandle;
   HMENU = THandle;
   HWnd = THandle;

   EMenuError = class(Exception);

   TMenu = class(TComponent)
   public
      property AutoLineReduction: TMenuAutoFlag;
      property BiDiMode: TBiDiMode;
      property Handle: HMENU;
      property OwnerDraw: Boolean;
      property ParentBiDiMode: Boolean;
      property WindowHandle: HWnd;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      function DispatchCommand(ACommand: Word): Boolean; dynamic;
      function DispatchPopup(AHandle: HMENU): Boolean;
      function FindItem(Value: Integer; Kind: TFindItemKind): TMenuItem;
      function GetHelpContext(Value: Integer; ByCommand: Boolean): THelpContext;
      function IsRightToLeft: Boolean;
      function IsShortCut(var Message: TWMKey): Boolean; dynamic;
      procedure ParentBiDiModeChanged; overload;
      procedure ParentBiDiModeChanged(AControl: TObject); overload;
      procedure ProcessMenuChar(var Message: TWMMenuChar);
   published
      property Items: TMenuItem; default;
   protected
      property Images: TCustomImageList;
      procedure AdjustBiDiBehavior;
      procedure DoBiDiModeChanged;
      procedure DoChange(Source: TMenuItem; Rebuild: Boolean); virtual;
      function DoGetMenuString(Menu: HMENU; ItemID: UINT; Str: PChar; MaxCount: Integer; Flag: UINT): Integer;
      procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
      function GetHandle: HMENU; virtual;
      function IsOwnerDraw: Boolean;
      procedure Loaded; override;
      procedure MenuChanged(Sender: TObject; Source: TMenuItem; Rebuild: Boolean); virtual;
      procedure Notification(AComponent: TComponent; Operation: TOperation); override;
      procedure SetChildOrder(Child: TComponent; Order: Integer); override;
      procedure UpdateItems;
      property OnChange: TMenuChangeEvent;
   end;

   TMainMenu = class(TMenu)
   public
      property Handle: HMENU;
      procedure GetOle2AcceleratorTable(var AccelTable: HAccel; var AccelCount: Integer; const
                                           Groups: array of Integer);
      procedure Merge(Menu: TMainMenu);
      procedure PopulateOle2Menu(SharedMenu: HMenu; const Groups: array of Integer; var Widths: array of Longint);
      procedure SetOle2MenuHandle(Handle: HMENU);
      procedure Unmerge(Menu: TMainMenu);
   published
      property AutoMerge: Boolean;
   end;   

   TMenuActionLink = class(TActionLink)
   public
   protected
      procedure AssignClient(AClient: TObject); override;
      function IsAutoCheckLinked: Boolean; override;
      function IsCaptionLinked: Boolean; override;
      function IsCheckedLinked: Boolean; override;
      function IsEnabledLinked: Boolean; override;
      function IsGroupIndexLinked: Boolean; override;
      function IsHelpLinked: Boolean; override;
      function IsHintLinked: Boolean; override;
      function IsImageIndexLinked: Boolean; override;
      function IsOnExecuteLinked: Boolean; override;
      function IsShortCutLinked: Boolean; override;
      function IsVisibleLinked: Boolean; override;
      procedure SetAutoCheck(Value: Boolean); override;
      procedure SetCaption(const Value: string); override;
      procedure SetChecked(Value: Boolean); override;
      procedure SetEnabled(Value: Boolean); override;
      procedure SetHelpContext(Value: THelpContext); override;
      procedure SetHelpKeyword(const Value: string); override;
      procedure SetHelpType(Value: THelpType ); override;
      procedure SetHint(const Value: string); override;
      procedure SetImageIndex(Value: Integer); override;
      procedure SetOnExecute(Value: TNotifyEvent); override;
      procedure SetShortCut(Value: TShortCut); override;
      procedure SetSmallIndex(Value: Integer); override;
      procedure SetVisible(Value: Boolean); override;
   end;

   TMenuItem = class(TComponent)
   public
      property Command: Word;
      property Count: Integer;
      property Handle: HMENU;
      property Items[Index: Integer]: TMenuItem; default;
      property MenuIndex: Integer;
      property Parent: TMenuItem;
      procedure Add(Item: TMenuItem); overload;
      procedure Add(const AItems: array of TMenuItem); overload;
      procedure Clear;
      procedure Click; virtual;
      constructor Create(AOwner: TComponent); override;
      procedure Delete(Index: Integer);
      destructor Destroy; override;
      function Find(ACaption: string): TMenuItem;
      function GetImageList: TCustomImageList;
      function GetParentComponent: TComponent; override;
      function GetParentMenu: TMenu;
      function HasParent: Boolean; override;
      function IndexOf(Item: TMenuItem): Integer;
      procedure InitiateAction; virtual;
      procedure Insert(Index: Integer; Item: TMenuItem);
      function InsertNewLineAfter(AItem: TMenuItem): Integer;
      function InsertNewLineBefore(AItem: TMenuItem): Integer;
      function IsLine: Boolean;
      function NewBottomLine: Integer;
      function NewTopLine: Integer;
      procedure Remove(Item: TMenuItem);
      function RethinkHotkeys: Boolean;
      function RethinkLines: Boolean;
   published
      property Action: TBasicAction;
      property AutoCheck: Boolean;
      property AutoHotkeys: TMenuItemAutoFlag;
      property AutoLineReduction: TMenuItemAutoFlag;
      property Bitmap: TBitmap;
      property Break: TMenuBreak;
      property Caption: string;
      property Checked: Boolean;
      property Default: Boolean;
      property Enabled: Boolean;
      property GroupIndex: Byte;
      property HelpContext: THelpContext;
      property Hint: string;
      property ImageIndex: TImageIndex;
      property RadioItem: Boolean;
      property ShortCut: TShortCut
      property SubMenuImages: TCustomImageList;
      property Visible: Boolean;
      property OnAdvancedDrawItem: TAdvancedMenuDrawItemEvent;
      property OnClick: TNotifyEvent;
      property OnDrawItem: TMenuDrawItemEvent;
      property OnMeasureItem: TMenuMeasureItemEvent;
   end;

   TPopupMenu = class(TMenu)
   public
      property PopupComponent: TComponent;
      property PopupPoint: TPoint;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      procedure Popup(X, Y: Integer); virtual;
   published
      property Alignment: TPopupAlignment;
      property AutoPopup: Boolean;
      property HelpContext: THelpContext;
      property MenuAnimation: TMenuAnimation;
      property TrackButton: TTrackButton;
   protected
      procedure DoPopup(Sender: TObject); virtual;
      function UseRightToLeftAlignment: Boolean;
      property OnPopup: TNotifyEvent;
   end;

   TPopupList = class(TList)
   public
      property Window: HWND;
      procedure Add(Popup: TPopupMenu);
      procedure Remove(Popup: TPopupMenu);
   published
      procedure MainWndProc(var Message: TMessage);
      procedure WndProc(var Message: TMessage); virtual;
   end;

var  
   PopupList: TPopupList;

function GetHotKey(const Text: string): string;
function NewItem(const ACaption: string; AShortCut: TShortCut; AChecked, AEnabled: Boolean; AOnClick: TNotifyEvent; hCtx: THelpContext; const AName: string): TMenuItem;
function NewSubMenu(const ACaption: string; hCtx: THelpContext; const AName: string; const Items: array of TMenuItem; AEnabled: Boolean = True): TMenuItem;
function ShortCutToText(ShortCut: TShortCut): string;
function StripHotKey (const Text: string): string;

implementation
end.









