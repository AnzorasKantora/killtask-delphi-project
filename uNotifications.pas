unit uNotifications;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Forms, System.Notification;

type
  TMNotification = class
    function ShowMinimizedNotification(mShow: Boolean): Boolean;
  end;

var
  mNotification: TMNotification;

implementation

// uses - System.Notification;
// Add to main form uses clause - uNotifications;
// usage - mNotification.ShowNotification(Name, Title, Body);

function TMNotification.ShowMinimizedNotification(mShow: Boolean): Boolean;
var
  MyNotification: TNotification;
  NotificationCenter: TNotificationCenter;
  nName, nTitle, nAlertBody: string;
begin

  if mShow then
  begin

    nName := Application.Title;
    nTitle := Application.Title;
    nAlertBody := 'Minimized to system tray!';

    NotificationCenter := TNotificationCenter.Create(Application.MainForm);
    MyNotification := NotificationCenter.CreateNotification;
    try
      MyNotification.Name := nName;
      MyNotification.Title := nTitle;
      MyNotification.AlertBody := nAlertBody;

      NotificationCenter.PresentNotification(MyNotification);
    finally
      MyNotification.Free;
    end;

    Result := False;
  end;

end;

end.
