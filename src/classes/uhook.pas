unit uhook;

{$mode Delphi}

interface

uses
  Classes, SysUtils, LazUTF8, Windows, uconfig;

const
  WM_GET_MESSAGE = WM_USER + 10;
  LLKHF_ALTDOWN = KF_ALTDOWN shr 8;
  //REM_L = 2;
  //REM_R = 18;

type
  PKbdDllHookStruct = ^TKbdDllHookStruct;

  _KBDLLHOOKSTRUCT = record
    vkCode: DWORD;
    scanCode: DWORD;
    flags: DWORD;
    time: DWORD;
    dwExtraInfo: PDWORD;
  end;
  TKbdDllHookStruct = _KBDLLHOOKSTRUCT;


procedure Sethook();
procedure Removehook();
function LowLevelKeyboardProc(nCode: longint; wParam: wParam;
  lParam: lParam): LRESULT; stdcall;
function ToUnicodeEx(wVirtKey, wScanCode: UINT; lpKeyState: PByte;
  pwszBuff: PWideChar; cchBuff: integer; wFlags: UINT; dwhkl: HKL): integer;
  stdcall; external 'user32.dll';

var
  khook: THandle;
  KeyPressTime: longint;
  strData: string;
  AltDown, ShiftDown, CtrlDown, NumLockDown: boolean;
  CharCount: integer = 0;

implementation

uses umain;

function TranslateVirtualKey(VirtualKey: integer): WideString;
begin
  Result := '';
  {$Region 'Translate VirtualKey'}
  case VirtualKey of
    VK_RETURN: Result := sLineBreak;
    VK_TAB: Result := '     ';
    VK_BACK: Result := '[BackSpace]';
    VK_SHIFT: Result := '[Shift]';
    VK_CONTROL: Result := '[Ctrl]';
    VK_MENU: Result := '[Alt]';
    VK_ESCAPE: Result := '[Esc]';
    VK_PAUSE: Result := '[Pause]';
    VK_CAPITAL: Result := '[Caps Lock]';
    VK_PRIOR: Result := '[Page Up]';
    VK_NEXT: Result := '[Page Down]';
    VK_END: Result := '[End]';
    VK_HOME: Result := '[Home]';
    VK_LEFT: Result := '[Left Arrow]';
    VK_UP: Result := '[Up Arrow]';
    VK_RIGHT: Result := '[Right Arrow]';
    VK_DOWN: Result := '[Down Arrow]';
    VK_SELECT: Result := '[Select]';
    VK_PRINT: Result := '[Print Screen]';
    VK_EXECUTE: Result := '[Execute]';
    VK_SNAPSHOT: Result := '[Print]';
    VK_INSERT: Result := '[Ins]';
    VK_DELETE: Result := '[Del]';
    VK_HELP: Result := '[Help]';
    VK_F1: Result := '[F1]';
    VK_F2: Result := '[F2]';
    VK_F3: Result := '[F3]';
    VK_F4: Result := '[F4]';
    VK_F5: Result := '[F5]';
    VK_F6: Result := '[F6]';
    VK_F7: Result := '[F7]';
    VK_F8: Result := '[F8]';
    VK_F9: Result := '[F9]';
    VK_F10: Result := '[F10]';
    VK_F11: Result := '[F11]';
    VK_F12: Result := '[F12]';
    VK_NUMPAD0: Result := '0';
    VK_NUMPAD1: Result := '1';
    VK_NUMPAD2: Result := '2';
    VK_NUMPAD3: Result := '3';
    VK_NUMPAD4: Result := '4';
    VK_NUMPAD5: Result := '5';
    VK_NUMPAD6: Result := '6';
    VK_NUMPAD7: Result := '7';
    VK_NUMPAD8: Result := '8';
    VK_NUMPAD9: Result := '9';
    VK_SEPARATOR: Result := '+';
    VK_SUBTRACT: Result := '-';
    VK_DECIMAL: Result := '.';
    VK_DIVIDE: Result := '/';
    VK_NUMLOCK: Result := '[Num Lock]';
    VK_SCROLL: Result := '[Scroll Lock]';
    VK_PLAY: Result := '[Play]';
    VK_ZOOM: Result := '[Zoom]';
    VK_LWIN,
    VK_RWIN: Result := '[Win Key]';
    VK_APPS: Result := '[Menu]'
  end;
   {$EndRegion}
end;

function GetCharFromVirtualKey(Key: word): string;
var
  keyboardState: TKeyboardState;
  asciiResult: integer;
  keyboardLayout: HKL;
  ActiveWindow: HWND;
  ActiveThreadID: DWord;
  scanCode: integer;
  AChr: array[0..1] of widechar;
  str: string;
