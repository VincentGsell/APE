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
unit uSwingDoor;

interface


Uses uGroup, uRectangleParticle, uCircleParticle, uSpringConstraint, uApeEngine, uRenderer;

Type
  TSwingDoor = class(TGroup)
  Private
  Public
    Constructor Create(Render : TAbstractRenderer; aEngine : TApeEngine); reintroduce; Virtual;
  End;


implementation

{ SwingDoor }

constructor TSwingDoor.Create(Render: TAbstractRenderer; aEngine: TApeEngine);
var swingDoorP1,swingDoorP2, swingDoorAnchor : TCircleParticle;
    swingdoor, swingDoorSpring : TSpringConstraint;
    StopperA : TCircleParticle;
    StopperB : TRectangleParticle;
begin
  inherited Create;
	// setting collideInternal allows the arm to hit the hidden stoppers.
	// you could also make the stoppers its own group and tell it to collide
	// with the SwingDoor
	collideInternal := true;

	swingDoorP1 := TCircleParticle.Create(543,55,7);
	swingDoorP1.mass := 0.001;
	addParticle(swingDoorP1);

  swingDoorP2 := TCircleParticle.Create(620,55,7,true);
	addParticle(swingDoorP2);

  swingDoor := TSpringConstraint.Create(swingDoorP1, swingDoorP2, 1, true, 13);
	addConstraint(swingDoor);

	swingDoorAnchor := TCircleParticle.Create(543,5,2,true);
	swingDoorAnchor.visible := false;
	swingDoorAnchor.collidable := false;
	addParticle(swingDoorAnchor);

	swingDoorSpring := TSpringConstraint.Create(swingDoorP1, swingDoorAnchor, 0.02);
	swingDoorSpring.restLength := 40;
	swingDoorSpring.visible := false;
	addConstraint(swingDoorSpring);

  stopperA := TCircleParticle.Create(550,-60,70,true);
	stopperA.visible := false;
	addParticle(stopperA);

	stopperB := TRectangleParticle.Create(650,130,42,70,0,true);
	stopperB.visible := false;
	addParticle(stopperB);
end;

end.
