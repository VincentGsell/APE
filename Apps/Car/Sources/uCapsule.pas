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

unit uCapsule;

interface


Uses uGroup, uCircleParticle, uSpringConstraint, uApeEngine, uRenderer;

Type
  TCapsule = class(TGroup)
  Private
  Public
    Constructor Create(Render : TAbstractRenderer; aEngine : TApeEngine); reintroduce; Virtual;
  End;

implementation

{ Capsule }

constructor TCapsule.Create(Render: TAbstractRenderer; aEngine: TApeEngine);
var capsuleP1, capsuleP2 : TCircleParticle;
    Capsule : TSpringConstraint;
begin
  inherited Create;
  capsuleP1 := TCircleParticle.Create(300,10,14,false,1.3,0.4);
	addParticle(capsuleP1);

  capsuleP2 := TCircleParticle.Create(325,35,14,false,1.3,0.4);
	addParticle(capsuleP2);

  capsule := TSpringConstraint.Create(capsuleP1, capsuleP2, 1, true, 24);
	addConstraint(capsule);
end;

end.
