program Laba1;

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {IPhone_XS_Max};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TIPhone_XS_Max, IPhone_XS_Max);
  Application.Run;
end.
