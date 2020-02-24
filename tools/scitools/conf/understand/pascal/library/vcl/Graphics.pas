unit Graphics;
interface
   uses Windows, Types, Classes;
type
   EInvalidGraphic = class(Exception);
   EInvalidGraphicOperation = class(Exception);

   THandle = Integer;
   TBitmapHandleType = (bmDIB, bmDDB);
   TBrushStyle = (bsSolid, bsClear, bsHorizontal, bsVertical, bsFDiagonal, bsBDiagonal, bsCross, bsDiagCross);
   TCanvasOrientation = (coLeftToRight, coRightToLeft);
   TColor = -$7FFFFFFF-1..$7FFFFFFF;
   TCopyMode = Longint;
   TFillStyle = (fsSurface, fsBorder);
   TFontCharSet = 0..255;
   TFontName = type string;
   TFontPitch = (fpDefault, fpVariable, fpFixed);
   TFontStyle = (fsBold, fsItalic, fsUnderline, fsStrikeOut);
   TFontStyles = set of TFontStyle;
   TGetStrProc = procedure(const S: string) of object;
   TPenMode = (pmBlack, pmWhite, pmNop, pmNot, pmCopy, pmNotCopy, pmMergePenNot, pmMaskPenNot, pmMergeNotPen, pmMaskNotPen, pmMerge, pmNotMerge, pmMask, pmNotMask, pmXor, pmNotXor);
   TPenStyle = (psSolid, psDash, psDot, psDashDot, psDashDotDot, psClear, psInsideFrame);
   TPixelFormat = (pfDevice, pf1bit, pf4bit, pf8bit, pf15bit, pf16bit, pf24bit, pf32bit, pfCustom);
   TProgressEvent = procedure (Sender: TObject; Stage: TProgressStage; PercentDone: Byte; RedrawNow: Boolean; const R: TRect; const Msg: string) of object;
   TTransparentMode = (tmAuto, tmFixed);
   TProgressStage = (psStarting, psRunning, psEnding);

   TCanvas = class;
   TFont = class;
   TFontRecall = class;
   TGraphic = class;
   TPen = class;
   TSharedImage = class;

   TGraphicClass = class of TGraphic;

   HBITMAP = THandle;
   HBRUSH = THandle;
   HDC = THandle;
   HENHMETAFILE = THandle;
   HFont = THandle;
   HIcon = THandle;
   HMetafile = THandle;
   HPalette = THandle;
   HPEN = THandle;

   IChangeNotifier = interface
   end;

   TSharedImage = class(TObject)
   end;

   TGraphic = class(TInterfacedPersistent)
   public
      property Empty: Boolean;
      property Height: Integer;
      property Modified: Boolean;
      property Palette: HPALETTE;
      property PaletteModified: Boolean;
      property Transparent: Boolean;
      property Width: Integer;
      procedure LoadFromClipboardFormat(AFormat: Word; AData: THandle; APalette: HPALETTE); virtual; abstract;
      procedure LoadFromFile(const FileName: string); virtual;
      procedure LoadFromStream(Stream: TStream); virtual; abstract;
      procedure SaveToClipboardFormat(var AFormat: Word; var AData: THandle; var APalette: HPALETTE); virtual; abstract;
      procedure SaveToFile(const Filename: string); virtual;
      procedure SaveToStream(Stream: TStream); virtual; abstract;
      property OnChange: TNotifyEvent;
      property OnProgress: TProgressEvent;
   end;

   TBitmap = class(TGraphic)
   public
      property Canvas: TCanvas;
      property Empty: Boolean;
      property Handle: HBitmap;
      property HandleType: TBitmapHandleType;
      property Height: Integer;
      property IgnorePalette: Boolean;
      property MaskHandle: HBitmap;
      property Monochrome: Boolean
      property Palette: HPalette;
      property PixelFormat: TPixelFormat;
      property ScanLine[Row: Integer]: Pointer;
      property TransparentColor: TColor;
      property Transparent: TTransparentMode;
      property Width: Integer;
      procedure Assign(Source: TPersistent); override;
      constructor Create; override;
      destructor Destroy; override;
      procedure Dormant;
      procedure FreeImage;
      function HandleAllocated: Boolean;
      procedure LoadFromClipboardFormat(AFormat: Word; AData: THandle; APalette: HPALETTE); override;
      procedure LoadFromResourceID(Instance: THandle; ResID: Integer);
      procedure LoadFromResourceName(Instance: THandle; const ResName: string);
      procedure LoadFromStream(Stream: TStream); override;
      procedure Mask(TransparentColor: TColor);
      function ReleaseHandle: HBitmap;
      function ReleaseMaskHandle: HBitmap;
      function ReleasePalette: HPalette;
      procedure SaveToClipboardFormat(var AFormat: Word; var AData: THandle; var APalette: HPALETTE); override;
      procedure SaveToStream(Stream: TStream); override;
      property OnChange: TNotifyEvent;
      property OnProgress: TProgressEvent;
   end;

   TBitmapImage = class(TSharedImage)
      destructor Destroy; override;
   end;

   TGraphicsObject = class(TPersistent)
   public
      property OwnerCriticalSection: PRTLCriticalSection;
      function HandleAllocated: Boolean;
      property OnChange: TNotifyEvent;
   protected
      procedure Changed; dynamic;
      procedure Lock;
      procedure Unlock;
   end;

   TBrush = class(TGraphicsObject)
   public
      property Bitmap: TBitmap;
      property Handle: HBRUSH;
      procedure Assign(Source: TPersistent); override;
      constructor Create;
      destructor Destroy; override;
      property OnChange: TNotifyEvent;
   published
      property Color: TColor;
      property Style:TBrushStyle;
   end;

   TBrushRecall = class(TRecall)
      constructor Create(ABrush: TBrush); override;
   end;

   TCanvas = class(TPersistent)
   public
      property CanvasOrientation: TCanvasOrientation;
      property ClipRect: TRect;
      property Handle: HDC;
      property LockCount: Integer;
      property PenPos: TPoint;
      property TextFlags: LongInt;
      procedure Arc(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer);
      procedure BrushCopy(const Dest: TRect; Bitmap: TBitmap; const Source: TRect; Color: TColor);
      procedure Chord(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer);
      procedure CopyRect(const Dest: TRect; Canvas: TCanvas; const Source: TRect);
      constructor Create;
      destructor Destroy; override;
      procedure Draw(X, Y: Integer; Graphic: TGraphic);
      procedure DrawFocusRect(const Rect: TRect);
      procedure Ellipse(X1, Y1, X2, Y2: Integer); overload;
      procedure Ellipse(const Rect: TRect); overload;
      procedure FillRect(const Rect: TRect);
      procedure FloodFill(X, Y: Integer; Color: TColor; FillStyle: TFillStyle);
      procedure FrameRect(const Rect: TRect);
      function HandleAllocated: Boolean;
      procedure LineTo(X, Y: Integer);
      procedure Lock;
      procedure MoveTo(X, Y: Integer);
      procedure Pie(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer);
      procedure PolyBezier(const Points: array of TPoint);
      procedure PolyBezierTo(const Points: array of TPoint);
      procedure Polygon(Points: array of TPoint);
      procedure Polyline(Points: array of TPoint);
      procedure Rectangle(X1, Y1, X2, Y2: Integer); overload;
      procedure Rectangle(const Rect: TRect); overload;
      procedure Refresh;
      procedure RoundRect(X1, Y1, X2, Y2, X3, Y3: Integer);
      procedure StretchDraw(const Rect: TRect; Graphic: TGraphic);
      function TextExtent(const Text: string): TSize;
      function TextHeight(const Text: string): Integer;
      procedure TextOut(X, Y: Integer; const Text: string);
      procedure TextRect(Rect: TRect; X, Y: Integer; const Text: string);
      function TextWidth(const Text: string): Integer;
      function TryLock: Boolean;
      procedure Unlock;
      property OnChange: TNotifyEvent;
      property OnChanging: TNotifyEvent;
   published
      property Brush: TBrush;
      property CopyMode: TCopyMode;
      property Font: TFont;
      property Pen: TPen;
      property Pixels[X, Y: Integer]: TColor;
   end;

   TFont = class(TGraphicsObject)
   public
      property FontAdapter: IChangeNotifier;
      property Handle: HFont;
      property PixelsPerInch: Integer;
      procedure Assign(Source: TPersistent); override;
      constructor Create;
      destructor Destroy; override;
      property OnChange: TNotifyEvent;
   published
      property Charset: TFontCharset;
      property Color: TColor;
      property Height: Integer;
      property Name: TFontName;
      property Pitch: TFontPitch;
      property Size: Integer;
      property Style: TFontStyles;
   end;

   TFontRecall = class(TRecall)
   public
      constructor Create(AFont: TFont); override;
   end;


   TIcon = class(TGraphic)
   public
      property Empty: Boolean;
      property Handle: HIcon;
      property Height: Integer;
      property Transparent: Boolean;
      property Width: Integer;
      procedure Assign(Source: TPersistent); override;
      constructor Create; override;
      destructor Destroy; override;
      function HandleAllocated: Boolean;
      procedure LoadFromClipboardFormat(AFormat: Word; AData: THandle; APalette: HPALETTE); override;
      procedure LoadFromStream(Stream: TStream);
      function ReleaseHandle: HIcon;
      procedure SaveToClipboardFormat(var AFormat: Word; var AData: THandle; var APalette: HPALETTE); override;
      procedure SaveToStream(Stream: TStream);
   end;

   TIconImage = class(TSharedImage)
   public
      destructor Destroy; override;
   end;

   TMetafile = class(TGraphic)
   public
      property CreatedBy: string;
      property Description: string;
      property Empty: Boolean;
      property Enhanced: Boolean;
      property Handle: HMetafile;
      property Height: Integer;
      property Inch: Word;
      property MMHeight: Integer;
      property MMWidth: Integer;
      property Palette: HPalette;
      property Transparent: Boolean;
      property Width: Integer;
      procedure Assign(Source: TPersistent);
      procedure Clear;
      destructor Destroy; override;
      function HandleAllocated: Boolean;
      procedure LoadFromClipboardFormat(AFormat: Word; AData: THandle; APalette: HPALETTE); override;
      procedure LoadFromStream(Stream: TStream); override;
      function ReleaseHandle: HENHMETAFILE;
      procedure SaveToClipboardFormat(var AFormat: Word; var AData: THandle; var APalette: HPALETTE); override;
      procedure SaveToFile(const Filename: String); override;
      procedure SaveToStream(Stream: TStream); override;
      property OnChange: TNotifyEvent;
      property OnProgress: TProgressEvent;
   end;

   TMetafileCanvas = class(TCanvas)
   public
      constructor Create(AMetafile: TMetafile; ReferenceDevice: HDC);
      constructor CreateWithComment(AMetafile: TMetafile; ReferenceDevice: HDC; const CreatedBy, Description: String);
      destructor Destroy; override;
      property OnChange: TNotifyEvent;
      property OnChanging: TNotifyEvent;
   end;

   TMetafileImage = class(TSharedImage)
   public
      destructor Destroy; override;
   end;

   TPicture = class(TInterfacedPersistent)
   public
      property Bitmap: TBitmap;
      property Graphic: TGraphic;
      property Height: Integer;
      property Icon: TIcon;
      property Metafile: TMetafile;
      property PictureAdapter: IChangeNotifier;
      property Width: Integer;
      procedure Assign(Source: TPersistent);
      constructor Create;
      destructor Destroy; override;
      procedure LoadFromClipboardFormat(AFormat: Word; AData: THandle; APalette: HPALETTE);
      procedure LoadFromFile(const Filename: string);
      class procedure RegisterClipboardFormat(AFormat: Word; AGraphicClass: TGraphicClass);
      class procedure RegisterFileFormat(const AExtension, ADescription: string; AGraphicClass: TGraphicClass);
      class procedure RegisterFileFormatRes(const AExtension: String; ADescriptionResID: Integer; AGraphicClass: TGraphicClass);
      procedure SaveToClipboardFormat(var AFormat: Word; var AData: THandle; var APalette: HPALETTE);
      procedure SaveToFile(const Filename: string);
      class function SupportsClipboardFormat(AFormat: Word): Boolean;
      class procedure UnregisterGraphicClass(AClass: TGraphicClass);
      property OnChange: TNotifyEvent;
      property OnProgress: TProgressEvent;
   end;

   TPen = class(TGraphicsObject)
   public
      property Handle: HPen;
      procedure Assign(Source: TPersistent); override;
      constructor Create;
      destructor Destroy; override;
      property OnChange: TNotifyEvent;
   published
      property Color: TColor;
      property Mode: TPenMode;
      property Style: TPenStyle;
      property Width: Integer;
   end;


var DDBsOnly: Boolean = False;
var SystemPalette16: HPalette;

function CharsetToIdent(Charset: Longint; var Ident: string): Boolean;
function CopyPalette(Category: HPALETTE): HPALETTE;
function CreateGrayMappedBmp(Handle: HBITMAP): HBITMAP;
function CreateGrayMappedRes(Instance: THandle; ResName: PChar): HBITMAP;
function CreateMappedBmp(Handle: HBITMAP; const OldColors, NewColors: array of TColor): HBITMAP;
procedure GetCharsetValues(Proc: TGetStrProc);
function GetDefFontCharSet: TFontCharset;
function GetDIB(Bitmap: HBITMAP; Palette: HPALETTE; var BitmapInfo; var Bits): Boolean;
procedure GetDIBSizes(Bitmap: HBITMAP; var InfoHeaderSize: DWord; var ImageSize: DWORD);
function IdentToCharset(const Ident: string; var Charset: Longint): Boolean;
implementation
end.

