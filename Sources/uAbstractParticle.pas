unit uAbstractParticle;

interface

Uses uVector, uInterval, uCollision, uAbstractItem, uRenderer;

Type

  { TAbstractParticle }

  TAbstractParticle = Class(TAbstractItem)
  protected
    FInterval: TInterval;
    FForces, Temp : TVector;
    aCollision : TCollision;
    Fkfr, Fmass, FinvMass, FFriction : Double;
    FFixed, FCollidable : Boolean;
    FCenter : TVector;
    FCollisionFvn, FCollisionFvt : TVector;
    FMultiSample : Integer;
    FCurr : TVector;
    FPrev : TVector;
    FSamp : TVector;
    function GetCurr: PVector;
    function GetPrev: PVector;
    function GetSamp: PVector;
    procedure SetCurr(const AValue: PVector);
    procedure SetInterval(const AValue: TInterval);
    procedure SetPrev(const AValue: PVector);
    procedure SetSamp(const AValue: PVector);
  Public
    Constructor Create(x,y,amass,aElasticity, aFriction : Double; IsFixed : Boolean); Reintroduce; Virtual;
    Destructor Destroy; OVerride;

    function GetFriction: Double; virtual;
    procedure SetFriction(const Value: Double); Virtual;
    function GetElasticity: Double; virtual;
    procedure SetElasticity(const Value: Double); virtual;
    function GetMass: Double; virtual;
    procedure SetMass(value : Double); Virtual;
    Function GetVelocity : TVector; Virtual;
    Procedure SetVelocity(value : TVector); Virtual;
    Function getPx : Double;  Virtual;
    Procedure SetPx(value : Double);  Virtual;
    Function getPy : Double;  Virtual;
    Procedure setPy(value : Double);  Virtual;
    Function GetInvMass : Double; Virtual;
    Function Center : TVector;
    Function Position : TVector; Overload;
    Procedure Position(Value : TVector); Overload;
    Procedure Update(dt2 : Double; Force, MassLEssForce : TVector; Damping : Double); Virtual;
    Procedure AddForce(f : TVector);
    Procedure AddMassLessForce(f : TVector);
    Function GetComponents(CollisionNormal : TVector) : TCollision;
    Procedure ResolveCollision(mtd,vel,n : Tvector; d : Double; o : Integer; p : TAbstractParticle); Virtual;
    Function ParticleType : Integer;
    Property px : Double read GetPx write SetPx;
    Property py : double read GetPy Write SetPy;
    Property Fixed : Boolean read FFixed Write FFixed;
    Property Mass : Double read GetMass Write SetMass;
    Property Velocity : TVector read GetVelocity Write SetVelocity;
    Property Collidable : Boolean read FCollidable Write FCollidable;
    Property Elasticity : Double Read GetElasticity Write SetElasticity;
    Property Friction : Double read GetFriction Write SetFriction;
    Property MultiSample : Integer read FMultiSample Write FMultiSample;
    Property InvMass : Double read GetInvMass;
    property Curr : PVector read GetCurr write SetCurr;
    property Prev : PVector read GetPrev write SetPrev;
    property Samp : PVector read GetSamp write SetSamp;
    property Interval : TInterval read FInterval write SetInterval;
  end;

implementation

uses SysUtils;

{ TAbstractParticle }

procedure TAbstractParticle.AddForce(f: TVector);
begin
  PlusEquals(@FForces, Mult(f, InvMass));
end;

procedure TAbstractParticle.AddMassLessForce(f: TVector);
begin
  PlusEquals(@FForces, f);
end;

function TAbstractParticle.Center: TVector;
begin
  FCenter := Vector(Px,Py);
  Result:= FCenter;
end;

function TAbstractParticle.GetCurr: PVector;
begin
  result := @FCurr;
end;

function TAbstractParticle.GetPrev: PVector;
begin
  result := @FPrev;
end;

function TAbstractParticle.GetSamp: PVector;
begin
  result := @FSamp;
end;

procedure TAbstractParticle.SetCurr(const AValue: PVector);
begin
  FCurr := AValue^;
end;

procedure TAbstractParticle.SetInterval(const AValue: TInterval);
begin
  if FInterval=AValue then exit;
  FInterval:=AValue;
end;

procedure TAbstractParticle.SetPrev(const AValue: PVector);
begin
  FPrev := AValue^;