begin
  ActiveWindow := GetForegroundWindow;
  ActiveThreadID := GetWindowThreadProcessId(ActiveWindow, nil);
  GetKeyboardState(KeyBoardState);
  KeyBoardLayOut := GetKeyboardLayout(ActiveThreadID);
  //asciiResult := ToUnicodeEx(key, MapVirtualKey(key, 0), keyboardState, @Result[1], 0);

  ScanCode := MapVirtualKeyEx(key, 0, KeyBoardLayOut);
  if ScanCode <> 0 then
  begin
    asciiResult := ToUnicodeEx(key, ScanCode, @KeyBoardState, @Achr,
      SizeOf(Achr), 0, KeyBoardLayOut);
    asciiResult := ToUnicodeEx(key, ScanCode, @KeyBoardState, @Achr,
      SizeOf(Achr), 0, KeyBoardLayOut);
    if asciiResult > 0 then
      Str := AChr;
  end;
  Result := UTF16ToUTF8(str);

end;

procedure Sethook;
const
  WH_KEYBOARD_LL = 13;
begin
  kHook := SetWindowsHookEx(WH_KEYBOARD_LL, LowLevelKeyboardProc, hInstance, 0);
  if (kHook = 0) then
    RaiseLastOSError;
  strData := 'Перехват активирован!';
  PostMessage(MainForm.Handle, WM_GET_MESSAGE, 0, UIntPtr(PChar(strData)));

end;

procedure Removehook;
begin
  // Hooks.Free;
  UnhookWindowsHookEx(kHook);
  strData := 'Перехват остановлен!';
  PostMessage(MainForm.Handle, WM_GET_MESSAGE, 0, UIntPtr(PChar(strData)));
end;
//PostMessage(MainForm.Handle, WM_GET_MESSAGE, 0, UIntPtr(PChar(strData)));
function LowLevelKeyboardProc(nCode: longint; wParam: wParam; lParam: lParam): LRESULT;
  stdcall;
var
  pkbhs: PKbdDllHookStruct;
  AChr: array[0..1] of widechar;
  VirtualKey: integer;
  ScanCode: integer;
  ConvRes: integer;
  ActiveWindow: HWND;
  ActiveThreadID: DWord;
  Str: WideString;
begin
  pkbhs := PKbdDllHookStruct(Pointer(lParam));
  strData := '';
  if nCode = HC_ACTION then
  begin
    VirtualKey := pkbhs^.vkCode;

    Str := '';
    //Alt key, log once on keydown
    if longbool(pkbhs^.flags and LLKHF_ALTDOWN) and (not AltDown) then
    begin
      Str := '[Alt]';
      AltDown := True;
    end;
    if (not longbool(pkbhs^.flags and LLKHF_ALTDOWN)) and (AltDown) then
      AltDown := False;

    //Ctrl key, log once on keydown
    if (wordbool(GetAsyncKeyState(VK_CONTROL) and $8000)) and (not CtrlDown) then
    begin
      Str := '[Ctrl]';
      CtrlDown := True;
    end;
    if (not wordbool(GetAsyncKeyState(VK_CONTROL) and $8000)) and (CtrlDown) then
      CtrlDown := False;

    //Shift key, log once on keydown
    if ((VirtualKey = VK_LSHIFT) or (VirtualKey = VK_RSHIFT)) and (not ShiftDown) then
    begin
      Str := '[Shift]';
      ShiftDown := True;
    end;
    if (wParam = WM_KEYUP) and ((VirtualKey = VK_LSHIFT) or
      (VirtualKey = VK_RSHIFT)) then
      ShiftDown := False;

    //Other Virtual Keys, log once on keydown
    if (wParam = WM_KEYDOWN) and ((VirtualKey <> VK_LMENU) and
      (VirtualKey <> VK_RMENU)) and  //not Alt
      (VirtualKey <> VK_LSHIFT) and (VirtualKey <> VK_RSHIFT) and // not Shift
      (VirtualKey <> VK_LCONTROL) and (VirtualKey <> VK_RCONTROL) then //not Ctrl
    begin
      Str := TranslateVirtualKey(VirtualKey);

      if (CharCount > 0) and (VirtualKey <> GetKeyName(config.StartCutKey)) and (wParam = WM_KEYDOWN) then
      begin
        Inc(CharCount);
        if (NumLockDown) and (CharCount <= Config.LeftSideTrunc) then
        begin
          Result := 1;
          exit;
        end;

        if (NumLockDown) and (CharCount > config.RightSideTrunc) then
        begin
          Result := 1;
          exit;
        end;


      end;


      if (VirtualKey = GetKeyName(config.StartCutKey)) and (wParam = WM_KEYDOWN) then
      begin
        numlockdown := not numlockdown;
        if numlockdown then
          Inc(CharCount)
        else
          CharCount := 0;
      end;

      if Str = '' then
      begin
        Str := GetCharFromVirtualKey(VirtualKey);
      end;
    end;
    //do whatever you have to do with Str, add to memo, write to file, etc...

    strData := str;
    if Str <> '' then
      PostMessage(MainForm.Handle, WM_GET_MESSAGE, 0, UIntPtr(PChar(strData)));
    //fMain.mLog.Text :=  fMain.mLog.Text + UTF16ToUTF8(Str);
  end;

  Result := CallNextHookEx(kHook, nCode, wParam, lParam);

end;

end.
