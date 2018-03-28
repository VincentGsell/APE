unit uCollisionDetector;

interface

Uses uAbstractParticle, uVector, uRectangleParticle, uCircleParticle, uInterval, uCollisionResolver;

Type

  { TCollisionDetector }

  TCollisionDetector = Class
  Public
    constructor Create; virtual;
    destructor Destroy; override;

    Procedure Test(ObjA, ObjB : TAbstractParticle);
    Procedure NormVsNorm(ObjA,OBjB : TAbstractParticle);
    Procedure SampVsNorm(ObjA,OBjB : TAbstractParticle);
    Procedure SampVsSamp(ObjA,OBjB : TAbstractParticle);
    Function TestTypes(ObjA,OBjB : TAbstractParticle) : Boolean;
    Function TestOBBvsOBB(rA,rB : TRectangleParticle) : Boolean;
    Function TestCirclevsCircle(ca, cb : TCircleParticle) : Boolean;
    Function TestOBBvsCircle(ra : TRectangleParticle; ca : TCircleParticle) : Boolean;

    Function TestIntervals(IntervalA, IntervalB : TInterval) : Double;
    Function ClosestVertexOnOBB(p : TVector; r : TRectangleParticle) : TVector;
  end;

var CollisionDetectorInstance : TCollisionDetector;

implementation

uses
  uLogger;

{ TCollisionDetector }

function TCollisionDetector.ClosestVertexOnOBB(p: TVector;
  r: TRectangleParticle): TVector;
var d,q : TVector;
    i : integer;
    dist : Double;
begin
  d:=Minus(p, r.Samp^);
  q:=Vector(r.Samp^.x,r.Samp^.y);
  for i:=0 to 1 do
  begin
    dist := Dot(d, r.axes[i]);
    if dist>=0 then
      dist := r.extents[i]
    else
      dist := - r.extents[i];

    PlusEquals(@q, Mult(r.axes[i], dist));
  end;
  result:=q;
end;


procedure TCollisionDetector.NormVsNorm(ObjA, OBjB: TAbstractParticle);
begin
  CopyVector(obja.Samp, obja.Curr^);
  CopyVector(objb.Samp, objb.Curr^);
  TestTypes(obja,objb);
end;

procedure TCollisionDetector.SampVsNorm(ObjA, OBjB: TAbstractParticle);
var s,t : Double;
    i : integer;
begin
  s:=1/ (ObjA.MultiSample+1);
  t :=s;
  CopyVector(objb.Samp, objb.Curr^);

  for i:=0 to ObjA.MultiSample-1 do
  begin
    ObjA.Samp^ := Vector( Obja.Prev^.x + t * (ObjA.Curr^.x - obja.Prev^.x),
                     Obja.Prev^.y + t * (ObjA.Curr^.y - obja.Prev^.y));
    if TestTypes(obja,objb) then
      Exit;
    t:=t+s;
  end;
end;

procedure TCollisionDetector.SampVsSamp(ObjA, OBjB: TAbstractParticle);
var s,t : Double;
    i : integer;
begin
  s:=1/ (ObjA.MultiSample+1);
  t :=s;
  CopyVector(objb.Samp, objb.Curr^);

  for i:=0 to ObjA.MultiSample-1 do
  begin
    ObjA.Samp^ := Vector( Obja.Prev^.x + t * (ObjA.Curr^.x - obja.Prev^.x),
                     Obja.Prev^.y + t * (ObjA.Curr^.y - obja.Prev^.y));
    Objb.Samp^ := Vector( Objb.Prev^.x + t * (Objb.Curr^.x - objb.Prev^.x),
                     Objb.Prev^.y + t * (Objb.Curr^.y - objb.Prev^.y));
    if TestTypes(obja,objb) then
      Exit;
    t:=t+s;
  end;
end;

constructor TCollisionDetector.Create;
begin
  LogAddObj(self);
end;

destructor TCollisionDetector.Destroy;
begin
  LogRemoveObj(self);
  inherited Destroy;
end;

procedure TCollisionDetector.Test(ObjA, ObjB: TAbstractParticle);
begin
  if OBja.Fixed And Objb.Fixed then
    Exit;

  if (ObjA.MultiSample = 0) And (ObjB.MultiSample = 0) then
    NormVsNorm(obja,objb)
  else
  if (ObjA.MultiSample > 0) And (ObjB.MultiSample = 0) then
    SampVsNorm(Obja,Objb)
  else
  if (ObjB.MultiSample > 0) And (ObjA.MultiSample = 0) then
    SampVsNorm(Objb,Obja)
  else
  if Obja.MultiSample=objb.MultiSample then
    SampVsSamp(obja,objb)
  else
    NormVsNorm(obja,objb);

end;

function TCollisionDetector.TestCirclevsCircle(ca,
  cb: TCircleParticle): Boolean;
var DepthX, DepthY : Double;
    CollisionNormal : TVector;
    CollisionDepth : Double;
    Mag : Double;
