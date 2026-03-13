object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 915
  ClientWidth = 1451
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object edtPassword: TEdit
    Left = 200
    Top = 64
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object btnAccept: TButton
    Left = 376
    Top = 62
    Width = 75
    Height = 25
    Caption = #1055#1088#1080#1085#1103#1090#1100
    TabOrder = 1
    OnClick = btnAcceptClick
  end
  object pnlMain: TPanel
    Left = 32
    Top = 200
    Width = 1305
    Height = 521
    Enabled = False
    TabOrder = 2
    object grpFiles: TGroupBox
      Left = 34
      Top = 24
      Width = 377
      Height = 81
      Caption = #1060#1072#1081#1083#1099
      TabOrder = 0
      object btnEncryptFile: TButton
        Left = 24
        Top = 24
        Width = 153
        Height = 25
        Caption = #1047#1072#1096#1080#1092#1088#1086#1074#1072#1090#1100' Source.txt'
        TabOrder = 0
        OnClick = btnEncryptFileClick
      end
      object btnDecryptFile: TButton
        Left = 192
        Top = 24
        Width = 153
        Height = 25
        Caption = #1056#1072#1089#1096#1080#1092#1088#1086#1074#1072#1090#1100' Coded.txt'
        TabOrder = 1
        OnClick = btnDecryptFileClick
      end
    end
    object grpText: TGroupBox
      Left = 34
      Top = 128
      Width = 1247
      Height = 249
      Caption = #1058#1077#1082#1089#1090
      TabOrder = 1
      object Label1: TLabel
        Left = 24
        Top = 24
        Width = 97
        Height = 13
        Caption = #1048#1089#1093#1086#1076#1085#1099#1081' '#1090#1077#1082#1089#1090':'
      end
      object Label2: TLabel
        Left = 280
        Top = 24
        Width = 65
        Height = 13
        Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090':'
      end
      object memSource: TMemo
        Left = 24
        Top = 56
        Width = 185
        Height = 89
        ScrollBars = ssBoth
        TabOrder = 0
      end
      object memResult: TMemo
        Left = 280
        Top = 56
        Width = 185
        Height = 89
        ScrollBars = ssBoth
        TabOrder = 1
      end
      object btnEncryptText: TButton
        Left = 24
        Top = 176
        Width = 153
        Height = 25
        Caption = #1047#1072#1096#1080#1092#1088#1086#1074#1072#1090#1100' '#1090#1077#1082#1089#1090
        TabOrder = 2
        OnClick = btnEncryptTextClick
      end
      object btnDecryptText: TButton
        Left = 280
        Top = 175
        Width = 153
        Height = 25
        Caption = #1056#1072#1089#1096#1080#1092#1088#1086#1074#1072#1090#1100' '#1090#1077#1082#1089#1090
        TabOrder = 3
        OnClick = btnDecryptTextClick
      end
    end
  end
end
