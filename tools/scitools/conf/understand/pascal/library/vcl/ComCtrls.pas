unit ComCtrls;
interface
   uses Graphics, Controls, Classes, ImgList, ToolWin;
type 
   TAttributeType = (atSelected, atDefaultText);
   TAutoCompleteOption = (acoAutoSuggest, acoAutoAppend, acoSearch, acoFilterPrefixes, acoUseTab, acoUpDownKeyDropsList, acoRtlReading);
   TAutoCompleteOptions = set of TAutoCompleteOption;
   TCommonAVI = (aviNone, aviFindFolder, aviFindFile, aviFindComputer, aviCopyFiles, aviCopyFile, aviRecycleFile, aviEmptyRecycle, aviDeleteFile);
   TConsistentAttribute = (caBold, caColor, caFace, caItalic, caSize, caStrikeout, caUnderline, caProtected);
   TConsistentAttributes = set of TConsistentAttribute;
   TControlActionLinkClass = class of TControlActionLink;
   TDateTimeKind = (dtkDate, dtkTime);
   TDisplayCode = (drBounds, drIcon, drLabel, drSelectBounds);
   TDTCalAlignment = (dtaLeft, dtaRight);
   TDTDateFormat = (dfShort, dfLong);
   TDTDateMode = (dmComboBox, dmUpDown);
   TFontName = type string;
   TFontPitch = (fpDefault, fpVariable, fpFixed);
   TFontStyle = (fsBold, fsItalic, fsUnderline, fsStrikeOut);
   TFontStyles = set of TFontStyle;
   THeaderSectionStyle = (hsText, hsOwnerDraw);
   THKInvalidKey = (hcNone, hcShift, hcCtrl, hcAlt, hcShiftCtrl, hcShiftAlt, hcCtrlAlt, hcShiftCtrlAlt);
   THKInvalidKeys = set of THKInvalidKey;
   THKModifier = (hkShift, hkCtrl, hkAlt, hkExt);
   THKModifiers = set of THKModifier;
   TIconArrangement = (iaTop, iaLeft);
   TItemRequests = (irText, irImage, irParam, irState, irIndent);
   TItemRequest = set of TItemRequests;
   TListArrangement = (arAlignBottom, arAlignLeft, arAlignRight, arAlignTop, arDefault, arSnapToGrid);
   TMultiSelectStyles = (msControlSelect, msShiftSelect, msVisibleOnly, msSiblingOnly);
   TMultiSelectStyle = set of TMultiSelectStyles;
   TNumberingStyle = (nsNone, nsBullet);
   TProgressBarOrientation = (pbHorizontal, pbVertical);
   TSearchType = (stWholeWord, stMatchCase);
   TSearchTypes = set of TSearchType;
   TSectionTrackState = (tsTrackBegin, tsTrackMove, tsTrackEnd);
   TStatusPanelBevel = (pbNone, pbLowered, pbRaised);
   TStatusPanelStyle = (psText, psOwnerDraw);
   TTabPosition = (tpTop, tpBottom, tpLeft, tpRight);
   TTickMark = (tmBottomRight, tmTopLeft, tmBoth);
   TTickStyle = (tsNone, tsAuto, tsManual);
   TTime = type TDateTime;
   TToolButtonStyle = (tbsButton, tbsCheck, tbsDropDown, tbsSeparator, tbsDivider);
   TTrackBarOrientation = (trHorizontal, trVertical);
   TUDAlignButton = (udLeft, udRight);
   TUDBtnType = (btNext, btPrev);
   TUDOrientation = (udHorizontal, udVertical);
   TViewStyle = (vsIcon, vsSmallIcon, vsList, vsReport);

   ECommonCalendarError = class(Exception);
   EDateTimeError = class(ECommonCalendarError);
   EMonthCalError = class(ECommonCalendarError);
   ETreeViewError = class(Exception);

   TConversionClass = class of TConversion;
   TCoolBar = class;
   TCustomHeaderControl = class;
   TCustomListView = class;
   THeaderControl = class;
   THeaderSection = class;
   TListItem = class;
   TListItems = class;
   TStatusBar = class;
   TStatusPanel = class;
   TStatusPanels = class;
   TTabSheet = class;
   TTextAttributes = class;
   TToolBar = class;
   TToolButton = class;
   TTreeNode = class;
   TTreeNodes = class;
   TUpDown = class;
   TWorkAreas = class;

   PFNTVCOMPARE = function(lParam1, lParam2, lParamSort: Longint): Integer stdcall;
   TTVCompare = PFNTVCOMPARE;
   THeaderSectionClass = class of THeaderSection;
   TControlActionLinkClass = class of TControlActionLink;

   TCustomHCCreateSectionClassEvent = procedure(Sender: TCustomHeaderControl;
                var SectionClass: THeaderSectionClass) of object;
   TCustomDrawSectionEvent = procedure(HeaderControl: TCustomHeaderControl; Section: THeaderSection; const Rect: TRect; Pressed: Boolean) of object;
   TCustomSectionNotifyEvent = procedure(HeaderControl: TCustomHeaderControl; Section: THeaderSection) of object;
   TDrawPanelEvent = procedure(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect) of object;
   TDrawSectionEvent = procedure (HeaderControl: THeaderControl; Section: THeaderSection; const Rect: TRect; Pressed: Boolean) of object;
   TSectionDragEvent = procedure (Sender: TObject; FromSection, ToSection: THeaderSection; var AllowDrag: Boolean) of object;
   TSectionTrackEvent = procedure(HeaderControl: THeaderControl; Section: THeaderSection; Width: Integer; State: TSectionTrackState) of object;
   TCustomSectionNotifyEvent = procedure(HeaderControl: TCustomHeaderControl; Section: THeaderSection) of object;
   TCustomSectionTrackEvent = procedure(HeaderControl: THeaderControl; Section: THeaderSection; Width: Integer; State: TSectionTrackState) of object;
   TDTParseInputEvent = procedure(Sender: TObject; const UserString: string; var DateAndTime: TDateTime; var AllowChange: Boolean) of object;
   TLVAdvancedCustomDrawEvent = procedure(Sender: TCustomListView; 
      const ARect: TRect; Stage: TCustomDrawStage; 
      var DefaultDraw: Boolean) of object;
   TLVAdvancedCustomDrawItemEvent = procedure(Sender: TCustomListView; 
      Item: TListItem; State: TCustomDrawState; 
      Stage: TCustomDrawStage; var DefaultDraw: Boolean) of object;
   TLVAdvancedCustomDrawSubItemEvent = procedure(Sender: TCustomListView; 
      Item: TListItem; SubItem: Integer; State: TCustomDrawState; 
      Stage: TCustomDrawStage; var DefaultDraw: Boolean) of object;
   TLVCompare = function(lParam1, lParam2, lParamSort: Integer): Integer stdcall;
   TRichEditProtectChange = procedure(Sender: TObject; StartPos, EndPos: Integer; var AllowChange: Boolean) of object;
   TRichEditResizeEvent = procedure(Sender: TObject; Rect: TRect) of object;
   TRichEditSaveClipboard = procedure(Sender: TObject; NumObjects, NumChars: Integer; var SaveClipboard: Boolean) of object;
   TSectionNotifyEvent = procedure(HeaderControl: THeaderControl; Section: THeaderSection) of object;
   TTabChangingEvent = procedure (Sender: TObject; var AllowChange: Boolean) of object;
   TTBAdvancedCustomDrawBtnEvent = procedure(Sender: TToolBar; Button: TToolButton; State: TCustomDrawState; Stage: TCustomDrawStage; var Flags TTBCustomDrawFlags; var DefaultDraw: Boolean) of object;
   TTBAdvancedCustomDrawEvent = procedure(Sender: TToolBar; const ARect: TRect; Stage: TCustomDrawStage; var DefaultDraw: Boolean) of object;
   TTBCustomDrawBtnEvent = procedure(Sender: TToolBar; Button: TToolButton; State: TCustomDrawState; var DefaultDraw: Boolean) of object;
   TTBCustomDrawEvent = procedure(Sender: TToolBar; const ARect: TRect; var DefaultDraw: Boolean) of object;
   TTBNewButtonEvent = procedure(Sender: TToolBar; Index: Integer; var Button: TToolButton) of object;
   TTVAdvancedCustomDrawItemEvent = procedure(Sender: TCustomTreeView; 
      Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage; 
      var PaintImages, DefaultDraw: Boolean) of object;
   TTVChangedEvent = procedure(Sender: TObject; Node: TTreeNode) of object;
   TTVChangingEvent = procedure(Sender: TObject; Node: TTreeNode; var AllowChange: Boolean) of object;
   TTVCollapsingEvent = procedure(Sender: TObject; Node: TTreeNode; var AllowCollapse: Boolean) of object;
   TTVCompare = function(lParam1, lParam2, lParamSort: Longint): Integer stdcall;
   TTVCompareEvent = procedure(Sender: TObject; Node1, Node2: TTreeNode; Data: Integer; var Compare: Integer) of object;
   TTVCreateNodeClassEvent = procedure(Sender: TCustomTreeView; var NodeClass: TTreeNodeClass) of object;
   TTVCustomDrawEvent = procedure(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean) of object;
   TTVCustomDrawItemEvent = procedure(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean) of object;
   TTVEditedEvent = procedure(Sender: TObject; Node: TTreeNode; var S: string) of object;
   TTVEditingEvent = procedure(Sender: TObject; Node: TTreeNode; var AllowEdit: Boolean) of object;
   TTVExpandingEvent = procedure(Sender: TObject; Node: TTreeNode; var AllowExpansion: Boolean) of object;
   TUDChangingEvent = procedure (Sender: TObject; var AllowChange: Boolean) of object;
   TUDChangingEventEx = procedure (Sender: TObject; var AllowChange: Boolean; NewValue: SmallInt; Direction: TUpDownDirection) of object;
   TUDClickEvent = procedure (Sender: TObject; Button: TUDBtnType) of object;

   TAnimate = class(TWinControl)
   public
      property FrameCount: Integer;
      property FrameHeight: Integer;
      property FrameWidth: Integer;
      property Open: Boolean;
      property ResHandle: THandle;
      property ResID: Integer;
      property ResName: string;
      constructor Create(AOwner: TComponent); override;
      procedure Play(FromFrame, ToFrame: Word; Count: Integer);
      procedure Reset;
      procedure Seek(Frame: SmallInt);
      procedure Stop;
   published
      property Active: Boolean;
      property Center: Boolean;
      property CommonAVI: TCommonAVI;
      property FileName: TFileName;
      property Repetitions: Integer;
      property StartFrame: SmallInt;
      property StopFrame: SmallInt;
      property Timers: Boolean;
      property Transparent: Boolean;
      property OnClose: TNotifyEvent;
      property OnOpen: TNotifyEvent;
      property OnStart: TNotifyEvent;
      property OnStop: TNotifyEvent;
   end;

   TComboBoxEx = class(TCustomComboBoxEx)
   end;

   TComboExItem = class(TListControlItem)
   public
      property Data: Pointer;
      property DisplayName: string;
      procedure Assign(Source: TPersistent); override;
   published
      property Caption: String;
      property ImageIndex: TImageIndex;
      property Indent: Integer;
      property OverlayImageIndex: TImageIndex;
      property OverlayImageIndex: TImageIndex;
   end;

   TComboExItems = class(TListControlItems) 
   public
      property ComboItems[const Index: Integer]: TComboExItem;
      function Add: TComboExItem;
      function AddItem(const Caption: String; const ImageIndex, SelectedImageIndex, OverlayImageIndex, Indent: Integer; Data: Pointer): TComboExItem;
      function Insert(Index: Integer): TComboExItem;
   end;

   TCommonCalendar = class(TWinControl)
   public
      procedure BoldDays(Days: array of LongWord; var MonthBoldInfo: LongWord);
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
   protected
      property OnGetMonthInfo: TOnGetMonthInfoEvent;
   end;

   TConversion = class(TObject)
   public
      function ConvertReadStream(Stream: TStream; Buffer: PChar; BufSize: Integer): Integer; virtual;
      function ConvertWriteStream(Stream: TStream; Buffer: PChar; BufSize: Integer): Integer; virtual;
   end;
   
   TCoolBand = class(TCollectionItem)
   public
      property Height: Integer;
      procedure Assign(Source: TPersistent); override;
      constructor Create(Collection: TCollection); override;
      destructor Destroy; override;
   published
      property Bitmap: TBitmap;
      property BorderStyle: TBorderStyle;
      property Break: Boolean;
      property Color: TColor;
      property Control: TWinControl;
      property FixedBackground: Boolean;
      property FixedSize: Boolean;
      property HorizontalOnly: Boolean;
      property ImageIndex: TImageIndex;
      property MinHeight: Integer;
      property MinWidth: Integer;
      property ParentBitmap: Boolean;
      property ParentColor: Boolean;
      property Text: string;
      property Visible: Boolean;
      property Width: Integer;
   end;

   TCoolBands = class(TCollection)
   public
      property CoolBar: TCoolBar;
      property Items[Index: Integer]: TCoolBand; default;
      function Add: TCoolBand;
      constructor Create(CoolBar: TCoolBar);
      function FindBand(AControl: TControl): TCoolBand;
   end;

   TCoolBar = class(TToolWindow)
   public
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      procedure FlipChildren(AllLevels: Boolean); override;
   published
      property Align: TAlign;
      property BandBorderStyle: TBorderStyle;
      property BandMaximize: TCoolBandMaximize;
      property Bands: TCoolBands;
      property Bitmap: TBitmap;
      property Constraints: TSizeConstraints;
      property DockSite: Boolean;
      property DragKind: TDragKind;
      property FixedOrder: Boolean;
      property FixedSize: Boolean;
      property Images: TCustomImageList;
      property ShowText: Boolean;
      property Vertical: Boolean;
      property OnChange: TNotifyEvent;
   end;

   TCustomHeaderControl = class(TWinControl)
   public
      property Canvas: TCanvas;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      procedure FlipChildren(AllLevels: Boolean); override;
   published
      property DragReorder: Boolean;
      property FullDrag: Boolean;
      property HotTrack: Boolean;
      property Images: TCustomImageList;
      property Sections: THeaderSections;
      property Style: THeaderStyle;
      property OnCreateSectionClass: TCustomHCCreateSectionClassEvent;
      property OnSectionClick: TCustomSectionNotifyEvent;
      property OnSectionDrag: TSectionDragEvent;
      property OnSectionEndDrag: TNotifyEvent;
      property OnSectionResize: TCustomSectionNotifyEvent;
      property OnSectionTrack: TSectionTrackEvent;
   protected
      procedure Notification(AComponent: TComponent; Operation: TOperation); override;
      property OnDrawSection: TCustomDrawSectionEvent;
   end;

   TCustomHotKey = class(TWinControl)
   public
      constructor Create(AOwner: TComponent); override;
   protected
      property AutoSize: Boolean;
      property HotKey: TShortCut;
      property InvalidKeys: THKInvalidKeys;
      property Modifiers: THKModifiers;
      property OnChange: TNotifyEvent;
   end;

   TCustomListView = class(TWinControl)
   public
      property BoundingRect: TRect;
      property Canvas: TCanvas;
      property CheckBoxes: Boolean;
      property Column[Index: Integer]: TListColumn;
      property DropTarget: TListItem;
      property FlatScrollBars: Boolean;
      property FullDrag: Boolean;
      property GridLines: Boolean;
      property HotTrack: Boolean;
      property HotTrackStyles: TListHotTrackStyles;
      property ItemFocused: TListItem;
      property ItemIndex: Integer;
      property RowSelect: Boolean;
      property SelCount: Integer;
      property Selected: TListItem;
      property TopItem: TListItem;
      property ViewOrigin: TPoint;
      property VisibleRowCount: Integer;
      property WorkAreas: TWorkAreas;
      procedure AddItem(Item: String; AObject: TObject); virtual; override;
      function AlphaSort: Boolean;
      procedure Arrange(Code: TListArrangement);
      procedure Clear; override;
      procedure ClearSelection; override;
      procedure CopySelection(Destination: TCustomListControl); override;
      constructor Create(AOwner: TListItems);
      function CustomSort(SortProc: TLVCompare; lParam: Longint): Boolean;
      procedure DeleteSelected; override;
      destructor Destroy; override;
      function FindCaption(StartIndex: Integer; Value: string; Partial, Inclusive, Wrap: Boolean): TListItem;
      function FindData(StartIndex: Integer; Value: Pointer; Inclusive, Wrap: Boolean): TListItem;
      function GetHitTestInfoAt(X, Y: Integer): THitTests;
      function GetItemAt(X, Y: Integer): TListItem;
      function GetNearestItem(Point: TPoint; Direction: TSearchDirection): TListItem;
      function GetNextItem(StartItem: TListItem; Direction: TSearchDirection; States: TItemStates): TListItem;
      function GetSearchString: string;
      function IsEditing: Boolean;
      procedure Scroll(DX, DY: Integer);
      procedure SelectAll; override;
      function StringWidth(S: string): Integer;
      procedure UpdateItems(FirstIndex, LastIndex: Integer);
   protected
      property AllocBy: Integer;
      property BorderStyle: TBorderStyle;
      property ColumnClick: Boolean;
      property Columns: TListColumns;
      property HideSelection: Boolean;
      property HoverTime: Integer;
      property IconOptions: TIconOptions;
      property Items: TListItems;
      property LargeImages: TCustomImageList;
      property MultiSelect: Boolean;
      property OwnerData: Boolean;
      property OwnerDraw: Boolean;
      property ReadOnly: Boolean;
      property ShowColumnHeaders: Boolean;
      property ShowWorkAreas: Boolean;
      property SmallImages: TCustomImageList;
      property SortType: TSortType;
      property StateImages: TCustomImageList;
      property ViewStyle: TViewStyle;
      procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;
      function CanChange(Item: TListItem; Change: Integer): Boolean; dynamic;
      function CanEdit(Item: TListItem): Boolean; dynamic;
      procedure Change(Item: TListItem; Change: Integer); dynamic;
      procedure ChangeScale(M, D: Integer); override;
      procedure ColClick(Column: TListColumn); dynamic;
      procedure ColRightClick(Column: TListColumn; Point:TPoint); dynamic;
      function ColumnsShowing: Boolean;
      function CreateListItem: TListItem; virtual;
      function CreateListItems: TListItems; virtual;
      procedure CreateParams(var Params: TCreateParams); override;
      procedure CreateWnd; override;
      function CustomDraw(const ARect: TRect; Stage: TCustomDrawStage): Boolean; virtual;
      function CustomDrawSubItem(Item: TListItem; SubItem: Integer; State: TCustomDrawState; Stage: TCustomDrawStage): Boolean; virtual;
      procedure Delete(Item: TListItem); dynamic;
      procedure DestroyWnd; override;
      procedure DoEndDrag(Target: TObject; X, Y: Integer); override;
      procedure DoInfoTip(Item: TListItem; var InfoTip: string); virtual;
      procedure DoStartDrag(var DragObject: TDragObject); override;
      procedure DrawItem(Item: TListItem; Rect: TRect; State: TOwnerDrawState); virtual;
      procedure Edit(const Item: TLVItem); dynamic;
      function GetActionLinkClass: TControlActionLinkClass; override;
      function GetCount: Integer; override;
      function GetDragImages: TDragImageList; override;
      function GetItemIndex(Value: TListItem): Integer; reintroduce; overload;
      function GetItemIndex: Integer; reintroduce; overload; override;
      function GetSelCount: Integer; override;
      procedure InsertItem(Item: TListItem); dynamic;
      function IsCustomDrawn(Target: TCustomDrawTarget; Stage: TCustomDrawStage): Boolean; virtual
      procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
      procedure Notification(AComponent: TComponent; Operation: TOperation); override;
      function OwnerDataFetch(Item: TListItem; Request: TItemRequest): Boolean; virtual;
      function OwnerDataFind(Find: TItemFind; const FindString: string; const FindPosition: TPoint; FindData: Pointer; StartIndex: Integer; Direction: TSearchDirection; Wrap: Boolean): Integer; virtual;
      function OwnerDataHint(StartIndex, EndIndex: Integer): Boolean; virtual;
      function OwnerDataStateChange(StartIndex, EndIndex: Integer; OldState, NewState: TItemStates): Boolean; virtual;
      procedure SetItemIndex(const Value: Integer); override;
      procedure SetMultiSelect(Value: Boolean); override;
      procedure SetViewStyle(Value: TViewStyle); virtual;
      procedure UpdateColumn(AnIndex: Integer);
      procedure UpdateColumns;
      procedure WndProc(var Message: TMessage); override;
      property OnAdvancedCustomDraw: TLVAdvancedCustomDrawEvent;
      property OnAdvancedCustomDrawItem: TLVAdvancedCustomDrawItemEvent;
      property OnAdvancedCustomDrawSubItem: TLVAdvancedCustomDrawSubItemEvent
   end;

   TCustomRichEdit = class(TCustomMemo)
   public
      property DefAttributes: TTextAttributes;
      property DefaultConverter: TConversionClass;
      property PageRect: TRect;
      property Paragraph: TParaAttributes;
      property SelAttributes: TTextAttributes;
      property SelLength: Integer;
      property SelStart: Integer;
      property SelText: string;
      procedure Clear; override;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      function FindText(const SearchStr: string; StartPos, Length: Integer; Options: TSearchTypes): Integer;
      function GetSelTextBuf(Buffer: PChar; BufSize: Integer): Integer; override;
      procedure Print(const Caption: string); virtual;
      class procedure RegisterConversionFormat(const AExtension: string; AConversionClass: TConversionClass);
   protected
      property HideScrollBars;
      property HideSelection: Boolean;
      property Lines: TStrings;
      property PlainText: Boolean;
      procedure CreateParams(var Params: TCreateParams); override;
      procedure CreateWnd; override;
      procedure DestroyWnd; override;
      procedure DoSetMaxLength(Value: Integer); override;
      function GetCaretPos: TPoint; override;
      function GetSelLength: Integer; override;
      function GetSelStart: Integer; override;
      function GetSelText: string; override;
      procedure RequestSize(const Rect: TRect); virtual;
      procedure SelectionChange; dynamic;
      procedure SetCaretPos(const Value: TPoint); override;
      procedure SetSelLength(Value: Integer); override;
      procedure SetSelStart(Value: Integer); override;
      property OnProtectChange: TRichEditProtectChange;
      property OnResizeRequest: TRichEditResizeEvent;
      property OnSaveClipboard: TRichEditSaveClipboard;
      property OnSelectionChange: TNotifyEvent;
   end;

   TCustomStatusBar = class(TWinControl)
   public
      property AutoHint: Boolean;
      property Canvas: TCanvas;
      property Panels: TStatusPanels;
      property Parent: TWinControl;
      property SimplePanel: Boolean;
      property SimpleText: string;
      property SizeGrip: Boolean;
      property UseSystemFont: Boolean;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      function ExecuteAction(Action: TBasicAction): Boolean; override;
      procedure FlipChildren(AllLevels: Boolean); override;
      procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
      property OnCreatePanelClass: TSBCreatePanelClassEvent;
      property OnDrawPanel: TCustomDrawPanelEvent;
      property OnHint: TNotifyEvent;
   protected
