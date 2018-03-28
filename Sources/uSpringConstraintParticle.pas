unit uSpringConstraintParticle;

interface

Uses uRectangleParticle, uAbstractParticle, uSpringConstraint, uVector,
     uMathUtil, uCircleParticle, SysUtils, uRenderer;

Type
  TSpringConstraintParticle = class(TRectangleParticle)
  Private
		fp1:TAbstractParticle;
		fp2:TAbstractParticle;

		avgVelocity:TVector;
		lambda:TVector;
		parent:TSpringConstraint;
		fscaleToLength:Boolean;
    s : Double;

		rca:TVector;
		rcb:TVector;

		FrectScale:Double;
		FrectHeight:Double;
		FfixedEndLimit:Double;
  Public
    function GetMass: Double; Override;
    function GetElasticity: Double; override;
    function GetFriction: Double; Override;
    function GetVelocity: TVector; Override;
    function GetInvMass: Double; Override;

    Constructor Create( p1,p2 : TAbstractParticle; p : TSpringConstraint;
                        aRectHeight, aRectScale : Double; bScaleToLength : Boolean); Reintroduce;

    Procedure init; Override;
    Procedure Paint(WithRender : TAbstractRenderer); Override;
    Procedure UpdatePosition;
    Procedure ResolveCollision(mtd,vel,n : TVector; d : Double; o : Integer; p : TAbstractParticle); Override;
    Function ClosestParamPoint(c : TVector) : Double;
    Function GetContactParamPoint(p : TAbstractParticle) : Double;
    Procedure SetCorners(r : TRectangleParticle; i : Integer);
    Function ClosestPtSegmentSegment : Double;

    Property RectScale : Double read FrectScale Write FrectScale;
    Property RectHeight : Double Read FrectHeight Write FrectHeight;
    Property FixedEndLimit : Double Read FfixedEndLimit Write FfixedEndLimit;
    property Mass : Double Read GetMass;
    property InvMass : Double Read GetInvMass;
    Property Friction : Double Read GetFriction;
    property Elasticity : Double Read GetElasticity;
    Property Velocity : TVector Read GetVelocity;
  End;

implementation

{ TSpringConstraintParticle }

function TSpringConstraintParticle.ClosestParamPoint(c: TVector): Double;
var ab : TVector;
    t : Double;
begin
  ab := minus(fp2.curr^, fp1.curr^);
  t := dot(ab, minus(c, fp1.curr^)) / (dot(ab, ab));
	Result := Clamp(t, 0, 1);
end;

function TSpringConstraintParticle.ClosestPtSegmentSegment: Double;
var pp1,pq1,pp2,pq2 : TVector;
    d1,d2,r : TVector;
    t,a,e,f : Double;
    c,b,denom : Double;
    c1,c2,c1mc2 : TVector;

begin
	pp1 := fp1.curr^;
	pq1 := fp2.curr^;
	pp2 := rca;
	pq2 := rcb;

	d1 := minus(pq1, pp1);
	d2 := minus(pq2, pp2);
	r := minus(pp1, pp2);

	a := dot(d1, d1);
	e := dot(d2, d2);
	f := dot(d2, r);

	c := dot(d1, r);
	b := dot(d1, d2);
	denom := a * e - b * b;

	if (denom <> 0.0) then
    s := Clamp((b*f-c*e) / denom,0,1)
  else
  begin
    s := 0.5
  end;
  t:=(b*s+f) / e;

  if (t<0) then
  begin
    t:=0;
    s:= Clamp(-c / a,0,1);
  end
  else
  if (t>0) then
  begin
    t:=1;
    s:=clamp((b-c) / a,0,1)
  end;

  c1 := plus(pp1, mult(d1, s));
  c2 := plus(pp2, mult(d2, t));
  c1mc2 := minus(c1, c2);
	Result := dot(c1mc2, c1mc2);
end;

constructor TSpringConstraintParticle.Create(p1, p2: TAbstractParticle;
  p: TSpringConstraint; aRectHeight, aRectScale: Double;
  bScaleToLength: Boolean);
begin
  inherited Create(0,0,0,0,0,False,0.1,0,0);
  fp1 := p1;
  fp2 := p2;
  lambda := Vector(0,0);
  avgVelocity := Vector(0,0);

  Parent := p;

  fRectScale := aRectScale;
  fRectHeight := aRectHeight;
  fScaleToLength := bScaleToLength;
  FixedEndLimit := 0;

  rca := Vector(0, 0);
  rcb := Vector(0, 0);
end;

//* returns the average friction of the two connected particles
function TSpringConstraintParticle.GetContactParamPoint(
  p: TAbstractParticle): Double;
var t,d : Double;
    ShortestIndex : Integer;
    ShortestDistance : Double;
    ParamList : array[0..3] of Double;
    i : integer;
begin
	if (p is TCircleParticle) then
    t := closestParamPoint(p.curr^)
  else if (p is TRectangleParticle) then
    begin
      shortestDistance := High(Integer);
    	// go through the sides of the colliding rectangle as line segments
  		for i:=0 to 3 do
      begin
        shortestIndex:=0; //Because compil warning.
    		setCorners(TRectangleParticle(p), i);
        // check for closest points on SCP to side of rectangle
  			d := closestPtSegmentSegment;
  			if (d < shortestDistance) then
        begin
  				shortestDistance := d;
  				shortestIndex := i;
  				paramList[i] := s;
        end;
      end;
    	t := paramList[shortestIndex];
    end
  else
    raise Exception.Create('TSpringConstraintParticle.GetContactParamPoint : Unknown Particle Type');
	Result :=  t;
