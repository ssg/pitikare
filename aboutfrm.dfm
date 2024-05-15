object fAbout: TfAbout
  Left = 279
  Top = 230
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'About'
  ClientHeight = 165
  ClientWidth = 202
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 48
    Width = 165
    Height = 13
    Caption = 'Following filesystems are supported'
  end
  object Label2: TLabel
    Left = 40
    Top = 8
    Width = 94
    Height = 13
    Caption = 'Pitikare Commander'
  end
  object lbFS: TListBox
    Left = 8
    Top = 64
    Width = 169
    Height = 57
    Color = clMenu
    ItemHeight = 13
    TabOrder = 1
  end
  object bClose: TButton
    Left = 8
    Top = 128
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Very &OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
end
