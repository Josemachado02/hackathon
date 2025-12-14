program GeradorArquivoLimpo;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  GeradorArquivo;

var
  Gerador: TGerador;

begin
  try
    Gerador := TGerador.Create;
    try
      Gerador.RodarDesafio('C:\Temp\Hackathon_Input.txt');
    finally
      Gerador.Free;
    end;

    Writeln('Processamento finalizado...' + sLineBreak +'Arquivo salvo na pasta: C:\Temp\Hackathon_Resultado.csv');
    Writeln('Pressione ENTER para sair.');
    Readln;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

