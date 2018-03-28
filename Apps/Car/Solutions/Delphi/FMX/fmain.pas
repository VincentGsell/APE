unit fmain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  uCarLevel, uRenderer.FMX;

type
  TFormCar = class(TForm)
    TimerCarApp: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormPaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
    procedure TimerCarAppTimer(Sender: TObject);
  private
    { Private declarations }
    function IsKeyDown(k: Char): boolean; Overload;
    function IsKeyDown(w: Word): boolean; Overload;
    Procedure InitKeyboard;

  public
    Keys: array[word] of boolean;
    { Public declarations }
    TheLevel : TLevel;
    Renderer : TFMXRenderer;
  end;

var
  FormCar: TFormCar;

implementation

{$R *.fmx}

procedure TFormCar.FormCreate(Sender: TObject);
begin
  Renderer :=  TFMXRenderer.Create(Canvas);
  TheLevel :=  TLevel.Create(Renderer);
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

procedure TFormCar.InitKeyboard;
var
  i : Word;
begin
  for i := 0 to Length(Keys)-1 do
    Keys[i] := false;
end;

procedure TFormCar.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  Keys[Ord(UpCase(KeyChar))] := True;
end;

procedure TFormCar.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
begin
  Keys[Ord(UpCase(KeyChar))] := false;
end;

procedure TFormCar.FormPaint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
  if Canvas.BeginScene then
  begin
    TheLevel.Render;
    Canvas.EndScene;
  end;
end;

end.
