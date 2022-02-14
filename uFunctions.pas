unit uFunctions;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.ComCtrls, System.Actions, Vcl.ActnList, Vcl.ToolWin,
  System.ImageList, Vcl.ImgList, Vcl.Menus, uTaskKill, uNotifications,
  System.Notification, Vcl.VirtualImageList, Vcl.BaseImageCollection;

type
  TFunctions = Class
    function LoadList: bool;
    function PauseResume: bool;
    function ShowHide: bool;
    function AddNew: bool;
    function DeleteSelected: bool;
  End;

var
  mFunctions: TFunctions;

implementation

uses uMain;

function TFunctions.LoadList: LongBool;
var
  Itm: TListItem;
  i: integer;
begin
  listFileName := ChangeFileExt(Application.ExeName, '.lst');
  procList := TStringList.Create;
  if FileExists(listFileName, False) then
  begin
    procList.LoadFromFile(listFileName);
  end;
  MainForm.TaskList.Clear;
  for i := 0 to procList.Count - 1 do
  begin
    Itm := MainForm.TaskList.Items.Add;
    Itm.Caption := (procList.Strings[i]);
    Itm.SubItems.Add('0');
  end;
end;

function TFunctions.PauseResume: LongBool;
begin
  if MainForm.KillTimer.Enabled then
  begin
    MainForm.ActionPause.Caption := sResume;
    MainForm.ActionPause.Hint := sResume;
    MainForm.ActionPause.ImageIndex := 5;
    MainForm.ActionShow.ImageIndex := 8;
    MainForm.StatusBar.Panels[0].Text := sPaused;
    MainForm.Caption := Application.Title + ' - ' + sPaused;
    MainForm.SmallImages.GetIcon(8, Application.Icon);
    MainForm.Icon := Application.Icon;
    MainForm.TrayIcon.Hint := Application.Title + ' - ' + sPaused;
    MainForm.TrayIcon.Visible := False;
    MainForm.TrayIcon.Icon := Application.Icon;
    MainForm.TrayIcon.Visible := True;
    MainForm.KillTimer.Enabled := False;
    MainForm.TaskList.Enabled := False;
  end
  else
  begin
    MainForm.ActionPause.Caption := sPause;
    MainForm.ActionPause.Hint := sPause;
    MainForm.ActionPause.ImageIndex := 6;
    MainForm.ActionShow.ImageIndex := 7;
    MainForm.StatusBar.Panels[0].Text := sReady;
    MainForm.Caption := Application.Title;
    MainForm.SmallImages.GetIcon(7, Application.Icon);
    MainForm.Icon := Application.Icon;
    MainForm.TrayIcon.Hint := Application.Title;
    MainForm.TrayIcon.Visible := False;
    MainForm.TrayIcon.Icon := Application.Icon;
    MainForm.TrayIcon.Visible := True;
    MainForm.KillTimer.Enabled := True;
    MainForm.TaskList.Enabled := True;
  end;
end;

function TFunctions.ShowHide: LongBool;
begin
  if MainForm.Visible then
  begin
    MainForm.ActionShow.Caption := sShow;
    MainForm.TrayIcon.Icon := Application.Icon;
    MainForm.WindowState := wsMinimized;
    Sleep(150);
    MainForm.Visible := False;
    mNotification.ShowMinimizedNotification(mMinimizeNtification);
  end
  else
  begin
    MainForm.ActionShow.Caption := sHide;
    MainForm.TrayIcon.Icon := Application.Icon;
    MainForm.Visible := True;
    MainForm.WindowState := wsNormal;
    Application.BringToFront();
  end;
end;

function TFunctions.AddNew: LongBool;
var
  mNew: String;
  Itm: TListItem;
begin
  if InputQuery('Add New', 'Enter process name to kill:', mNew) then
  begin
    if mNew > '' then
    begin
      procList.Add(mNew);
      procList.SaveToFile(listFileName);
      Itm := MainForm.TaskList.Items.Add;
      Itm.Caption := (mNew);
      Itm.SubItems.Add('0');
      MessageDlg('"' + mNew + '"' + ' added to kill list!', mtInformation,
        [mbOk], 0, mbOk);
    end
    else
    begin
      MessageDlg('Process name can not be empty!', mtWarning, [mbOk], 0, mbOk);
    end;
  end;
end;

function TFunctions.DeleteSelected: LongBool;
var
  mIndex: Integer;
  mName: string;
begin
  mIndex := MainForm.TaskList.ItemIndex;
  mName := MainForm.TaskList.Items.Item[mIndex].Caption;
  procList.Delete(mIndex);
  MainForm.TaskList.Items.Delete(mIndex);
  procList.SaveToFile(listFileName);

  MessageDlg('"' + mName + '"' + ' Removed from kill list!', mtInformation,
    [mbOk], 0, mbOk);
end;

end.