begin
  Result := False;

  DepthX := TestIntervals(ca.GetIntervalX,cb.GetIntervalX);
  if DepthX = 0 then
  begin
    Exit;
  end;

   DepthY := TestIntervals(ca.GetIntervalY, cb.GetIntervalY);
   if DepthY = 0 then
   begin
     Exit;
   end;

   CollisionNormal := Minus(ca.Samp^, cb.Samp^);
   mag := Magnitude(CollisionNormal);
   CollisionDepth := (ca.Radius + cb.Radius) - mag;

   if CollisionDepth>0 then
   begin
     DivEquals(@CollisionNormal, mag);
     CollisionResolverInstance.ResolveParticleParticle(ca,cb,CollisionNormal,CollisionDepth);
     Result := true;
   end;
end;

function TCollisionDetector.TestIntervals(IntervalA,
  IntervalB: TInterval): Double;
var lena,lenB : Double;
begin
  if IntervalA.Max<IntervalB.Min then
    Result:=0
  else
    if IntervalB.Max<IntervalA.Min then
      Result:=0
    else
    begin
      lenA:=IntervalB.max-IntervalA.min;
      lenb:=IntervalB.min-IntervalA.max;
      result:=lenB;
      if abs(lenA) < abs(lenb) then
        Result:=lenA;
    end;
end;

function TCollisionDetector.TestOBBvsCircle(ra: TRectangleParticle;
  ca: TCircleParticle): Boolean;
var CollisionNormal : TVector;
    CollisionDepth : Double;
    Depths : Array[0..1] of Double;
    i : Integer;
    BoxAxis : TVector;
    Depth : Double;
    r : Double;
    Vertex : TVector;
    mag : Double;
begin

  CollisionDepth := High(Integer);
  CollisionNormal := ra.Axes[0]; //Initialisation

  // first go through the axes of the rectangle
  for i:= 0 to 1 do
  begin
    BoxAxis:=ra.axes[i];
    Depth := TestIntervals(ra.GetProjection(BoxAxis), ca.GetProjection(BoxAxis));

    If Depth = 0 then
    begin
      Result := False;
      Exit;
    end;

    if Abs(depth) < Abs(CollisionDepth) then
    begin
      CollisionNormal:= BoxAxis;
      CollisionDepth := Depth;
    end;

    Depths[i]:=Depth;
  end;

  // determine if the circle's center is in a vertex region
  r := ca.Radius;

  if (abs(Depths[0]) < r) And (Abs(Depths[1])<r) Then
  begin
    Vertex := ClosestVertexOnOBB(ca.Samp^,ra);
    // get the distance from the closest vertex on rect to circle center
    CollisionNormal := Minus(Vertex, ca.Samp^);
    mag := Magnitude(CollisionNormal);
    CollisionDepth := r - mag;

    If CollisionDepth > 0 then
      DivEquals(@CollisionNormal, mag)
    else
      begin
        Result := False;
        Exit;
      end;
  end;

  CollisionResolverInstance.resolveParticleParticle(ra, ca, collisionNormal, collisionDepth);
  Result :=True;
end;

function TCollisionDetector.TestOBBvsOBB(rA,
  rB: TRectangleParticle): Boolean;
var CollisionNormal : TVector;
    CollisionDepth : Double;
    i : integer;
    axisA, Axisb : TVector;
    absA,AbsB : Double;
    DepthA,DepthB : Double;
    altb : Boolean;
begin
  CollisionDepth := High(Integer);
  CollisionNormal := ra.Axes[0]; //Initialisation

  For i:=0 to 1 do
  begin
    axisA:=ra.axes[i];
    depthA:=TestIntervals(ra.GetProjection(AxisA),rb.GetProjection(axisA));
    if DepthA = 0 then
    begin
      Result:=False;
      Exit;
    end;

    axisB:=rb.axes[i];
    DepthB:=TestIntervals(ra.GetProjection(AxisB),rb.GetProjection(axisB));
    if DepthB = 0 then
    begin
      Result:=False;
      Exit;
    end;

    absa:=abs(deptha);
    absb:=abs(depthb);

    if (absa < abs(CollisionDepth)) or (absb < abs(CollisionDepth)) then
    begin
      altb:=absa<absb;
      CollisionNormal:=axisB;
      CollisionDepth:=depthB;

      if altb then
      begin
        CollisionNormal:=axisA;
        CollisionDepth:=DepthA;
      end;
    end;
  end;

  CollisionResolverInstance.ResolveParticleParticle(ra,rB,CollisionNormal,CollisionDepth);
  Result:=true;
end;

function TCollisionDetector.TestTypes(ObjA,
  OBjB: TAbstractParticle): Boolean;
begin
  Result:=False;
  if (ObjA is TRectangleParticle) And (Objb is TRectangleParticle) then
    Result := TestOBBvsOBB(TRectangleParticle(obja),TRectangleParticle(objb))
  else
  if (ObjA is TCircleParticle) And (OBjB is TCircleParticle) then
    Result := TestCirclevsCircle(TCircleParticle(ObjA),TCircleParticle(OBjB))
  else
  if (ObjA is TRectangleParticle) And (OBjB is TCircleParticle) then
    Result := TestOBBvsCircle(TRectangleParticle(ObjA),TCircleParticle(OBjB))
  else
  if (ObjA is TCircleParticle) And (OBjB is TRectangleParticle) then
    Result := TestOBBvsCircle(TRectangleParticle(ObjB),TCircleParticle(OBjA));
end;

Initialization
  CollisionDetectorInstance:=TCollisionDetector.Create;
 
Finalization
  CollisionDetectorInstance.Free;

end.
