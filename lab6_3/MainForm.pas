unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    edtKey: TEdit;
    btnEncrypt: TButton;
    btnDecrypt: TButton;
    procedure btnEncryptClick(Sender: TObject);
    procedure btnDecryptClick(Sender: TObject);
  private
    function KeyToY0(const Key: string): Integer;
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

// Преобразование ключа в начальное значение Y0 (0..m-1)
function TForm1.KeyToY0(const Key: string): Integer;
var
  i: Integer;
  h: Integer;
begin
  h := 0;
  for i := 1 to Length(Key) do
    h := (h * 31 + Ord(Key[i])) mod m;
  Result := h;
end;

// Гаммирование массива байт (симметрично)
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

// Универсальная процедура обработки файла (шифрование/дешифрование)
procedure ProcessFile(const InFileName, OutFileName: string; Y0: Integer);
var
  InStream, OutStream: TFileStream;
  Data: TBytes;
begin
  InStream := TFileStream.Create(InFileName, fmOpenRead or fmShareDenyWrite);
  try
    SetLength(Data, InStream.Size);
    InStream.Read(Data[0], InStream.Size);
  finally
    InStream.Free;
  end;

  GammaTransform(Data, Y0);

  OutStream := TFileStream.Create(OutFileName, fmCreate);
  try
    OutStream.Write(Data[0], Length(Data));
  finally
    OutStream.Free;
  end;
end;

// Обработчик кнопки "Зашифровать"
procedure TForm1.btnEncryptClick(Sender: TObject);
var
  Key: string;
  Y0: Integer;
  SourcePath: string;
begin
  Key := Trim(edtKey.Text);
  if Key = '' then
  begin
    ShowMessage('Введите ключ');
    Exit;
  end;

  SourcePath := ExtractFilePath(Application.ExeName) + 'Source.txt';
  if not FileExists(SourcePath) then
  begin
    ShowMessage('Файл Source.txt не найден в папке программы!');
    Exit;
  end;

  Y0 := KeyToY0(Key);
  ProcessFile(SourcePath, ExtractFilePath(Application.ExeName) + 'Coded.txt', Y0);
  ShowMessage('Файл Source.txt зашифрован в Coded.txt');
end;

// Обработчик кнопки "Расшифровать"
procedure TForm1.btnDecryptClick(Sender: TObject);
var
  Key: string;
  Y0: Integer;
  CodedPath: string;
begin
  Key := Trim(edtKey.Text);
  if Key = '' then
  begin
    ShowMessage('Введите ключ');
    Exit;
  end;

  CodedPath := ExtractFilePath(Application.ExeName) + 'Coded.txt';
  if not FileExists(CodedPath) then
  begin
    ShowMessage('Файл Coded.txt не найден. Сначала зашифруйте Source.txt.');
    Exit;
  end;

  Y0 := KeyToY0(Key);
  ProcessFile(CodedPath, ExtractFilePath(Application.ExeName) + 'DeCoded.txt', Y0);
  ShowMessage('Файл Coded.txt расшифрован в DeCoded.txt');
end;

end.
