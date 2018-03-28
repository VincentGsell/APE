unit uVector;

interface

type
  PVector = ^TVector;
  TVector = packed record
    x, y : Double;
  end;

function Vector(x, y : Double): TVector;

Function Dot(v1, v2: TVector) : Double;
Function Cross(v1, v2 : TVector) : double;
Function Plus(v1, v2 : TVector) : TVector;
Function PlusEquals(v1: PVector; v2: TVector): TVector;
Function Minus(v1, v2 : TVector) : TVector;
Function MinusEquals(v1: PVector; v2: TVector): TVector;
Function Mult(v : TVector; s : Double) : TVector;
Function MultEquals(v : PVector; s : Double) : TVector;
function DivVector(v : TVector; s : Double) : TVector;
Function DivEquals(v : PVector; s : Double) : TVector;
Function Distance(v1, v2 : TVector) : Double;
Function Times(v1, v2 : TVector) : TVector;
Function Magnitude(v : TVector) : Double;
Function Normalyze(v : TVector) : TVector;

procedure TurnAngle(v : PVector; a : Double);
Procedure ResetAngle(v : PVector);

procedure CopyVector(v1 : PVector; v2 : TVector);

implementation

uses Math;

function Vector(x, y: Double): TVector;
begin
  result.x := x;
  result.y := y;
end;

function Dot(v1, v2: TVector): Double;
begin
  result:= v1.x * v2.x + v1.y * v2.y;
end;

function Cross(v1, v2: TVector): double;
begin
  result:= v1.x * v2.y - v1.y * v2.x;
end;

function Plus(v1, v2: TVector): TVector;
begin
  result := Vector(v1.x+v2.x, v1.y+v2.y);
end;

function PlusEquals(v1: PVector; v2: TVector): TVector;
begin
  v1^.x := v1^.x+v2.x;
  v1^.y := v1^.y+v2.y;
  result := v1^;
end;

function Minus(v1, v2: TVector): TVector;
begin
  result := Vector(v1.x-v2.x, v1.y-v2.y);
end;

function MinusEquals(v1: PVector; v2: TVector): TVector;
begin
  v1^.x := v1^.x-v2.x;
  v1^.y := v1^.y-v2.y;
  result := v1^;
end;

function Mult(v : TVector; s: Double): TVector;
begin
  result := Vector(v.x * s, v.y * s);
end;

function MultEquals(v : PVector; s: Double): TVector;
begin
  v^.x := v^.x * s;
  v^.y := v^.y * s;
  result := v^;
end;

function DivVector(v: TVector; s: Double): TVector;
begin
  result := Vector(v.x / s, v.y / s);
end;

function DivEquals(v : PVector; s: Double): TVector;
begin
  v^.x := v^.x / s;
  v^.y := v^.y / s;
  result := v^;
end;

function Distance(v1, v2 : TVector) : Double;
begin
  result := Magnitude(Minus(v1, v2));
end;

function Times(v1, v2 : TVector) : TVector;
begin
  result := Vector(v1.x * v2.x, v1.y * v2.y);
end;

function Magnitude(v : TVector): Double;
begin
  result:=sqrt(v.x*v.x+v.y*v.y);
end;

function Normalyze(v : TVector) : TVector;
var
  m : Double;
begin
  m := Magnitude(v);
  if(m=0) then
    m := 0.0001;
  result := Mult(v, 1/m);
end;

Procedure PolarToCartesian(const R, Phi: Extended; var X, Y: Double);
var
  Sine, CoSine: Extended;
begin
  SinCos(Phi, Sine, CoSine);
  X := R * CoSine*-1;
  Y := R * Sine *-1;
end;

procedure TurnAngle(v : PVector; a : Double);
begin
  PolarToCartesian(Magnitude(v^), a, v^.x, v^.y);
end;

procedure ResetAngle(v : PVector);
begin
  v^.x:=Magnitude(v^);
  v^.y:=0;
end;

procedure CopyVector(v1: PVector; v2: TVector);
begin
  v1^.x := v2.x;
  v1^.y := v2.y;
end;

end.
