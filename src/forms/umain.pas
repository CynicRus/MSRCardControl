unit umain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, ComCtrls,
  StdCtrls, uhook, LMessages, ExtCtrls, uconfig, uconfigfrm;

type

  { TMainForm }

  TMainForm = class(TForm)
    GroupBox1: TGroupBox;
    ImageList1: TImageList;
    MainMenu1: TMainMenu;
    InfoMemo: TMemo;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    N1: TMenuItem;
    trayMenu: TPopupMenu;
    StatusBar1: TStatusBar;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    TrayIcon: TTrayIcon;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure ToolButton6Click(Sender: TObject);
  private

  public
    procedure OnGetMessageLog(var aMessage: TLMessage);
      message WM_GET_MESSAGE;

  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
begin
  if config.HideOnStart then
  begin
    MainForm.Hide;
    MainForm.ShowInTaskBar := stNever;
    TrayIcon.Show;
    setHook;
  end;
end;

procedure TMainForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caNone;
  MainForm.Hide;
  MainForm.ShowInTaskBar := stNever;
  TrayIcon.Show;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  ToolButton4Click(Sender);
end;

procedure TMainForm.FormShow(Sender: TObject);
begin

end;

procedure TMainForm.MenuItem10Click(Sender: TObject);
begin
  toolbutton1click(Sender);
end;

procedure TMainForm.MenuItem2Click(Sender: TObject);
begin
  toolbutton1click(Sender);
end;

procedure TMainForm.MenuItem4Click(Sender: TObject);
begin
  ToolButton6Click(Sender);
end;

procedure TMainForm.MenuItem8Click(Sender: TObject);
begin
  TrayIcon.Visible := False;
  MainForm.Show;
end;

procedure TMainForm.ToolButton1Click(Sender: TObject);
begin
  application.Terminate;
end;

procedure TMainForm.ToolButton3Click(Sender: TObject);
begin
  setHook;
end;

procedure TMainForm.ToolButton4Click(Sender: TObject);
begin
  removeHook;
end;

procedure TMainForm.ToolButton6Click(Sender: TObject);
begin
  ConfigFrm.ShowModal;
end;

procedure TMainForm.OnGetMessageLog(var aMessage: TLMessage);
begin
  InfoMemo.Lines.Add(PChar(aMessage.LParam));
end;

end.

