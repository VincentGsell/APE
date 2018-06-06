unit MainForm;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  uApeEngine, uVector, uRenderer.NativeCanvas, uCar, uBridge, uSurfaces, uCapsule,
  uSwingDoor, uRotator, ExtCtrls, uCarLevel;

type

  { TForm1 }

  TForm1 = class(TForm)
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
    FMouseStartX, FMouseStartY : Integer;
    FKeys: array[word] of boolean;
  public
    { public declarations }
    TheLevel : TLevel;
    Renderer : TNativeCanvasRenderer;

    function IsKeyDown(k : Char) : boolean; overload;
    function IsKeyDown(w : Word) : boolean; overload;
    procedure InitKeyboard;
  end;

var
  Form1: TForm1; 

implementation

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  Renderer :=  TNativeCanvasRenderer.Create(Canvas);
  TheLevel := TLevel.Create(Renderer);
  DoubleBuffered := true;
  InitKeyboard;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  TheLevel.Free;
  Renderer.Free;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  FKeys[key] := true;
end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  FKeys[key] := false;
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FMouseStartX:= X - renderer.OffsetX;
  FMouseStartY:= Y - Renderer.OffsetY;
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if(ssLeft in Shift) then
    Renderer.SetOffset(X-FMouseStartX, Y-FMouseStartY);
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
  TheLevel.Render;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  WindowState := wsMaximized;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := false;
  try
    if IsKeyDown('a') then
      TheLevel.aCar.Speed := 0.1
    else if IsKeyDown('d') then
      TheLevel.aCar.Speed := -0.1
    else
      TheLevel.aCar.Speed := 0;
    TheLevel.Progress;
    Invalidate;
  finally
    Timer1.Enabled := true;
  end;
end;

function TForm1.IsKeyDown(k: Char): boolean;
var
  w : Word;
begin
  w := ord(upcase(k));
  result := IsKeyDown(w);
end;

function TForm1.IsKeyDown(w: Word): boolean;
begin
  result := FKeys[w];
end;

procedure TForm1.InitKeyboard;
var
  i : Word;
begin
  for i := 0 to Length(FKeys)-1 do
    FKeys[i] := false;
end;


initialization
{$I MainForm.lrs}

end.

