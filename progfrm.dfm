object fProgress: TfProgress
  Left = 332
  Top = 321
  BorderStyle = bsDialog
  Caption = 'Duh!'
  ClientHeight = 125
  ClientWidth = 243
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 36
    Height = 14
    Caption = 'Current'
  end
  object Label2: TLabel
    Left = 8
    Top = 48
    Width = 34
    Height = 14
    Caption = 'Overall'
  end
  object Bevel1: TBevel
    Left = 6
    Top = 88
    Width = 233
    Height = 9
    Shape = bsTopLine
  end
  object lOverall: TLabel
    Left = 216
    Top = 48
    Width = 21
    Height = 14
    Alignment = taRightJustify
    Caption = '97%'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lCurrent: TLabel
    Left = 210
    Top = 8
    Width = 27
    Height = 14
    Alignment = taRightJustify
    Caption = '100%'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object pbCurrent: TProgressBar
    Left = 8
    Top = 24
    Width = 233
    Height = 16
    Min = 0
    Max = 100
    Smooth = True
    TabOrder = 0
  end
  object pbOverall: TProgressBar
    Left = 6
    Top = 64
    Width = 233
    Height = 16
    Min = 0
    Max = 100
    Smooth = True
    TabOrder = 1
  end
  object bCancel: TButton
    Left = 88
    Top = 96
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 2
  end
  object eCurrent: TEdit
    Left = 48
    Top = 8
    Width = 161
    Height = 14
    TabStop = False
    AutoSize = False
    BorderStyle = bsNone
    Color = clMenu
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    ReadOnly = True
    TabOrder = 3
    Text = 'C:\AUTOEXEC.BAT'
  end
  object tUpdate: TTimer
    Interval = 500
    Left = 8
    Top = 88
  end
end