end;

procedure TAbstractParticle.SetSamp(const AValue: PVector);
begin
  FSamp := AValue^;
end;

constructor TAbstractParticle.Create(x, y, amass, aElasticity,
  aFriction: Double; IsFixed: Boolean);
begin
  inherited Create;
  FInterval := TInterval.Create(0,0);

  fcurr := Vector(x,y);
  fprev := Vector(x,y);
	fsamp := Vector(0, 0);
	temp := Vector(0, 0);
	fixed:=isFixed;

	fforces := Vector (0, 0);
	FcollisionFvn := Vector (0, 0);
	FcollisionFvt := Vector (0, 0);
	aCollision := TCollision.Create(FcollisionFvn, FcollisionFvt);
	Collidable:=true;

	mass:=amass;
	elasticity:=aelasticity;
	friction:=afriction;

	Fcenter := Vector (0, 0);
	Fmultisample := 0;
end;

destructor TAbstractParticle.Destroy;
begin
  Interval.free;
  aCollision.Free;
//  FreeAndNil(Interval);
//  FreeAndNil(aCollision);
  inherited Destroy;
end;


function TAbstractParticle.GetComponents(
  CollisionNormal: TVector): TCollision;
var t, vel : TVector;
    vdotn : Double;
begin
  vel := Velocity;
	vdotn := dot(CollisionNormal, vel);
  t := Mult(CollisionNormal, vdotn);
  aCollision.vn:= @t;
  t := Minus(vel, aCollision.vn^);
  aCollision.vt:=@t;
  Result:=aCollision;
end;

function TAbstractParticle.GetInvMass: Double;
begin
  if Fixed then
    Result:=0
  else
    Result:=FinvMass;
end;

procedure TAbstractParticle.SetMass(value: Double);
begin
  If Value<=0 then
    Raise Exception.Create('Mass must be not less or equals than 0.');
  Fmass := Value;
  FinvMass := 1 / Fmass;
end;

function TAbstractParticle.ParticleType: Integer;
begin
  Result:=0;
end;

function TAbstractParticle.Position: TVector;
begin
  CopyVector(@result, FCurr);
end;

procedure TAbstractParticle.Position(Value: TVector);
begin
  CopyVector(@Fcurr, Value);
  CopyVector(@FPrev, Value);
end;

procedure TAbstractParticle.setPx(value: Double);
begin
 	fcurr.x := Value;
	fprev.x := Value;
end;

function TAbstractParticle.getPx: Double;
begin
  Result := fcurr.x;
end;

procedure TAbstractParticle.setPy(value: Double);
begin
 	fcurr.y := Value;
	fprev.y := Value;
end;

function TAbstractParticle.getPy: Double;
begin
  Result := fCurr.y;
end;

procedure TAbstractParticle.ResolveCollision(mtd, vel, n: Tvector; d: Double;
  o: Integer; p: TAbstractParticle);
begin
  PlusEquals(@fcurr, mtd);
  Velocity:=vel;
end;

procedure TAbstractParticle.SetVelocity(Value: TVector);
begin
  fprev := Minus(fcurr, Value);
end;

function TAbstractParticle.GetVelocity: TVector;
begin
  result := Minus(fcurr, fPrev);
end;

procedure TAbstractParticle.Update(dt2: Double; Force,
  MassLEssForce: TVector; Damping: Double);
var nv : TVector;
begin
	if (fixed) then
    Exit;

  //Global forces
	addForce(force);
	addMasslessForce(masslessForce);

  //Integrate
	CopyVector(@temp, fcurr);

	nv := plus(velocity, multEquals(@fforces, dt2));
	plusEquals(@fcurr, multEquals(@nv, damping));
	CopyVector(@fprev, temp);
	// clear the forces
	fforces := Vector(0,0);
end;


function TAbstractParticle.GetMass: Double;
begin
  Result := Fmass;
end;

function TAbstractParticle.GetElasticity: Double;
begin
  Result:=Fkfr
end;

procedure TAbstractParticle.SetElasticity(const Value: Double);
begin
  Fkfr := Value;
end;

function TAbstractParticle.GetFriction: Double;
begin
  result := FFriction;
end;

procedure TAbstractParticle.SetFriction(const Value: Double);
begin
  FFriction := Value;
end;

end.
