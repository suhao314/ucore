unit Dialogs;
interface
   uses SysUtils, Types, Printers, Messages, Classes, Graphics, Forms;
type 
   HWnd = THandle;
   TColorDialogOption = (cdFullOpen, cdPreventFullOpen, cdShowHelp, cdSolidColor, cdAnyColor);
   TColorDialogOptions = set of TColorDialogOption;
   TFDApplyEvent = procedure(Sender: TObject; Wnd: HWND) of object;
   TFileEditStyle = (fsEdit, fsComboBox);
   TFindOption = (frDown, frFindNext, frHideMatchCase, frHideWholeWord, frHideUpDown, frMatchCase, frDisableMatchCase, frDisableUpDown, frDisableWholeWord, frReplace, frReplaceAll, frWholeWord, frShowHelp);
   TFindOptions = set of TFindOption;
   TFontDialogDevice = (fdScreen, fdPrinter, fdBoth);
   TFontDialogOption = (fdAnsiOnly, fdTrueTypeOnly, fdEffects, fdFixedPitchOnly, fdForceFontExist, fdNoFaceSel, fdNoOEMFonts, fdNoSimulations, fdNoSizeSel, fdNoStyleSel, fdNoVectorFonts, fdShowHelp, fdWysiwyg, fdLimitSize, fdScalableOnly, fdApplyButton);
   TFontDialogOptions = set of TFontDialogOption;
   _OFNOTIFYEXA = packed record
      hdr: integer;  // tbd - TNMHdr, but no doc on this
      lpOFN: PString;  // tbd - POpenFilename, but no doc on this
      psf: integer;  // tbd - IShellFolder, but no doc on this
      pidl: Pointer;
   end;
   TOFNotifyExA = _OFNOTIFYEXA;
   TOFNotifyEx = TOFNotifyExA;
   TIncludeItemEvent = procedure(const OFN:TOFNotifyEx; var Include: Boolean) of object;

   TMsgDlgType = (mtWarning, mtError, mtInformation, mtConfirmation, mtCustom);

   TMsgDlgBtn = (mbYes, mbNo, mbOK, mbCancel, mbAbort, mbRetry, mbIgnore, mbAll, mbNoToAll, mbYesToAll, mbHelp);
   TMsgDlgButtons = set of TMsgDlgBtn;

   TOpenOption = (ofReadOnly, ofOverwritePrompt, ofHideReadOnly, ofNoChangeDir, ofShowHelp, ofNoValidate, ofAllowMultiSelect, ofExtensionDifferent, ofPathMustExist, ofFileMustExist, ofCreatePrompt, ofShareAware, ofNoReadOnlyReturn, ofNoTestFileCreate, ofNoNetworkButton, ofNoLongNames, ofOldStyleDialog, ofNoDereferenceLinks, ofEnableIncludeNotify, ofEnableSizing, ofDontAddToRecent, ofForceShowHidden);
   TOpenOptions = set of TOpenOption;
   TOpenOptionEx = (ofExNoPlacesBar);
   TOpenOptionsEx = set of TOpenOptionEx;

   TPageMeasureUnits = (pmDefault, pmMillimeters, pmInches);
   TPageSetupDialogOption = (psoDefaultMinMargins, psoDisableMargins,
                             psoDisableOrientation, psoDisablePagePainting,
                             psoDisablePaper, psoDisablePrinter,
                             psoMargins, psoMinMargins, psoShowHelp, 
                             psoWarning, psoNoNetworkButton);
   TPageSetupDialogOptions = set of TPageSetupDialogOption;
   TPageType = (ptEnvelope, ptPaper);

   TPageSetupBeforePaintEvent = procedure (Sender: TObject; 
                                           PaperSize: SmallInt;
                                           Orientation: TPrinterOrientation;
                                           PageType: TPageType; 
                                           var DoneDrawing: Boolean)
                                           of object;

   TMsgDlgBtn = (mbNone, mbOk, mbCancel, mbYes, mbNo, mbAbort, mbRetry, mbIgnore); 
   TMsgDlgButtons = set of TMsgDlgBtn;
