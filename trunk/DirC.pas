unit DirC;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, Outline, DirOutln, StdCtrls, FileCtrl;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    DirectoryListBox1: TDirectoryListBox;
    procedure DirectoryListBox1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure DirectoryListBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
Uses
  ScanEngine;

{$R *.dfm}


procedure TForm1.Button1Click(Sender: TObject);
begin
  Form4.Edit1.Text := Edit1.Text;
  Self.Close;
end;

procedure TForm1.DirectoryListBox1Change(Sender: TObject);
begin
  try
  Edit1.Text := DirectoryListBox1.Directory;
  except
    Application.MessageBox('Open Error (Maybe, User Access Error)','Error')
  end;
end;

procedure TForm1.DirectoryListBox1Click(Sender: TObject);
begin
  try
  Edit1.Text := DirectoryListBox1.Directory;
  except
    Application.MessageBox('Open Error (Maybe, User Access Error)','Error')
  end;
end;

end.
