unit GeradorArquivo;

interface

uses
  System.SysUtils,
  System.Classes,
  Hackathon;

type
  TGerador = class(THackathon)
  protected
    procedure Processar(const pArquivo: string); override;
  end;

implementation

procedure TGerador.Processar(const pArquivo: string);
var
  lArquivoLeitura: TStreamReader;
  lArquivoResultado: TStreamWriter;
  lLinha: string;
  lCursor: PChar;
  lId: Integer;
  lValor: Integer;
  lNome: string;
  lTipo: Char;
  lConteudo: TStringBuilder;
begin
  lArquivoLeitura := TStreamReader.Create(pArquivo, TEncoding.ANSI, False, 1 shl 20);
  lArquivoResultado := TStreamWriter.Create('C:\Temp\Hackathon_resultado.csv', False, TEncoding.ANSI);
  lConteudo := TStringBuilder.Create(1 shl 20);

  try
    lConteudo.AppendLine('ID;NOME;VALOR;TIPO;HASH_ESPERADO');

    while not lArquivoLeitura.EndOfStream do
    begin
      lLinha := lArquivoLeitura.ReadLine;
      if (lLinha = '') or (lLinha[1] = '#') then
        Continue;

      lCursor := PChar(lLinha);

      Inc(lCursor, 3);
      lId := 0;
      while lCursor^ <> '|' do
      begin
        lId := lId * 10 + (Ord(lCursor^) - 48);
        Inc(lCursor);
      end;

      Inc(lCursor);
      Inc(lCursor, 5);
      SetString(lNome, lCursor, 30);
      lNome := TrimRight(lNome);
      Inc(lCursor, 30);

      Inc(lCursor);
      Inc(lCursor, 6);
      lValor := 0;
      while lCursor^ <> '.' do
      begin
        lValor := lValor * 10 + (Ord(lCursor^) - 48);
        Inc(lCursor);
      end;

      Inc(lCursor);
      lValor := lValor * 100 +
        (Ord(lCursor^) - 48) * 10 +
        (Ord((lCursor + 1)^) - 48);

      Inc(lCursor, 3);
      Inc(lCursor);
      Inc(lCursor, 4);
      lTipo := lCursor^;

      lConteudo.Append(lId);
      lConteudo.Append(';');
      lConteudo.Append(lNome);
      lConteudo.Append(';');
      lConteudo.Append(lValor div 100);
      lConteudo.Append('.');
      lConteudo.Append((lValor mod 100).ToString.PadLeft(2, '0'));
      lConteudo.Append(';');
      lConteudo.Append(lTipo);
      lConteudo.Append(';');
      lConteudo.Append(lId + (lValor div 100));
      lConteudo.AppendLine;

      if lConteudo.Length > 500000 then
      begin
        lArquivoResultado.Write(lConteudo.ToString);
        lConteudo.Clear;
      end;
    end;

    if lConteudo.Length > 0 then
      lArquivoResultado.Write(lConteudo.ToString);

  finally
    lArquivoLeitura.Free;
    lArquivoResultado.Free;
    lConteudo.Free;
  end;
end;

end.

