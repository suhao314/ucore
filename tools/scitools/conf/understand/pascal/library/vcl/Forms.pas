unit Forms;
interface
   uses Windows, Messages, SysUtils, Types, Menus, HelpIntfs, OleCtnrs,
      Controls, Classes, Graphics, Actnlist;
type 
   TActiveFormBorderStyle = (afbNone, afbSingle, afbSunken, afbRaised);
   TBorderIcon = (biSystemMenu, biMinimize, biMaximize, biHelp);
   TBorderIcons = set of TBorderIcon;
   TCloseAction = (caNone, caHide, caFree, caMinimize);
   TDefaultMonitor = (dmDesktop, dmPrimary, dmMainForm, dmActiveForm);
   TFormBorderStyle = (bsNone, bsSingle, bsSizeable, bsDialog, bsToolWindow, bsSizeToolWin);
   TBorderStyle = bsNone..bsSingle;
   TFormState = set of (fsCreating, fsVisible, fsShowing, fsModal, fsCreatedMDIChild, fsActivated);
   TFormStyle = (fsNormal, fsMDIChild, fsMDIForm, fsStayOnTop);
   TIdleEvent = procedure (Sender: TObject; var Done: Boolean) of object;
   TMonitorDefaultTo = (mdNearest, mdNull, mdPrimary);
   TPosition = (poDesigned, poDefault, poDefaultPosOnly, poDefaultSizeOnly, poScreenCenter, poDesktopCenter, poMainFormCenter, poOwnerFormCenter);
   TPrintScale = (poNone, poProportional, poPrintToFit);
   TScrollBarInc = 1..32767;
   TScrollBarKind = (sbHorizontal, sbVertical);
   TScrollCode = (scLineUp, scLineDown, scPageUp, scPageDown, scPosition, scTrack, scTop, scBottom, scEndScroll);
   TTileMode = (tbHorizontal, tbVertical);
   TWindowState = (wsNormal, wsMinimized, wsMaximized);

   TMonitor = class;

   THintWindowClass = class of THintWindow;
   THintInfo = record
      HintControl: TControl;
      HintWindowClass: THintWindowClass;
      HintPos: TPoint;
      HintMaxWidth: Integer;
      HintColor: TColor;
      CursorRect: TRect;
      CursorPos: TPoint;
      ReshowTimeout: Integer;
      HideTimeout: Integer;
      HintStr: string;
      HintData: Pointer;
   end;

const
   //  tbd - these values are made up
   MB_ABORTRETRYIGNORE = 1;
   MB_OK = 2;
   MB_OKCANCEL = 3;
   MB_RETRYCANCEL = 4;
   MB_YESNO = 5;
   MB_YESNOCANCEL = 6;

   IDOK = 1;
   IDCANCEL = 2;
   IDABORT = 3;
   IDRETRY = 4;
   IDIGNORE = 5;
   IDYES = 6;
   IDNO = 7;

