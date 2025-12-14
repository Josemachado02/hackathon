unit Hackathon;

interface

uses
  System.SysUtils,
  System.TimeSpan,
  System.Diagnostics;

type
  THackathon = class
  private
    function FormatarTempo(const pTempo: TTimeSpan): string;
    procedure ExibirResultado(const pTempo: TTimeSpan);
  protected
    procedure Processar(const pArquivo: string); virtual; abstract;
  public
    procedure RodarDesafio(const pArquivo: string);
  end;

implementation

uses
  Vcl.Dialogs;

function THackathon.FormatarTempo(const pTempo: TTimeSpan): string;
begin
  Result := Format('%.2d:%.2d:%.2d.%.3d', [
    Trunc(pTempo.TotalHours),
    pTempo.Minutes,
    pTempo.Seconds,
    pTempo.Milliseconds
  ]);
end;

procedure THackathon.ExibirResultado(const pTempo: TTimeSpan);
var
  lMensagem: string;
begin
  lMensagem := Format('Tempo Total: %s', [FormatarTempo(pTempo)]);

  if IsConsole then
    Writeln(lMensagem)
  else
    ShowMessage(lMensagem);
end;

procedure THackathon.RodarDesafio(const pArquivo: string);
var
  lStopwatch: TStopwatch;
begin
  lStopwatch := TStopwatch.StartNew();
  try
    Processar(pArquivo);
  finally
    lStopwatch.Stop;
  end;

  ExibirResultado(lStopwatch.Elapsed);
end;

end.
