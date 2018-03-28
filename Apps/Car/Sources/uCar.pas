unit uCar;

interface

Uses uGroup, uWheelParticle, uSpringConstraint, uApeEngine, uRenderer;

type

  { TCar }

  TCar = class(TGroup)
  private
    wheelparticleA : TWheelParticle;
    wheelparticleB : TWheelParticle;
    wheelconnector : TSpringConstraint;

    function GetSpeed: Double;
    procedure SetSpeed(const Value: Double);
  public
    Constructor Create(aRenderer : TAbstractRenderer; anApeEngine : TApeEngine); Reintroduce;
    destructor Destroy; override;

    property Speed : Double read GetSpeed Write SetSpeed;
  end;

implementation

uses uAbstractCollection;

{ TCar }

constructor TCar.Create(aRenderer : TAbstractRenderer; anApeEngine : TApeEngine);
begin
  inherited Create(True);
  wheelparticleA := TWheelParticle.Create(anApeEngine,140,10,14,False,2);
  wheelparticleB := TWheelParticle.Create(anApeEngine,200,10,14,False,2);
  wheelconnector := TSpringConstraint.Create(wheelparticleA,wheelparticleB,0.5,True,8);

  AddParticle(wheelparticleA);
  AddParticle(wheelparticleB);
  AddConstraint(wheelconnector);
end;

destructor TCar.Destroy;
begin
  inherited Destroy;
end;

function TCar.GetSpeed: Double;
begin
  result :=(wheelparticleA.AngularVelocity + wheelparticleB.AngularVelocity) / 2;
end;

procedure TCar.SetSpeed(const Value: Double);
begin
  wheelparticleA.AngularVelocity:=Value;
  wheelparticleb.AngularVelocity:=Value;
end;

end.
