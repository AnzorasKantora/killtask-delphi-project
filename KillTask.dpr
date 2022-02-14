program KillTask;

uses
  Vcl.Forms,
  Windows,
  Dialogs,
  System.UITypes,
  uMain in 'uMain.pas' {MainForm},
  uTaskKill in 'uTaskKill.pas',
  uNotifications in 'uNotifications.pas',
  uInterval in 'uInterval.pas' {IntervalForm},
  uInit in 'uInit.pas',
  uFunctions in 'uFunctions.pas';

var
  Mutex: THandle;
  AppName: String;

{$R *.res}

begin

  AppName := 'KillTask';

  Mutex := CreateMutex(nil, True, 'AharonXXL');
  if (Mutex = 0) or (GetLastError = ERROR_ALREADY_EXISTS) then
  begin

    MessageDlg('"' + AppName + '"' + ' is running!', mtInformation,
      [mbOk], 0, mbOk);

  end
  else
  begin
    Application.Initialize;
    Application.MainFormOnTaskbar := True;
    Application.Title := AppName;
    Application.CreateForm(TMainForm, MainForm);
  //Application.CreateForm(TIntervalForm, IntervalForm);
    Application.Run;
  end;

end.
