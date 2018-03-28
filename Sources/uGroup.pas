unit uGroup;

interface

uses uAbstractCollection, uvector, Classes, uComposite, uAbstractPArticle,
     uAbstractConstraint, uRenderer;

Type

  { TGroup }

  TGroup = Class(TAbstractCollection)
  Private
    FComposites : TList;
    FCollisionList : TList;
    FCollideInternal : Boolean;
    Procedure CheckCollisionGroupInternal;
    Procedure CheckCollisionVsGroup(g : TGroup);
  public
    constructor Create(bCollideInternal : Boolean = False); Reintroduce; Virtual;
    destructor Destroy; override;
    Procedure Init; Override;

    Procedure AddComposite(c : TComposite);
    Procedure RemoveComposite(c : TComposite; bFree : Boolean = false);

    Procedure Paint(WithRender : TAbstractRenderer); Override;

    Procedure AddCollidable(g : TGroup);
    Procedure RemoveCollidable(g : TGroup; bFree : Boolean = false);

    Procedure AddCollidableList(list : Tlist);
    Function GetAll : Tlist;

    Procedure Integrate(dt2 : Double; Force, MassLessForce : TVector; Damping : Double); Override;
    Procedure SatisfyConstraints; Override;
    Procedure CheckCollision;

    Property CollideInternal : Boolean read FCollideInternal Write FCollideInternal;
  end;

implementation

uses MaskUtils;

{ TGroup }

procedure TGroup.AddCollidable(g: TGroup);
begin
  FCollisionList.Add(g);
end;

procedure TGroup.AddCollidableList(list: Tlist);
var i : Integer;
begin
  for i:=0 to list.Count-1 do
    FCollisionList.Add(List[i]);
end;

procedure TGroup.AddComposite(c: TComposite);
begin
  FComposites.Add(c);
  c.IsParented := true;
  if IsParented then
    c.Init;
end;

procedure TGroup.CheckCollision;
var i : integer;
begin
  if FCollideInternal then
    CheckCollisionGroupInternal;

  for i:=0 to FCollisionList.Count-1 do
  begin
    CheckCollisionVsGroup(TGroup(FCollisionList[i]));
  end;
end;

procedure TGroup.CheckCollisionGroupInternal;
var i,j : Integer;
    ca : TComposite;
begin
  CheckInternalCollision;
  for j:=0 to FComposites.Count-1 do
  begin
    ca:=TComposite(FComposites[j]);
    ca.CheckCollisionVsCollection(Self);
    for i:=j+1 to FComposites.Count-1 do
      ca.CheckCollisionVsCollection(TComposite(FComposites[i]));
  end;
end;

procedure TGroup.CheckCollisionVsGroup(g : TGroup);
var clen, gclen : Integer;
    i,j : integer;
    c : TComposite;
begin
  CheckCollisionVsCollection(g);
  clen := FComposites.Count;
  gclen := g.FComposites.Count;
  for i:=0 to clen-1 do
  begin
    c:=TComposite(FComposites[i]);
    c.CheckCollisionVsCollection(g);
    for j:=0 to gclen -1 do
      c.CheckCollisionVsCollection(TAbstractCollection(g.FComposites[j]));
  end;

  For j:=0 to gclen-1 do
    CheckCollisionVsCollection(TAbstractCollection(TComposite(g.FComposites[j])));

end;

constructor TGroup.Create(bCollideInternal: Boolean);
begin
  inherited Create;
  FCollideInternal:=bCollideInternal;
  FComposites := TList.Create;
  FCollisionList := Tlist.Create;
end;

destructor TGroup.Destroy;
var
  co: TComposite;
begin
  while(FComposites.Count > 0) do
    RemoveComposite(TComposite(FComposites[FComposites.Count-1]), true);
  FComposites.Free;
  FCollisionList.Free;
  inherited Destroy;
end;

function TGroup.GetAll: Tlist;
var i : integer;
begin
  Result:=Tlist.create;
  for i:=0 to FParticles.Count-1 do
    Result.Add(Particles[i]);
  for i:=0 to FConstraints.Count-1 do
    Result.Add(Constraints[i]);
  for i:=0 to FComposites.Count-1 do
    Result.Add(FComposites[i]);
end;

procedure TGroup.Init;
var i : integer;
begin
  //inherited Init;
  For i:=0 to FComposites.Count-1 do
    TComposite(FComposites[i]).Init;
end;

procedure TGroup.Integrate(dt2 : Double; Force, MassLessForce : TVector; Damping : Double);
var i : integer;
begin
  inherited Integrate(dt2,Force,MasslessForce,Damping);
  for i:=0 to FComposites.Count-1 do
    TComposite(FComposites[i]).Integrate(dt2,Force,MAssLessForce,Damping);
end;

procedure TGroup.Paint(WithRender : TAbstractRenderer);
var i : integer;
begin
  //Inherited Paint;
  for i:=0 to FComposites.Count-1 do
    TComposite(FComposites[i]).Paint(WithRender);

  for i:=0 to FParticles.Count-1 do
    Particles[i].Paint(WithRender);

  for i:=0 to FConstraints.Count-1 do
    Constraints[i].Paint(WithRender);
end;

procedure TGroup.RemoveCollidable(g: TGroup; bFree : Boolean);
begin
  FCollisionList.Remove(g);
  if bFree then
    g.Free;
end;

procedure TGroup.removeComposite(c: TComposite; bFree : Boolean);
begin
  FComposites.Remove(c);
  c.IsParented:=False;
  if bFree then
    c.Free;
end;

procedure TGroup.SatisfyConstraints;
var i : integer;
begin
  inherited SatisfyConstraints;
  for i:=0 to FComposites.Count-1 do
    TComposite(FComposites[i]).SatisfyConstraints;
end;

end.
