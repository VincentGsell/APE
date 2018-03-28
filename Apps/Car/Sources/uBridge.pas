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
unit uBridge;

interface

Uses uGroup, uCircleParticle, uSpringConstraint, uApeEngine, uRenderer;

Type
  TBridge = class(TGroup)
  Private
  Public
    Constructor Create(Render : TAbstractRenderer; aEngine : TApeEngine); reintroduce; Virtual;
  End;

implementation

{ Bridge }

constructor TBridge.Create(Render : TAbstractRenderer; aEngine : TApeEngine);
var bx : Double;
    By : Double;
    bsize : Double;
    yslope : Double;
    ParticleSize : Double;

    bridgePAA, bridgePA, bridgePB, bridgePC, bridgePD, bridgePDD : TCircleParticle;
    bridgeConnA, bridgeConnB, bridgeConnC, bridgeConnD, bridgeConnE : TSpringConstraint;
begin
  inherited Create(False);
  bx := 170;
  By := 40;
  bsize := 51.5;
  yslope := 2.4;
  ParticleSize := 4;

	bridgePAA:= TCircleParticle.Create(bx,by,particleSize,true);
	addParticle(bridgePAA);

	bx := bx + bsize;
	by := By + yslope;

	bridgePA := TCircleParticle.Create(bx,by,particleSize);
	addParticle(bridgePA);

	bx := bx + bsize;
	by := By + yslope;
	bridgePB := TCircleParticle.Create(bx,by,particleSize);
	addParticle(bridgePB);

	bx := bx + bsize;
	by := By + yslope;
	bridgePC := TCircleParticle.Create(bx,by,particleSize);
	addParticle(bridgePC);

	bx := bx + bsize;
	by := By + yslope;
  bridgePD := TCircleParticle.Create(bx,by,particleSize);
	addParticle(bridgePD);

	bx := bx + bsize;
	by := By + yslope;
	bridgePDD := TCircleParticle.Create(bx,by,particleSize,true);
	addParticle(bridgePDD);


  bridgeConnA := TSpringConstraint.Create(bridgePAA, bridgePA, 0.9, true, 10, 0.8);

	bridgeConnA.FixedEndLimit := 0.25;
	addConstraint(bridgeConnA);

	bridgeConnB := TSpringConstraint.Create(bridgePA, bridgePB,0.9, true, 10, 0.8);
	addConstraint(bridgeConnB);

  bridgeConnC := TSpringConstraint.Create(bridgePB, bridgePC,0.9, true, 10, 0.8);
	addConstraint(bridgeConnC);

  bridgeConnD := TSpringConstraint.Create(bridgePC, bridgePD,	0.9, true, 10, 0.8);
	addConstraint(bridgeConnD);

  bridgeConnE := TSpringConstraint.Create(bridgePD, bridgePDD,	0.9, true, 10, 0.8);
	bridgeConnE.fixedEndLimit := 0.25;
  addConstraint(bridgeConnE);
end;

end.
