unit Controls;
interface
   uses Windows, Types, Menus, Messages, Menus, Classes, Graphics, ImgList;
type
   TAlign = (alNone, alTop, alBottom, alLeft, alRight, alClient, alCustom);
   TAnchors = set of TAnchorKind;
   TAnchorKind = (akTop, akLeft, akRight, akBottom);
   TBevelCut = (bvNone, bvLowered, bvRaised, bvSpace);
   TBevelEdge = (beLeft, beTop, beRight, beBottom);
   TBevelEdges = set of TBevelEdge;
   TBevelKind = (bkNone, bkTile, bkSoft, bkFlat);
   TBevelWidth = 1..MaxInt;
   TBorderWidth = 0..MaxInt;
   TCaption = type string;
   TControlActionLinkClass = class of TControlActionLink;

   TControlState = set of (csLButtonDown, csClicked, csPalette, 
                           csReadingState, csAlignmentNeeded, 
                           csFocusing, csCreating, csPaintCopy, 
                           csCustomPaint, csDestroyingHandle, csDocking);
   TControlStyle = set of (csAcceptsControls, csCaptureMouse, csDesignInteractive, csClickEvents, csFramed, csSetCaption, csOpaque, csDoubleClicks, csFixedWidth, csFixedHeight, csNoDesignVisible, csReplicatable, csNoStdEvents, csDisplayDragImage, csReflector, csActionClient, csMenuEvents);
   TCreateParams = record
      Caption: PChar;
      Style: DWORD;
      ExStyle: DWORD;
      X, Y: Integer;
      Width, Height: Integer;
      WndParent: HWND;
      Param: Pointer;
      WindowClass: Integer;  // tbd - was TWndClass but no doc
      WinClassName: array[0..63] of Char;
   end;
   TCursor = -32768..32767;
   TDockOrientation = (doNoOrient, doHorizontal, doVertical);
   TDragKind = (dkDrag, dkDock);
   TDragMode = (dmManual, dmAutomatic);
   TDragState = (dsDragEnter, dsDragLeave, dsDragMove);
   TImeMode = (imDisable, imClose, imOpen, imDontCare, imSAlpha, imAlpha, imHira, imSKata, imKata, imChinese, imSHanguel, imHanguel);
   TModalResult = Low(Integer)..High(Integer);
   TMouseButton = (mbLeft, mbRight, mbMiddle);

   TScalingFlags = set of (sfLeft, sfTop, sfWidth, sfHeight, sfFont, sfDesignSize);
   TScrollBarStyle = (ssRegular, ssFlat, ssHotTrack);
  
   HWnd = THandle;

   UINT = LongWord;
   TConstraintSize = 0..MaxInt;
   TImeName = type string;
   TTabOrder = -1..32767;

   TControlActionLink = class;
   TDockTree = class;
   TDragDockObject = class;
   TDragObject = class;
   TSizeConstraints = class;
   TWinControl = class;

   TWinControlClass = class of TWinControl;
   TDockTreeClass = class of TDockTree;

   TCanResizeEvent = procedure(Sender: TObject; var NewWidth, NewHeight: Integer; var Resize: Boolean) of object;
   TContextPopupEvent = procedure(Sender: TObject; MousePos: TPoint; 
                                  var Handled: Boolean) of object;
   TConstrainedResizeEvent = procedure(Sender: TObject; var MinWidth, MinHeight, MaxWidth, MaxHeight: Integer) of object;
   TDockDropEvent = procedure(Sender: TObject; Source: TDragDockObject;  X, Y: Integer) of object;
   TDockOverEvent = procedure(Sender: TObject; Source: TDragDockObject; 
         X, Y: Integer; State: TDragState; var Accept: Boolean) of object;
   TDragDropEvent = procedure(Sender, Source: TObject; X, Y: Integer) of object;
   TDragOverEvent = procedure(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean) of object;
   TEndDragEvent = procedure(Sender, Target: TObject; X, Y: Integer) of object;
   TGetSiteInfoEvent = procedure(Sender: TObject; DockClient: TControl; var InfluenceRect: TRect; MousePos: TPoint; var CanDock: Boolean) of object;
   TMouseEvent = procedure (Sender: TObject; Button: TMouseButton; 
                            Shift: TShiftState; X, Y: Integer) of object;
   TMouseMoveEvent = procedure(Sender: TObject; Shift: TShiftState; X, Y: Integer) of object;
   TMouseEvent = procedure (Sender: TObject; Button: TMouseButton; 
                            Shift: TShiftState; X, Y: Integer) of object;
   TStartDragEvent = procedure (Sender: TObject; var DragObject: TDragObject) of object;
   TStartDockEvent = procedure(Sender: TObject; var DragObject: TDragDockObject) of object;
   TUnDockEvent = procedure(Sender: TObject; Client: TControl; NewTarget: TWinControl; var Allow: Boolean) of object;

   TKeyEvent = procedure (Sender: TObject; var Key: Word; Shift: TShiftState) of object;
   TMouseWheelEvent = procedure(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean) of object;
   TMouseWheelUpDownEvent = procedure(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean) of object;
   TKeyPressEvent = procedure (Sender: TObject; var Key: Char) of object;

   IDockManager = interface(IInterface)
   public
      procedure BeginUpdate;
      procedure EndUpdate;
      procedure GetControlBounds(Control: TControl; out CtlBounds: TRect);
      procedure InsertControl(Control: TControl; InsertAt: TAlign; 
                              DropCtl: TControl); virtual;
      procedure LoadFromStream(Stream: TStream); virtual;
      procedure PaintSite(DC: HDC); virtual;
      procedure PositionDockRect(Client, DropCtl: TControl; 
                                 DropAlign: TAlign; 
                                 var DockRect: TRect); virtual;
      procedure RemoveControl(Control: TControl) virtual;
      procedure ResetBounds(Force: Boolean); virtual;
      procedure SaveToStream(Stream: TStream); virtual;
      procedure SetReplacingControl(Control: TControl);
   end;

   TControl = class(TComponent)
   public
      property Action: TBasicAction;
      property Align: TAlign;
      property Anchors: TAnchors;
      property BiDiMode: TBiDiMode;
      property BoundsRect: TRect;
      property ClientHeight: Integer;
      property ClientOrigin: TPoint;
      property ClientRect: TRect;
      property ClientWidth: Integer;
      property Constraints: TSizeConstraints;
      property ControlState: TControlState;
      property ControlStyle: TControlStyle;
      property DockOrientation: TDockOrientation;
      property Enabled: Boolean;
      property Floating: Boolean;
      property FloatingDockSiteClass: TWinControlClass;
      property LRDockWidth: Integer;
      property Parent: TWinControl;
      property ShowHint: Boolean;
      property TBDockHeight: Integer;
      property UndockHeight: Integer;
      property UndockWidth: Integer;
      property Visible: Boolean;
      property WindowProc: TWndMethod;
