unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    edtPassword: TEdit;
    btnAccept: TButton;
    pnlMain: TPanel;
    grpFiles: TGroupBox;
    btnEncryptFile: TButton;
    btnDecryptFile: TButton;
    grpText: TGroupBox;
    memSource: TMemo;
    memResult: TMemo;
    btnEncryptText: TButton;
    btnDecryptText: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure btnAcceptClick(Sender: TObject);
    procedure btnEncryptFileClick(Sender: TObject);
    procedure btnDecryptFileClick(Sender: TObject);
    procedure btnEncryptTextClick(Sender: TObject);
    procedure btnDecryptTextClick(Sender: TObject);
  private
    { Private declarations }
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
  Y0 = 502;

// ------------------------------------------------------------
// Вспомогательные функции для шифрования/дешифрования данных
// ------------------------------------------------------------

// Преобразование массива байт гаммированием (симметрично)
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

// Шифрование строки (возвращает строку в UTF-8)
function EncryptString(const S: string; StartY: Integer): string;
var
  Bytes: TBytes;
begin
  Bytes := TEncoding.Default.GetBytes(S);
  GammaTransform(Bytes, StartY);
  Result := TEncoding.Default.GetString(Bytes);
end;

// Дешифрование строки (симметрично)
function DecryptString(const S: string; StartY: Integer): string;
begin
  Result := EncryptString(S, StartY); // операция симметрична
end;

// Процедура обработки файла (шифрование/дешифрование)
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
        GammaByte := Y mod 256;
        b := b xor GammaByte;
        OutStream.Write(b, 1);
        Y := (a * Y) mod m;
      end;
    finally
      OutStream.Free;
    end;
  finally
    InStream.Free;
  end;
end;

// ------------------------------------------------------------
// Обработчики событий
// ------------------------------------------------------------

// Проверка пароля
procedure TForm1.btnAcceptClick(Sender: TObject);
var
  PasswordFilePath: string;
  FileContents: TStringList;
  CorrectPassword: string;
  UserPassword: string;
begin
  try
    PasswordFilePath := ExtractFilePath(Application.ExeName) + 'password.txt';
    if not FileExists(PasswordFilePath) then
    begin
      ShowMessage('Файл пароля password.txt не найден в папке программы!');
      Exit;
    end;

    FileContents := TStringList.Create;
    try
      // Используйте ту кодировку, которая подошла (UTF8 или Default)
      FileContents.LoadFromFile(PasswordFilePath, TEncoding.UTF8); // или TEncoding.Default
      if FileContents.Count > 0 then
        CorrectPassword := Trim(FileContents[0])
      else
        CorrectPassword := '';
    finally
      FileContents.Free;
    end;

    UserPassword := Trim(edtPassword.Text);

    if UserPassword = CorrectPassword then
    begin
      ShowMessage('Удачно');
      pnlMain.Enabled := True;
      btnAccept.Enabled := False;
    end
    else
      ShowMessage('Пароль неверный');
  except
    on E: Exception do
      ShowMessage('Ошибка: ' + E.Message);
  end;
end;

// Шифрование файла Source.txt -> Coded.txt
procedure TForm1.btnEncryptFileClick(Sender: TObject);
var
  SourcePath: string;
begin
  SourcePath := ExtractFilePath(Application.ExeName) + 'Source.txt';
  if not FileExists(SourcePath) then
  begin
    ShowMessage('Файл Source.txt не найден в папке программы!');
    Exit;
  end;

  try
    ProcessFile(SourcePath, ExtractFilePath(Application.ExeName) + 'Coded.txt', Y0);
    ShowMessage('Файл Source.txt зашифрован в Coded.txt');
  except
    on E: Exception do
      ShowMessage('Ошибка: ' + E.Message);
  end;
end;

// Расшифровка файла Coded.txt -> DeCoded.txt
procedure TForm1.btnDecryptFileClick(Sender: TObject);
var
  CodedPath: string;
begin
  CodedPath := ExtractFilePath(Application.ExeName) + 'Coded.txt';
  if not FileExists(CodedPath) then
  begin
    ShowMessage('Файл Coded.txt не найден в папке программы! Сначала зашифруйте Source.txt.');
    Exit;
  end;

  try
    ProcessFile(CodedPath, ExtractFilePath(Application.ExeName) + 'DeCoded.txt', Y0);
    ShowMessage('Файл Coded.txt расшифрован в DeCoded.txt');
  except
    on E: Exception do
      ShowMessage('Ошибка: ' + E.Message);
  end;
end;

// Шифрование текста из memSource в memResult
procedure TForm1.btnEncryptTextClick(Sender: TObject);
begin
  if memSource.Text = '' then
  begin
    ShowMessage('Введите исходный текст для шифрования');
    Exit;
  end;

  try
    memResult.Text := EncryptString(memSource.Text, Y0);
    memSource.Clear;            // <-- очищаем поле исходного текста
    ShowMessage('Текст зашифрован');
  except
    on E: Exception do
      ShowMessage('Ошибка при шифровании текста: ' + E.Message);
  end;
end;

// Расшифровка текста из memResult в memSource
procedure TForm1.btnDecryptTextClick(Sender: TObject);
begin
  if memResult.Text = '' then
  begin
    ShowMessage('Введите зашифрованный текст для расшифровки');
    Exit;
  end;

  try
    memSource.Text := DecryptString(memResult.Text, Y0);
    memResult.Clear;
    ShowMessage('Текст расшифрован');
  except
    on E: Exception do
      ShowMessage('Ошибка при расшифровке текста: ' + E.Message);
  end;
end;

end.
