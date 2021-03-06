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

unit uSurfaces;

interface

Uses uGroup, uRectangleParticle, uCircleParticle, uSpringConstraint, uApeEngine, uRenderer;

Type
  TSurfaces = class(TGroup)
  Private
  Public
    Constructor Create(Render : TAbstractRenderer; aEngine : TApeEngine); reintroduce; Virtual;
  End;

implementation

{ Surfaces }

constructor TSurfaces.Create(Render: TAbstractRenderer; aEngine: TApeEngine);
var Floor, Ceil, RampRight, RampLeft, rampLeft2, BouncePad : TRectangleParticle;
    RampCircle, FloorBump : TCircleParticle;
    leftWall, leftWallChannelInner, leftWallChannel, leftWallChannelAng,
    topLeftAng, rightWall, bridgeStart,bridgeEnd: TRectangleParticle;
begin
  Inherited Create(False);
  floor := TRectangleParticle.Create(340,327,550,50,0,true);
  addParticle(floor);

  ceil := TRectangleParticle.Create(325,-33,649,80,0,true);
  addParticle(ceil);

  rampRight := TRectangleParticle.Create(375,220,390,20,0.405,true);
  addParticle(rampRight);

  rampLeft := TRectangleParticle.Create(90,200,102,20,-0.7,true);
  addParticle(rampLeft);

  rampLeft2 := TRectangleParticle.Create(96,129,102,20,-0.7,true);
  addParticle(rampLeft2);

  rampCircle := TCircleParticle.Create(175,190,60,true);
  addParticle(rampCircle);

  floorBump := TCircleParticle.Create(600,660,400,true);
  addParticle(floorBump);

  bouncePad := TRectangleParticle.Create(35,370,40,60,0,true);
  bouncePad.elasticity := 4;
  addParticle(bouncePad);

  leftWall := TRectangleParticle.Create(1,99,30,500,0,true);
  addParticle(leftWall);

  leftWallChannelInner := TRectangleParticle.Create(54,300,20,150,0,true);
  addParticle(leftWallChannelInner);

  leftWallChannel := TRectangleParticle.Create(54,122,20,94,0,true);
  addParticle(leftWallChannel);

  leftWallChannelAng := TRectangleParticle.Create(75,65,60,25,- 0.7,true);
  addParticle(leftWallChannelAng);

  topLeftAng := TRectangleParticle.Create(23,11,65,40,-0.7,true);
  addParticle(topLeftAng);

  rightWall := TRectangleParticle.Create(654,230,50,500,0,true);
  addParticle(rightWall);

  bridgeStart := TRectangleParticle.Create(127,49,75,25,0,true);
  addParticle(bridgeStart);

  bridgeEnd := TRectangleParticle.Create(483,55,100,15,0,true);
  addParticle(bridgeEnd);
end;

end.
