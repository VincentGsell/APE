unit uRectangleParticle;

interface

uses uAbstractParticle, uMathUtil, uVector, uInterval, uRenderer, sysUtils;

Type
  TRctTypeDouble = Array[0..1] of Double;
  TRctTypeVector = Array[0..1] of TVector;

  TRectangleParticle = Class(TAbstractParticle)
  Private
    Fextents : TRctTypeDouble;
    Faxes : TRctTypeVector;
    Fradian : Double;
    function GetAngle: Double;
    function GetHEight: Double;
    function GetRadian: Double;
    function GetWidth: Double;
    procedure SetAngle(const Value: Double);
    procedure SetAxes(const Value: Double);
    procedure SetHeight(const Value: Double);
    procedure SetRadian(const Value: Double);
    procedure SetWidth(const Value: Double);
  Public
    Constructor Create(x,y,awidth,aheight, rotation : double; isFixed : Boolean; aMass : Double = 1; aElasticity : Double = 0.3; aFriction: Double = 0); reintroduce;

    Procedure Init; Override;
    Procedure Paint(WithRender : TAbstractRenderer); Override;
    Function GetProjection(AnAxis : TVector) : TInterval;

    Property Radian : Double read GetRadian Write SetRadian;
    Property Angle : Double read GetAngle Write SetAngle;
    Property Width : Double read GetWidth Write SetWidth;
    Property Height : Double read GetHEight Write SetHeight;
    Property Axes : TRctTypeVector read Faxes write FAxes;
    Property Extents : TRctTypeDouble read FExtents Write FExtents;
  end;

implementation

uses uAbstractItem;

{ TRectangleParticle }


constructor TRectangleParticle.Create(x, y, awidth, aheight,
  rotation: double; isFixed: Boolean; aMass : Double = 1; aElasticity : Double = 0.3; aFriction: Double = 0);
begin
  inherited Create(x,y,amass,aelasticity,afriction,isfixed);
  FExtents[0]:=awidth/2;
  FExtents[1]:=aheight/2;
  Faxes[0]:=Vector(0,0);
  Faxes[1]:=Vector(0,0);
  Radian:=Rotation;
end;

function TRectangleParticle.GetAngle: Double;
begin
  Result :=Radian * ONE_EIGHTY_OVER_PI;
end;

function TRectangleParticle.GetHEight: Double;
begin
  result:= FExtents[1] * 2;
end;

function TRectangleParticle.GetProjection(AnAxis: TVector): TInterval;
var radius : Double;
    c : Double;
begin
  Radius := extents[0] * Abs(Dot(AnAxis, axes[0]))+
            extents[1] * Abs(Dot(AnAxis, axes[1]));
  c := Dot(Samp^, AnAxis);
  Interval.min:=c-Radius;
  Interval.max:=c+Radius;
  Result:=Interval;
end;

function TRectangleParticle.GetRadian: Double;
begin
  result :=FRadian;
end;

function TRectangleParticle.GetWidth: Double;
begin
  Result:= Fextents[0] * 2;
end;

procedure TRectangleParticle.Init;
begin
  //CleanUp;
  //Paint;
end;

procedure TRectangleParticle.Paint(WithRender : TAbstractRenderer);
begin
  WithRender.Rectangle(px,py,Width,Height,Angle);
end;

procedure TRectangleParticle.SetAngle(const Value: Double);
begin
  Radian := Value * PI_OVER_ONE_EIGHTY;
end;

procedure TRectangleParticle.SetAxes(const Value: Double);
var s : Double;
    c : Double;
begin
  s:= Sin(Value);
  c:= Cos(Value);
  Faxes[0].x:=c;
  Faxes[0].y:=s;
  Faxes[1].x:=-s;
  Faxes[1].y:=c;
end;

procedure TRectangleParticle.SetHeight(const Value: Double);
begin
  FExtents[1] := Value /2;
end;

procedure TRectangleParticle.SetRadian(const Value: Double);
begin
  FRadian := Value;
  SetAxes(Value);
end;

procedure TRectangleParticle.SetWidth(const Value: Double);
begin
  FExtents[0] := Value /2;
end;


end.
