unit uautorun;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils {$IFDEF Darwin}, process{$ENDIF} , Forms {$IFDEF Windows}, registry {$ENDIF};

function  CheckLoginItem  :Boolean;
function  AddLoginItem    :Boolean;
function  RemoveLoginItem :Boolean;

implementation


{
  CheckLoginItems

  Returns TRUE if your application already exists in the MacOSX LoginItems or Windows Registry (Current User).
  Application name is derived from the Title in project options.

  Example:    if not CheckLoginItems then AddLoginItem;
}
function CheckLoginItem:Boolean;
{$IFDEF Darwin}
var s:ansistring;
{$ENDIF}
{$IFDEF Windows}
var tmpRegistry:TRegistry;
{$ENDIF}
begin
  {$IFDEF Darwin}
  RunCommand('/usr/bin/osascript',
             ['-e','tell application "System Events" to get the path of every login item'],s);
  CheckLoginItem := (Pos(Application.Title,s)>0);
  {$ENDIF}
  {$IFDEF Windows}
  tmpRegistry:=TRegistry.Create;
  CheckLoginItem := false;

  if (Application.Title<>'') and (Application.ExeName<>'') then
    begin
      tmpRegistry.RootKey := HKEY_CURRENT_USER; //Current User settings are stored Here
      if tmpRegistry.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\', False) then
        CheckLoginItem := tmpRegistry.ReadString(Application.Title)<>'';
      tmpRegistry.Free;
    end;
  {$ENDIF}
end;

{
  AddLoginItem

  Adds your application as a login item for MacOSX or registry entry fot Windows and returns the appName as seen in the LoginItems/Registry.
  Application name is derived from the Title in project options.

  Example:    AppName := AddLoginItem;
}
function AddLoginItem:boolean;
{$IFDEF Darwin}
var s:ansistring;
    appName:string;
{$ENDIF}
{$IFDEF Windows}
var tmpRegistry:TRegistry;
{$ENDIF}
begin
  {$IFDEF Darwin}
  appName := Copy(Application.ExeName,0,pos('.app/',Application.ExeName)+3);

  if not CheckLoginItem then
    RunCommand('/usr/bin/osascript',
               ['-e',
                'tell app "System Events" to make login item at end with properties {name: "'+Application.title+
                '", path:"'+appName+'", hidden:true}'],s);

  AddLoginItem:= CheckLoginItem;
  {$ENDIF}
  {$IFDEF Windows}
  tmpRegistry  := TRegistry.Create;
  AddLoginItem := CheckLoginItem;

  if (not AddLoginItem) and (Application.Title<>'') and (Application.ExeName<>'') then
    begin
      tmpRegistry.RootKey := HKEY_CURRENT_USER; //Current User only
      if tmpRegistry.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\', False) then
        begin
          tmpRegistry.WriteString(Application.Title,Application.ExeName);
          AddLoginItem := tmpRegistry.ReadString(Application.Title)=Application.ExeName;
        end;
      tmpRegistry.Free;
    end;
  {$ENDIF}
end;

{
  RemoveLoginItem

  Removes your application as a login item for MacOSX or registry entry for Windows.
  Application name is derived from the Title in project options (Windows) or .app package (MacOSX).

  Example:    RemoveLoginItem;
}
function RemoveLoginItem:boolean;
{$IFDEF Darwin}
var s:ansistring;
{$ENDIF}
{$IFDEF Windows}
var tmpRegistry:TRegistry;
{$ENDIF}
begin
  {$IFDEF Darwin}
  RunCommand('/usr/bin/osascript',
             ['-e',
              'tell app "System Events" to delete login item "'+Application.Title+'"'],s);
  RemoveLoginItem := (s='');
  {$ENDIF}
  {$IFDEF Windows}
  tmpRegistry:=TRegistry.Create;
  RemoveLoginItem := false;

  if Application.Title<>'' then
    begin
      tmpRegistry.RootKey := HKEY_CURRENT_USER; //Current User settings are stored Here
      if tmpRegistry.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\', False) then
        RemoveLoginItem:=tmpRegistry.DeleteValue(Application.Title);
      tmpRegistry.Free;
    end;
  {$ENDIF}
end;

end.

