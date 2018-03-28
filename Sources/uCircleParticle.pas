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
unit uCircleParticle;

interface

Uses uAbstractParticle, uVector, uInterval, uRenderer;

Type
  TCircleParticle = class(TAbstractParticle)
  Private
    FRadius : Double;
  Public
    Constructor Create( x, y,
                        radius : Double;
                        isFixed : Boolean = False;
                        aMass : Double = 1;
                        aElasticity : Double = 0.3;
                        aFriction : Double = 0); Reintroduce;

    Procedure Init; Override;
    Procedure Paint(WithRender : TAbstractRenderer); OVerride;
    Function GetProjection(AnAxis : TVector) : TInterval;
    Function GetIntervalX : TInterval;
    Function GetIntervalY : TInterval;

    Property Radius : Double read FRadius Write FRadius;
  End;

implementation

{ TCircleParticle }

constructor TCircleParticle.Create(x, y, radius: Double; isFixed: Boolean;
  aMass, aElasticity, aFriction: Double);
begin
  inherited Create(x,y,amass,aelasticity,afriction,isfixed);
  FRadius := Radius;
end;

function TCircleParticle.GetIntervalX: TInterval;
begin
  interval.min := curr^.x - Fradius;
  interval.max := curr^.x + Fradius;
	result := interval;
end;

function TCircleParticle.GetIntervalY: TInterval;
begin
  interval.min := curr^.y - Fradius;
  interval.max := curr^.y + Fradius;
  Result := interval;
end;

function TCircleParticle.GetProjection(AnAxis: TVector): TInterval;
var c : Double;
begin
  c := Dot(Samp^, anAxis);
  Interval.min := c - Fradius;
  interval.max := c + Fradius;
  Result := Interval;
end;

procedure TCircleParticle.Init;
begin
  //none ?
end;

procedure TCircleParticle.Paint(WithRender : TAbstractRenderer);
begin
  WithRender.Circle(curr^.x,curr^.y,FRadius,0);
end;

end.
