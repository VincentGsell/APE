unit uAbstractCollection;

interface

Uses uVector, uAbstractParticle, uAbstractConstraint, uSpringConstraint,
     uSpringConstraintParticle,uCollisionDetector, Classes, uRenderer;

Type

  { TAbstractCollection }

  TAbstractCollection = Class
  protected
    FIsPArented : Boolean;
    FParticles : TList;
    FConstraints : TList;
    function GetConstraints(index : integer): TSpringConstraint;
    function GetParticles(index : integer): TAbstractPArticle;
  Public
    constructor Create; Virtual;
    Destructor Destroy; Override;

    Function GetIsParented : Boolean; Overload;
    Procedure SetIsParented(value : Boolean); Overload;

    Procedure Init; Virtual;

    Procedure AddParticle(p : TAbstractParticle);
    Procedure AddConstraint(c : TSpringConstraint);
    Procedure RemoveParticle(p : TAbstractParticle; bFree : Boolean = false);
    Procedure RemoveConstraint(c : TAbstractConstraint; bFree : Boolean = false);

    Procedure Paint(WithRender : TAbstractRenderer); Virtual;
    Procedure Integrate(dt2 : Double; Force, MassLessForce : TVector; Damping : Double); Virtual;
    Procedure SatisfyConstraints; Virtual;
    Procedure CheckCollisionVsCollection(ac : TAbstractCollection);
    Procedure CheckInternalCollision;

    Property IsPArented : Boolean read GetIsPArented Write SetIsParented;
    property Particles[index : integer] : TAbstractPArticle read GetParticles;
    property Constraints[index : integer] : TSpringConstraint read GetConstraints;
  end;


implementation

uses uLogger;

{ TAbstractCollection }

procedure TAbstractCollection.AddConstraint(c: TSpringConstraint);
begin
  if(FConstraints.IndexOf(c)=-1) then
    FConstraints.Add(c);
  if IsParented then
    c.Init;
end;

procedure TAbstractCollection.AddPArticle(p: TAbstractPArticle);
begin
  if(FParticles.IndexOf(p)=-1) then
    FParticles.Add(p);
  if IsParented then
    p.Init;
end;

procedure TAbstractCollection.CheckCollisionVsCollection(
  ac: TAbstractCollection);
var clen, plen, acplen, Acclen, j,x,n : Integer;
    pga,pgb : TAbstractParticle;
    cgb,cga : TSpringConstraint;
begin
  //Every particle in this collection...
  plen := FParticles.Count;
  for j:=0 to plen-1 do
  begin
    pga := particles[j];
    if not(pga.Collidable) then
      continue;

    //...vs every particle of the other collection
    acplen := ac.FParticles.Count;
    for x:=0 to acplen-1 do
    begin
      pgb:=ac.Particles[x];
      if pgb.Collidable then
        CollisionDetectorInstance.Test(pga,pgb);
    end;

    //...vs every constraint of the other collection
    acclen := ac.FConstraints.Count;
		for x := 0 to acclen-1 do
    begin
		  cgb := ac.constraints[x];
		  if ((cgb.collidable) and not(cgb.isConnectedTo(pga))) then
      begin
		    TSpringConstraintParticle(cgb.scp).UpdatePosition;
		    CollisionDetectorInstance.test(pga, TSpringConstraintParticle(cgb.scp));
      end;
    end;
  end;

  //Every constraint of the collection
	clen := fconstraints.Count;
	for j:=0 to clen-1 do
  begin
    cga := constraints[j];
    if not(cga.Collidable) then
      Continue;
    //...vs every particle of the other collection
    // ...vs every particle in the other collection
	  acplen := ac.fparticles.Count;
		for n:=0 to acplen-1 do
    begin
	    pgb := ac.particles[n];
	    if ((pgb.collidable) And Not(cga.isConnectedTo(pgb))) Then
      begin
	      TSpringConstraintParticle(cga.scp).updatePosition;
	  		CollisionDetectorInstance.test(pgb, TSpringConstraintParticle(cga.scp));
	    end;
    end;
  end;
