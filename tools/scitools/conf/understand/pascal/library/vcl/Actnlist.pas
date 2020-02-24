unit Actnlist;
interface
   uses Messages, Classes, ImgList;
type 
   TActionListState = (asNormal, asSuspended, asSuspendedEnabled);
   TImageIndex = type Integer;
   TLoadResource = (lrDefaultColor, lrDefaultSize, lrFromFile, lrMap3DColors, lrTransparent, lrMonoChrome);
   TLoadResources = set of TLoadResource;


   TActionEvent = procedure (Action: TBasicAction; 
                                 var Handled: Boolean) of object;
   THintEvent = procedure (var HintStr: string; var CanShow: Boolean) of object;

   TContainedAction = class;

   TShortCutList = class(TStringList)
   public
      property ShortCuts[Index: Integer]: TShortCut;
      function Add(const S: string): Integer; override;
      function IndexOfShortCut(const Shortcut: TShortCut): Integer;
   end;


   TCustomActionList = class(TComponent)
   public
      property ActionCount: Integer;
      property Actions[Index: Integer]: TContainedAction;
      property Images: TCustomImageList;
      property State: TActionListState;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      function ExecuteAction(Action: TBasicAction): Boolean; override;
      function IsShortCut(var Message: TWMKey): Boolean;
      function UpdateAction(Action: TBasicAction): Boolean; override;
      property OnStateChange;
   protected
      procedure AddAction(Action: TContainedAction);
      procedure Change; virtual;
      procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
      procedure Notification(AComponent: TComponent; Operation: TOperation); override;
      procedure RemoveAction(Action: TContainedAction);
      procedure SetChildOrder(Component: TComponent; Order: Integer); override;
      procedure SetImages(Value: TCustomImageList); virtual;
      property OnChange: TNotifyEvent;
      property OnExecute: TActionEvent;
      property OnUpdate: TActionEvent;
   end;

   TContainedAction = class(TBasicAction)
   public
      property ActionList: TCustomActionList;
      property Index: Integer;
      destructor Destroy; override;
      function Execute: Boolean; override;
      function GetParentComponent: TComponent; override;
      function HasParent: Boolean; override;
      function Update: Boolean; override;
   published
      property Category: String;
   end;

   TCustomAction = class(TContainedAction)
   public
      property AutoCheck: TShortCutList;
      property Caption: String;
      property Checked: Boolean;
      property DisableIfNoHandler: Boolean;
      property Enabled: Boolean;
      property GroupIndex: Integer;
      property HelpContext: THelpContext;
      property HelpKeyword: string;
      property HelpType: THelpType;
      property Hint: String;
      property ImageIndex: TImageIndex;
      property Name: TComponentName;
      property SecondaryShortCuts: TShortCutList;
      property ShortCut: TShortCut;
      property Visible: Boolean;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      function DoHint(var HintStr: String): Boolean; dynamic;
      function Execute: Boolean; override;
      property OnHint: THintEvent;
   protected
      procedure AssignTo(Dest: TPersistent); override;
      function HandleShortCut: Boolean; virtual;
      procedure SetName(const Value: TComponentName); override;
   end;
   
   TAction = class(TCustomAction)
   public
      constructor Create(AOwner: TComponent); override;
   end;

   TActionLink = class(TBasicActionLink)
   public
   protected
      function IsCaptionLinked: Boolean; virtual;
      function IsCheckedLinked: Boolean; virtual;
      function IsEnabledLinked: Boolean; virtual;
      function IsGroupIndexLinked: Boolean; virtual;
      function IsHelpContextLinked: Boolean; virtual;
      function IsHelpLinked: Boolean; virtual;
      function IsHintLinked: Boolean; virtual;
      function IsImageIndexLinked: Boolean; virtual;
      function IsShortCutLinked: Boolean; virtual;
      function IsShortCutLinked: Boolean; virtual;
      function IsVisibleLinked: Boolean; virtual;
      procedure SetAutoCheck(Value: Boolean); virtual;
      procedure SetCaption(const Value: String); virtual;
      procedure SetChecked(Value: Boolean); virtual;
      procedure SetEnabled(Value: Boolean); virtual;
      procedure SetGroupIndex(Value: Integer); virtual;
      procedure SetHelpContext(Value: THelpContext); virtual;
      procedure SetHelpKeyword(const Value: string); virtual;
      procedure SetHelpType(Value: THelpType); virtual;
      procedure SetHint(const Value: String); virtual;
      procedure SetImageIndex(Value: Integer); virtual;
      procedure SetShortCut(Value: TShortCut); virtual;
      procedure SetVisible(Value: Boolean); virtual;
   end;


   TActionList = class(TCustomActionList)
   end;


      
implementation
end.
      
      
      











