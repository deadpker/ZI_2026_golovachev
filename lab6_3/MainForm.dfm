object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 411
  ClientWidth = 852
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object edtKey: TEdit
    Left = 160
    Top = 72
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object btnEncrypt: TButton
    Left = 160
    Top = 120
    Width = 105
    Height = 25
    Caption = #1047#1072#1096#1080#1092#1088#1086#1074#1072#1090#1100
    TabOrder = 1
    OnClick = btnEncryptClick
  end
  object btnDecrypt: TButton
    Left = 160
    Top = 167
    Width = 105
    Height = 25
    Caption = #1056#1072#1089#1096#1080#1092#1088#1086#1074#1072#1090#1100
    TabOrder = 2
    OnClick = btnDecryptClick
  end
end
