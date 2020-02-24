// tbd - not documented with other units in help
unit Messages;
interface
type 
  HDC = THandle;
  HMenu = THandle;

  TMessage = packed record
    Msg: Cardinal;
    case Integer of
      0: (
        WParam: Longint;
        LParam: Longint;
        Result: Longint);
      1: (
        WParamLo: Word;
        WParamHi: Word;
        LParamLo: Word;
        LParamHi: Word;
        ResultLo: Word;
        ResultHi: Word);
  end;

  TWMKey = packed record
    Msg: Cardinal;
    CharCode: Word;
    Unused: Word;
    KeyData: Longint;
    Result: Longint;
  end;

  TWMMouse = packed record
    Msg: Cardinal;
    Keys: Longint;
    case Integer of
      0: (
        XPos: Smallint;
        YPos: Smallint);
      1: (
        Pos: TSmallPoint;
        Result: Longint);
  end;

  TWMLButtonDown = TWMMouse;

  TWMPaint = packed record
    Msg: Cardinal;
    DC: HDC;
    Unused: Longint;
    Result: Longint;
  end;

  TWMMenuChar = record
    Msg: Cardinal;
    User: Char;
    Unused: Byte;
    MenuFlag: Word;
    Menu: HMENU;
    Result: Longint;
  end;

  TWMNotify = packed record
    Msg: Cardinal;
    IDCtrl: Longint;
    NMHdr: Integer;    // tbd - PNMHdr, not in doc
    Result: Longint;
  end;
implementation
end.







