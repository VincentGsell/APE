{
APE (Actionscript Physics Engine) is an AS3 open source 2D physics engine
Copyright 2006, Alec Cove

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

Contact: ape@cove.org

2009.03.01 - Converted to ObjectPascal by Vincent Gsell [https://github.com/VincentGsell]
}
unit uComposite;

interface

Uses uVector, uAbstractCollection, MAth, uAbstractParticle, uMathUtil, Classes,
     uSpringConstraint;

Type
  TComposite = Class(TAbstractCollection)
  Private
    delta : TVector;
    function GetFixed: Boolean;
    procedure SetFixed(const Value: Boolean);
  Public
    Constructor Create; Override;

    Procedure RotateByRadian(AngleRadian : double; Center : TVector);
    Procedure RotateByAngle(AngleDegree : Double; Center : TVector);
    Function GetRelativeAngle(Center, p : TVector) : Double;

    Property Fixed : Boolean read GetFixed Write SetFixed;
  end;

implementation

{ TComposite }

constructor TComposite.Create;
begin
  inherited Create;
  Delta := Vector(0,0);
end;

function TComposite.GetFixed: Boolean;
var i : integer;
begin
  result:=true;
  for i:=0 to fParticles.Count-1 do
  begin
    if not Particles[i].Fixed then
    begin
      Result:=False;
      exit;
    end;
  end;
end;

function TComposite.GetRelativeAngle(Center, p: TVector): Double;
begin
  Delta := Vector(p.x-Center.x,p.y-center.y);
  Result := ArcTan2(delta.y,delta.x);
end;

procedure TComposite.RotateByAngle(AngleDegree: Double; Center: TVector);
var angleRadians : Double;
begin
  AngleRadians := AngleDegree * PI_OVER_ONE_EIGHTY;
  RotateByRadian(angleRadians, Center);
end;

procedure TComposite.RotateByRadian(AngleRadian: double; Center: TVector);
var p : TAbstractPArticle;
    len : Integer;
    radius, angle : Double;
    i : integer;
begin
  len:=FParticles.Count;
  For i:=0 to len-1 do
  begin
    p:=Particles[i];
    Radius := distance(p.center, center);
    Angle := GetRelativeAngle(Center,p.Center) + AngleRadian;
    p.Px := (Cos(Angle) * Radius) + center.x;
    p.Py := (Sin(Angle) * Radius) + center.y;
  end;
end;

procedure TComposite.SetFixed(const Value: Boolean);
var i : integer;
begin
  for i:=0 to FParticles.Count-1 do
    Particles[i].Fixed:=Value;
end;

end.
