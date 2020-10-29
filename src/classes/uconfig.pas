unit uconfig;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, inifiles, lcltype, fgl;

const
  ConfigFile = 'config.cfg';

type
  TKeyNameMap = specialize TFPGMap<word, string>;
  { TConfig }

  TConfig = class
  private
    FAutorun: boolean;
    FHideOnStart: boolean;
    FLeftSideTrunc: integer;
    FRightSideTrunc: integer;
    FStartCutKey: string;

  public
    procedure Load;
    procedure Save;
    property LeftSideTrunc: integer read FLeftSideTrunc write FLeftSideTrunc;
    property RightSideTrunc: integer read FRightSideTrunc write FRightSideTrunc;
    property HideOnStart: boolean read FHideOnStart write FHideOnStart;
    property Autorun: boolean read FAutorun write FAutorun;
    property StartCutKey: string read FStartCutKey write FStartCutKey;
    //property TruncBetween: boolean read FTruncBetween write FTruncBetween;
  end;


  function GetKeyName(Value: string): word;
  function GetKeyValue(Name: word): string;

var
  Config: TConfig;
  FKeyNameMap: TKeyNameMap;



implementation

procedure InitKeyMap();
begin
  FKeyNameMap.add(VK_0, '0');
  FKeyNameMap.add(VK_1, '1');
  FKeyNameMap.add(VK_2, '2');
  FKeyNameMap.add(VK_3, '3');
  FKeyNameMap.add(VK_4, '4');
  FKeyNameMap.add(VK_5, '5');
  FKeyNameMap.add(VK_6, '6');
  FKeyNameMap.add(VK_7, '7');
  FKeyNameMap.add(VK_8, '8');
  FKeyNameMap.add(VK_9, '9');
  FKeyNameMap.add(VK_A, 'A');
  FKeyNameMap.add(VK_ACCEPT, 'ACCEPT');
  FKeyNameMap.add(VK_ADD, 'ADD');
  FKeyNameMap.add(VK_APPS, 'APPS');
  FKeyNameMap.add(VK_ATTN, 'ATTN');
  FKeyNameMap.add(VK_B, 'B');
  FKeyNameMap.add(VK_BACK, 'BACK');
  FKeyNameMap.add(VK_BROWSER_BACK, 'BROWSER_BACK');
  FKeyNameMap.add(VK_BROWSER_FAVORITES, 'BROWSER_FAVORITES');
  FKeyNameMap.add(VK_BROWSER_FORWARD, 'BROWSER_FORWARD');
  FKeyNameMap.add(VK_BROWSER_HOME, 'BROWSER_HOME');
  FKeyNameMap.add(VK_BROWSER_REFRESH, 'BROWSER_REFRESH');
  FKeyNameMap.add(VK_BROWSER_SEARCH, 'BROWSER_SEARCH');
  FKeyNameMap.add(VK_BROWSER_STOP, 'BROWSER_STOP');
  FKeyNameMap.add(VK_C, 'C');
  FKeyNameMap.add(VK_CANCEL, 'CANCEL');
  FKeyNameMap.add(VK_CAPITAL, 'CAPITAL');
  FKeyNameMap.add(VK_CLEAR, 'CLEAR');
  FKeyNameMap.add(VK_CONTROL, 'CONTROL');
  FKeyNameMap.add(VK_CONVERT, 'CONVERT');
  FKeyNameMap.add(VK_CRSEL, 'CRSEL');
  FKeyNameMap.add(VK_D, 'D');
  FKeyNameMap.add(VK_DECIMAL, 'DECIMAL');
  FKeyNameMap.add(VK_DELETE, 'DELETE');
  FKeyNameMap.add(VK_DIVIDE, 'DIVIDE');
  FKeyNameMap.add(VK_DOWN, 'DOWN');
  FKeyNameMap.add(VK_E, 'E');
  FKeyNameMap.add(VK_END, 'END');
  FKeyNameMap.add(VK_EREOF, 'EREOF');
  FKeyNameMap.add(VK_ESCAPE, 'ESCAPE');
  FKeyNameMap.add(VK_EXECUTE, 'EXECUTE');
  FKeyNameMap.add(VK_EXSEL, 'EXSEL');
  FKeyNameMap.add(VK_F, 'F');
  FKeyNameMap.add(VK_F1, 'F1');
  FKeyNameMap.add(VK_F10, 'F10');
  FKeyNameMap.add(VK_F11, 'F11');
  FKeyNameMap.add(VK_F12, 'F12');
  FKeyNameMap.add(VK_F13, 'F13');
  FKeyNameMap.add(VK_F14, 'F14');
  FKeyNameMap.add(VK_F15, 'F15');
  FKeyNameMap.add(VK_F16, 'F16');
  FKeyNameMap.add(VK_F17, 'F17');
  FKeyNameMap.add(VK_F18, 'F18');
  FKeyNameMap.add(VK_F19, 'F19');
  FKeyNameMap.add(VK_F2, 'F2');
  FKeyNameMap.add(VK_F20, 'F20');
  FKeyNameMap.add(VK_F21, 'F21');
  FKeyNameMap.add(VK_F22, 'F22');
  FKeyNameMap.add(VK_F23, 'F23');
  FKeyNameMap.add(VK_F24, 'F24');
  FKeyNameMap.add(VK_F3, 'F3');
  FKeyNameMap.add(VK_F4, 'F4');
  FKeyNameMap.add(VK_F5, 'F5');
  FKeyNameMap.add(VK_F6, 'F6');
  FKeyNameMap.add(VK_F7, 'F7');
  FKeyNameMap.add(VK_F8, 'F8');
  FKeyNameMap.add(VK_F9, 'F9');
  FKeyNameMap.add(VK_FINAL, 'FINAL');
  FKeyNameMap.add(VK_G, 'G');
  FKeyNameMap.add(VK_H, 'H');
  FKeyNameMap.add(VK_HANGUL, 'HANGUL');
  FKeyNameMap.add(VK_HANJA, 'HANJA');
  FKeyNameMap.add(VK_HELP, 'HELP');
  FKeyNameMap.add(VK_HIGHESTVALUE, 'HIGHESTVALUE');
  FKeyNameMap.add(VK_HOME, 'HOME');
  FKeyNameMap.add(VK_I, 'I');
  FKeyNameMap.add(VK_INSERT, 'INSERT');
  FKeyNameMap.add(VK_J, 'J');
  FKeyNameMap.add(VK_JUNJA, 'JUNJA');
  FKeyNameMap.add(VK_K, 'K');
  FKeyNameMap.add(VK_KANA, 'KANA');
  FKeyNameMap.add(VK_KANJI, 'KANJI');
  FKeyNameMap.add(VK_L, 'L');
  FKeyNameMap.add(VK_LAUNCH_APP1, 'LAUNCH_APP1');
  FKeyNameMap.add(VK_LAUNCH_APP2, 'LAUNCH_APP2');
  FKeyNameMap.add(VK_LAUNCH_MAIL, 'LAUNCH_MAIL');
  FKeyNameMap.add(VK_LAUNCH_MEDIA_SELECT, 'LAUNCH_MEDIA_SELECT');
  FKeyNameMap.add(VK_LBUTTON, 'LBUTTON');
  FKeyNameMap.add(VK_LCL_ALT, 'LCL_ALT');
  FKeyNameMap.add(VK_LCL_AT, 'LCL_AT');
  FKeyNameMap.add(VK_LCL_BACKSLASH, 'LCL_BACKSLASH');
  FKeyNameMap.add(VK_LCL_CALL, 'LCL_CALL');
  FKeyNameMap.add(VK_LCL_CAPSLOCK, 'LCL_CAPSLOCK');
  FKeyNameMap.add(VK_LCL_CLOSE_BRAKET, 'LCL_CLOSE_BRAKET');
  FKeyNameMap.add(VK_LCL_COMMA, 'LCL_COMMA');
  FKeyNameMap.add(VK_LCL_ENDCALL, 'LCL_ENDCALL');
  FKeyNameMap.add(VK_LCL_EQUAL, 'LCL_EQUAL');
  FKeyNameMap.add(VK_LCL_LALT, 'LCL_LALT');
  FKeyNameMap.add(VK_LCL_MINUS, 'LCL_MINUS');
  FKeyNameMap.add(VK_LCL_OPEN_BRAKET, 'LCL_OPEN_BRAKET');
  FKeyNameMap.add(VK_LCL_POINT, 'LCL_POINT');
  FKeyNameMap.add(VK_LCL_POWER, 'LCL_POWER');
  FKeyNameMap.add(VK_LCL_QUOTE, 'LCL_QUOTE');
  FKeyNameMap.add(VK_LCL_RALT, 'LCL_RALT');
  FKeyNameMap.add(VK_LCL_SEMI_COMMA, 'LCL_SEMI_COMMA');
  FKeyNameMap.add(VK_LCL_SLASH, 'LCL_SLASH');
  FKeyNameMap.add(VK_LCL_TILDE, 'LCL_TILDE');
  FKeyNameMap.add(VK_LCONTROL, 'LCONTROL');
  FKeyNameMap.add(VK_LEFT, 'LEFT');
  FKeyNameMap.add(VK_LMENU, 'LMENU');
  FKeyNameMap.add(VK_LSHIFT, 'LSHIFT');
  FKeyNameMap.add(VK_LWIN, 'LWIN');
  FKeyNameMap.add(VK_M, 'M');
  FKeyNameMap.add(VK_MBUTTON, 'MBUTTON');
  FKeyNameMap.add(VK_MEDIA_NEXT_TRACK, 'MEDIA_NEXT_TRACK');
  FKeyNameMap.add(VK_MEDIA_PLAY_PAUSE, 'MEDIA_PLAY_PAUSE');
  FKeyNameMap.add(VK_MEDIA_PREV_TRACK, 'MEDIA_PREV_TRACK');
  FKeyNameMap.add(VK_MEDIA_STOP, 'MEDIA_STOP');
  FKeyNameMap.add(VK_MENU, 'MENU');
  FKeyNameMap.add(VK_MODECHANGE, 'MODECHANGE');
  FKeyNameMap.add(VK_MULTIPLY, 'MULTIPLY');
  FKeyNameMap.add(VK_N, 'N');
  FKeyNameMap.add(VK_NEXT, 'NEXT');
  FKeyNameMap.add(VK_NONAME, 'NONAME');
  FKeyNameMap.add(VK_NONCONVERT, 'NONCONVERT');
  FKeyNameMap.add(VK_NUMLOCK, 'NUMLOCK');
  FKeyNameMap.add(VK_NUMPAD0, 'NUMPAD0');
  FKeyNameMap.add(VK_NUMPAD1, 'NUMPAD1');
  FKeyNameMap.add(VK_NUMPAD2, 'NUMPAD2');
  FKeyNameMap.add(VK_NUMPAD3, 'NUMPAD3');
  FKeyNameMap.add(VK_NUMPAD4, 'NUMPAD4');
  FKeyNameMap.add(VK_NUMPAD5, 'NUMPAD5');
  FKeyNameMap.add(VK_NUMPAD6, 'NUMPAD6');
  FKeyNameMap.add(VK_NUMPAD7, 'NUMPAD7');
  FKeyNameMap.add(VK_NUMPAD8, 'NUMPAD8');
  FKeyNameMap.add(VK_NUMPAD9, 'NUMPAD9');
  FKeyNameMap.add(VK_O, 'O');
  FKeyNameMap.add(VK_OEM_1, 'OEM_1');
  FKeyNameMap.add(VK_OEM_102, 'OEM_102');
  FKeyNameMap.add(VK_OEM_2, 'OEM_2');
  FKeyNameMap.add(VK_OEM_3, 'OEM_3');
  FKeyNameMap.add(VK_OEM_4, 'OEM_4');
  FKeyNameMap.add(VK_OEM_5, 'OEM_5');
  FKeyNameMap.add(VK_OEM_6, 'OEM_6');
  FKeyNameMap.add(VK_OEM_7, 'OEM_7');
  FKeyNameMap.add(VK_OEM_8, 'OEM_8');
  FKeyNameMap.add(VK_OEM_CLEAR, 'OEM_CLEAR');
  FKeyNameMap.add(VK_OEM_COMMA, 'OEM_COMMA');
  FKeyNameMap.add(VK_OEM_MINUS, 'OEM_MINUS');
  FKeyNameMap.add(VK_OEM_PERIOD, 'OEM_PERIOD');
  FKeyNameMap.add(VK_OEM_PLUS, 'OEM_PLUS');
  FKeyNameMap.add(VK_P, 'P');
  FKeyNameMap.add(VK_PA1, 'PA1');
  FKeyNameMap.add(VK_PAUSE, 'PAUSE');
  FKeyNameMap.add(VK_PLAY, 'PLAY');
  FKeyNameMap.add(VK_PRINT, 'PRINT');
  FKeyNameMap.add(VK_PRIOR, 'PRIOR');
  FKeyNameMap.add(VK_PROCESSKEY, 'PROCESSKEY');
  FKeyNameMap.add(VK_Q, 'Q');
  FKeyNameMap.add(VK_R, 'R');
  FKeyNameMap.add(VK_RBUTTON, 'RBUTTON');
  FKeyNameMap.add(VK_RCONTROL, 'RCONTROL');
  FKeyNameMap.add(VK_RETURN, 'RETURN');
  FKeyNameMap.add(VK_RIGHT, 'RIGHT');
  FKeyNameMap.add(VK_RMENU, 'RMENU');
  FKeyNameMap.add(VK_RSHIFT, 'RSHIFT');
  FKeyNameMap.add(VK_RWIN, 'RWIN');
  FKeyNameMap.add(VK_S, 'S');
  FKeyNameMap.add(VK_SCROLL, 'SCROLL');
  FKeyNameMap.add(VK_SELECT, 'SELECT');
  FKeyNameMap.add(VK_SEPARATOR, 'SEPARATOR');
  FKeyNameMap.add(VK_SHIFT, 'SHIFT');
  FKeyNameMap.add(VK_SLEEP, 'SLEEP');
  FKeyNameMap.add(VK_SNAPSHOT, 'SNAPSHOT');
  FKeyNameMap.add(VK_SPACE, 'SPACE');
  FKeyNameMap.add(VK_SUBTRACT, 'SUBTRACT');
  FKeyNameMap.add(VK_T, 'T');
  FKeyNameMap.add(VK_TAB, 'TAB');
  FKeyNameMap.add(VK_U, 'U');
  FKeyNameMap.add(VK_UNDEFINED, 'UNDEFINED');
  FKeyNameMap.add(VK_UNKNOWN, 'UNKNOWN');
  FKeyNameMap.add(VK_UP, 'UP');
  FKeyNameMap.add(VK_V, 'V');
  FKeyNameMap.add(VK_VOLUME_DOWN, 'VOLUME_DOWN');
  FKeyNameMap.add(VK_VOLUME_MUTE, 'VOLUME_MUTE');
  FKeyNameMap.add(VK_VOLUME_UP, 'VOLUME_UP');
  FKeyNameMap.add(VK_W, 'W');
  FKeyNameMap.add(VK_X, 'X');
  FKeyNameMap.add(VK_XBUTTON1, 'XBUTTON1');
  FKeyNameMap.add(VK_XBUTTON2, 'XBUTTON2');
  FKeyNameMap.add(VK_Y, 'Y');
  FKeyNameMap.add(VK_Z, 'Z');
  FKeyNameMap.add(VK_ZOOM, 'ZOOM');
