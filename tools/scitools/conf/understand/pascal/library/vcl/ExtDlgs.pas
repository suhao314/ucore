unit ExtDlgs;
interface
   uses Classes, Dialogs;
type
   TOpenPictureDialog = class(TOpenDialog)
   public
      constructor Create(AOwner: TComponent); override;
      function Execute: Boolean; override;
   end;

   TSavePictureDialog = class(TOpenPictureDialog)
   public
      function Execute: Boolean; override;
   end;

implementation
end.
