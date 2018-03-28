unit uApeEngine;

interface

Uses uVector, uGroup, uRenderer, Classes;

Type

  { TApeEngine }

  TApeEngine = Class
  Private
    FForce : TVector;
    FMasslessForce : TVector;
    TimeSteps : Double;
    FDamping : Double;
    FConstraintCycles : Integer;
    FConstraintCollisionCycle : Integer;
    FGroups : TList;

    function GetGroups(index : integer): TGroup;
    function GetNumGroups: Integer;
    function GetConstraintCollisionCycle: Integer;
    function GetConstraintCycle: Integer;
    procedure SetConstraintCollisionCycle(const Value: Integer);
    procedure SetConstraintCycle(const Value: Integer);
    function GetDamping: Double;
    procedure SetDamping(const Value: Double);

    Procedure Integrate;
    Procedure SatisfyConstraints;
    Procedure CheckCollisions;
  Public
    constructor Create; virtual;
    destructor Destroy; override;

    Procedure Init(deltatime : Double = 0.25);

    Procedure AddForce(v : TVector);
    Procedure AddMasslessForce(v : TVector);
    Procedure AddGroup(g : TGroup);
    Procedure RemoveGroup(g : TGroup; bFree : Boolean = false);

    Procedure Step;
    Procedure Paint(WithRender : TAbstractRenderer);
    Property NumGroups : Integer read GetNumGroups;
    Property ConstraintCycles : Integer read GetConstraintCycle Write SetConstraintCycle;
    Property ConstraintCollisionCycles : Integer read GetConstraintCollisionCycle Write SetConstraintCollisionCycle;
    Property Damping : Double read GetDamping Write SetDamping;
    property Groups[index : integer] : TGroup read GetGroups;
  end;

implementation

uses
  uLogger;

{ TApeEngine }

procedure TApeEngine.AddForce(v: TVector);
begin
  PlusEquals(@FForce, v);
end;

procedure TApeEngine.AddGroup(g: TGroup);
begin
  FGroups.Add(g);
  g.IsPArented:=True;
  g.Init;
end;

procedure TApeEngine.AddMasslessForce(v: TVector);
begin
  PlusEquals(@FMasslessForce, v);
end;

procedure TApeEngine.CheckCollisions;
var j : integer;
begin
  for j:= 0 to FGroups.Count-1 do
    Groups[j].CheckCollision;
end;

constructor TApeEngine.Create;
begin
  LogAddObj(self);
end;

destructor TApeEngine.Destroy;
var
  g : TGroup;
begin
  while(NumGroups > 0) do
    RemoveGroup(Groups[NumGroups-1], true);
  LogRemoveObj(self);
  inherited Destroy;
end;

function TApeEngine.GetConstraintCollisionCycle: Integer;
begin
  Result:=FConstraintCollisionCycle;
end;

function TApeEngine.GetConstraintCycle: Integer;
begin
  Result:=FConstraintCycles;
end;

function TApeEngine.GetDamping: Double;
begin
  Result:=FDamping;
end;

function TApeEngine.GetNumGroups: Integer;
begin
  result:=FGroups.count;
end;

function TApeEngine.GetGroups(index : integer): TGroup;
begin
  result := TGroup(FGroups[index]);
end;

procedure TApeEngine.Init(deltatime: Double);
begin
  TimeSteps := deltatime * deltatime;
  FGroups := TList.Create;
  FForce:=Vector(0,0);
  FMasslessForce:=Vector(0,0);
  Damping := 1;
  FConstraintCycles:=0;
  FConstraintCollisionCycle:=1;
end;

procedure TApeEngine.Integrate;
var j : integer;
begin
  for j:= 0 to FGroups.Count-1 do
    Groups[j].Integrate(TimeSteps,FForce,FMasslessForce,Damping);
end;

procedure TApeEngine.Paint(WithRender : TAbstractRenderer);
var i : integer;
begin
  for i:=0 to FGroups.Count-1 do
    Groups[i].Paint(WithRender);
end;

procedure TApeEngine.RemoveGroup(g: TGroup; bFree : Boolean);
begin
  FGroups.Remove(g);
  g.IsPArented:=false;
  if bFree then
    g.free;
end;

procedure TApeEngine.SatisfyConstraints;
var j : integer;
begin
  for j:= 0 to FGroups.Count-1 do
    Groups[j].SatisfyConstraints;
end;

procedure TApeEngine.SetConstraintCollisionCycle(const Value: Integer);
begin
  FConstraintCollisionCycle:=Value;
end;

procedure TApeEngine.SetConstraintCycle(const Value: Integer);
begin
  FConstraintCycles:=Value;
end;

procedure TApeEngine.SetDamping(const Value: Double);
begin
  FDamping:=Value;
end;

procedure TApeEngine.Step;
var i : integer;
begin
  Integrate;
  For i:=0 to FConstraintCycles -1 do
    SatisfyConstraints;

  For i:=0 to FConstraintCollisionCycle -1 do
  begin
    SatisfyConstraints;
    CheckCollisions;
  end;
end;

end.
