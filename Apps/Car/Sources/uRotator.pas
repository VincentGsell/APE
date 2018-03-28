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

Converted to ObjectPascal by Vincent Gsell vincent.gsell@gmail.com
}
unit uRotator;

interface


Uses uGroup, uCircleParticle, uSpringConstraint, uApeEngine,
    uRectangleParticle, uRenderer, uRectComposite, uVector;

Type
  TRotator = class(TGroup)
  Private
    ctr : TVector;
    arectcomposite : TRectComposite;
  Public
    Constructor Create(Render : TAbstractRenderer; aEngine : TApeEngine); reintroduce; Virtual;

    function RotateByRadian( a : Double) : Double;
  End;


implementation

{ Rotator }

constructor TRotator.Create(Render: TAbstractRenderer; aEngine: TApeEngine);
var circA : TCircleParticle;
  rectA, rectB : TRectanglePArticle;
  ConnectorA, ConnectorB : TSpringConstraint;
begin
  inherited Create;
	collideInternal := true;

  ctr := Vector(555,175);
	arectComposite := TRectComposite.Create(Render, aEngine, ctr);
	addComposite(arectComposite);

  circA := TCircleParticle.create(ctr.x,ctr.y,5);
	addParticle(circA);

	rectA := TRectangleParticle.Create(555,160,10,10,0,false,3);
	addParticle(rectA);

	connectorA := TSpringConstraint.create(arectComposite.CpA, rectA, 1);
	addConstraint(connectorA);

	rectB := TRectangleParticle.Create(555,190,10,10,0,false,3);
	addParticle(rectB);

	connectorB := TSpringConstraint.Create(arectComposite.cpc, rectB, 1);
	addConstraint(connectorB);
end;

function TRotator.RotateByRadian(a: Double): Double;
begin
  arectcomposite.RotateByRadian(a,ctr);
end;

end.