type

   HCursor = THandle;
   HKL = THandle;
   HMonitor = THandle;
   HResult = Longint;
   HWnd = THandle;

   TCustomForm = class;
   TForm = class;
   TScrollingWinControl = class;

   TFormClass = class of TForm;

   TCloseEvent = procedure(Sender: TObject; var Action: TCloseAction) of object;
   TCloseQueryEvent = procedure(Sender: TObject; var CanClose: Boolean) of object;
   TExceptionEvent = procedure (Sender: TObject; E: Exception) of object;
   THelpEvent = function (Command: Word; Data: Longint; var CallHelp: Boolean): Boolean of object;
   TMessageEvent = procedure (var Msg: TMsg; var Handled: Boolean) of object;
   TSettingChangeEvent = procedure (Sender: TObject; Flag: Integer; const Section: string; var Result: Longint) of object;
   TShortCutEvent = procedure (var Msg: TWMKey; var Handled: Boolean) of object;
   TShowHintEvent = procedure (var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo) of object;
   TWindowHook = function(var Message: TMessage): Boolean of object;

   IDesignerHook = interface(IDesignerNotify)
      property Form: TCustomForm;
      property IsControl: Boolean;
      function GetCustomForm: TCustomForm;
      function GetIsControl: Boolean;
      function GetRoot: TComponent;
      function IsDesignMsg(Sender: TControl; var Message: TMessage): Boolean;
      procedure PaintGrid;
      procedure SetCustomForm(Value: TCustomForm);
      procedure SetIsControl(Value: Boolean);
      function UniqueName(const BaseName: string): string;
      procedure ValidateRename(AComponent: TComponent; const CurName, NewName: string);
   end;

   TApplication = class(TComponent)
   public
      property Active: Boolean;
      property AllowTesting: Boolean;
      property AutoDragDocking: Boolean;
      property BiDiKeyboard: string;
      property BiDiMode: TBiDiMode;
      property CurrentHelpFile: string;
      property DialogHandle: HWnd;
      property ExeName: string;
      property Handle: HWND;
      property HelpFile: string;
      property HelpSystem: IHelpSystem;
      property Hint: string;
      property HintColor: TColor;
      property HintHidePause: Integer;
      property HintPause: Integer;
      property HintShortCuts: Boolean;
      property HintShortPause: Integer;
      property Icon: TIcon;
      property MainForm: TForm;
      property NonBiDiKeyboard: string;
      property ShowHint: Boolean;
      property ShowMainForm: Boolean;
      property Terminated: Boolean;
      property Title: string;
      property UpdateFormatSettings: Boolean;
      property UpdateMetricSettings: Boolean;
      procedure ActivateHint(CursorPos: TPoint);
      procedure BringToFront;
      procedure CancelHint;
      procedure ControlDestroyed(Control: TControl);
      constructor Create(AOwner: TComponent); override;
      procedure CreateForm(FormClass: TFormClass; var Reference);
      procedure CreateHandle;
      destructor Destroy; override;
      function ExecuteAction(Action: TBasicAction): Boolean; reintroduce;
      procedure HandleException(Sender: TObject);
      procedure HandleMessage;
      function HelpCommand(Command: Word; Data: Longint): Boolean;
      function HelpContext(Context: THelpContext): Boolean;
      function HelpJump(const JumpID: string): Boolean;
      function HelpKeyword(const Keyword: string): Boolean;
      procedure HideHint;
      procedure HintMouseMessage(Control: TControl; var Message: TMessage);
      procedure HookMainWindow(Hook: TWindowHook);
      procedure HookSynchronizeWakeup;
      procedure Initialize;
      function IsRightToLeft: Boolean;
      function MessageBox(const Text, Caption: PChar; Flags: Longint = MB_OK): Integer;
      procedure Minimize;
      procedure ModalFinished;
      procedure ModalStarted;
      procedure NormalizeAllTopMosts;
      procedure NormalizeTopMosts;
      procedure ProcessMessages;
      procedure Restore;
      procedure RestoreTopMosts;
      procedure Run;
      procedure ShowException(E: Exception);
      procedure Terminate;
      procedure UnhookMainWindow(Hook: TWindowHook);
      procedure UnhookSynchronizeWakeup;
      function UpdateAction(Action: TBasicAction): Boolean; reintroduce;
      function UseRightToLeftAlignment: Boolean;
      function UseRightToLeftReading: Boolean;
      function UseRightToLeftScrollBar: Boolean;
      property OnActionExecute: TActionEvent;
      property OnActionUpdate: TActionEvent;
      property OnActivate: TNotifyEvent;
      property OnDeactivate: TNotifyEvent;
      property OnException: TExceptionEvent;
      property OnHelp: THelpEvent;
      property OnHint: TNotifyEvent;
      property OnIdle: TIdleEvent;
      property OnMessage: TMessageEvent;
      property OnMinimize: TNotifyEvent;
      property OnModalBegin: TNotifyEvent;
      property OnModalEnd: TNotifyEvent;
      property OnRestore: TNotifyEvent;
      property OnSettingChange: TSettingChangeEvent;
      property OnShortCut: TShortCutEvent;
      property OnShowHint: TShowHintEvent;
   end;

   TControlScrollBar = class(TPersistent)
   public
      property Kind: TScrollBarKind;
      property ScrollPos: Integer;
      procedure Assign(Source: TPersistent); override;
      procedure ChangeBiDiPosition;
      constructor Create(AControl: TScrollingWinControl; AKind: TScrollBarKind);
      function IsScrollBarVisible: Boolean;
   published
      property ButtonSize: Integer
      property Color: TColor
      property Increment: TScrollBarInc;
      property Margin: Word;
      property ParentColor: Boolean;
      property Position: Integer;
      property Range: Integer;
      property Size: Integer
      property Smooth: Boolean;
      property Style: TScrollBarStyle;
      property ThumbSize: Integer
      property Tracking: Boolean;
      property Visible: Boolean;
   end;

   TScrollingWinControl = class(TWinControl)
   public
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      procedure DisableAutoRange;
      procedure EnableAutoRange;
      procedure ScrollInView(AControl: TControl)
   published
      property HorzScrollBar: TControlScrollBar;
      property VertScrollBar: TControlScrollBar;
   protected
      property AutoScroll: Boolean;
      procedure AdjustClientRect(var Rect: TRect); override;
      procedure AlignControls(AControl: TControl; var ARect: TRect); override;
      function AutoScrollEnabled: Boolean; virtual;
      procedure AutoScrollInView(AControl: TControl); virtual;
      procedure ChangeScale(M, D: Integer); override;
      procedure CreateParams(var Params: TCreateParams); override;
      procedure CreateWnd; override;
      procedure DoFlipChildren; override;
      procedure Resizing(State: TWindowState); virtual;
   end;


   TCustomForm = class(TScrollingWinControl)
   public
      property Active: Boolean;
      property ActiveControl: TWinControl;
      property ActiveOLEControl: TWinControl;
      property BorderStyle: TFormBorderStyle;
      property Canvas: TCanvas;
      property ClientRect: TRect;
      property DesignerHook: IDesignerHook;
      property DropTarget: Boolean;
      property Floating: Boolean;
      property FormState: TFormState;
      property HelpFile: string;
      property KeyPreview: Boolean;
      property Menu: TMainMenu;
      property ModalResult: TModalResult;
      property Monitor: TMonitor;
      property OleFormObject: IOleForm;
      property Parent: TWinControl;
      property WindowState: TWindowState;
      procedure AfterConstruction; override;
      procedure BeforeDestruction; override;
      procedure Close;
      function CloseQuery: Boolean; virtual;
      constructor CreateNew(AOwner: TComponent; Dummy: Integer = 0); virtual;
      procedure DefocusControl(Control: TWinControl; Removing: Boolean);
      destructor Destroy; override;
      procedure Dock(NewDockSite: TWinControl; ARect: TRect); override;
      procedure FocusControl(Control: TWinControl);
      function GetFormImage: TBitmap;
      procedure Hide;
      function IsShortCut(var Message: TWMKey): Boolean; dynamic;
      procedure MakeFullyVisible(AMonitor: TMonitor = nil);
      procedure MouseWheelHandler(var Message: TMessage); override;
      procedure Print; virtual;
      procedure Release;
      procedure SendCancelMode(Sender: TControl);
      procedure SetFocus; override
      function SetFocusedControl(Control: TWinControl): Boolean; virtual;
      procedure Show;
      function ShowModal: Integer; virtual;
      function WantChildKey(Child: TControl; var Message: TMessage): Boolean; virtual;
   protected
      property ActiveMDIChild: TForm;
      property AlphaBlend: Boolean;
      property AlphaBlendValue: Byte;
      property BorderIcons:TBorderIcons;
      property ClientHandle: HWND;
      property ClientHeight: Integer;
      property ClientWidth: Integer;
      property DefaultMonitor: TDefaultMonitor;
      property FormStyle: TFormStyle;
      property Icon: TIcon;
      property MDIChildCount: Integer;
      property MDIChildren[I: Integer]: TForm;
      property ObjectMenuItem: TMenuItem;
      property OldCreateOrder: Boolean;
      property ParentBiDiMode: Boolean;
      property PixelsPerInch: Integer;
      property Position: TPosition;
      property PrintScale: TPrintScale;
      property Scaled: Boolean;
      property ScreenSnap: Boolean;
      property SnapBuffer: Integer;
      property TileMode: TTileMode;
      property TransparentColor: Boolean;
      property TransparentColorValue: TColor;
      property Visible: Boolean;
      property WindowMenu: TMenuItem;
      property OnActivate: TNotifyEvent;
      property OnClose: TCloseEvent;
      property OnCloseQuery: TCloseQueryEvent;
      property OnCreate: TNotifyEvent;
      property OnDeactivate: TNotifyEvent;
      property OnDestroy: TNotifyEvent;
      property OnHelp: THelpEvent;
      property OnHide: TNotifyEvent;
      property OnPaint: TNotifyEvent;
      property OnShortCut: TShortCutEvent;
      property OnShow: TNotifyEvent;
      procedure Activate; dynamic;
      procedure ActiveChanged; dynamic;
      procedure AlignControls(AControl: TControl; var ARect: TRect); override;
      procedure BeginAutoDrag; override;
      procedure ChangeScale(M, D: Integer); override;
      procedure CreateParams(var Params: TCreateParams); override;
      procedure CreateWindowHandle(const Params: TCreateParams); override;
      procedure CreateWnd; override;
      procedure Deactivate; dynamic;
      procedure DefaultHandler(var Message); override;
      procedure DefineProperties(Filer: TFiler); override;
      procedure DestroyWindowHandle; override;
      procedure DoClose(var Action: TCloseAction); dynamic;
      procedure DoCreate; virtual;
      procedure DoDestroy; virtual;
      procedure DoDock(NewDockSite: TWinControl; var ARect: TRect); override;
      procedure DoHide; dynamic;
      procedure DoShow; dynamic;
      procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
      function GetClientRect: TRect; override;
      function GetFloating: Boolean; override;
      function HandleCreateException: Boolean; dynamic;
      procedure Loaded; override;
      procedure Notification(AComponent: TComponent; Operation: TOperation); override;
      procedure Paint; dynamic;
      procedure PaintWindow(DC: HDC); override;
      function PaletteChanged(Foreground: Boolean): Boolean; override;
      function QueryInterface(const IID: TGUID; out Obj): HResult; override;
      procedure ReadState(Reader: TReader); override;
      procedure RequestAlign; override;
      procedure Resizing(State: TWindowState); override;
      procedure SetChildOrder(Child: TComponent; Order: Integer); override;
      procedure SetParent(AParent: TWinControl); override;
      procedure SetParentBiDiMode(Value: Boolean); override;
      procedure UpdateActions; virtual;
      procedure UpdateWindowState;
      procedure ValidateRename(AComponent: TComponent; const CurName, NewName: string); override;
      procedure VisibleChanging; override;
      procedure WndProc(var Message: TMessage); override;
   end;

   TCustomActiveForm = class(TCustomForm)
   public
      constructor Create(AOwner: TComponent); override;
      function WantChildKey(Child: TControl; var Message: TMessage): Boolean; override;
   published
      property AxBorderStyle: TActiveFormBorderStyle;
   protected
      procedure CreateParams(var Params: TCreateParams); override;
   end;

   TCustomDockForm = class(TCustomForm)
   public
      constructor Create(AOwner: TComponent); override;
   protected
      procedure DoAddDockClient(Client: TControl; const ARect: TRect); override;
      procedure DoRemoveDockClient(Client: TControl); override;
      procedure GetSiteInfo(Client: TControl; var InfluenceRect: TRect; 
                            MousePos: TPoint; var CanDock: Boolean); override;
      procedure Loaded; override;
   end;

   TMonitor = class(TObject)
   public
      property BoundsRect: TRect;
      property Handle: HMONITOR;
      property Height: Integer;
      property Left: Integer;
      property MonitorNum: Integer;
      property Primary: Boolean;
      property Top: Integer;
      property Width: Integer;
      property WorkareaRect: TRect;
   end;

   TScreen = class(TComponent)
   public
      property ActiveControl: TWinControl;
      property ActiveCustomForm: TCustomForm;
      property ActiveForm: TForm;
      property Cursor: TCursor;
      property Cursors[Index: Integer]: HCursor;
      property CustomFormCount: Integer;
      property CustomForms[Index: Integer]: TCustomForm;
      property DataModuleCount: Integer;
      property DataModules[Index: Integer]: TDataModule;
      property DefaultIme: string;
      property DefaultKbLayout: HKL;
      property DesktopHeight: Integer;
      property DesktopLeft: Integer;
      property DesktopRect: TRect;
      property DesktopTop: Integer;
      property DesktopWidth: Integer;
      property Fonts: TStrings;
      property FormCount: Integer;
      property Forms[Index: Integer]: TForm;
      property Height: Integer;
      property HintFont: TFont;
      property IconFont: TFont;
      property Imes: TStrings;
      property MenuFont: TFont;
      property MonitorCount: Integer;
      property Monitors[Index: Integer]: TMonitor;
      property PixelsPerInch: Integer;
      property Width: Integer;
      property WorkAreaHeight: Integer;
      property WorkAreaLeft: Integer;
      property WorkAreaRect: TRect;
      property WorkAreaTop: Integer;
      property WorkAreaWidth: Integer;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      procedure DisableAlign;
      procedure EnableAlign;
      function MonitorFromPoint(const Point: TPoint; MonitorDefault: TMonitorDefaultTo = mdNearest): TMonitor;
      function MonitorFromRect(const Rect: TRect; MonitorDefault: TMonitorDefaultTo = mdNearest): TMonitor;
      function MonitorFromWindow(const Handle: THandle; MonitorDefault: TMonitorDefaultTo = mdNearest): TMonitor;
      procedure Realign;
      procedure ResetFonts;
      property OnActiveControlChange: TNotifyEvent;
      property OnActiveFormChange: TNotifyEvent;
   end;


   TScrollBox = class(TScrollingWinControl)
   public
      constructor Create(AOwner: TComponent);
   published
      property BorderStyle: TBorderStyle;
   end;

   TCustomFrame = class(TScrollingWinControl)
   public
      property Parent: TWinControl;
      constructor Create(AOwner: TComponent); override;
   protected
      procedure CreateParams(var Params: TCreateParams); override;
      procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
      procedure Notification(AComponent: TComponent; Operation: TOperation); override;
      procedure SetParent(AParent: TWinControl); override;
   end;

   TFrame = class(TCustomFrame)
   end;


   TForm = class(TCustomForm)
   public
      procedure ArrangeIcons;
      procedure Cascade;
      procedure Next;
      procedure Previous;
      procedure Tile;
   end;

function ForegroundTask: Boolean;

implementation
end.







