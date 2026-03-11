program GammaCipherInteractive;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes, Windows;

const
  a = 7;          // множитель
  m = 4096;       // модуль
  Y0 = 502;       // начальное значение

// Процедура гаммирования/расшифровки файла
procedure ProcessFile(const InFileName, OutFileName: string; StartY: Integer);
var
  InStream, OutStream: TFileStream;
  Y: Integer;
  b: Byte;
  GammaByte: Byte;
begin
  InStream := TFileStream.Create(InFileName, fmOpenRead or fmShareDenyWrite);
  try
    OutStream := TFileStream.Create(OutFileName, fmCreate);
    try
      Y := StartY;
      while InStream.Position < InStream.Size do
      begin
        InStream.Read(b, 1);
        GammaByte := Y mod 256;          // младший байт текущего Y
        b := b xor GammaByte;            // наложение гаммы
        OutStream.Write(b, 1);
        Y := (a * Y) mod m;              // следующее состояние генератора
      end;
    finally
      OutStream.Free;
    end;
  finally
    InStream.Free;
  end;
end;

// Вывод меню
procedure ShowMenu;
begin
  Writeln('Выберите действие:');
  Writeln('1. Зашифровать Source.txt');
  Writeln('2. Зашифровать другой файл (ввести имя)');
  Writeln('3. Выход');
  Write('Ваш выбор: ');
end;

var
  Choice: Integer;
  FileName: string;
begin
  // Устанавливаем кодовую страницу консоли для вывода русских букв
  SetConsoleOutputCP(1251);

  try
    repeat
      ShowMenu;
      Readln(Choice);
      case Choice of
        1:
          begin
            if FileExists('Source.txt') then
            begin
              ProcessFile('Source.txt', 'Coded.txt', Y0);
              ProcessFile('Coded.txt', 'DeCoded.txt', Y0);
              Writeln('Готово. Source.txt зашифрован в Coded.txt и затем расшифрован в DeCoded.txt.');
            end
            else
              Writeln('Ошибка: файл Source.txt не найден!');
          end;
        2:
          begin
            Write('Введите имя файла (например, data.txt): ');
            Readln(FileName);
            FileName := Trim(FileName); // удаляем лишние пробелы
            if FileExists(FileName) then
            begin
              ProcessFile(FileName, 'Coded.txt', Y0);
              ProcessFile('Coded.txt', 'DeCoded.txt', Y0);
              Writeln('Готово. ', FileName, ' зашифрован в Coded.txt и затем расшифрован в DeCoded.txt.');
            end
            else
              Writeln('Ошибка: файл ', FileName, ' не найден!');
          end;
        3:
          Writeln('Выход из программы.');
        else
          Writeln('Неверный выбор. Пожалуйста, введите 1, 2 или 3.');
      end;
      Writeln; // пустая строка для разделения
    until Choice = 3;
  except
    on E: Exception do
      Writeln('Ошибка: ', E.Message);
  end;
end.
