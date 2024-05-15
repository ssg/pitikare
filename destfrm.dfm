object fDest: TfDest
  Left = 378
  Top = 311
  Width = 249
  Height = 106
  Caption = 'Bird of prey'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 3
    Top = 4
    Width = 104
    Height = 14
    Caption = 'Enter destination path'
  end
  object eDestPath: TEdit
    Left = 3
    Top = 20
    Width = 233
    Height = 22
    TabOrder = 0
  end
  object bOK: TButton
    Left = 3
    Top = 52
    Width = 41
    Height = 23
    Caption = '&Ok'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object bCancel: TButton
    Left = 51
    Top = 52
    Width = 57
    Height = 23
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