end;

function TSpringConstraintParticle.GetElasticity: Double;
begin
  Result := (fp1.Elasticity + fp2.Elasticity) / 2;
end;

//* returns the average friction of the two connected particles
function TSpringConstraintParticle.GetFriction: Double;
begin
  Result := (fp1.Friction + fp2.Friction) / 2;
end;

//* returns the average mass of the two connected particles
function TSpringConstraintParticle.GetInvMass: Double;
begin
  if (Fp1.Fixed And Fp2.Fixed) then
    Result:=0
  else
    Result:= 1 / ((Fp1.Mass+Fp2.Mass) /2)
end;

function TSpringConstraintParticle.GetMass: Double;
begin
  Result := (fp1.Mass + fp2.Mass) / 2;
end;

//* returns the average velocity of the two connected particles
function TSpringConstraintParticle.GetVelocity: TVector;
var p1v, p2v : TVector;
begin
  p1v := fp1.Velocity;
  p2v := fp2.Velocity;

  avgVelocity := Vector(((p1v.x + p2v.x) / 2), ((p1v.y + p2v.y) / 2));

  Result := avgVelocity;
end;

procedure TSpringConstraintParticle.init;
begin
  inherited;

end;

procedure TSpringConstraintParticle.Paint(WithRender : TAbstractRenderer);
var w,h : Double;
    c : TVector;
begin
  //inherited;
  c := Parent.center;
  w := parent.CurrLength * RectScale;
  h := RectHeight;
  WithRender.Rectangle(c.x,c.y,w,h,Parent.angle);
end;

procedure TSpringConstraintParticle.ResolveCollision(mtd, vel, n: TVector;
  d: Double; o: Integer; p: TAbstractParticle);
var t,c1,c2 : Double;
    Denom : Double;
    corrParticle : TAbstractParticle;
begin
  inherited;

  t := GetContactParamPoint(p);
  c1 := 1-t;
  c2 := t;

  // if one is fixed then move the other particle the entire way out of collision.
	// also, dispose of collisions at the sides of the scp. The higher the fixedEndLimit
	// value, the more of the scp not be effected by collision.
  if (fp1.fixed) Then
    begin
  		if (c2 <= fixedEndLimit) then
        Exit;

  		lambda := Vector(mtd.x / c2, mtd.y / c2);
  		plusEquals(fp2.curr, lambda);
  		fp2.velocity := vel;
  	End
  else if (fp2.fixed) then
    begin
    	if (c1 <= fixedEndLimit) then
        Exit;
    	lambda := Vector(mtd.x / c1, mtd.y / c1);
  		plusEquals(fp1.curr, lambda);
  		fp1.velocity := vel;
    end
  else
    begin
  		// else both non fixed - move proportionally out of collision
      denom := c1 * c1 + c2 * c2;
  		if (denom = 0) Then
        Exit;
  		lambda := Vector(mtd.x / denom, mtd.y / denom);

  		plusEquals(fp1.curr, mult(lambda, c1));
  		plusEquals(fp2.curr, mult(lambda, c2));

      //if collision is in the middle of SCP set the velocity of both end particles
      if (t = 0.5) then
        begin
    		  fp1.velocity := vel;
    			fp2.velocity := vel;
        end
  		else
      begin
    		// otherwise change the velocity of the particle closest to contact
        If t<0.5 then
          corrParticle := fp1
        else
          corrParticle := fp2;

         corrParticle.Velocity := Vel;
      end;
    end;
end;

procedure TSpringConstraintParticle.SetCorners(r: TRectangleParticle;
  i: Integer);
var rx,ry,ae0Fx,ae0Fy,ae1Fx,ae1Fy,emx,emy, epx,epy : Double;
    aaxes : TRctTypeVector;
    aExtents : TRctTypeDouble;
begin
  rx := r.curr^.x;
  ry := r.curr^.y;

  aaxes := r.axes;
  aextents := r.extents;

  ae0Fx  := aaxes[0].x * aextents[0];
  ae0Fy  := aaxes[0].y * aextents[0];
  ae1Fx  := aaxes[1].x * aextents[1];
  ae1Fy  := aaxes[1].y * aextents[1];

  emx := ae0Fx - ae1Fx;
  emy := ae0Fy - ae1Fy;
  epx := ae0Fx + ae1Fx;
  epy := ae0Fy + ae1Fy;

  if (i = 0) then
  begin	// 0 and 1
		rca.x := rx - epx;
		rca.y := ry - epy;
		rcb.x := rx + emx;
		rcb.y := ry + emy;
  end
  else
  if (i = 1) Then
  Begin	// 1 and 2
		rca.x := rx + emx;
		rca.y := ry + emy;
		rcb.x := rx + epx;
		rcb.y := ry + epy;
  end
  else
  if (i = 2) Then
  begin	// 2 and 3
		rca.x := rx + epx;
		rca.y := ry + epy;
		rcb.x := rx - emx;
		rcb.y := ry - emy;
	end
  else
  if (i = 3) then
  begin	// 3 and 0
		rca.x := rx - emx;
		rca.y := ry - emy;
		rcb.x := rx - epx;
		rcb.y := ry - epy;
  end;
end;

procedure TSpringConstraintParticle.UpdatePosition;
var c : TVector;
begin
  c := parent.center;
	fcurr := Vector(c.x, c.y);

  if fscaleToLength then
    Width := Parent.CurrLength * RectScale
  else
    Width := parent.RestLength * RectScale;

  Height := RectHeight;
  Radian := Parent.Radian;
end;

end.
