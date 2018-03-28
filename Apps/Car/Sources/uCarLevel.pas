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
