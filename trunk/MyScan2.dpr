program MyScan2;

uses
  Forms,
  ScanEngine in 'ScanEngine.pas' {Form4},
  clamav3 in 'clamav3.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.
