unit uSpringConstraint;

interface

uses uAbstractConstraint, uAbstractParticle, uMathUtil, uVector, MAth, SysUtils,
     uRenderer;

Type

  { TSpringConstraint }

  TSpringConstraint = Class(TAbstractConstraint)
  Private
  	fp1:TAbstractParticle;
  	fp2:TAbstractParticle;

  	FrestLength : Double;
  	Fcollidable : Boolean;
  	Fscp : TAbstractParticle;

    function GetCurrLenght: Double;
    function GetCenter: TVector;
    function GetAngle: Double;
    function GetRadian: Double;
    function GetRectHeight: Double;
    function GetRectScale: Double;
    function GetDelta: TVector;
    procedure SetRestLength(const Value: Double);
    function GetFixedEndLimit: Double;
    procedure SetFixedEndLimit(const Value: Double);
    function GetFixed: Boolean;
  Public
    constructor Create( p1,p2 : TAbstractParticle; aStiffness : Double = 0.5; isCollidable : Boolean = False;
                      arectHeight : Double = 1; arectScale : Double = 1; aScaleToLength : Boolean = False); virtual;
    destructor Destroy; override;

    Procedure checkParticlesLocation;
    Procedure Resolve; OVerride;
    procedure SetCollidable(b : boolean; aRectHeight, aRectScale : Double; ScaleLen : Boolean = false);
    Function IsConnectedTo(p : TAbstractParticle) : Boolean;

    Procedure Paint(WithRender : TAbstractRenderer); OverridE;

    Property CurrLength : Double read GetCurrLenght;
    property Center : TVector read GetCenter;
    property Angle : Double read GetAngle;
    property Radian : Double Read GetRadian;
    property RectScale : Double read GetRectScale;
    Property RectHeight : Double Read GetRectHEight;
    property Delta : TVector read GetDelta;
    property RestLength : Double read FrestLength Write SetRestLength;
    property Collidable : Boolean read Fcollidable Write Fcollidable;
    property SCP : TAbstractParticle read Fscp;
    property FixedEndLimit : Double read GetFixedEndLimit Write SetFixedEndLimit;
    PRoperty Fixed : Boolean read GetFixed; 
  end;


implementation

uses uSpringConstraintParticle, uAbstractItem;

{ TSpringConstraint }


//* if the two particles are at the same location offset slightly
procedure TSpringConstraint.checkParticlesLocation;
begin
  if ((fp1.curr^.x = fp2.curr^.x) and (fp1.curr^.y = fp2.curr^.y)) Then
	  fp2.curr^.x := fp2.curr^.x + 0.0001;
end;

constructor TSpringConstraint.Create( p1,p2 : TAbstractParticle; aStiffness : Double = 0.5; isCollidable : Boolean = False;
                      arectHeight : Double = 1; arectScale : Double = 1; aScaleToLength : Boolean = False);
begin
  inherited Create(aStiffness);
  fp1 := p1;
  fp2 := p2;
  checkParticlesLocation;
  FrestLength := CurrLength;
  SetCollidable(isCollidable,arectHeight,arectScale,aScaleToLength);
end;

destructor TSpringConstraint.Destroy;
begin
  if assigned(Fscp) then
    fscp.Free;
  inherited Destroy;
end;

function TSpringConstraint.GetAngle: Double;
begin
  Result := radian * ONE_EIGHTY_OVER_PI;
end;

function TSpringConstraint.GetCenter: TVector;
begin
  Result :=divVector((plus(fp1.curr^, fp2.curr^)), 2);
end;

function TSpringConstraint.GetCurrLenght: Double;
begin
  result := Distance(fp1.Curr^, fp2.Curr^);
end;


function TSpringConstraint.GetDelta: TVector;
begin
  Result := minus(fp1.curr^, fp2.curr^);
end;

function TSpringConstraint.GetFixed: Boolean;
begin
  Result := fp1.Fixed And fp2.Fixed;
end;

function TSpringConstraint.GetFixedEndLimit: Double;
begin
  Result := TSpringConstraintParticle(Fscp).FixedEndLimit;
end;

function TSpringConstraint.GetRadian: Double;
var d : TVector;
begin
  d := Delta;
	Result := Arctan2(d.y, d.x);
end;

function TSpringConstraint.GetRectHeight: Double;
begin
  Result := TSpringConstraintPArticle(Fscp).RectHeight;
end;

function TSpringConstraint.GetRectScale: Double;
begin
  Result := TSpringConstraintPArticle(Fscp).RectScale;
end;

function TSpringConstraint.IsConnectedTo(p: TAbstractParticle): Boolean;
begin
  Result := (p = fp1) Or (p=fp2);
end;

procedure TSpringConstraint.Paint(WithRender : TAbstractRenderer);
begin
  if Collidable then
    TSpringConstraintParticle(Fscp).Paint(WithRender)
  else
    WithRender.Line(fp1.px,fp1.py,fp2.px,fp2.py);
end;

procedure TSpringConstraint.Resolve;
var DeltaLength : Double;
    Diff : Double;
    dmds : TVector;
begin
  if fp1.Fixed and fp2.Fixed then
    Exit;

  deltaLength := currLength;
  if(deltaLength > 0) then
    diff := (deltaLength - restLength) / (deltaLength * (fp1.invMass + fp2.invMass))
  else
    diff := 0;
	dmds := mult(delta, diff * stiffness);

  minusEquals(fp1.curr, mult(dmds, fp1.invMass));
	plusEquals(fp2.curr, mult(dmds, fp2.invMass));
end;

procedure TSpringConstraint.SetCollidable(b: boolean; aRectHeight,
  aRectScale: Double; ScaleLen: Boolean);
begin
  Fcollidable := b;
  if assigned(Fscp) then
    fscp.Free;
  Fscp := nil;
  if Fcollidable then
    Fscp := TSpringConstraintPArticle.Create(fp1, fp2, self, arectHeight, aRectScale, ScaleLen);
end;

procedure TSpringConstraint.SetFixedEndLimit(const Value: Double);
begin
  if Assigned(Fscp) then
    TSpringConstraintParticle(Fscp).FixedEndLimit := Value;
end;

procedure TSpringConstraint.SetRestLength(const Value: Double);
begin
  if Value<=0 then
    raise Exception.Create('SpringConstant.RestLength must be grater than 0');
  FRestLength := Value;
end;

end.