const

  mbYesNoCancel = [mbYes, mbNo, mbCancel];
  mbYesNo = [mbYes, mbNo];
  mbOKCancel = [mbOK, mbCancel];
  mbAbortRetryIgnore = [mbAbort, mbRetry, mbIgnore];

type

   TPaintPageEvent = procedure(Sender: TObject; Canvas: TCanvas; PageRect: TRect; var DoneDrawing: Boolean) of object;
   TPrintDialogOption = (poPrintToFile, poPageNums, poSelection, poWarning, poHelp, poDisablePrintToFile);
   TPrintDialogOptions = set of TPrintDialogOption;
   TPrintRange = (prAllPages, prSelection, prPageNums);

   TCommonDialog = class(TComponent);
   TColorDialog = class(TCommonDialog);
   TFindDialog = class(TCommonDialog);
   TFontDialog = class(TCommonDialog);
   TOpenDialog = class(TCommonDialog);
   TPageSetupDialog = class(TCommonDialog);
   TPrintDialog = class(TCommonDialog);
   TPrinterSetupDialog = class(TCommonDialog);
   TReplaceDialog = class(TFindDialog);
   TSaveDialog = class(TOpenDialog);

   TColorDialog = class(TCommonDialog)
   public
      property Color: TColor;
      property CustomColors: TStrings;
      property Options: TColorDialogOptions;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      function Execute: Boolean; override;
   end;

   TCommonDialog = class(TComponent)
   public
      property Handle: HWnd;
      constructor Create(AOwner: TComponent); override;
      procedure DefaultHandler(var Message); override;
      destructor Destroy; override;
      function Execute: Boolean; virtual; abstract;
   published
      property Ctl3D: Boolean;
      property HelpContext: THelpContext;
   protected
      property Template: PChar;
      procedure DoClose; dynamic;
      procedure DoShow; dynamic;
      property OnClose: TNotifyEvent;
      property OnShow: TNotifyEvent;
      function MessageHook(var Msg: TMessage): Boolean; virtual;
      function TaskModalDialog(DialogFunc: Pointer; var DialogData): Bool; virtual;
      procedure WndProc(var Message: TMessage); virtual;
   end;

   TFindDialog = class(TCommonDialog)
   public
      property Left: Integer;
      property Position: TPoint;
      property Top: Integer;
      procedure CloseDialog;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      function Execute: Boolean; override;
   protected
      property FindText: String;
      property Options: TFindOptions;
      property OnFind: TNotifyEvent;
   end;

   TFontDialog = class(TCommonDialog)
   public
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      function Execute: Boolean; override;
   protected
      property Device: TFontDialogDevice;
      property Font: TFont;
      property MaxFontSize: Integer;
      property MinFontSize: Integer;
      property Options: TFontDialogOptions;
      property OnApply: TFDApplyEvent;
   end;

   TOpenDialog = class(TCommonDialog)
   public
      property FileEditStyle: TFileEditStyle;
      property Files: TStrings;
      property HistoryList: TStrings;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      function Execute: Boolean; override;
   published
      property DefaultExt: String;
      property FileName: TFileName;
      property Filter: String;
      property FilterIndex: Integer;
      property InitialDir: String;
      property Options: TOpenOptions;
      property OptionsEx: TOpenOptionsEx;
      property Title: String;
      property OnCanClose: TCloseQueryEvent;
      property OnFolderChange: TNotifyEvent;
      property OnIncludeItem: TIncludeItemEvent;
      property OnSelectionChange: TNotifyEvent;
      property OnTypeChange: TNotifyEvent;
   protected
      function GetStaticRect: TRect; virtual;
   end;

   TPageSetupDialog = class(TCommonDialog)
   public
      constructor Create(AOwner: TComponent); override;
      function Execute: Boolean; override;
      function GetDefaults: Boolean; override;
   published
      property MarginBottom: Integer;
      property MarginBottom: Integer;
      property MarginRight: Integer;
      property MarginTop: Integer;
      property MinMarginBottom: Integer;
      property MinMarginLeft: Integer;
      property MinMarginRight: Integer;
      property MinMarginTop: Integer;
      property Options: TPageSetupDialogOptions;
      property PageHeight: Integer;
      // Changed from TPageSetupDlg to integer - no docs on this 
      // property PageSetupDlgRec: TPageSetupDlg;
      property PageSetupDlgRec: integer;
      property PageWidth: Integer;
      property Units: TPageMeasureUnits;
      property BeforePaint: TPageSetupBeforePaintEvent;
      property OnDrawEnvStamp: TPaintPageEvent;
      property OnDrawFullPage: TPaintPageEvent;
      property OnDrawGreekText: TPaintPageEvent;
      property OnDrawMargin: TPaintPageEvent;
      property OnDrawMinMargin: TPaintPageEvent;
      property OnDrawRetAddress: TPaintPageEvent;
   end;

   TPrintDialog = class(TCommonDialog)
   public
      function Execute: Boolean; override;
   published
      property Collate: Boolean;
      property Copies: Integer;
      property FromPage: Integer;
      property MaxPage: Integer;
      property MinPage: Integer;
      property Options: TPrintDialogOptions;
      property PrintRange: TPrintRange;
      property PrintToFile: Boolean;
      property ToPage: Integer;
   end;

   TPrinterSetupDialog = class(TCommonDialog)
   public
      function Execute: Boolean; override;
   end;

   TReplaceDialog = class(TFindDialog)
   public
      constructor Create(AOwner: TComponent); override;
   published
      property ReplaceText: String;
      property OnReplace: TNotifyEvent;
   end;

   TSaveDialog = class(TOpenDialog)
   public
      function Execute: Boolean; override;
   end;


