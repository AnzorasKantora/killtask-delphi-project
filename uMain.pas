unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.ComCtrls, System.Actions, Vcl.ActnList, Vcl.ToolWin,
  System.ImageList, Vcl.ImgList, Vcl.Menus, uTaskKill, uNotifications,
  System.Notification, Vcl.VirtualImageList, Vcl.BaseImageCollection,
  Vcl.ImageCollection, Registry;

type
  TMainForm = class(TForm)
    KillTimer: TTimer;
    StatusBar: TStatusBar;
    TaskList: TListView;
    MainActions: TActionList;
    ActionAdd: TAction;
    MainToolBar: TToolBar;
    BtnAdd: TToolButton;
    BtnDelete: TToolButton;
    ActionDelete: TAction;
    MainPopUpMenu: TPopupMenu;
    MenuDelete: TMenuItem;
    N5: TToolButton;
    BtnExit: TToolButton;
    ActionExit: TAction;
    TrayPopupMenu: TPopupMenu;
    TrayIcon: TTrayIcon;
    MenuExit: TMenuItem;
    ActionShow: TAction;
    N1: TMenuItem;
    MenuHide: TMenuItem;
    NotificationCenter: TNotificationCenter;
    ActionPause: TAction;
    BtnPause: TToolButton;
    N6: TToolButton;
    N2: TMenuItem;
    Pause1: TMenuItem;
    ImageCollection: TImageCollection;
    SmallImages: TVirtualImageList;
    MainMenu: TMainMenu;
    MainMenuFile: TMenuItem;
    MainMenuShow: TMenuItem;
    N3: TMenuItem;
    MainMenuPause: TMenuItem;
    N4: TMenuItem;
    MainMenuExit: TMenuItem;
    MainMenuEdit: TMenuItem;
    MainMenuAdd: TMenuItem;
    MainMenuDelete: TMenuItem;
    ActionMinimizeNotification: TAction;
    MainMenuOptions: TMenuItem;
    MainMenuShowNotification: TMenuItem;
    LargeImages: TVirtualImageList;
    N7: TMenuItem;
    MnuCheckInterval: TMenuItem;
    N8: TMenuItem;
    MenuSystemStart: TMenuItem;
    procedure KillTimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ActionAddExecute(Sender: TObject);
    procedure TaskListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure ActionDeleteExecute(Sender: TObject);
    procedure ActionExitExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TrayIconDblClick(Sender: TObject);
    procedure ActionShowExecute(Sender: TObject);
    procedure ActionPauseExecute(Sender: TObject);
    procedure ActionMinimizeNotificationExecute(Sender: TObject);
    procedure MnuCheckIntervalClick(Sender: TObject);
    procedure MenuSystemStartClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  procList: TStringList;
  procName: String;
  killName: String;
  listFileName: String;
  mMinimizeNtification: bool = True;

  sPause, sPaused, sReady, sResume, sShow, sHide: string;

implementation

uses uInterval, uInit, uFunctions;

{$R *.dfm}

procedure TMainForm.ActionAddExecute(Sender: TObject);
begin
  mFunctions.AddNew;
end;

procedure TMainForm.ActionDeleteExecute(Sender: TObject);
begin
  mFunctions.DeleteSelected;
end;

procedure TMainForm.ActionExitExecute(Sender: TObject);
begin
  mInit.SaveConfig;
  Application.Terminate;
end;

procedure TMainForm.ActionMinimizeNotificationExecute(Sender: TObject);
begin
  mMinimizeNtification := ActionMinimizeNotification.Checked;
end;

procedure TMainForm.ActionPauseExecute(Sender: TObject);
begin
  mFunctions.PauseResume;
end;

procedure TMainForm.ActionShowExecute(Sender: TObject);
begin
  mFunctions.ShowHide;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := False;
  ActionShowExecute(Self);
  mInit.SaveConfig;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  sPause := 'Pause';
  sPaused := 'Paused';
  sResume := 'Resume';
  sReady := 'Ready';
  sShow := 'Show';
  sHide := 'Hide';

  mInit.InitApp;
  mInit.LoadConfig;

  ActionMinimizeNotification.Checked := mMinimizeNtification;

  if KillTimer.Enabled then
  begin
    StatusBar.Panels[0].Text := sReady;
  end
  else
  begin
    StatusBar.Panels[0].Text := sPaused;
  end;

  ActionDelete.Enabled := False;
  KillTimer.Enabled := False;

  mFunctions.LoadList;

  KillTimer.Enabled := True;
end;

procedure TMainForm.TaskListSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if Selected then
  begin
    ActionDelete.Enabled := True;
  end
  else
  begin
    ActionDelete.Enabled := False;
  end;
end;

procedure TMainForm.KillTimerTimer(Sender: TObject);
var
  i: Integer;
  Itm: TListItem;
  pValue: Integer;
  cValue: Integer;
begin
  i := 0;
  for i := 0 to procList.Count - 1 do
  begin
    procName := procList.Strings[i];
    if mTaskKill.TaskKill(procName) = 1 then
    begin
      Itm := TaskList.Items.Item[i];
      pValue := StrToInt(Itm.SubItems[0]);
      cValue := pValue + 1;
      Itm.SubItems[0] := IntToStr(cValue);
      TaskList.Items.Item[i].ImageIndex := 1;
    end;
  end;
end;

procedure TMainForm.MenuSystemStartClick(Sender: TObject);
var
  reg: TRegistry;
begin
  if MenuSystemStart.Checked then
  begin
    reg := TRegistry.Create(KEY_ALL_ACCESS or KEY_WOW64_64KEY);
    reg.RootKey := HKEY_CURRENT_USER;
    reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', True);
    reg.WriteString(Application.Title, '"' + Application.ExeName + '"');
    reg.CloseKey();
    reg.Free;
  end
  else
  begin
    reg := TRegistry.Create(KEY_ALL_ACCESS or KEY_WOW64_64KEY);
    reg.RootKey := HKEY_CURRENT_USER;
    reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', True);
    reg.DeleteValue(Application.Title);
    reg.CloseKey();
    reg.Free;
  end;
end;

procedure TMainForm.MnuCheckIntervalClick(Sender: TObject);
begin
  Application.CreateForm(TIntervalForm, IntervalForm);
  IntervalForm.SpinEditInterval.Value := KillTimer.Interval;
  IntervalForm.WarningImage.ImageCollection := ImageCollection;
  IntervalForm.WarningImage.ImageIndex := 9;
  IntervalForm.ShowModal;
end;

procedure TMainForm.TrayIconDblClick(Sender: TObject);
begin
  ActionShowExecute(Self);
end;

end.
