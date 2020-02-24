unit Windows;
interface
   uses Types;
type

  HWND = THandle;

  // tbd - not in doc
  UINT = LongWord;

  TOwnerDrawState = set of (odSelected, odGrayed, odDisabled,
     odChecked, odFocused, odDefault, odHotLight, odInactive, odNoAccel,
     odNoFocusRect, odReserved1, odReserved2, odComboBoxEdit);

  TMsg = packed record
    hwnd: HWND;
    message: UINT;
    wParam: integer;    // tbd - WPARAM, but no doc on this
    lParam: integer;   // tbd - LPARAM, but no doc on this
    time: DWORD;
    pt: TPoint;
  end;

  PSystemTime = ^TSystemTime;
  TSystemTime = record
    wYear: Word;
    wMonth: Word;
    wDayOfWeek: Word;
    wDay: Word;
    wHour: Word;
    wMinute: Word;
    wSecond: Word;
    wMilliseconds: Word;
  end;

  PRTLCriticalSection = ^TRTLCriticalSection;
  TRTLCriticalSection = _RTL_CRITICAL_SECTION;
  _RTL_CRITICAL_SECTION = record
    DebugInfo: integer;  // tbd - PRTLCriticalSectionDebug
    LockCount: Longint;
    RecursionCount: Longint;
    OwningThread: THandle;
    LockSemaphore: THandle;
    Reserved: DWORD;
  end;
implementation
end.