procedure ChangeScale(M, D: Integer); override;
      function CreatePanel: TStatusPanel; virtual;
      function CreatePanels: TStatusPanels; virtual;
      procedure CreateParams(var Params: TCreateParams); override;
      procedure CreateWnd; override;
      function DoHint: Boolean; virtual;
      procedure DrawPanel(Panel: TStatusPanel; const Rect: TRect); dynamic;
      function GetPanelClass: TStatusPanelClass; virtual;
      function IsFontStored: Boolean;
      procedure SetParent(AParent: TWinControl); override;
   end;

   TCustomTabControl = class(TWinControl)
   public
      property Canvas: TCanvas;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      function GetHitTestInfoAt(X, Y: Integer): THitTests;
      function IndexOfTabAt(X, Y: Integer): Integer;
      function RowCount: Integer;
      procedure ScrollTabs(Delta: Integer);
      function TabRect(Index: Integer): TRect;
   protected
      property DisplayRect: TRect;
      property HotTrack: Boolean;
      property Images: TCustomImageList;
      property MultiLine: Boolean;
      property MultiSelect: Boolean;
      property OwnerDraw: Boolean;
      property RaggedRight: Boolean;
      property ScrollOpposite: Boolean;
      property Style: TTabStyle;
      property TabHeight: Smallint;
      property TabIndex: Integer;
      property TabPosition: TTabPosition;
      property Tabs: TStrings;
      property TabWidth: Smallint;
      procedure AdjustClientRect(var Rect: TRect); override;
      function CanChange: Boolean; dynamic;
      function CanShowTab(TabIndex: Integer): Boolean; virtual;
      procedure Change; dynamic
      procedure CreateParams(var Params: TCreateParams); override;
      procedure CreateWnd; override;
      procedure DrawTab(TabIndex: Integer; const Rect: TRect; Active: Boolean); virtual;
      function GetImageIndex(TabIndex: Integer): Integer; virtual;
      procedure Loaded; override;
      procedure Notification(AComponent: TComponent; Operation: TOperation); override;
      procedure SetTabIndex(Value: Integer); virtual;
      procedure UpdateTabImages;
      property OnChange: TNotifyEvent;
      property OnChanging: TTabChangingEvent;
      property OnDrawTab: TDrawTabEvent;
      property OnGetImageIndex: TTabGetImageEvent;
   end;


   TCustomTreeView = class(TWinControl)
   public
      property Canvas: TCanvas;
      property DropTarget: TTreeNode;
      property Selected: TTreeNode;
      property SelectionCount: Cardinal;
      property Selections[Index: Integer]: TTreeNode;
      property TopItem: TTreeNode;
      function AlphaSort(ARecurse: Boolean): Boolean;
      procedure ClearSelection(KeepPrimary: Boolean = False); virtual;
      constructor Create(AOwner: TComponent);
      function CustomSort(SortProc: TTVCompare; Data: Longint; ARecurse: Boolean = True): Boolean;
      procedure Deselect(Node: TTreeNode); virtual;
      destructor Destroy; override;
      function FindNextToSelect: TTreeNode; virtual;
      procedure FullCollapse;
      procedure FullExpand;
      function GetHitTestInfoAt(X, Y: Integer): THitTests;
      function GetNodeAt(X, Y: Integer): TTreeNode;
      function GetSelections(AList: TList): TTreeNode;
      function IsEditing: Boolean;
      procedure LoadFromFile(const FileName: string);
      procedure LoadFromStream(Stream: TStream);
      procedure SaveToFile(const FileName: string);
      procedure SaveToStream(Stream: TStream);
      procedure Select(const Nodes: array of TTreeNode); overload; virtual;
      procedure Select(Nodes: TList); overload; virtual;
      procedure Select(Node: TTreeNode; ShiftState: TShiftState = []); overload; virtual;
      procedure Subselect(Node: TTreeNode; Validate: Boolean = False); virtual;
   protected
      property AutoExpand: Boolean;
      property BorderStyle: TBorderStyleTBorderStyle;
      property ChangeDelay: Integer;
      property HideSelection: Boolean;
      property HotTrack: Boolean;
      property Images: TCustomImageList;
      property Indent: Integer;
      property Items: TTreeNodes;
      property MultiSelect: Boolean;
      property MultiSelectStyle: TMultiSelectStyle;
      property ReadOnly: Boolean;
      property RightClickSelect: Boolean;
      property RowSelect: Boolean;
      property ShowButtons: Boolean;
      property ShowLines: Boolean;
      property ShowRoot: Boolean;
      property SortType: TSortType;
      property StateImages: TCustomImageList;
      property ToolTips: Boolean;
      function CanChange(Node: TTreeNode): Boolean; dynamic;
      function CanCollapse(Node: TTreeNode): Boolean; dynamic;
      function CanEdit(Node: TTreeNode): Boolean; dynamic;
      function CanExpand(Node: TTreeNode): Boolean; dynamic;
      procedure Change(Node: TTreeNode); dynamic;
      procedure Collapse(Node: TTreeNode); dynamic;
      function CreateNode: TTreeNode; virtual;
      procedure CreateParams(var Params: TCreateParams); override;
      procedure CreateWnd; override;
      function CustomDraw(const ARect: TRect; Stage: TCustomDrawStage): Boolean; virtual;
      function CustomDrawItem(Node: TTreeNode; State: TCustomDrawState; 
         Stage: TCustomDrawStage; var PaintImages: Boolean): Boolean; virtual;
      procedure Delete(Node: TTreeNode); dynamic;
      procedure DestroyWnd; override;
      procedure DoEndDrag(Target: TObject; X, Y: Integer); override;
      procedure DoStartDrag(DragObject: TDragObject); override;
      procedure Edit(const Item: TTVItem); dynamic;
      procedure Expand(Node: TTreeNode); dynamic;
      function GetDragImages: TDragImageList; override;
      procedure GetImageIndex(Node: TTreeNode); virtual;
      procedure GetSelectedIndex(Node: TTreeNode); virtual;
      function IsCustomDrawn(Target: TCustomDrawTarget; Stage: TCustomDrawStage): Boolean; virtual;
      procedure Loaded; override;
      procedure SetDragMode(Value: TDragMode); override;
      procedure WndProc(var Message: TMessage); override;
      property OnAddition: TTVExpandedEvent;
      property OnAdvancedCustomDraw: TTVAdvancedCustomDrawEvent;
      property OnAdvancedCustomDrawItem: TTVAdvancedCustomDrawItemEvent;
      property OnCancelEdit: TTVChangedEvent;
      property OnChange: TTVChangedEvent;
      property OnChanging: TTVChangingEvent;
      property OnCollapsed: TTVExpandedEvent;
      property OnCollapsing: TTVCollapsingEvent;
      property OnCompare: TTVCompareEvent;
      property OnCreateNodeClass: TTVCreateNodeClassEvent;
      property OnCustomDraw: TTVCustomDrawEvent;
      property OnCustomDrawItem: TTVCustomDrawItemEvent;
      property OnDeletion: TTVExpandedEvent;
      property OnEdited: TTVEditedEvent;
      property OnEditing: TTVEditingEvent;
      property OnExpanded: TTVExpandedEvent;
      property OnExpanding: TTVExpandingEvent;
      property OnGetImageIndex: TTVExpandedEvent;
      property OnGetSelectedIndex: TTVExpandedEvent;
   end;

   TCustomUpDown = class(TWinControl)
   public
      constructor Create(AOwner: TComponent); override;
   protected
      property AlignButton: TUDAlignButton;
      property ArrowKeys: Boolean;
      property Associate: TWinControl;
      property Increment: Integer;
      property Max: SmallInt;
      property Min: SmallInt;
      property Orientation: TUDOrientation;
      property Position: SmallInt;
      property Thousands: Boolean;
      property Wrap: Boolean;
      function CanChange: Boolean;
      procedure Click(Button: TUDBtnType); reintroduce; dynamic;
      procedure CreateParams(var Params: TCreateParams); override;
      procedure CreateWnd; override;
      function DoCanChange(NewVal: SmallInt; Delta: SmallInt): Boolean;
      procedure Notification(AComponent: TComponent; Operation: TOperation); override;
      property OnChanging: TUDChanginEvent;
      property OnChangingEx: TUDChanginEventEx;
      property OnClick: TUDClickEvent
   end;

   TDateTimePicker = class(TCommonCalendar)
   public
      property DroppedDown: Boolean;
      constructor Create(AOwner: TComponent); override;
   published
      property CalAlignment: TDTCalAlignment;
      property Checked: Boolean;
      property DateFormat: TDTDateFormat;
      property DateMode: TDTDateMode;
      property Format: String;
      property Kind: TDateTimeKind;
      property ParseInput: Boolean;
      property ShowCheckbox: Boolean;
      property Time: TTime;
      property OnChange: TNotifyEvent;
      property OnCloseUp: TNotifyEvent;
      property OnDropDown: TNotifyEvent;
      property OnUserInput: TDTParseInputEvent;
   end;

   THeaderControl = class(TCustomHeaderControl)
   published
      property OnDrawSection: TDrawSectionEvent;
      property OnSectionClick: TSectionNotifyEvent;
      property OnSectionResize: TSectionNotifyEvent;
      property OnSectionTrack: TSectionTrackEvent;
   end;

   THeaderSection = class(TCollectionItem)
   public
      property DisplayName: string;
      property Left: Integer;
      property Right: Integer;
      procedure Assign(Source: TPersistent); override;
      constructor Create(Collection: TCollection); override;
      procedure ParentBiDiModeChanged;
      function UseRightToLeftAlignment: Boolean;
      function UseLeftToRightAlignment: Boolean;
   published
      property Alignment: TAlignment;
      property AllowClick: Boolean;
      property AutoSize: Boolean;
      property BiDiMode: TBiDiMode;
      property ImageIndex: TImageIndex;
      property MaxWidth: Integer;
      property MinWidth: Integer;
      property ParentBiDiMode: Boolean;
      property Style: THeaderSectionStyle;
      property Text: string;
      property Width: Integer;
   end;

   THotKey = class(TCustomHotKey)
   end;

   TIconOptions = class(TPersistent)
   public
      constructor Create(AOwner: TCustomListView);
   published
      property Arrangement: TIconArrangement;
      property AutoArrange: Boolean;
      property WrapText: Boolean;
   end;

   TCustomHeaderSection = class(TCollectionItem)
   public
      property DisplayName: string;
      constructor Create(Collection: TCollection); override;
   published
      property AllowClick: Boolean;
      property AllowResize: Boolean;
      property MaxWidth: Integer;
      property MinWidth: Integer;
   end;


   TListColumn = class(TCustomHeaderSection)
   public
   published
      property Alignment: TAlignment;
      property AutoSize: Boolean;
      property Caption: string;
      property Width: Integer;
      destructor Destroy; override;
   protected
      function AddSection: Integer; override;
      procedure AssignTo(Dest: TPersistent); override;
      procedure Resubmit; override;
      procedure SetWidthVal(const Value: Integer); override;
   end;

   TListColumns = class(TCollection)
   public
      property Items[Index: Integer]: TListColumn; default;
      function Add: TListColumn;
      constructor Create(AOwner: TCustomListView);
      function Owner: TCustomListView;
   end;

   TListItem = class(TPersistent)
   public
      property Caption: string;
      property Checked: Boolean;
      property Cut: Boolean;
      property Data: Pointer;
      property Deleting: Boolean;
      property DropTarget: Boolean;
      property Focused: Boolean;
      property Handle: HWND;
      property ImageIndex: TImageIndex;
      property Indent: Integer;
      property Index: Integer;
      property Left: Integer;
      property ListView: TCustomListView;
      property OverlayIndex: TImageIndex;
      property Owner: TListItems;
      property Position: TPoint;
      property Selected: Boolean;
      property StateIndex: TImageIndex;
      property SubItemImages[Index: Integer]: Integer;
      property SubItems: TStrings;
      property Top: Integer;
      procedure Assign(Source: TPersistent); override;
      procedure CancelEdit;
      constructor Create(AOwner: TListItems);
      procedure Delete;
      destructor Destroy; override;
      function DisplayRect(Code: TDisplayCode): TRect;
      function EditCaption: Boolean;
      function GetPosition: TPoint;
      procedure MakeVisible(PartialOK: Boolean);
      procedure SetPosition(const Value: TPoint);
      procedure Update;
      function WorkArea: Integer;
   end;

   TListItems = class(TPersistent)
   public
      property Count: Integer;
      property Handle: HWND;
      property Item[Index: Integer]: TListItem;
      property Owner: TCustomListView;
      function Add: TListItem;
      function AddItem(Item: TListItem; Index: Integer = -1): TListItem;
      procedure Assign(Source: TPersistent); override;
      procedure BeginUpdate;
      procedure Clear;
      constructor Create(AOwner: TCustomListView);
      procedure Delete(Index: Integer);
      destructor Destroy; override;
      procedure EndUpdate;
      function IndexOf(Value: TListItem): Integer;
      function Insert(Index: Integer): TListItem;
   protected
      procedure DefineProperties(Filer: TFiler); override;
      procedure SetCount(Value: Integer);
   end;

   TListView = class(TCustomListView)
   end;

   TMonthCalColors = class(TPersistent)
   public
      procedure Assign(Source: TPersistent); override;
      constructor Create(AOwner: TCommonCalendar);
   published
      property BackColor: TColor;
      property MonthBackColor: TColor;
      property TextColor: TColor;
      property TitleBackColor: TColor;
      property TitleTextColor: TColor;
      property TrailingTextColor: TColor;
   end;

   TMonthCalendar = class(TCommonCalendar)
   public
      constructor Create(AOwner: TComponent); override;
   protected
      function CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;
      procedure ConstrainedResize(var MinWidth, MinHeight, MaxWidth, MaxHeight: Integer); override;
      procedure CreateParams(var Params: TCreateParams); override;
      function GetCalendarHandle: HWND; override;
      function MsgSetCalColors(ColorIndex: Integer; ColorValue: TColor): Boolean; override;
      function MsgSetDateTime(Value: TSystemTime): Boolean; override;
      function MsgSetRange(Flags: Integer; SysTime: PSystemTime): Boolean; override;
   end;

   TPageControl = class(TCustomTabControl)
   public
      property ActivePageIndex: Integer;
      property PageCount: Integer;
      property Pages[Index: Integer]: TTabSheet;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      function FindNextPage(CurPage: TTabSheet; GoForward, CheckTabVisible: Boolean): TTabSheet;
      procedure SelectNextPage(GoForward: Boolean; CheckTabVisible:Boolean = True);
   published
      property ActivePage: TTabSheet;
   protected
      function CanShowTab(TabIndex: Integer): Boolean; override;
      procedure Change; override;
      procedure DoAddDockClient(Client: TControl; const ARect: TRect); override;
      procedure DockOver(Source: TDragDockObject; X, Y: Integer; State: TDragState; var Accept: Boolean); override;
      procedure DoRemoveDockClient(Client: TControl); override;
      procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
      function GetImageIndex(TabIndex: Integer): Integer; override;
      function GetPageFromDockClient(Client: TControl): TTabSheet;
      procedure GetSiteInfo(Client: TControl; var InfluenceRect: TRect; MousePos: TPoint; var
       CanDock: Boolean);
      procedure Loaded; override;
      procedure SetChildOrder(Child: TComponent; Order: Integer); override;
      procedure ShowControl(AControl: TControl); override;
   end;

   TPageScroller = class(TWinControl)
   public
   published
      property AutoScroll: Boolean;
      property ButtonSize: Integer;
      property Control: TWinControl;
      property DragScroll: Boolean;
      property Margin: Integer;
      property Orientation: TPageScrollerOrientation;
      property Position: Integer;
      constructor Create(AOwner: TComponent); override;
      function GetButtonState(Button: TPageScrollerButton): TPageScrollerButtonState;
   protected
      procedure AlignControls(AControl: TControl; var Rect: TRect); override;
      procedure CreateParams(var Params: TCreateParams); override;
      procedure CreateWnd; override;
      procedure Scroll(Shift: TShiftState; X, Y: Integer; Orientation: TPageScrollerOrientation; var Delta: Integer); dynamic;
      property OnScroll: TPageScrollEvent;
   end;

   TParaAttributes = class(TPersistent)
   public
      property Alignment: TAlignment;
      property FirstIndent: Longint;
      property LeftIndent: Longint;
      property Numbering: TNumberingStyle;
      property RightIndent: Longint;
      property Tab[Index: Byte]: Longint;
      property TabCount: Integer;
      procedure Assign(Source: TPersistent); override;
      constructor Create(AOwner: TCustomRichEdit);
   end;

   TProgressBar = class(TWinControl)
   public
      constructor Create(AOwner: TComponent); override;
      procedure StepBy(Delta: Integer);
      procedure StepIt;
   published
      property Max: Integer;
      property Min: Integer;
      property Orientation: TProgressBarOrientation;
      property Position: Integer;
      property Smooth: Boolean;
      property Step: Integer;
   end;

   TRichEdit = class(TCustomRichEdit)
   end;

   TStatusBar = class(TCustomStatusBar)
   published
      property OnDrawPanel: TDrawPanelEvent;
   end;
      
   TStatusPanel = class(TCollectionItem)
   public
      property DisplayName: string
      procedure Assign(Source: TPersistent); override;
      constructor Create(Collection: TCollection); override;
      procedure ParentBiDiModeChanged;
      function UseRightToLeftAlignment: Boolean;
      function UseRightToLeftReading: Boolean;
   published
      property Alignment: TAlignment;
      property Bevel: TStatusPanelBevel;
      property BiDiMode: TBiDiMode;
      property ParentBiDiMode: Boolean;
      property Style: TStatusPanelStyle;
      property Text: string;
      property Width: Integer;
   protected
      function GetDisplayName: string; override;
   end;

   TStatusPanels = class(TCollection)
   public
      property Items[Index: Integer]: TStatusPanel; default;
      function Add: TStatusPanel;
      function AddItem(Item: TStatusPanel; Index: Integer): TStatusPanel;
      constructor Create(StatusBar: TStatusBar);
      function Insert(Index: Integer): TStatusPanel;
   protected
      function GetOwner: TPersistent; override;
      procedure Update(Item: TCollectionItem); override;
   end;

   TTabControl = class(TCustomTabControl)
   end;

   TTabSheet = class(TWinControl)
   public
      property PageControl: TPageControl;
      property TabIndex: Integer;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
   published
      property Highlighted: Boolean;
      property ImageIndex: TImageIndex;
      property PageIndex: Integer;
      property TabVisible: Boolean;
      property OnHide: TNotifyEvent;
      property OnShow: TNotifyEvent;
   protected
      procedure CreateParams(var Params: TCreateParams); override;
      procedure DoHide; dynamic;
      procedure DoShow; dynamic;
      procedure ReadState(Reader: TReader); override;
   end;

   TTextAttributes = class(TPersistent)
   public
      property Charset: TFontCharset;
      property Color: TColor;
      property ConsistentAttributes: TConsistentAttributes;
      property Height: Integer;
      property Name: TFontName;
      property Pitch: TFontPitch;
