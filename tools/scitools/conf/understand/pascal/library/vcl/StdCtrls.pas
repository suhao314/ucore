unit StdCtrls;
interface
   uses Windows, Types, Controls, ComCtrls, Messages, Classes,
            Dialogs, Forms, Graphics;
type
   TCheckBoxState = (cbUnchecked, cbChecked, cbGrayed);
   TComboBoxExStyleEx = (csExCaseSensitive, csExNoEditImage, csExNoEditImageIndent, csExNoSizeLimit, csExPathWordBreak);
   TComboBoxExStyles = set of TComboBoxExStyleEx;
   TComboBoxExStyle = (csExDropDown, csExSimple, csExDropDownList);
   TComboBoxStyle = (csDropDown, csDropDownList, csOwnerDrawFixed, csOwnerDrawVariable);
   TEditCharCase = (ecNormal, ecUpperCase, ecLowerCase);
   TListBoxStyle = (lbStandard, lbOwnerDrawFixed, lbOwnerDrawVariable, lbVirtual, lbVirtualOwnerDraw);
   TScrollStyle = (ssNone, ssHorizontal, ssVertical, ssBoth);
   TStaticBorderStyle = (sbsNone, sbsSingle, sbsSunken);
   TTextLayout = (tlTop, tlCenter, tlBottom);

   TDrawItemEvent = procedure(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState) of object;
   TKeyEvent = procedure (Sender: TObject; var Key: Word; Shift: TShiftState) of object;
   TKeyEvent = procedure (Sender: TObject; var Key: Word; Shift: TShiftState) of object;
   TLBGetDataEvent = procedure(Control: TWinControl; Index: Integer; var Data: String) of object;
   TLBGetDataObjectEvent = procedure(Control: TWinControl; Index: Integer; var DataObject: TObject ) of object;
   TKeyPressEvent = procedure (Sender: TObject; var Key: Char) of object;
   TLBFindDataEvent = function(Control: TWinControl; FindString: String): Integer of object;
   TMeasureItemEvent = procedure(Control: TWinControl; Index: Integer; var Height: Integer) of object;
   TScrollEvent = procedure(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer) of object;

   TCustomComboBoxStrings = class;
   TCustomComboBoxStringsClass = class of TCustomComboBoxStrings;

   TButtonControl = class(TWinControl)
   public
      constructor Create(AOwner: TComponent); override;
   protected
      property Checked: Boolean;
      property ClicksDisabled: Boolean;
      property WordWrap: Boolean;
      procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;
      function GetActionLinkClass: TControlActionLinkClass; override;
      function GetChecked: Boolean; virtual;
      procedure SetChecked(Value: Boolean); virtual;
      procedure WndProc(var Message: TMessage); override;
   end;

   TButton = class(TButtonControl)
   public
      procedure Click; override;
      constructor Create(AOwner: TComponent); override;
      function UseRightToLeftAlignment: Boolean; override;
   published
      property Cancel: Boolean;
      property Default: Boolean;
      property ModalResult: TModalResult;
      property ToggleButton: Boolean;
      property OnEnter: TNotifyEvent;
      property OnExit: TNotifyEvent;
      property OnKeyDown: TKeyEvent;
      property OnKeyPress: TKeyPressEvent;
      property OnKeyUp: TKeyEvent;
   end;

   TButtonActionLink = class(TWinControlActionLink) 
   protected
      procedure AssignClient(AClient: TObject); override;
      function IsCheckedLinked: Boolean; override;
      procedure SetChecked(Value: Boolean); override;
   end;

   TCustomCheckBox = class(TButtonControl)
   public
      constructor Create(AOwner: TComponent); override;
   protected
      property Alignment: TLeftRight;
      property AllowGrayed: Boolean;
      property Checked: Boolean;
      property State: TCheckBoxState;
      procedure Click; override;
      procedure CreateParams(var Params: TCreateParams); override;
      procedure CreateWnd; override;
      function GetChecked: Boolean; override;
      function GetControlsAlignment: TAlignment; override;
      function SetChecked: Boolean; override;
      procedure Toggle; virtual;
   end;

   TCheckBox = class(TCustomCheckBox)
   end;

   TCustomCombo = class(TCustomListControl)
   public
      property Canvas: TCanvas;
      property DroppedDown: Boolean;
      property ItemIndex: Integer;
      property Items: TStrings;
      property SelLength: Integer;
      property SelStart: Integer;
      procedure AddItem(Item: String; AObject: TObject);
      procedure Clear; override;
      procedure ClearSelection; override
      procedure CopySelection (Destination: TCustomListControl); override;
      constructor Create(AOwner: TComponent); override;
      procedure DeleteSelected; override
      destructor Destroy; override;
      function Focused: Boolean; override;
   protected
      property DropDownCount: Integer;
      property EditHandle: HWnd;
      property ItemCount: Integer;
      property ItemHeight: Integer;
      property ListHandle: HWND;
      property MaxLength: Integer;
      procedure AdjustDropDown; virtual;
      procedure Change; dynamic;
      procedure CloseUp; dynamic;
      procedure ComboWndProc(var Message: TMessage; ComboWnd: HWnd; 
                             ComboProc: pointer); virtual;
      procedure CreateWnd; override;
      procedure DestroyWindowHandle; dynamic;
      procedure DropDown; dynamic;
      procedure EditWndProc(var Message: TMessage);
      function GetCount: Integer; override;
      property OnChange: TNotifyEvent;
      property OnCloseUp: TNotifyEvent;
      property OnDropDown: TNotifyEvent;
      property OnSelect: TNotifyEvent;
   end;

   TCustomComboBox = class(TCustomCombo)
   public
      property AutoCloseUp: Boolean;
      property AutoComplete: Boolean;
      property AutoDropDown: Boolean;
      property CharCase: TEditCharCase;
      property SelText: string;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
   protected
      property ItemHeight: Integer;
      property Sorted: Boolean;
      property Style: TComboBoxStyle;
      procedure CreateParams(var Params: TCreateParams); override;
      procedure CreateWnd; override;
      procedure DestroyWnd; override;
      procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); virtual;
      function GetItemCount: Integer; override;
      function GetItemHt: Integer; override;
      function GetItemsClass: TCustomComboBoxStringsClass; override;
      function GetSelText: string;
      procedure KeyPress (var Key: Char); override;
      procedure MeasureItem(Index: Integer; var Height: Integer); virtual;
      function SelectItem(const AnItem: string): Boolean;
      procedure SetStyle(Value: TComboBoxStyle); virtual;
      procedure WndProc(var Message: TMessage); override;
      property OnDrawItem: TDrawItemEvent;
      property OnMeasureItem: TMeasureItemEvent;
   end;

   TComboBox = class(TCustomComboBox)
   end;

   TCustomComboBoxEx = class(TCustomCombo)
   public
      property AutoCompleteOptions: TAutoCompleteOptions;
      property DropDownCount: Integer;
      property Images: TCustomImageList;
      property ItemsEx: TComboExItems;
      property SelText: string;
      property Style: TComboBoxExStyle;
      property StyleEx: TComboBoxExStyles;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      function Focused: Boolean; override;
      property OnBeginEdit: TNotifyEvent;
      property OnEndEdit: TNotifyEvent;
   protected
      property ItemHeight: Integer;
      procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;
      procedure CMColorChanged(var Message: TMessage);
      procedure CMParentColorChanged(var Message: TMessage);
      procedure CNNotify(var Message: TWMNotify);
      procedure ComboExWndProc(var Message: TMessage);
      procedure CreateParams(var Params: TCreateParams); override;
      procedure CreateWnd; override;
      procedure DestroyWnd; override;
      function GetActionLinkClass: TControlActionLinkClass; override;
      function GetItemCount: Integer; override;
      function GetItemHt: Integer; override;
      function GetItemsClass: TCustomComboBoxStringsClass; override;
      procedure Notification(AComponent: TComponent; Operation: TOperation); override;
      procedure SetDropDownCount(const Value: Integer); override;
      procedure WMLButtonDown(var Message: TWMLButtonDown);
      procedure WndProc(var Message: TMessage); override;
   end;

   TCustomBoxStrings = class(TStrings)
   public
      property Count: Integer;
      property Objects[Index: Integer]: TObject;
      property Strings[Index: Integer]: string; default;
      procedure Clear; override;
      procedure Delete(Index: Integer); override;
      function IndexOf(const S: string): Integer; override;
   protected
      property ComboBox: TCustomCombo;
      function Get(Index: Integer): string; override;
      function GetCount: Integer; override;
      function GetObject(Index: Integer): TObject; override;
      procedure PutObject(Index: Integer; AObject: TObject); override;
      procedure SetUpdateState(Updating: Boolean); virtual;
   end;

   TCustomEdit = class(TWinControl)
   public
      property CanUndo: Boolean;
      property Modified: Boolean;
      property SelLength: Integer;
      property SelStart: Integer;
      property SelText: string;
      procedure Clear; virtual;
      procedure ClearSelection;
      procedure ClearUndo;
      procedure CopyToClipboard;
      constructor Create(AOwner: TComponent); override;
      procedure CutToClipboard;
      procedure DefaultHandler(var Message); override;
      function GetSelTextBuf(Buffer: PChar; BufSize: Integer): Integer; virtual;
      procedure PasteFromClipboard;
      procedure SelectAll;
      procedure SetSelTextBuf(Buffer: PChar);
      procedure Undo;
   protected
      property AutoSelect: Boolean;
      property AutoSize: Boolean;
      property BorderStyle: TBorderStyle;
      property CharCase: TEditCharCase;
      property HideSelection: Boolean;
      property MaxLength: Integer;
      property OEMConvert: Boolean;
      property PasswordChar: Char;
      property ReadOnly: Boolean;
      procedure Change; virtual;
      procedure CreateParams(var Params: TCreateParams); override;
      procedure CreateWindowHandle(const Params: TCreateParams); override;
      procedure CreateWnd; override;
      procedure DestroyWnd; override;
      procedure DoSetMaxLength(Value: Integer); virtual;
      function GetSelLength: Integer; virtual;
      function GetSelStart: Integer; virtual;
      function GetSelText: string; virtual;
      procedure SetAutoSize(Value: Boolean); override;
      procedure SetSelLength(Value: Integer); virtual;
      procedure SetSelStart(Value: Integer); virtual;
      property OnChange: TNotifyEvent;
   end;

   TCustomGroupBox = class(TCustomControl)
   public
      constructor Create(AOwner: TComponent); override;
   protected
      procedure AdjustClientRect(var Rect: TRect); override;
      procedure CreateParams(var Params: TCreateParams); override;
      procedure Paint; override;
   end;

   TCustomLabel = class(TGraphicControl)
   public
      constructor Create(AOwner: TComponent); override;
      property OnMouseEnter: TNotifyEvent;
      property OnMouseLeave: TNotifyEvent;
   protected
      property Alignment: TAlignment;
      property AutoSize: Boolean;
      property FocusControl: TWinControl;
      property Layout: TTextLayout;
      property ShowAccelChar: Boolean;
      property Transparent: Boolean;
      property WordWrap: Boolean;
      procedure AdjustBounds; dynamic;
      procedure DoDrawText(var Rect: TRect; Flags: Longint); dynamic;
      function GetLabelText: string; virtual;
      procedure Loaded; override;
      procedure Notification(AComponent: TComponent; Operation: TOperation); override;
      procedure Paint; override;
      procedure SetAutoSize(Value: Boolean); override;
   end;  

   TCustomListBox = class(TCustomMultiSelectListControl)
   public
      property AutoComplete: Boolean;
      property Canvas: TCanvas;
      property Count: Integer;
      property ItemIndex: Integer;
      property Items: TStrings;
      property MultiSelect: Boolean;
      property ScrollWidth: Integer;
      property SelCount: Integer;
      property Selected[Index: Integer]: Boolean;
      property TopIndex: Integer;
      procedure AddItem(Item: String; AObject: TObject);
      procedure Clear;
      procedure ClearSelection;
      procedure CopySelection (Destination: TCustomListControl); override;
      constructor Create(AOwner: TComponent); override;
      procedure DeleteSelected; override;
      destructor Destroy; override;
      function ItemAtPos(Pos: TPoint; Existing: Boolean): Integer;
      function ItemRect(Item: Integer): TRect;
      procedure SelectAll;override;
   protected
      property BorderStyle: TBorderStyle;
      property Columns: Integer;
      property ExtendedSelect: Boolean;
      property IntegralHeight: Boolean;
      property ItemHeight: Integer;
      property Sorted: Boolean;
      property Style: TListBoxStyle;
      property TabWidth: Integer;
      procedure CreateParams(var Params: TCreateParams); virtual;
      procedure CreateWnd; virtual;
      procedure DeleteString(Index: Integer); dynamic;
      procedure DestroyWnd; virtual;
      function DoFindData(const Data: String): Integer;
      function DoGetData(const Index: Integer): string;
      function DoGetDataObject(const Index: Integer): TObject;
      procedure DragCanceled; dynamic;
      procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); virtual;
      function GetCount: Integer; override;
      function GetItemData(Index: Integer): LongInt; dynamic;
      function GetItemIndex: Integer; override;
      function GetSelCount: Integer; override;
      function GetSelected (Index: Integer): Boolean;
      function InternalGetItemData(Index: Integer): Longint; dynamic;
      procedure InternalSetItemData(Index: Integer; AData: Longint); dynamic;
      procedure KeyPress (var Key: Char); override;
      procedure MeasureItem(Index: Integer; var Height: Integer); virtual;
      procedure ResetContent; dynamic;
      procedure SetItemData(Index: Integer; AData: LongInt); dynamic;
      procedure SetItemIndex(const Value: Integer); override;
      procedure SetMultiSelect(Value: Boolean); override;
      procedure WndProc(var Message: TMessage); virtual;
      property OnData: TLBGetDataEvent;
      property OnDataFind: TLBFindDataEvent;
      property OnDataObject: TLBGetDataObjectEvent;
      property OnDrawItem: TDrawItemEvent;
      property OnMeasureItem: TMeasureItemEvent;
   end;
    

   TCustomMemo = class(TCustomEdit)
   public
      property CaretPos: TPoint;
      property Lines: TStrings;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      function GetControlsAlignment: TAlignment; override;
   protected
      property Alignment: TAlignment;
      property ScrollBars: TScrollStyle;
      property WantReturns: Boolean;
      property WantTabs: Boolean;
      property WordWrap: Boolean;
      procedure CreateParams(var Params: TCreateParams); override;
      procedure CreateWindowHandle(const Params: TCreateParams); override
      function GetCaretPos: TPoint; virtual;
      procedure KeyPress(var Key: Char); override;
      procedure Loaded; override;
      procedure SetAlignment(Value: TAlignment);
      procedure SetCaretPos (const Value: TPoint); virtual;
      procedure SetLines(Value: TStrings);
      procedure SetScrollBars(Value: TScrollStyle);
      procedure SetWordWrap(Value: Boolean);
   end;

   TCustomStaticText = class(TWinControl)
   public
      constructor Create(AOwner: TComponent); override;
   protected
      property Alignment: TAlignment;
      property AutoSize: Boolean;
      property BorderStyle: TStaticBorderStyle;
      property FocusControl: TWinControl;
      property ShowAccelChar: Boolean;
      property Transparent: Boolean;
   end;

   TEdit = class(TCustomEdit)
   protected
      property OnChange: TNotifyEvent;
   end; 

   TGroupBox = class(TCustomGroupBox)
   end;

   TLabel = class(TCustomLabel)
   end;

   TListBox = class(TCustomListBox)
   end;

   TMemo = class(TCustomMemo)
   end;

   TRadioButton = class(TButtonControl)
   public
      constructor Create(AOwner: TComponent); override;
      function GetControlsAlignment: TAlignment; override;
   published
      property Alignment: TLeftRight;
      property Checked: Boolean;
   end;

   TScrollBar = class(TWinControl)
   public
      constructor Create(AOwner: TComponent); override;
      procedure SetParams(APosition, AMin, AMax: Integer);
   published
      property Kind: TScrollBarKind;
      property LargeChange: TScrollBarInc;
      property Max: Integer;
      property Min: Integer;
      property PageSize: Integer;
      property Position: Integer;
      property SmallChange: TScrollBarInc;
      property OnChange: TNotifyEvent;
      property OnScroll: TScrollEvent;
   end;

   TStaticText = class(TCustomStaticText)
   end;

implementation
end.







