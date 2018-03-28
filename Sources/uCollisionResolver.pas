{
APE (Actionscript Physics Engine) is an AS3 open source 2D physics engine
Copyright 2006, Alec Cove

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

Contact: ape@cove.org

2009.03.01 - Converted to ObjectPascal by Vincent Gsell [https://github.com/VincentGsell]
}
unit uCollisionResolver;

interface

uses uAbstractParticle, uVector, uCollision, uMathUtil;

type

  { TCollisionResolver }

  TCollisionResolver = class
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure ResolveParticleParticle(pa, pb: TAbstractPArticle;
      normal: TVector; Depth: double);
  end;

var
  CollisionResolverInstance: TCollisionResolver;

implementation

uses uLogger;

{ TCollisionResolver }

constructor TCollisionResolver.Create;
begin
  LogAddObj(self);
end;

destructor TCollisionResolver.Destroy;
begin
  LogRemoveObj(self);
  inherited Destroy;
end;

procedure TCollisionResolver.ResolveParticleParticle(pa, pb: TAbstractPArticle;
  normal: TVector; Depth: double);
var
  mtd, vna, vnb, mtda, mtdb: TVector;
  te, suminvmass, tf: double;
  ca, cb: TCollision;
begin
  // a collision has occured. set the current positions to sample locations
  CopyVector(pa.Curr, pa.Samp^);
  CopyVector(pb.Curr, pb.Samp^);

  mtd := Mult(normal, depth);
  te  := pa.Elasticity + pb.Elasticity;
  suminvmass := pa.InvMass + pb.InvMass;

  // the total friction in a collision is combined but clamped to [0,1]
  tf := Clamp(1 - (pa.Friction + pb.Friction), 0, 1);

  // get the collision components, vn and vt
  ca := pa.GetComponents(normal);
  cb := pb.GetComponents(normal);

  // calculate the coefficient of restitution based on the mass, as the normal component
  vnA := DivVector(plus(mult(cb.vn^, (te + 1) * pa.invMass),
    mult(ca.vn^, pb.invMass - te * pa.invMass)), sumInvMass);
  vnB := DivVector(plus(mult(ca.vn^, (te + 1) * pb.invMass),
    mult(cb.vn^, pa.invMass - te * pb.invMass)), sumInvMass);

  // apply friction to the tangental component
  multEquals(ca.vt, tf);
  multEquals(cb.vt, tf);

  // scale the mtd by the ratio of the masses. heavier particles move less
  mtdA := mult(mtd, pa.invMass / sumInvMass);
  mtdB := mult(mtd, -pb.invMass / sumInvMass);

  // add the tangental component to the normal component for the new velocity
  plusEquals(@vnA, ca.vt^);
  plusEquals(@vnB, cb.vt^);

  if not pa.Fixed then
    pa.ResolveCollision(mtdA, vnA, normal, depth, -1, pb);
  if not pb.Fixed then
    pb.resolveCollision(mtdB, vnB, normal, depth, 1, pa);
end;

initialization
  CollisionResolverInstance := TCollisionResolver.Create;

finalization
  CollisionResolverInstance.Free;

end.

