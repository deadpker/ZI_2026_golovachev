program MagKvadr;

{$APPTYPE CONSOLE}

uses
  SysUtils, Windows;

type
  TIntMatrix = array of array of Integer;
  TCharMatrix = array of array of Char;

procedure GenerateMagicSquare(var A: TIntMatrix; N: Integer);
var
  i, j, num, newi, newj: Integer;
begin
  for i := 0 to N - 1 do
    for j := 0 to N - 1 do
      A[i][j] := 0;

  i := 0;
  j := N div 2;

  for num := 1 to N * N do
  begin
    A[i][j] := num;

    newi := (i - 1 + N) mod N;
    newj := (j + 1) mod N;

    if A[newi][newj] <> 0 then
      i := (i + 1) mod N
    else
    begin
      i := newi;
      j := newj;
    end;
  end;
end;

procedure PrintMagicSquare(A: TIntMatrix; N: Integer);
var
  i, j: Integer;
begin
  Writeln('Магический квадрат:');
  for i := 0 to N - 1 do
  begin
    for j := 0 to N - 1 do
      Write(A[i][j]:4);
    Writeln;
  end;
  Writeln;
end;

procedure PrintCharMatrix(A: TCharMatrix; N: Integer; Title: string);
var
  i, j: Integer;
begin
  Writeln(Title);
  for i := 0 to N - 1 do
  begin
    for j := 0 to N - 1 do
      Write(A[i][j]:4);
    Writeln;
  end;
  Writeln;
end;

var
  N, i, j, k: Integer;
  Magic: TIntMatrix;
  TextMatrix, EncryptedMatrix: TCharMatrix;
  InputText, EncryptedText, DecryptedText: string;

begin
  SetConsoleOutputCP(1251);
  SetConsoleCP(1251);

  Write('Введите нечётный порядок магического квадрата: ');
  Readln(N);

  if (N <= 0) or (N mod 2 = 0) then
  begin
    Writeln('Ошибка! Нужно нечётное число.');
    Readln;
    Exit;
  end;

  SetLength(Magic, N, N);
  SetLength(TextMatrix, N, N);
  SetLength(EncryptedMatrix, N, N);

  GenerateMagicSquare(Magic, N);
  PrintMagicSquare(Magic, N);

  Write('Введите текст длиной ', N*N, ' символов: ');
  Readln(InputText);

  while Length(InputText) < N*N do
    InputText := InputText + ' ';

  SetLength(InputText, N*N);

  // Исходная таблица
  k := 1;
  for i := 0 to N - 1 do
    for j := 0 to N - 1 do
    begin
      TextMatrix[i][j] := InputText[k];
      Inc(k);
    end;

  PrintCharMatrix(TextMatrix, N, 'Исходная таблица текста:');

  // Шифрование
  SetLength(EncryptedText, N*N);

  for k := 1 to N*N do
    for i := 0 to N - 1 do
      for j := 0 to N - 1 do
        if Magic[i][j] = k then
          EncryptedText[k] := TextMatrix[i][j];

  // Таблица зашифрованного текста
  k := 1;
  for i := 0 to N - 1 do
    for j := 0 to N - 1 do
    begin
      EncryptedMatrix[i][j] := EncryptedText[k];
      Inc(k);
    end;

  PrintCharMatrix(EncryptedMatrix, N, 'Таблица зашифрованного текста:');

  // Расшифровка (без таблицы)
  SetLength(DecryptedText, N*N);

  for k := 1 to N*N do
    for i := 0 to N - 1 do
      for j := 0 to N - 1 do
        if Magic[i][j] = k then
          DecryptedText[(i*N + j) + 1] := EncryptedText[k];

  Writeln('Зашифрованная строка:');
  Writeln(EncryptedText);
  Writeln;

  Writeln('Расшифрованная строка:');
  Writeln(DecryptedText);
  Writeln;

  Writeln('Нажмите Enter для выхода...');
  Readln;
end.
