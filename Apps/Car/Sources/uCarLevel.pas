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
unit uCarLevel;

interface

Uses SysUtils, Classes,
    uApeEngine, uVector, uRenderer, uCar, uBridge, uSurfaces, uCapsule,
    uSwingDoor, uRotator;

Type
  TLevel = Class
  protected
    R : TAbstractRenderer;
  Public
    //buf : TBitmap;
    Ape : TApeEngine;
    aSurface : TSurfaces;
    aBridge : TBridge;
    aCar : TCar;
    aCapsule : TCapsule;
    aSwingDoor : TSwingDoor;
    aRotator : TRotator;

    Constructor Create(aRenderer : TAbstractRenderer); Virtual;
    Destructor Destroy; Override;
    Procedure Render;
    Procedure Progress;
  End;

implementation

{ TLevel }

constructor TLevel.Create(aRenderer : TAbstractRenderer);
begin
  Assert(Assigned(aRenderer));
  R := aRenderer;
  Ape := TApeEngine.Create;
  // Initialize the engine. The argument here is the time step value.
	// Higher values scale the forces in the sim, making it appear to run
	// faster or slower. Lower values result in more accurate simulations.
  Ape.Init(1/4);

	// gravity -- particles of varying masses are affected the same
  Ape.AddMasslessForce(Vector(0,3));

  aSurface := TSurfaces.Create(R,Ape);
	Ape.addGroup(aSurface);
	aBridge := TBridge.Create(R,Ape);
	Ape.addGroup(aBridge);

	acapsule := TCapsule.Create(R,Ape);
	APe.addGroup(acapsule);

	arotator := TRotator.Create(R,Ape);
	APE.addGroup(arotator);

	aswingDoor := TSwingDoor.create(R,Ape);
	APE.addGroup(aswingDoor);

	aCar := TCar.Create(R,Ape);
	Ape.addGroup(aCar);

  aCar.AddCollidable(aSurface);
  aCar.AddCollidable(aBridge);
  aCar.AddCollidable(aCapsule);
  aCar.AddCollidable(aSwingDoor);
  aCar.AddCollidable(aRotator);

  aCapsule.AddCollidable(aSurface);
  aCapsule.AddCollidable(aBridge);
  aCapsule.AddCollidable(aSwingDoor);
  aCapsule.AddCollidable(aRotator);

//  DoubleBuffered := true;
//  InitKeyboard;
end;

destructor TLevel.Destroy;
begin

  inherited;
end;

procedure TLevel.Progress;
begin
  Ape.Step;
  aRotator.RotateByRadian(0.02);
end;

procedure TLevel.Render;
begin
  Ape.Paint(R);
end;


end.
