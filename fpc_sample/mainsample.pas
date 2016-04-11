unit mainSample;

{$mode delphi}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  clamav3;

{ TForm1 }

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Label2: TLabel;
    Target: TEdit;
    Label1: TLabel;
    M: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
    procedure Log(const Msg : String);
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation
uses
  IniFiles;
{$R *.lfm}

{ TForm1 }

var
    Path,
    s           : String;
    ret         : Integer;
    sigs        : longint;
    isEngineInit,
    isDBLoaded  : Boolean;

procedure TForm1.Log(const Msg: string);
begin
  M.Lines.Add(TimeToStr(Now)+' : '+Msg);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  // Verify Engine..
  if (cl_init(CL_INIT_DEFAULT)=CL_SUCCESS) and
     (not isEngineInit) then
  begin
    Log('AV-Engine ('+External_Library+') Ok..');
    Engine := cl_engine_new();
    // Retrieve the product version
    Log('Product Version : '+StrPas(PAnsiChar(cl_retver)));
    isEngineInit := True;
  end else
  if isEngineInit then
    Log('AV-Engine already loaded..:'+External_Library)
  else
  Log('Unable to verify AV-Engine :'+External_Library);

end;

procedure TForm1.Button2Click(Sender: TObject);
var
  okret : Integer;
begin
  // prevent from reloading database
  okret := 0;
  if (isEngineInit) and (not isDBLoaded) then
  begin
   {$IFDEF Windows}
    // change the path here...
   // Path := 'database';
   {$ENDIF}
     {$IFDEF Linux}
    //for linux return db directory
    Path := cl_retdbdir;
   {$ENDIF}
    if not FileExists(Path+'/main.cvd') then
    begin
      Log('Database Missing [main.cvd], nothing to do..');
      Exit;
    end;
    Log('Loading Virus DB '+Path);
    //---------------------------------------
    try
      if cl_load(PChar(path),cl_engine(Engine^),sigs,CL_DB_OFFICIAL)=CL_SUCCESS then
        //---------------------------------------
        try
          okret :=cl_engine_compile(cl_engine(Engine^));
          Log('Signature Count : '+IntToStr(sigs));
          isDBLoaded := True;
        except
         on E : Exception do
         begin
             Log('E : '+E.Message);
             Log('Unable to LoadDB '+AnsiString(cl_strerror(okret)));
             cl_engine_free(cl_engine(Engine^));
         end;
        end;
        //---------------------------------------
    except
      on E : Exception do
      begin
        Log('Unable to LoadDB '+E.Message);
        cl_engine_free(cl_engine(Engine^));
      end;
    end;
    //---------------------------------------
  end else
    if isDBLoaded then
      Log('DB Already Loaded..')
    else
      Log('Unable to load DB..Check if Engine is loaded..');

end;

procedure TForm1.Button3Click(Sender: TObject);
var
  virname    : PAnsiChar;
  someresult : String;
  scanned    : Word;

      Function __ScanFile(const xfilex: String):Integer;
      begin
        try
          Result := cl_scanfile(PChar(xfilex), @virname, scanned, cl_engine(Engine^), CL_SCAN_STDOPT);
        except
        end;
      end;
begin
  if isDBLoaded and isEngineInit then
  begin
    //if isDirectory.Checked then
   // begin

   // end else
   // begin
      ret := __ScanFile(Target.Text);
      someresult := 'safe..';
      if ret = (CL_CLEAN or CL_SUCCESS) then
         someresult := AnsiString(cl_strerror(ret))
      else
         if ret = CL_VIRUS then someresult:= AnsiString(virname);

      Log(Format('Scanned --> %s <-- %s',[ExtractFileName(Target.Text),someresult]));

    //end;
  end else
    Log('AV-Engine not yet ready..');

end;

procedure TForm1.Button4Click(Sender: TObject);
var
  sigss : DWORD;
begin
    cl_countsigs(PChar(path),CL_COUNTSIGS_ALL,sigss);
    Log('ClamAV cl_countsigs (CL_COUNTSIGS_ALL) : '+intToStr(sigss));
    cl_countsigs(PChar(path),CL_COUNTSIGS_OFFICIAL,sigss);
    Log('ClamAV cl_countsigs (CL_COUNTSIGS_OFFICIAL) : '+intToStr(sigss));
    cl_countsigs(PChar(path),CL_COUNTSIGS_UNOFFICIAL,sigss);
    Log('ClamAV cl_countsigs (CL_COUNTSIGS_UNOFFICIAL) : '+intToStr(sigss));
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  if Assigned(Engine) then
    Log('ClamAV is not available')
  else
    Log('Ready..');
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if isDBLoaded then cl_engine_free(cl_engine(Engine^));
  if Assigned(Engine) then Engine := nil;
  with TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
  begin
      WriteString('SIGNATURE','PATH',Path);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Log('Start');
  if (IsClamAVLibPresent and IsLibraryLoaded) then
    Log('ClamAV library found : '+External_library)
  else
    Log('ClamAV missing : '+External_library);

  ret         := 0;
  sigs        := 0;
  isDBLoaded  := False;
  isEngineInit:= False;

  with TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
  begin
       Path := ReadString('SIGNATURE','PATH','database');
       Close();
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  Log('Checking Engine Instance..');
end;

end.