const
  mbYesNoCancel = [mbYes, mbNo, mbCancel];
  mbYesAllNoAllCancel = [mbYes, mbYesToAll, mbNo, mbNoToAll, mbCancel];
  mbOKCancel = [mbOK, mbCancel];
  mbAbortRetryIgnore = [mbAbort, mbRetry, mbIgnore];
  mbAbortIgnore = [mbAbort, mbIgnore];


var 
   ForceCurrentDirectory: Boolean = False;

const
   mrOk = 1;
   mrCancel = 2;
   mrYes = 3;
   mrNo = 4;
   mrAbort = 5;
   mrRetry = 6;
   mrIgnore = 7;
   mrAll = 8;
   mrNoToAll = 9;
   mrYesToAll = 10;

function CreateMessageDialog(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons): TForm;
function MessageDlg(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons
; HelpCtx: Longint): Word; overload;
function MessageDlg(const Msg: WideString; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint; DefaultBtn: TMsgDlgBtn = mbNone; Bitmap: TBitmap = nil): Integer; overload;

function MessageDlg(const Caption: WideString; const Msg: WideString; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint; DefaultBtn: TMsgDlgBtn = mbNone; Bitmap: TBitmap = nil): Integer; overload;
function MessageDlg(const Caption: WideString; const Msg: WideString; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer; DefaultBtn: TMsgDlgBtn = mbNone; Bitmap: TBitmap = nil): Integer; overload;

function MessageDlg(const Caption: WideString; const Msg: WideString; DlgType: TMsgDlgType; Button1, Button2, Button3: TMsgDlgBtn; HelpCtx: Longint; X, Y: Integer; DefaultBtn: TMsgDlgBtn = mbNone; Bitmap: TBitmap = nil): Integer; overload;

function MessageDlgPosHelp(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer; const HelpFileName: string): Word;
function PromptForFileName(var AFileName: string; const AFilter: string = ''; const ADefaultExt: string = ''; const ATitle: string = ''; const AInitialDir: string = ''; SaveDialog: Boolean = False): Boolean;

implementation
end.

