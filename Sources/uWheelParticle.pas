unit uWheelParticle;

interface

Uses uRimParticle, uCircleParticle, uApeEngine, uVector, Math, uMAthUtil, uAbstractParticle;

Type

  { TWheelParticle }

  TWheelParticle = class(TCircleParticle)
  Private
		frp : TRimParticle;
		ftan : TVector;
		fnormSlip : TVector;
		forientation : TVector;
		Ftraction: Double;
    function GetAngularVelocity: Double;
    function GetSpeed: Double;
    function GetTraction: Double;
    procedure SetAngularVelocity(const Value: Double);
    procedure SetSpeed(const Value: Double);
    procedure SetTraction(const Value: Double);
    function GetRadian: Double;
    function GetAngle: Double;
  Public
    Constructor Create( anApeEngine : TApeEngine; x,y, aRadius : Double; isfixed : Boolean = False; aMass : Double = 1;
                        aElasticity : Double = 0.3; aFriction : Double = 0; aTraction : Double = 1); reintroduce;
    destructor Destroy; override;

    Procedure Update(dt2 : Double; Force, MassLEssForce : TVector; Damping : Double); Override;

    Procedure ResolveCollision(mtd,vel,n : TVector; d : Double; o : Integer; p : TAbstractParticle); Override;
    Procedure Resolve(n : TVector);

    Property Speed : Double read GetSpeed Write SetSpeed;
    Property AngularVelocity : Double Read GetAngularVelocity Write SetAngularVelocity;
    Property Traction : Double read GetTraction Write SetTraction;

    property Angle : Double read GetAngle;
    property Radian : Double Read GetRadian;
  End;

implementation

{ TWheelParticle }

constructor TWheelParticle.Create(anApeEngine: TApeEngine; x, y,
  aRadius: Double; isfixed: Boolean; aMass: Double; aElasticity: Double;
  aFriction: Double; aTraction: Double);
begin
  Inherited Create(x,y,aRadius,isfixed,aMass,aElasticity, aFriction);
	ftan := Vector(0,0);
	fnormSlip := Vector(0,0);
	frp := TRimParticle.Create(anApeEngine, aRadius, 2);
	Self.Traction := Traction;
	forientation := Vector(0,0);
end;

destructor TWheelParticle.Destroy;
begin
  frp.Free;
  inherited Destroy;
end;

function TWheelParticle.GetAngle: Double;
begin
  Result := Radian * ONE_EIGHTY_OVER_PI;
end;

function TWheelParticle.GetAngularVelocity: Double;
begin
  Result := frp.AngularVelocity;
end;

function TWheelParticle.GetRadian: Double;
begin
  forientation := Vector(frp.Curr^.X,frp.Curr^.Y);
  Result := ArcTan2(forientation.x, forientation.y) + Pi;
end;

function TWheelParticle.GetSpeed: Double;
begin
  Result := frp.Speed;
end;

function TWheelParticle.GetTraction: Double;
begin
  Result := 1 - Ftraction;
end;

procedure TWheelParticle.Resolve(n: TVector);
var cp : Double;
    wheelSurfaceVelocity, combinedVelocity : TVector;
    SlipSpeed : Double;
    vtemp : TVector;
begin
	// this is the tangent TVector at the rim particle
	ftan := Vector(-frp.curr^.y, frp.curr^.x);

	// normalize so we can scale by the rotational speed
	ftan := Normalyze(ftan);

	// velocity of the wheel's surface
	wheelSurfaceVelocity := mult(ftan, frp.speed);

	// the velocity of the wheel's surface relative to the ground
  vtemp := Velocity;
	combinedVelocity := plusEquals(@vtemp, wheelSurfaceVelocity);
  Velocity := vtemp;

	// the wheel's comb velocity projected onto the contact normal
	cp := cross(combinedVelocity, n);

	// set the wheel's spinspeed to track the ground
  multEquals(@ftan, cp);
	copyvector(frp.prev, minus(frp.curr^, ftan));

  // some of the wheel's torque is removed and converted into linear displacement
	slipSpeed := (1 - Ftraction) * frp.speed;
	fnormSlip := Vector(slipSpeed * n.y, slipSpeed * n.x);
	plusEquals(curr, fnormSlip);
	frp.speed := frp.speed * Ftraction;
end;

procedure TWheelParticle.ResolveCollision(mtd, vel, n: TVector; d: Double;
  o: Integer; p: TAbstractParticle);
begin
  inherited ResolveCollision(mtd,vel,n,d,o,p);
  Resolve(Mult(n, Sign(d*o)));
end;

procedure TWheelParticle.SetAngularVelocity(const Value: Double);
begin
  frp.AngularVelocity:=Value;
end;

procedure TWheelParticle.SetSpeed(const Value: Double);
begin
  frp.Speed:=Value;
end;

procedure TWheelParticle.SetTraction(const Value: Double);
begin
  Ftraction:= 1 - Value;
end;

procedure TWheelParticle.Update(dt2 : Double; Force, MassLEssForce : TVector; Damping : Double);
begin
  Inherited Update(dt2,Force, MassLessForce,Damping);
  frp.Update(dt2);
end;

end.
