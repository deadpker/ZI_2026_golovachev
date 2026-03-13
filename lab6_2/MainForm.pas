unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    edtKey: TEdit;
    btnEncryptFile: TButton;
    btnDecryptFile: TButton;
    procedure btnEncryptFileClick(Sender: TObject);
    procedure btnDecryptFileClick(Sender: TObject);
  private
    function CheckKey(const UserKey: string): Boolean;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

const
  a = 7;
  m = 4096;

// Хеш-функция для преобразования ключа в Y0
function KeyToY0(const Key: string): Integer;
var
  i: Integer;
  h: Integer;
begin
  h := 0;
  for i := 1 to Length(Key) do
    h := (h * 31 + Ord(Key[i])) mod m;
  Result := h;
end;

// Гаммирование массива байт
procedure GammaTransform(var Data: TBytes; StartY: Integer);
var
  Y: Integer;
  i: Integer;
  Gamma: Byte;
begin
  Y := StartY;
  for i := 0 to High(Data) do
  begin
    Gamma := Y mod 256;
    Data[i] := Data[i] xor Gamma;
    Y := (a * Y) mod m;
  end;
end;

// Универсальная процедура шифрования/дешифрования файла
procedure ProcessFile(const InFileName, OutFileName: string; const Key: string);
var
  InStream: TFileStream;
  Data: TBytes;
  Y0: Integer;
begin
  InStream := TFileStream.Create(InFileName, fmOpenRead or fmShareDenyWrite);
  try
    SetLength(Data, InStream.Size);
    InStream.Read(Data[0], InStream.Size);
  finally
    InStream.Free;
  end;

  Y0 := KeyToY0(Key);
  GammaTransform(Data, Y0);

  with TFileStream.Create(OutFileName, fmCreate) do
  try
    Write(Data[0], Length(Data));
  finally
    Free;
  end;
end;

// Проверка ключа сравнением с файлом key.txt
function TForm1.CheckKey(const UserKey: string): Boolean;
var
  KeyFilePath: string;
  sl: TStringList;
begin
  Result := False;
  KeyFilePath := ExtractFilePath(Application.ExeName) + 'key.txt';
  if not FileExists(KeyFilePath) then
  begin
    ShowMessage('Файл key.txt не найден в папке программы!');
    Exit;
  end;

  sl := TStringList.Create;
  try
    sl.LoadFromFile(KeyFilePath); // ANSI (по умолчанию)
    if sl.Count > 0 then
      Result := Trim(UserKey) = Trim(sl[0])
    else
      Result := False;
  finally
    sl.Free;
  end;
end;

// Шифрование Source.txt -> Coded.txt
procedure TForm1.btnEncryptFileClick(Sender: TObject);
var
  UserKey: string;
begin
  UserKey := Trim(edtKey.Text);
  if UserKey = '' then
  begin
    ShowMessage('Введите ключ');
    Exit;
  end;

  if not CheckKey(UserKey) then
  begin
    ShowMessage('Неверный ключ');
    Exit;
  end;

  if not FileExists(ExtractFilePath(Application.ExeName) + 'Source.txt') then
  begin
    ShowMessage('Файл Source.txt не найден в папке программы!');
    Exit;
  end;

  try
    ProcessFile(ExtractFilePath(Application.ExeName) + 'Source.txt',
                ExtractFilePath(Application.ExeName) + 'Coded.txt', UserKey);
    ShowMessage('Файл Source.txt зашифрован в Coded.txt');
    edtKey.Text := ''; // очищаем поле
  except
    on E: Exception do
      ShowMessage('Ошибка: ' + E.Message);
  end;
end;

// Расшифровка Coded.txt -> DeCoded.txt
procedure TForm1.btnDecryptFileClick(Sender: TObject);
var
  UserKey: string;
begin
  UserKey := Trim(edtKey.Text);
  if UserKey = '' then
  begin
    ShowMessage('Введите ключ');
    Exit;
  end;

  if not CheckKey(UserKey) then
  begin
    ShowMessage('Неверный ключ');
    Exit;
  end;

  if not FileExists(ExtractFilePath(Application.ExeName) + 'Coded.txt') then
  begin
    ShowMessage('Файл Coded.txt не найден. Сначала зашифруйте Source.txt.');
    Exit;
  end;

  try
    ProcessFile(ExtractFilePath(Application.ExeName) + 'Coded.txt',
                ExtractFilePath(Application.ExeName) + 'DeCoded.txt', UserKey);
    ShowMessage('Файл Coded.txt расшифрован в DeCoded.txt');
    edtKey.Text := ''; // очищаем поле
  except
    on E: Exception do
      ShowMessage('Ошибка: ' + E.Message);
  end;
end;

end.
