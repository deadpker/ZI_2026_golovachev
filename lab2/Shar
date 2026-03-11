program Shar_Lab2;

{$APPTYPE CONSOLE}

uses
  SysUtils, Windows;

const
  UpperAlphabet = 'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ';
  LowerAlphabet = 'абвгдеёжзийклмнопрстуфхцчшщъыьэюя';

function RemoveDuplicates(const S: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(S) do
    if Pos(S[i], Result) = 0 then
      Result := Result + S[i];
end;

function BuildCipherAlphabet(const Key: string): string;
var
  CleanKey, Remaining: string;
  i: Integer;
begin
  CleanKey := RemoveDuplicates(Key);
  Remaining := '';

  for i := 1 to Length(UpperAlphabet) do
    if Pos(UpperAlphabet[i], CleanKey) = 0 then
      Remaining := Remaining + UpperAlphabet[i];

  Result := CleanKey + Remaining;
end;

function Encrypt(const Text, Key: string): string;
var
  CipherUpper, CipherLower: string;
  i, Index: Integer;
  Ch: Char;
begin
  CipherUpper := BuildCipherAlphabet(UpperCase(Key));
  CipherLower := LowerCase(CipherUpper);

  Result := '';

  for i := 1 to Length(Text) do
  begin
    Ch := Text[i];

    Index := Pos(Ch, UpperAlphabet);
    if Index > 0 then
      Result := Result + CipherUpper[Index]
    else
    begin
      Index := Pos(Ch, LowerAlphabet);
      if Index > 0 then
        Result := Result + CipherLower[Index]
      else
        Result := Result + Ch;
    end;
  end;
end;

function Decrypt(const Text, Key: string): string;
var
  CipherUpper, CipherLower: string;
  i, Index: Integer;
  Ch: Char;
begin
  CipherUpper := BuildCipherAlphabet(UpperCase(Key));
  CipherLower := LowerCase(CipherUpper);

  Result := '';

  for i := 1 to Length(Text) do
  begin
    Ch := Text[i];

    Index := Pos(Ch, CipherUpper);
    if Index > 0 then
      Result := Result + UpperAlphabet[Index]
    else
    begin
      Index := Pos(Ch, CipherLower);
      if Index > 0 then
        Result := Result + LowerAlphabet[Index]
      else
        Result := Result + Ch;
    end;
  end;
end;

var
  Key, Text, ResultText: string;
  Choice: Integer;

begin
  SetConsoleOutputCP(1251);
  SetConsoleCP(1251);

  Writeln('ЛОЗУНГОВЫЙ ШИФР');
  Writeln('====================');
  Writeln('1 - Шифрование');
  Writeln('2 - Дешифрование');
  Write('Выберите режим: ');
  Readln(Choice);

  Write('Введите ключ (лозунг): ');
  Readln(Key);

  Write('Введите текст: ');
  Readln(Text);

  case Choice of
    1:
      begin
        ResultText := Encrypt(Text, Key);
        Writeln('Зашифрованный текст: ', ResultText);
      end;
    2:
      begin
        ResultText := Decrypt(Text, Key);
        Writeln('Расшифрованный текст: ', ResultText);
      end;
  else
    Writeln('Неверный выбор режима!');
  end;

  Writeln;
  Writeln('Нажмите Enter для выхода из программы...');
  Readln;
end.
 
