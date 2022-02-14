object IntervalForm: TIntervalForm
  Left = 0
  Top = 0
  ActiveControl = SpinEditInterval
  BorderStyle = bsDialog
  Caption = 'Set Chek Interval'
  ClientHeight = 146
  ClientWidth = 255
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  DesignSize = (
    255
    146)
  PixelsPerInch = 96
  TextHeight = 13
  object WarningImage: TVirtualImage
    Left = 8
    Top = 8
    Width = 33
    Height = 33
    ImageWidth = 0
    ImageHeight = 0
    ImageIndex = -1
  end
  object WarniingLabel: TLabel
    Left = 56
    Top = 8
    Width = 191
    Height = 41
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Warning! : Smaller number of "Check Interval", will increase mai' +
      'n CPU usage!'
    WordWrap = True
    ExplicitWidth = 210
  end
  object lblCheck: TLabel
    Left = 8
    Top = 58
    Width = 69
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Chek Interval:'
    ExplicitTop = 67
  end
  object SpinEditInterval: TSpinEdit
    Left = 8
    Top = 77
    Width = 239
    Height = 22
    Anchors = [akLeft, akRight, akBottom]
    Increment = 10
    MaxValue = 10000
    MinValue = 10
    TabOrder = 0
    Value = 10
  end
  object btnOk: TButton
    Left = 91
    Top = 113
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Ok'
    Default = True
    TabOrder = 1
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 172
    Top = 113
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 2
    OnClick = btnCancelClick
  end
end
