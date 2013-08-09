object Form4: TForm4
  Left = 345
  Top = 222
  BorderStyle = bsToolWindow
  Caption = 'Scanner Proof of Concept - reyjie.u.roque@gmail.com'
  ClientHeight = 227
  ClientWidth = 482
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 42
    Height = 13
    Caption = 'Scan File'
  end
  object Edit1: TEdit
    Left = 8
    Top = 24
    Width = 377
    Height = 21
    TabOrder = 0
    Text = '-'
  end
  object Button1: TButton
    Left = 391
    Top = 20
    Width = 81
    Height = 25
    Caption = 'Search'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 51
    Width = 377
    Height = 150
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object Button2: TButton
    Left = 391
    Top = 51
    Width = 81
    Height = 25
    Caption = 'Scan'
    TabOrder = 3
    OnClick = Button2Click
  end
  object CheckBox1: TCheckBox
    Left = 391
    Top = 82
    Width = 97
    Height = 17
    Caption = 'Directory'
    TabOrder = 4
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 208
    Width = 482
    Height = 19
    Panels = <
      item
        Width = 50
      end
      item
        Width = 50
      end>
  end
  object OpenDialog1: TOpenDialog
    Left = 392
    Top = 136
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = Timer1Timer
    Left = 424
    Top = 168
  end
  object XPManifest1: TXPManifest
    Left = 392
    Top = 168
  end
end