published
      property Cursor: TCursor;
      property Height: Integer;
      property HelpContext: THelpContext;
      property HelpKeyword: String;
      property HelpType: THelpType;
      property Hint: string;
      property HostDockSite: TWinControl;
      property Left: Integer;
      property Name: TComponentName;
      property Top: Integer;
      property Width: Integer;
   protected
      property ActionLink: TControlActionLink;
      property AutoSize: Boolean;
      property Caption: TCaption;
      property Color: TColor;
      property DesktopFont: Boolean;
      property DragCursor: TCursor;
      property DragKind: TDragKind;
      property DragMode: TDragMode;
      property Font: TFont;
      property IsControl: Boolean;
      property MouseCapture: Boolean;
      property ParentBiDiMode: Boolean;
      property ParentColor: Boolean;
      property ParentFont: Boolean;
      property ParentShowHint: Boolean;
      property PopupMenu: TPopupMenu;
      property ScalingFlags: TScalingFlags;
      property Text: TCaption;
      property WindowText: PChar;
      property OnCanResize: TCanResizeEvent;
      property OnClick: TNotifyEvent;
      property OnConstrainedResize: TConstrainedResizeEvent;
      property OnContextPopup: TContextPopupEvent;
      property OnDblClick: TNotifyEvent;
      property OnDragDrop: TDragDropEvent;
      property OnDragOver: TDragOverEvent;
      property OnEndDock: TEndDragEvent;
      property OnEndDrag: TEndDragEvent;
      property OnMouseDown: TMouseEvent;
      property OnMouseMove: TMouseMoveEvent;
      property OnMouseUp: TMouseEvent;
      property OnMouseWheel: TMouseWheelEvent;
      property OnMouseWheelDown: TMouseWheelUpDownEvent;
      property OnMouseWheelUp: TMouseWheelUpDownEvent;
      property OnResize: TNotifyEvent;
      property OnStartDock: TStartDockEvent;
      property OnStartDrag: TStartDragEvent;
   end;

   TControlActionLink = class(TActionLink)
   protected
      procedure AssignClient(AClient: TObject); override;
      function DoShowHint(var HintStr: string): Boolean; virtual;
      function IsCaptionLinked: Boolean; override;
      function IsEnabledLinked: Boolean; override;
      function IsHelpLinked: Boolean; override;
      function IsHintLinked: Boolean; override;
      function IsOnExecuteLinked: Boolean; override;
      function IsVisibleLinked: Boolean; override;
      procedure SetCaption(const Value: string); override;
      procedure SetEnabled(Value: Boolean); override;
      procedure SetHelpContext(Value: THelpContext); override;
      procedure SetHelpKeyword(const Value: string); override;
      procedure SetHelpType(Value: THelpType); override;
      procedure SetHint(const Value: string); override;
      procedure SetOnExecute(Value: TNotifyEvent); override;
      procedure SetVisible(Value: Boolean); override;
   end;

   TControlCanvas = class(TCanvas)
   public
      property Clipped: Boolean;
      property Control: TControl;
      destructor Destroy; override;
      procedure FreeHandle;
      procedure StartPaint;
   end;

   TDockTree = class(TInterfacedObject)
   public
      constructor Create(DockSite: TWinControl); virtual;
      destructor Destroy; override;
      procedure PaintSite(DC: HDC); virtual;
   protected
      property DockSite: TWinControl;
      procedure AdjustDockRect(Control: TControl; var ARect: TRect); virtual;
      procedure BeginUpdate;
      procedure EndUpdate;
      procedure GetControlBounds(Control: TControl; out CtlBounds: TRect);
      function HitTest(const MousePos: TPoint; 
                       out HTFlag: Integer): TControl; virtual;
      procedure InsertControl(Control: TControl; InsertAt: TAlign; 
                              DropCtl: TControl); virtual;
      procedure LoadFromStream(Stream: TStream); virtual;
      procedure PaintDockFrame(Canvas: TCanvas; Control: TControl; 
                               const ARect: TRect); virtual;
      procedure PositionDockRect(Client, DropCtl: TControl; 
                                 DropAlign: TAlign; 
                                 var DockRect: TRect); virtual;
      procedure RemoveControl(Control: TControl); virtual;
      procedure ResetBounds(Force: Boolean); virtual;
      procedure SaveToStream(Stream: TStream); virtual;
      procedure SetReplacingControl(Control: TControl);
   end;


   TDragDockObjectEx = class(TDragDockObject)
   public
      procedure BeforeDestruction; override;
   end;

   TDragImageList = class(TCustomImageList)
   public
      property DragCursor: TCursor;
      property Dragging: Boolean;
      function BeginDrag(Window: HWND; X, Y: Integer): Boolean;
      function DragLock(Window: HWND; XPos, YPos: Integer): Boolean;
      function DragMove(X,Y: Integer): Boolean;
      procedure DragUnlock;
      function EndDrag: Boolean;
      function GetHotSpot: TPoint; override;
      procedure HideDragImage;
      function SetDragImage(Index, HotSpotX, HotSpotY: Integer): Boolean;
      procedure ShowDragImage;
   protected
      procedure Initialize; override;
   end;

   TDragObject = class(TObject)
   public
      property Cancelling: Boolean;
      property DragHandle: HWND;
      property DragPos: TPoint;
      property DragTarget: Pointer;
      property DragTargetPos: TPoint;
      property Dropped: Boolean;
      property MouseDeltaX: Double;
      property MouseDeltaY: Double;
      procedure Assign(Source: TDragObject); virtual;
      function GetName: string; virtual;
      procedure HideDragImage; virtual;
      function Instance: THandle; virtual;
   protected
      procedure Finished(Target: TObject; X, Y: Integer; Accepted: Boolean); virtual;
      function GetDragCursor(Accepted: Boolean; X, Y: Integer): TCursor; virtual;
      function GetDragImages: TDragImageList; virtual;
      procedure ShowDragImage; virtual;
   end;

   TBaseDragControlObject = class(TDragObject)
   public
      property Control: TControl;
      procedure Assign(Source: TDragObject); override;
      constructor Create(AControl: TControl); virtual;
   protected
      procedure EndDrag(Target: TObject; X, Y: Integer); virtual;
      procedure Finished(Target: TObject; X, Y: Integer; Accepted: Boolean); override;
   end;

   
   TDragDockObject = class(TBaseDragControlObject)
   public
      property Brush: TBrush;
      property DockRect: TRect;
      property DropAlign: TAlign;
      property DropOnControl: TControl;
      property Floating: Boolean;
      property FrameWidth: Integer;
      procedure AdjustDockRect(ARect: TRect); virtual;
      procedure Assign(Source: TDragObject); override;
      constructor Create(AControl: TControl); override;
      destructor Destroy; override;
   protected
      procedure DrawDragDockImage; virtual;
      procedure EndDrag(Target: TObject; X, Y: Integer); override;
      procedure EraseDragDockImage; virtual;
      function GetDragCursor(Accepted: Boolean; X, Y: Integer): TCursor; override;
      function GetFrameWidth: Integer; virtual;
   end;

   TDragControlObject = class(TBaseDragControlObject)
   public
      procedure HideDragImage; override;
      procedure ShowDragImage; override;
   protected
      function GetDragCursor(Accepted: Boolean; X, Y: Integer): TCursor; override;
      function GetDragImages: TDragImageList; override;
   end;

   TDragControlObjectEx = class(TDragControlObject)
   public
      procedure BeforeDestruction; override;
   end;

   TDragObjectEx = class(TDragObject)
   public
      procedure BeforeDestruction; override;
   end;

   TGraphicControl = class(TControl)
   public
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
   protected
      property Canvas: TCanvas;
      procedure Paint; virtual;
   end;

   TImageList = class(TDragImageList)
   end;

   TMouse = class(TObject)
   public
      property Capture: HWND;
      property CursorPos: TPoint;
      property DragImmediate: Boolean;
      property DragThreshold: Integer;
      property IsDragging: Boolean;
      property MousePresent: Boolean;
      property RegWheelMessage: UINT;
      property WheelPresent: Boolean;
      property WheelScrollLines: Integer;
      constructor Create;
      destructor Destroy; override;
      procedure SettingChanged(Setting: Integer);
   end;

   TSizeConstraints = class(TPersistent)
   public
      constructor Create(Control: TControl); virtual;
      property OnChange: TNotifyEvent;
   published
      property MaxHeight: TConstraintSize;
      property MaxWidth: TConstraintSize;
      property MinHeight: TConstraintSize;
      property MinWidth: TConstraintSize;
   protected
      property Control: TControl;
      procedure AssignTo(Dest: TPersistent); override;
      procedure Change; dynamic;
   end;

   TWinControl = class(TControl)
   public
      property AlignDisabled: Boolean;
      property Brush: TBrush;
      property ClientOrigin: TPoint;
      property ClientRect: TRect;
      property ControlCount: Integer;
      property Controls[Index: Integer]: TControl;
      property DockClientCount: Integer;
      property DockClients[Index: Integer]: TControl;
      property DoubleBuffered: Boolean;
      property Handle: HWND;
      property ParentWindow: HWnd;
      property Showing: Boolean;
      property TabOrder: TTabOrder;
      property TabStop: Boolean;
      property VisibleDockClientCount: Integer;
      procedure Broadcast(var Message);
      function CanFocus: Boolean; dynamic;
      function ContainsControl(Control: TControl): Boolean;
      function ControlAtPos(const Pos: TPoint; 
                            AllowDisabled: Boolean;
                            AllowWinControls:Boolean=False): TControl;
      constructor Create(AOwner: TComponent); override;
      constructor CreateParented(ParentWindow: HWnd);
      class function CreateParentedControl(ParentWindow: HWnd): TWinControl;
      procedure DefaultHandler(var Message); virtual;
      destructor Destroy; override;
      procedure DisableAlign;
      procedure DockDrop(Source: TDragDockObject; X, Y: Integer); dynamic;
      procedure EnableAlign;
      function FindChildControl(const ControlName: string): TControl;
      procedure FlipChildren(AllLevels: Boolean); dynamic;
      function Focused: Boolean; dynamic;
      procedure GetTabOrderList(List: TList);
      function HandleAllocated: Boolean;
      procedure HandleNeeded;
      procedure InsertControl(AControl: TControl);
      procedure Invalidate; override;
      procedure PaintTo(DC: HDC; X, Y: Integer);
      procedure Realign;
      procedure RemoveControl(AControl: TControl);
      procedure Repaint; override;
      procedure ScaleBy(M, D: Integer);
      procedure ScrollBy(DeltaX, DeltaY: Integer);
      procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
      procedure SetFocus; virtual;
      procedure Update; override;
      procedure UpdateControlState;
   protected   
      property BevelEdges: TBevelEdges;
      property BevelInner: TBevelCut;
      property BevelKind: TBevelKind;
      property BevelOuter: TBevelCut;
      property BevelWidth: TBevelWidth;
      property BorderWidth: TBorderWidth;
      property Ctl3D: Boolean;
      property DefWndProc: Pointer;
      property DockManager: IDockManager;
      property DockSite: Boolean;
      property ImeMode: TImeMode;
      property ImeName: TImeName;
      property ParentCtl3D: Boolean;
      property ParentBackground: Boolean;
      property UseDockManager: Boolean;
      property WindowHandle: Hwnd;
      procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;
      procedure AddBiDiModeExStyle(var ExStyle: DWORD);
      procedure AdjustClientRect(var Rect: TRect); virtual;
      procedure AdjustSize; override;
      procedure AlignControls(AControl: TControl; var Rect: TRect); virtual;
      procedure AssignTo(Dest: TPersistent); override;
      function CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;
      function CanResize(var NewWidth, NewHeight: Integer): Boolean; override;
      procedure ChangeScale(M, D: Integer); override;
      procedure ConstrainedResize(var MinWidth, MinHeight, MaxWidth, MaxHeight: Integer); override;
      function CreateDockManager: IDockManager; dynamic;
      procedure CreateHandle; virtual;
      procedure CreateParams(var Params: TCreateParams); virtual;
      procedure CreateSubClass(var Params: TCreateParams; ControlClassName: PChar);
      procedure CreateWindowHandle(const Params: TCreateParams); virtual;
      procedure CreateWnd; virtual;
      function CustomAlignInsertBefore(C1, C2: TControl): Boolean; virtual;
      procedure CustomAlignPosition(Control: TControl; var NewLeft, NewTop, NewWidth,
          NewHeight: Integer; var AlignRect: TRect); virtual;
      procedure DestroyHandle;
      procedure DestroyWindowHandle; virtual;
      procedure DestroyWnd; virtual;
      procedure DoAddDockClient(Client: TControl; const ARect: TRect); dynamic;
      procedure DockOver(Source: TDragDockObject; X, Y: Integer; State: TDragState; var Accept: Boolean); dynamic;
      procedure DoDockOver(Source: TDragDockObject; X, Y: Integer; State: TDragState; var Accept: Boolean); dynamic;
      procedure DoEnter; dynamic;
      procedure DoExit; dynamic;
      procedure DoFlipChildren; dynamic;
      function DoKeyDown(var Message: TWMKey): Boolean;
      function DoKeyPress(var Message: TWMKey): Boolean;
      function DoKeyUp(var Message: TWMKey): Boolean;
      procedure DoRemoveDockClient(Client: TControl); dynamic;
      function DoUnDock(NewTarget: TWinControl; Client: TControl): Boolean; dynamic;
      function FindNextControl(CurControl: TWinControl; GoForward, CheckTabStop, CheckParent: Boolean): TWinControl;
      procedure FixupTabList;
      function GetActionLinkClass: TControlActionLinkClass; override;
      procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
      function GetClientOrigin: TPoint; override;
      function GetClientRect: TRect; override;
      function GetControlExtents: TRect; virtual;
      function GetDeviceContext(var WindowHandle: HWnd): HDC; override;
      function GetParentHandle: HWnd;
      procedure GetSiteInfo(Client: TControl; var InfluenceRect: TRect; MousePos: TPoint; var CanDock: Boolean); dynamic;
      function GetTopParentHandle: HWnd;
      function IsControlMouseMsg(var Message: TWMMouse): Boolean;
      procedure KeyDown(var Key: Word; Shift: TShiftState); dynamic;
      procedure KeyPress(var Key: Char); dynamic;
      procedure KeyUp(var Key: Word; Shift: TShiftState); dynamic;
      procedure MainWndProc(var Message: TMessage);
      procedure NotifyControls(Msg: Word);
      procedure PaintControls(DC: HDC; First: TControl);
      procedure PaintHandler(var Message: TWMPaint);
      procedure PaintWindow(DC: HDC); virtual;
      function PaletteChanged(Foreground: Boolean): Boolean; dynamic;
      procedure ReadState(Reader: TReader); override;
      procedure RecreateWnd;
      procedure ReloadDockedControl(const AControlName: string; var AControl: TControl); dynamic;
      procedure ResetIme;
      function ResetImeComposition(Action: DWORD): Boolean;
      procedure ScaleControls(M, D: Integer);
      procedure SelectFirst;
      procedure SelectNext(CurControl: TWinControl; GoForward, CheckTabStop: Boolean);
      procedure SetChildOrder(Child: TComponent; Order: Integer); override;
      procedure SetIme;
      function SetImeCompositionWindow( Font: TFont; XPos, YPos: Integer): Boolean;
      procedure SetZOrder(TopMost: Boolean); override;
      procedure ShowControl(AControl: TControl); virtual;
      procedure UpdateUIState(CharCode: Word);
      procedure WndProc(var Message: TMessage); override;
      property OnDockDrop: TDockDropEvent;
      property OnDockOver: TDockOverEvent;
      property OnEnter: TNotifyEvent;
      property OnExit: TNotifyEvent;
      property OnGetSiteInfo: TGetSiteInfoEvent;
      property OnKeyDown: TKeyEvent;
      property OnKeyPress: TKeyPressEvent;
      property OnKeyUp: TKeyEvent;
      property OnUnDock: TUnDockEvent;
   end;


   TCustomListControl = class(TWinControl)
   public
      property ItemIndex: Integer;
      procedure AddItem(Item: String; AObject: TObject); virtual; abstract;
      procedure Clear; virtual; abstract;
      procedure ClearSelection; virtual; abstract;
      procedure CopySelection(Destination: TCustomListControl); virtual; abstract;
      procedure DeleteSelected; virtual; abstract;
      procedure MoveSelection(Destination: TCustomListControl); virtual;
      procedure SelectAll; virtual; abstract;
   protected
      function GetCount: Integer; virtual; abstract;
      function GetItemIndex: Integer; virtual; abstract;
      procedure SetItemIndex(const Value: Integer); overload; virtual; abstract;
   end;

   TCustomMultiSelectListControl = class(TCustomListControl)
   public
      property MultiSelect: Boolean;
      property SelCount: Integer;
   protected
      function GetSelCount: Integer; virtual; abstract;
      procedure SetMultiSelect(Value: Boolean); virtual; abstract;
   end;



   TCustomControl = class(TWinControl)
   public
      property Canvas: TCanvas;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
   protected
      procedure Paint; virtual;
      procedure PaintWindow(DC: HDC); override;
   end;


   THintWindow = class(TCustomControl)
   public
      procedure ActivateHint(Rect: TRect; const AHint: string); virtual;
      procedure ActivateHintData(Rect: TRect; const AHint: string; AData: Pointer); virtual;
      function CalcHintRect(MaxWidth: Integer; const AHint: string; AData: Pointer): TRect; virtual;
      constructor Create(AOwner: TComponent); override;
      function IsHintMsg(var Msg: TMsg): Boolean; virtual;
      procedure ReleaseHandle;
   end;

   TWinControlActionLink = class(TControlActionLink)
   protected
      procedure AssignClient(AClient: TObject); override;
      function IsHelpContextLinked: Boolean; override;
      procedure SetHelpContext(Value: THelpContext); override;
   end;

var
  DefaultDockTreeClass: TDockTreeClass = TDockTree;
  NewStyleControls: Boolean;


procedure CancelDrag;
function FindVCLWindow(const Pos: TPoint): TWinControl;
function IsAbortResult(const AModalResult: TModalResult): Boolean;
function IsAnAllResult(const AModalResult: TModalResult): Boolean;
function IsDragObject(Sender: TObject): Boolean;
function IsNegativeResult(const AModalResult: TModalResult): Boolean;
function IsPositiveResult(const AModalResult: TModalResult): Boolean;
procedure MoveWindowOrg(DC: HDC; DX, DY: Integer);
function SendAppMessage(Msg: Cardinal; WParam, LParam: Longint): Longint;
function StripAllFromResult(const AModalResult: TModalResult): TModalResult;

implementation
end.







