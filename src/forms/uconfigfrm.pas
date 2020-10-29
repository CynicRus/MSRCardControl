unit uconfigfrm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Spin,
  uconfig, uautorun;

type

  { TConfigFrm }

  TConfigFrm = class(TForm)
    okBtn: TButton;
    autorunChBox: TCheckBox;
    HideOnStartBox: TCheckBox;
    KeyNameBox: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    procedure autorunChBoxClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure HideOnStartBoxClick(Sender: TObject);
    procedure okBtnClick(Sender: TObject);
  private

  public

  end;

var
  ConfigFrm: TConfigFrm;

implementation

{$R *.lfm}

{ TConfigFrm }

procedure TConfigFrm.FormShow(Sender: TObject);
var
  i: integer;
begin
  KeyNameBox.ReadOnly:=true;
  if KeyNameBox.Items.Count = 0 then
  begin
    for i := 0 to FKeyNameMap.Count - 1 do
    begin
      KeyNameBox.Items.Add(FKeyNameMap.Data[i]);
    end;
  end;
  KeyNameBox.ItemIndex:= KeyNameBox.Items.IndexOf(Config.StartCutKey);

  SpinEdit1.Value:=Config.LeftSideTrunc;
  SpinEdit2.Value:=Config.RightSideTrunc;

  AutorunChBox.Checked := Config.Autorun;
  HideOnStartBox.Checked := Config.HideOnStart;


end;

procedure TConfigFrm.HideOnStartBoxClick(Sender: TObject);
begin
  Config.HideOnStart:=HideOnStartBox.Checked;
end;

procedure TConfigFrm.autorunChBoxClick(Sender: TObject);
begin
  if autorunChBox.Checked then
  begin
    if CheckLoginItem then
     RemoveLoginItem;
  end else
  begin
    if not CheckLoginItem then
     AddLoginItem;
  end;
  Config.Autorun:=autorunChBox.Checked;
end;

procedure TConfigFrm.okBtnClick(Sender: TObject);
begin
  Config.StartCutKey:=KeyNameBox.Items[KeyNameBox.ItemIndex];
  Config.LeftSideTrunc:=SpinEdit1.Value;
  Config.RightSideTrunc:=SpinEdit2.Value;
  Config.Save;
  Close;
end;

end.

