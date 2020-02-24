unit ImgList;
interface
   uses Types, Classes, Graphics;
type
   TDrawingStyle = (dsFocus, dsSelected, dsNormal, dsTransparent);
   TImageType = (itImage, itMask);
   TOverlay = 0..3;
   TResType = (rtBitmap, rtCursor, rtIcon);

   HImageList = THandle;

   TCustomImageList = class;

   TChangeLink = class(TObject)
      property Sender : TCustomImageList;
      procedure Change;
      destructor Destroy;
      property OnChange: TNotifyEvent;
   end;

   TCustomImageList = class(TComponent)
      property AllocBy: Integer;
      property BkColor: TColor;
      property BlendColor: TColor;
      property Count: Integer;
      property DrawingStyle: TDrawingStyle;
      property Handle: HImageList;
      property Height: Integer;
      property ImageType: TImageType;
      property Masked: Boolean;
      property ShareImages: Boolean;
      property Width: Integer;
      function Add(Image, Mask: TBitmap): Integer;
      function AddIcon(Image: TIcon): Integer;
      procedure AddImages(Value: TCustomImageList);
      function AddMasked(Image: TBitmap; MaskColor: TColor): Integer;
      procedure Assign(Source: TPersistent); override;
      procedure Clear;
      constructor Create(AOwner: TComponent); override;
      constructor CreateSize(AWidth, AHeight: Integer);
      procedure Delete(Index: Integer);
      destructor Destroy;
      procedure Draw(Canvas: TCanvas; X, Y, Index: Integer; Enabled: Boolean=True); overload;
      procedure Draw(Canvas: TCanvas; X, Y, Index: Integer; ADrawingStyle: TDrawingStyle; AImageType: TImageType; Enabled: Boolean=True); overload;
      procedure DrawOverlay(Canvas: TCanvas; X, Y: Integer; ImageIndex: Integer; Overlay: TOverlay; Enabled: Boolean = True); overload;
      procedure DrawOverlay(Canvas: TCanvas; X, Y: Integer; ImageIndex: Integer; Overlay: TOverlay; ADrawingStyle: TDrawingStyle; AImageType: TImageType; Enabled: Boolean = True); overload;
      function FileLoad(ResType: TResType; const Name: string; MaskColor: TColor): Boolean;
      procedure GetBitmap(Index: Integer; Image: TBitmap);
      function GetHotSpot: TPoint; virtual;
      procedure GetIcon(Index: Integer; Image: TIcon); overload;
      procedure GetIcon(Index: Integer; Image: TIcon; 
                        ADrawingStyle: TDrawingStyle; AImageType: TImageType); overload;
      function GetImageBitmap: HBITMAP;
      function GetInstRes(Instance: THandle; ResType: TResType; const Name: string; Width: Integer; LoadFlags: TLoadResources; MaskColor: TColor): Boolean; overload;
      function GetInstRes(Instance: THandle; ResType: TResType; ResID: DWORD; Width: Integer; LoadFlags: TLoadResources; MaskColor: TColor): Boolean; overload;
      function GetMaskBitmap: HBITMAP;
      function GetResource(ResType: TResType; const Name: string; Width: Integer; LoadFlags: TLoadResources; MaskColor: TColor): Boolean;
      function HandleAllocated: Boolean;
      procedure Insert(Index: Integer; Image, Mask: TBitmap);
      procedure InsertIcon(Index: Integer; Image: TIcon);
      procedure InsertMasked(Index: Integer; Image: TBitmap; MaskColor: TColor);
      procedure Move(CurIndex, NewIndex: Integer);
      function Overlay(ImageIndex: Integer; Overlay: TOverlay): Boolean;
      procedure RegisterChanges(Value: TChangeLink);
      procedure Replace(Index: Integer; Image, Mask: TBitmap);
      procedure ReplaceIcon(Index: Integer; Image: TIcon);
      procedure ReplaceMasked(Index: Integer; NewImage: TBitmap; MaskColor: TColor);
      function ResInstLoad(Instance: THandle; ResType: TResType; const Name: string; MaskColor: TColor): Boolean;
      procedure UnRegisterChanges(Value: TChangeLink);
      property OnChange: TNotifyEvent;
   protected
      procedure AssignTo(Dest: TPersistent); override;
      procedure change;
      procedure DefineProperties(Filer: TFiler)override;
      procedure DefineProperties(Filer: TFiler)override;
      procedure DoDraw(Index: Integer; Canvas: TCanvas; X, Y: Integer; Style: Cardinal; Enabled: Boolean = True); virtual;
      procedure GetImages(Index: Integer; Image, Mask: TBitmap);
      procedure HandleNeeded;
      procedure Initialize; virtual;
   end;

implementation
end.
