unit uInterval;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.VirtualImage,
  Vcl.Samples.Spin;

type
  TIntervalForm = class(TForm)
    WarningImage: TVirtualImage;
    WarniingLabel: TLabel;
    SpinEditInterval: TSpinEdit;
    btnOk: TButton;
    lblCheck: TLabel;
    btnCancel: TButton;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IntervalForm: TIntervalForm;

implementation

uses uMain;

{$R *.dfm}

procedure TIntervalForm.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TIntervalForm.btnOkClick(Sender: TObject);
begin
  MainForm.KillTimer.Interval := SpinEditInterval.Value;

  Close;
end;

end.