end;

procedure TAbstractCollection.CheckInternalCollision;
var clen, plen, i,j,n : Integer;
    pa,pb : TAbstractParticle;
    c : TSpringConstraint;
begin
  plen := fPArticles.Count;
  // every particle in this TAbstractCollection...
  for j:=0 to plen-1 do
  begin
    pa := particles[j];
    if not(pa.Collidable) then
      continue;
    // ...vs every other particle in this TAbstractCollection
    for i:=j+1 to plen-1 do
    begin
      pb:=PArticles[i];
      if pb.Collidable then
        CollisionDetectorInstance.Test(pa,pb);
    end;

		// ...vs every other constraint in this TAbstractCollection
   	clen := FConstraints.Count;
		for n := 0 to clen-1 do
    begin
  		c := Constraints[n];
			if (c.collidable and not(c.isConnectedTo(pa))) then
      begin
				TSpringConstraintParticle(c.scp).UpdatePosition;
				CollisionDetectorInstance.test(pa, TSpringConstraintParticle(c.scp));
      end;
    end;

  end;
end;

function TAbstractCollection.GetConstraints(index : integer
  ): TSpringConstraint;
begin
  result := TSpringConstraint(FConstraints[index]);
end;

function TAbstractCollection.GetParticles(index : integer): TAbstractPArticle;
begin
  result := TAbstractPArticle(FParticles[index]);
end;

constructor TAbstractCollection.Create;
begin
  LogAddObj(self);
  FIsPArented:=False;
  FParticles:=TList.Create;
  FConstraints:=TList.Create;
end;

destructor TAbstractCollection.Destroy;
var
  p : TAbstractParticle;
  c : TAbstractConstraint;
begin
  while(FParticles.Count > 0) do
    RemoveParticle(Particles[FParticles.Count-1], true);
  while(FConstraints.Count > 0) do
    RemoveConstraint(Constraints[FConstraints.Count-1], true);
  fParticles.Free;
  fConstraints.Free;
  LogRemoveObj(self);
  inherited;
end;

procedure TAbstractCollection.Init;
var i : integer;
    p : tAbstractPArticle;
begin
  For I:=0 to fParticles.Count-1 do
  begin
    p:=Particles[i];
    p.Init;
  end;
end;

procedure TAbstractCollection.Integrate(dt2: Double; Force,
  MassLessForce: TVector; Damping: Double);
var i : integer;
begin
  for i:=0 to fParticles.Count-1 do
    TAbstractParticle(Particles[i]).Update(dt2,Force,MasslessForce,Damping);
end;

procedure TAbstractCollection.setIsPArented(value: Boolean);
begin
  FIsPArented:=Value;
end;

function TAbstractCollection.getIsPArented: Boolean;
begin
  Result:=FIsPArented;
end;

procedure TAbstractCollection.RemoveParticle(p: TAbstractParticle; bFree : Boolean);
begin
  fParticles.Remove(p);
  if bFree then
    p.Free;
end;

procedure TAbstractCollection.RemoveConstraint(c: TAbstractConstraint; bFree : Boolean);
begin
  fConstraints.Remove(c);
  if bFree then
    c.Free;
end;

procedure TAbstractCollection.SatisfyConstraints;
var len : Integer;
    i : integer;
    c : TAbstractConstraint;
begin
  len := FConstraints.Count;
  for i:=0 to len-1 do
    Constraints[i].Resolve;
end;

procedure TAbstractCollection.Paint(WithRender : TAbstractRenderer);
var i : integer;
begin
  for i:=0 to FParticles.Count-1 do
    Particles[i].Paint(WithRender);

  for i:=0 to FConstraints.Count-1 do
    Constraints[i].Paint(WithRender);
end;

end.
