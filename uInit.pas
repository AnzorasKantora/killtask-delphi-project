unit uInit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.ComCtrls, System.Actions, System.IniFiles, Vcl.ActnList, Vcl.ToolWin,
  Vcl.ImgList, Vcl.Menus, uNotifications, Registry;

type
  TInit = Class
    procedure InitApp;
    function LoadConfig: bool;
    function SaveConfig: bool;
    function GetConfigFileName: string;
  End;

var
  mInit: TInit;
  sConfigFileName: string;
  mIniFile: TIniFile;

implementation

uses uMain;

// Set configuration file name
function TInit.GetConfigFileName: string;
begin
  sConfigFileName := ChangeFileExt(Application.ExeName, '.conf');
  Result := sConfigFileName;
end;

// Initialize application
procedure TInit.InitApp;
begin
  MainForm.TrayIcon.Icon := Application.Icon;
  MainForm.TrayIcon.Visible := True;
  MainForm.Caption := Application.Title;
  MainForm.BorderIcons := MainForm.BorderIcons - [biMaximize];

  MainForm.StatusBar.Panels[1].Text := '© Anzoras Kantora.';
end;

// Load configuration
function TInit.LoadConfig: LongBool;
var
  reg: TRegistry;
begin
  if FileExists(GetConfigFileName, False) then
  begin
    mIniFile := TIniFile.Create(GetConfigFileName);
    MainForm.Top := mIniFile.ReadInteger('MAIN', 'Top', 50);
    MainForm.Left := mIniFile.ReadInteger('MAIN', 'Left', 50);
    MainForm.Width := mIniFile.ReadInteger('MAIN', 'Width', 433);
    MainForm.Height := mIniFile.ReadInteger('MAIN', 'Height', 351);
    // mMinimized := mIniFile.ReadBool('SYSTEMTRAY', 'Minimized', False);
    mMinimizeNtification := mIniFile.ReadBool('NOTIFICATION', 'Minimize', True);
    MainForm.KillTimer.Interval := mIniFile.ReadInteger('CHECK',
      'Interval', 500);
  end
  else
  begin
    MainForm.Width := 433;
    MainForm.Height := 351;
    MainForm.Position := poScreenCenter;;
  end;
  mIniFile.Free;

  reg := TRegistry.Create(KEY_READ);
  reg.RootKey := HKEY_CURRENT_USER;
  reg.Access := KEY_READ;
  reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', False);
  if reg.ValueExists(Application.Title) then
  begin
    MainForm.MenuSystemStart.Checked := True;
  end
  else
  begin
    MainForm.MenuSystemStart.Checked := False;
  end;
  reg.CloseKey();
  reg.Free;
end;

// Save configuration
function TInit.SaveConfig: LongBool;
begin
  mIniFile := TIniFile.Create(GetConfigFileName);
  mIniFile.WriteInteger('MAIN', 'Top', MainForm.Top);
  mIniFile.WriteInteger('MAIN', 'Left', MainForm.Left);
  mIniFile.WriteInteger('MAIN', 'Width', MainForm.Width);
  mIniFile.WriteInteger('MAIN', 'Height', MainForm.Height);
  mIniFile.WriteBool('NOTIFICATION', 'Minimize', mMinimizeNtification);
  // mIniFile.WriteBool('SYSTEMTRAY', 'Minimized', not MainForm.Visible);
  mIniFile.WriteInteger('CHECK', 'Interval', MainForm.KillTimer.Interval);
  mIniFile.Free;
end;

end.
