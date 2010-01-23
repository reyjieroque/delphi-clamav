object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'Select Folder'
  ClientHeight = 241
  ClientWidth = 417
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 30
    Height = 13
    Caption = 'Folder'
  end
  object Edit1: TEdit
    Left = 8
    Top = 27
    Width = 323
    Height = 21
    TabOrder = 0
    Text = '-'
  end
  object Button1: TButton
    Left = 337
    Top = 25
    Width = 75
    Height = 25
    Caption = 'Okay'
    TabOrder = 1
    OnClick = Button1Click
  end
  object DirectoryListBox1: TDirectoryListBox
    Left = 8
    Top = 54
    Width = 323
    Height = 179
    ItemHeight = 16
    TabOrder = 2
    OnChange = DirectoryListBox1Change
    OnClick = DirectoryListBox1Click
  end
end
