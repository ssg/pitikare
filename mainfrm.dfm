object fMain: TfMain
  Left = 413
  Top = 254
  AutoScroll = False
  Caption = 'Pitikare Commander - Version 0.1 alpha'
  ClientHeight = 452
  ClientWidth = 548
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Menu = mmMain
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object cbConsole: TCoolBar
    Left = 0
    Top = 369
    Width = 548
    Height = 83
    Hint = 'Console'
    Align = alBottom
    AutoSize = True
    Bands = <
      item
        Control = pConsole
        ImageIndex = -1
        MinHeight = 81
        Width = 546
      end>
    DragKind = dkDock
    DragMode = dmAutomatic
    EdgeInner = esNone
    object pConsole: TPanel
      Left = 9
      Top = 0
      Width = 533
      Height = 81
      BevelOuter = bvNone
      Caption = 'pConsole'
      TabOrder = 0
      object memConsole: TMemo
        Left = 0
        Top = 5
        Width = 533
        Height = 71
        TabStop = False
        Anchors = [akLeft, akTop, akRight, akBottom]
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
  object mmMain: TMainMenu
    Left = 8
    Top = 8
    object Dosya1: TMenuItem
      Caption = 'Dosya'
      object Biiileryap1: TMenuItem
        Caption = 'Bi$iiler yap'
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Programdancik1: TMenuItem
        Caption = 'Programdan &cik'
      end
    end
    object Duzen1: TMenuItem
      Caption = 'Duzen'
      object Bunelan1: TMenuItem
        Caption = 'Bu ne lan'
      end
    end
    object Yardim1: TMenuItem
      Caption = 'Yardim'
      object PitikareCommanderHakkinda1: TMenuItem
        Caption = 'Pitikare Commander &Hakkinda'
        OnClick = PitikareCommanderHakkinda1Click
      end
    end
  end
end
