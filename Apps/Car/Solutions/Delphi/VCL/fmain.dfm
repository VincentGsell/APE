object FormCar: TFormCar
  Left = 0
  Top = 0
  Caption = 'APE on Delphi VCL'
  ClientHeight = 490
  ClientWidth = 777
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyUp = FormKeyUp
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object TimerCarApp: TTimer
    Interval = 10
    OnTimer = TimerCarAppTimer
    Left = 384
    Top = 248
  end
end