// tbd - causes syntax error
//      property Protected: Boolean;
      property Size: Integer;
      property Style: TFontStyles;
      procedure Assign(Source: TPersistent); override;
      constructor Create(AOwner: TCustomRichEdit; AttributeType: TAttributeType);
   protected
      procedure AssignTo(Dest: TPersistent); override;
      procedure InitFormat(var Format: TCharFormat);
   end;

   TToolBar = class(TToolWindow)
   public
      property ButtonCount: Integer;
      property Buttons[Index: Integer]: TToolButton;
      property Canvas: TCanvas;
      property CustomizeKeyName: string;
      property CustomizeValueName: string;
      property RowCount: Integer;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      procedure FlipChildren(AllLevels: Boolean); override;
      function TrackMenu(Button: TToolButton): Boolean; dynamic;
   published
      property HideClippedButtons: Boolean;
      property ButtonHeight: Integer;
      property ButtonWidth: Integer;
      property Customizable: Boolean;
      property DisabledImages: TCustomImageList;
      property Flat: Boolean;
      property HotImages: TCustomImageList;
      property Images: TCustomImageList;
      property Indent: Integer;
      property List: Boolean;
      property Menu: TMainMenu;
      property ShowCaptions: Boolean;
      property Transparent: Boolean;
      property Wrapable: Boolean;
      property OnAdvancedCustomDraw: TTBAdvancedCustomDrawEvent;
      property OnAdvancedCustomDrawButton: TTBAdvancedCustomDrawBtnEvent;
      property OnCustomDraw: TTBCustomDrawEvent;
      property OnCustomDrawButton: TTBCustomDrawBtnEvent;
      property OnCustomizeAdded: TTBButtonEvent;
      property OnCustomizeCanDelete: TTBCustomizeQueryEvent;
      property OnCustomizeCanInsert: TTBCustomizeQueryEvent;
      property OnCustomized: TNotifyEvent;
      property OnCustomizeDelete: TTBButtonEvent;
      property OnCustomizeNewButton: TTBNewButtonEvent;
      property OnCustomizeReset: TNotifyEvent;
      property OnCustomizing: TNotifyEvent;
   protected 
      procedure AlignControls(AControl: TControl; var Rect: TRect); override;
      function CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;
      procedure CancelMenu; dynamic;
      procedure ChangeScale(M, D: Integer); override;
      function CheckMenuDropdown(Button: TToolButton): Boolean; dynamic;
      procedure ClickButton(Button: TToolButton); dynamic;
      procedure CreateParams(var Params: TCreateParams); override;
      procedure CreateWnd; override;
      function CustomDraw(const ARect: TRect; Stage: TCustomDrawStage): Boolean; virtual;
      function CustomDrawButton(Button: TToolButton; State: TCustomDrawState; Stage: TCustomDrawStage; var Flags: TTBCustomDrawFlags): Boolean; virtual;
      function DoQueryDelete(Index: Integer): Boolean; virtual;
      function DoQueryInsert(Index: Integer): Boolean; virtual;
      function FindButtonFromAccel(Accel: Word): TToolButton;
      procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
      procedure InitMenu(Button: TToolButton); dynamic;
      function IsCustomDrawn(Target: TCustomDrawTarget; Stage: TCustomDrawStage): Boolean; virtual;
      procedure Loaded; override;
      procedure Notification(AComponent: TComponent; Operation: TOperation); override;
      procedure RepositionButton(Index: Integer);
      procedure RepositionButtons(Index: Integer);
      procedure WndProc(var Message: TMessage); override;
      function WrapButtons(var NewWidth, NewHeight: Integer): Boolean;
   end;

   TToolButton = class(TGraphicControl)
   public
      property Index: Integer;
      function CheckMenuDropdown: Boolean; dynamic;
      procedure Click; override;
      constructor Create(AOwner: TComponent); override;
      procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
   published
      property AllowAllUp: Boolean;
      property AutoSize: Boolean;
      property Down: Boolean;
      property DropdownMenu: TPopupMenu;
      property Grouped: Boolean;
      property ImageIndex: TImageIndex;
      property Indeterminate: Boolean;
      property Marked: Boolean;
      property MenuItem: TMenuItem;
      property Style: TToolButtonStyle;
      property Wrap: Boolean;
   protected
      procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;
      procedure AssignTo(Dest: TPersistent); override;
      procedure BeginUpdate; virtual;
      procedure EndUpdate; virtual;
      function GetActionLinkClass: TControlActionLinkClass; override;
      procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);  override;
      procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
      procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
      procedure Notification(AComponent: TComponent; Operation: TOperation); override;
      procedure Paint; override;
      procedure RefreshControl; virtual;
      procedure SetAutoSize(Value: Boolean); override;
      procedure SetToolBar(AToolBar: TToolBar);
      procedure UpdateControl; virtual;
      procedure ValidateContainer(AComponent: TComponent); override;
   end;

   TToolButtonActiveLink = class(TControlActiveLink)
   protected
      procedure AssignClient(AClient: TObject); override;
      function IsCheckedLinked: Boolean; override;
      function IsImageIndexLinked: Boolean; override;
      procedure SetChecked(Value: Boolean); override;
      procedure SetImageIndex(Value: Integer); override;
   end;

   TTrackBar = class(TWinControl)
   public
      constructor Create(AOwner: TComponent); override;
      procedure SetTick(Value: Integer);
   published
      property Frequency: Integer;
      property LineSize: Integer;
      property Max: Integer;
      property Min: Integer;
      property Orientation: TTrackBarOrientation;
      property PageSize: Integer;
      property Position: Integer;
      property SelEnd: Integer;
      property SelStart: Integer;
      property SliderVisible: Boolean;
      property ThumbLength: Integer;
      property TickMarks: TTickMark;
      property TickStyle: TTickStyle;
      property OnChange: TNotifyEvent;
   end;

   TTreeNode = class(TPersistent)
   public
      property AbsoluteIndex: Integer;
      property Count: Integer;
      property Cut: Boolean;
      property Data: Pointer;
      property Deleting: Boolean;
      property DropTarget: Boolean;
      property Expanded: Boolean;
      property Focused: Boolean;
      property Handle: HWND;
      property HasChildren: Boolean;
      property ImageIndex: TImageIndex;
      property Index: Longint;
      property IsVisible: Boolean;
      property Item[Index: Integer]: TTreeNode;
      property ItemId: HTreeItem;
      property Level: Integer;
      property OverlayIndex: Integer;
      property Owner: TTreeNodes;
      property Parent: TTreeNode;
      property Selected: Boolean;
      property SelectedIndex: Integer;
      property StateIndex: Integer;
      property Text: string;
      property TreeView: TCustomTreeView;
      function AlphaSort(ARecurse: Boolean = False): Boolean;
      procedure Assign(Source: TPersistent); override;
      procedure Collapse(Recurse: Boolean);
      constructor Create(AOwner: TTreeNodes);
      function CustomSort(SortProc: TTVCompare; Data: Longint; ARecurse: Boolean = False): Boolean;
      procedure Delete;
      procedure DeleteChildren;
      destructor Destroy; override;
      function DisplayRect(TextOnly: Boolean): TRect;
      procedure EndEdit(Cancel Boolean);
      procedure Expand(Recurse: Boolean);
      function GetFirstChild: TTreeNode;
      function GetHandle: HWND;
      function GetLastChild: TTreeNode;
      function GetNext: TTreeNode;
      function GetNextChild(Value: TTreeNode): TTreeNode;
      function GetNextSibling: TTreeNode;
      function GetNextVisible: TTreeNode;
      function GetPrev: TTreeNode;
      function GetPrevChild(Value: TTreeNode): TTreeNode;
      function GetPrevSibling: TTreeNode;
      function GetPrevVisible: TTreeNode;
      function HasAsParent(Value: TTreeNode): Boolean;
      function IndexOf(Value: TTreeNode): Integer;
      property IsFirstNode: Boolean;
      procedure MakeVisible;
      procedure MoveTo(Destination: TTreeNode; Mode: TNodeAttachMode);
   end;

   TTreeNodes = class(TPersistent)
   public
      property Count: Integer;
      property Handle: HWND;
      property Item[Index: Integer]: TTreeNode; default;
      property Owner: TCustomTreeView;
      function Add(Node: TTreeNode; const S: string): TTreeNode;
      function AddChild(Node: TTreeNode; const S: string): TTreeNode;
      function AddChildFirst(Node: TTreeNode; const S: string): TTreeNode;
      function AddChildObject(Node: TTreeNode; const S: string; Ptr: Pointer): TTreeNode;
      function AddChildObjectFirst(Node: TTreeNode; const S: string; Ptr: Pointer): TTreeNode;
      function AddFirst(Node: TTreeNode; const S: string): TTreeNode;
      function AddNode(Node, Relative: TTreeNode; const S: string; Ptr: Pointer; Method: TNodeAttachMode): TTreeNode;
      function AddObject(Node: TTreeNode; const S: string; Ptr: Pointer): TTreeNode;
      function AddObjectFirst(Node: TTreeNode; const S: string; Ptr: Pointer): TTreeNode;
      function AlphaSort(ARecurse: Boolean): Boolean;
      procedure Assign(Source: TPersistent);
      procedure BeginUpdate;
      procedure Clear;
      constructor Create(AOwner: TCustomTreeView);
      function CustomSort(SortProc: TTVCompare; Data: Longint): Boolean;
      procedure Delete(Node: TTreeNode);
      procedure Destroy; override;
      procedure EndUpdate;
      function GetFirstNode: TTreeNode;
      function GetNode(ItemId: HTreeItem): TTreeNode;
      function Insert(Node: TTreeNode; const S: string): TTreeNode;
      function InsertNode(Node, Sibling: TTreeNode; const S: string; Ptr: Pointer): TTreeNode;
      function InsertObject(Node: TTreeNode; const S: string; Ptr: Pointer): TTreeNode;
   end;

   TTreeView = class(TCustomTreeView)
   end;

   TUpDown = class(TCustomUpDown)
   end;

   TWorkArea = class(TCollectionItem)
   public
      property Color: TColor;
      property Rect: TRect;
      constructor Create(Collection: TCollection); override;
      function GetDisplayName: string; override;
      procedure SetDisplayName(const Value: string); override;
   end;

   TWorkAreas = class(TOwnedCollection)
   public
      property Items[Index: Integer]:TWorkArea; default;
      function Add: TWorkArea;
      procedure Delete(Index: Integer);
      function Insert(Index: Integer): TWorkArea;
   end;

   procedure CheckToolMenuDropdown(ToolButton: TToolButton);
   function GetComCtlVersion: Integer;
   function InitCommonControl(CC: Integer): Boolean;

implementation
end.












