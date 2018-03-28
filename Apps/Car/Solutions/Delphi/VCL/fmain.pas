unit fmain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uCarLevel, uRenderer.GDI, Vcl.ExtCtrls;

type
  TFormCar = class(TForm)
    TimerCarApp: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure TimerCarAppTimer(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
   { Private declarations }
    function IsKeyDown(k: Char): boolean; Overload;
    function IsKeyDown(w: Word): boolean; Overload;
    Procedure InitKeyboard;

  public
    Keys: array[word] of boolean;
    { Public declarations }
    TheLevel : TLevel;
    Renderer : TGDIRenderer;
  end;

var
  FormCar: TFormCar;

implementation

{$R *.dfm}
procedure TFormCar.FormCreate(Sender: TObject);
begin
  Renderer :=  TGDIRenderer.Create(Canvas);
  TheLevel :=  TLevel.Create(Renderer);
  DoubleBuffered := true;
end;


function TFormCar.IsKeyDown(k: Char): boolean;
var
  w : Word;
begin
  w := ord(upcase(k));
  result := IsKeyDown(w);
end;

function TFormCar.IsKeyDown(w: Word): boolean;
begin
  result := Keys[w];
end;


procedure TFormCar.TimerCarAppTimer(Sender: TObject);
begin
  TimerCarApp.Enabled := false;
  try
    if IsKeyDown('a') then
      TheLevel.aCar.Speed := 0.2
    else if IsKeyDown('d') then
      TheLevel.aCar.Speed := -0.2
    else
      TheLevel.aCar.Speed := 0;

    TheLevel.Progress;
    Invalidate;
  finally
    TimerCarApp.Enabled := true;
  end;
end;


procedure TFormCar.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Keys[Key] := true;
end;

procedure TFormCar.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Keys[Key] := false;
end;

procedure TFormCar.FormPaint(Sender: TObject);
begin
  TheLevel.Render;
end;

procedure TFormCar.InitKeyboard;
var
  i : Word;
begin
  for i := 0 to Length(Keys)-1 do
    Keys[i] := false;
end;



end.
