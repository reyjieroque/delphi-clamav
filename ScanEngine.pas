unit ScanEngine;
// install the clamav signature files on the folder db
// example:
//  
// C:\delphiav       <-- your executable
// C:\delphiav\db    <-- your virus signature


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ClamAV3, ComCtrls, XPMan;

type
  TForm4 = class(TForm)
    OpenDialog1: TOpenDialog;
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    Timer1: TTimer;
    CheckBox1: TCheckBox;
    XPManifest1: TXPManifest;
    StatusBar1: TStatusBar;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4       : TForm4;

implementation
Uses
  DirC;

{$R *.dfm}

var
  isDBLoaded  : Boolean;
  Engine      : cl_engine;
  DirPopup    : TForm1;


procedure TForm4.Button1Click(Sender: TObject);
begin
  //HelloWorld;
  if CheckBox1.Checked then
    begin
      DirPopup := TForm1.Create(nil) ;
      DirPopup.ShowModal;
      DirPopup.Release;
//      if OpenDialog1. then
    end
  else
    begin
      if OpenDialog1.Execute  then
        Edit1.Text := OpenDialog1.FileName;
    end;
end;

function str2pas(C : PChar):String;
begin
 result := String(C);
end;

procedure TForm4.Button2Click(Sender: TObject);
var
//  h : Integer;
  scanme          : String;
  ret             : integer;
  scanned         : Word;
  virname         : PAnsiChar;
  S               : String;
  InfectionCnt    : Integer;
  TotalFiles      : Integer;

      Function __ScanFile(const xfilex: String):Integer;
      begin
        Result := cl_scanfile(PChar(xfilex), @virname, scanned, engine, CL_SCAN_STDOPT);
      end;

      Function __ScanDir(const xdirx: String): Integer;
        var
          Res: TSearchRec;
          EOFound: Boolean;
      begin
        Result := 0;
        InfectionCnt := 0;
        TotalFiles := 0;
        EOFound:= False;
        if FindFirst(xdirx+'\*.*', faAnyFile, Res) < 0 then
          exit
        else
          while not EOFound do
            begin
//              Memo1.Lines.Add(Res.Name) ;
              StatusBar1.Panels[1].Text := '[-] > Scanning - ['+res.Name+']';
              Scanme := Res.Name;
              virname := '';
              TotalFiles := TotalFiles+1;
              ret  := 0;
              ret := __ScanFile(scanme);
              if ret = (CL_CLEAN or CL_SUCCESS) then
                  S := str2pas(cl_strerror(ret))
              else
                begin
                  if ret = CL_VIRUS then
                  begin
                    S:= AnsiString(virname);
                    InfectionCnt := InfectionCnt+1;
                    Memo1.Lines.Add(Res.Name + ' - Infected -> '+ S );
                  end;
                end;
              EOFound:= FindNext(Res) <> 0;
              Application.ProcessMessages;
            end;
        FindClose(Res) ;
        Result := InfectionCnt;
      end;
begin
  if Edit1.Text = '-' then
    Memo1.Lines.Add('Must Select Filename')
  else
    if CheckBox1.Checked then
      begin
        //Memo1.Lines.Add('Not yet implemented.. later :D');
        ret := __ScanDir(Edit1.Text);
        if ret > 0 then
          begin
            Memo1.Lines.Add('-------------------------------');
            Memo1.Lines.Add('Total File(s) Infected > '+IntToStr(ret));
          end;
        //StatusBar1.Panels.Items[0].Text := 'Complete ..';
        Memo1.Lines.Add('Total File(s) Scanned  > '+IntToStr(TotalFiles));
         StatusBar1.Panels[1].Text := 'Scan Complete ..';
        // Label2.Caption := '[-] > Scan Complete..';
      end
    else
      begin
        scanme := PAnsiChar(AnsiString(Edit1.Text));
        virname := '';
        ret  := 0;
        //ret := cl_scandesc(h, @virname, scanned, engine, CL_SCAN_STDOPT);
        //ret := cl_scanfile(ScanMe, @virname, scanned, engine, CL_SCAN_RAW or CL_SCAN_ALGORITHMIC);
        ret := __ScanFile(scanme);
        if ret = (CL_CLEAN or CL_SUCCESS) then
          S := str2pas(cl_strerror(ret))
        else
          if ret = CL_VIRUS then S:= AnsiString(virname);
        Memo1.Lines.Add(Format('Scan --> %s <-- %s',[ExtractFileName(scanme),S]));
      end;
      //Label2.Caption := '[-] > Scan Complete..';
      StatusBar1.Panels[1].Text := 'Scan Complete ..';
end;

procedure TForm4.FormActivate(Sender: TObject);
begin
 isDBLoaded := FALSE;
 Timer1.Enabled := TRUE;
end;

procedure TForm4.Timer1Timer(Sender: TObject);
var
    s   : String;
    ret : Integer;
    sigs : word;
begin
//  Memo1.Lines.Add('timerin');
  if isDBLoaded then
      Timer1.Enabled := FALSE
  else
    begin
      Memo1.Lines.Add('Loading AV-Engine..');
      if not IsClamAVLibPresent then
        begin
          Application.MessageBox('Unable to Load ClamAV Engine','Error');
          Application.Terminate;
        end
      else
        begin
          Memo1.Lines.Add('Verifying AV-Engine..');
          ret := cl_init(CL_INIT_DEFAULT);
          if ret = CL_SUCCESS then
            begin
              Engine := cl_engine_new()^;
              if not Assigned(@Engine) then
                begin
                  Memo1.Lines.Add('Unable to create new AV-Engine');
                end
              else
                begin
                  s := '>>MyScan Engine - ClamAV : ' +Str2Pas(cl_retver);
                  Memo1.Lines.Add(s);
                  sigs :=0;
                  Memo1.Lines.Add('Loading Virus Signature');
                  ret := cl_load(cl_retdbdir, engine, sigs, CL_DB_OFFICIAL);
                  if ret <> CL_SUCCESS then
                    begin
                      Memo1.Lines.Add('Unable to LoadDB');
                      cl_engine_free(engine);
                    end
                  else
                    begin
                      ret :=  cl_engine_compile(engine);
                      if ret = CL_SUCCESS then
                        begin
                          Memo1.Lines.Add('Database Loaded : ('+IntToStr(sigs)+') Signatures');
                          isDBLoaded := TRUE;
                        end
                        else
                        begin
                          Memo1.Lines.Add('Database INIT Error');
                          cl_engine_free(engine);
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

end.