end;

function GetKeyValue(Name: word): string;
begin
  Result := '';
  if FKeyNameMap.IndexOf(Name) > -1 then
    Result := FKeyNameMap.KeyData[Name];
end;

function GetKeyName(Value: string): word;
var
  i: integer;
begin
  Result := -1;
  for i := 0 to FKeyNameMap.Count - 1 do
  begin
    if FKeyNameMap.Data[i] = Value then
    begin
      Result := FKeyNameMap.Keys[i];
      break;
    end;
  end;
end;

{ TConfig }

procedure TConfig.Load;
var
  Ini: TIniFile;
begin
  Ini := nil;
  Ini := TIniFile.Create(Configfile);
  try
    StartCutKey := Ini.ReadString('app','s_c_key','NUMLOCK');
    LeftSideTrunc := Ini.ReadInteger('app', 'l_trunc', 2);
    RightSideTrunc := Ini.ReadInteger('app', 'r_trunc', 18);
    HideOnStart := Ini.ReadBool('app', 'hide_on_start', False);
    Autorun := Ini.ReadBool('app', 'autorun', True);

  finally
    Ini.Free;
  end;
end;

procedure TConfig.Save;
var
  Ini: TIniFile;
begin
  Ini := nil;
  Ini := TIniFile.Create(Configfile);
  try
    Ini.WriteString('app','s_c_key',StartCutKey);
    Ini.WriteInteger('app', 'l_trunc', LeftSideTrunc);
    Ini.WriteInteger('app', 'r_trunc', RightSideTrunc);
    Ini.WriteBool('app', 'hide_on_start', HideOnStart);
    Ini.WriteBool('app', 'autorun', Autorun);
  finally
    Ini.Free;
  end;
end;

initialization
  Config := TConfig.Create;
  Config.Load;
  FKeyNameMap := TKeyNameMap.Create;
  InitKeyMap();

finalization
  Config.Save;
  Config.Free;
  FKeyNameMap.Free;
end.
