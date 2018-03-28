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
unit uRimParticle;

interface

Uses uVector, Math, uApeEngine;

type

  { TRimPArticle }

  TRimPArticle = class(TObject)
  Private
		wr : Double;
		av : Double ;
		sp : Double;
		maxTorque : Double;
    FApeEngine : TApeEngine;
  	fcurr : TVector;
		fprev : TVector;
    function GetCurr: PVector;
    function GetPrev: PVector;
    procedure SetCurr(const AValue: PVector);
    procedure SetPrev(const AValue: PVector);
  Public
    Constructor Create(anApeEngine : TApeEngine; Ar : Double; Mt : Double);
    destructor Destroy; override;
    
    Procedure Update(dt : Double);

    Property Speed : Double read sp Write sp;
    property AngularVelocity : Double read av Write av;
    property curr : PVector read GetCurr write SetCurr;
    property prev : PVector read GetPrev write SetPrev;
  End;

implementation

uses
  uLogger;

{ TRimPArticle }

function TRimPArticle.GetCurr: PVector;
begin
  result := @fcurr;
end;

function TRimPArticle.GetPrev: PVector;
begin
  result := @fprev;
end;

procedure TRimPArticle.SetCurr(const AValue: PVector);
begin
  fcurr := AValue^;
end;

procedure TRimPArticle.SetPrev(const AValue: PVector);
begin
  fprev := AValue^;
end;

constructor TRimParticle.Create(anApeEngine : TApeEngine; Ar : Double; Mt : Double);
begin
  LogAddObj(self);
  fcurr := Vector(ar,0);
  fprev := Vector(0,0);
  sp := 0;
  av := 0;
  FApeEngine := anApeEngine;

  maxTorque := mt;
  wr := ar;
end;

destructor TRimPArticle.Destroy;
begin
  LogRemoveObj(self);
  inherited Destroy;
end;

procedure TRimPArticle.Update(dt: Double);
var dx, dy, Len, ox, oy, px, py, clen, diff : Double;
begin
  //Origins of this code are from Raigan Burns, Metanet Software
  //Clamp torques to valid range
  sp := max(-maxTorque, min(maxTorque, sp + av));

  //Apply torque
	//This is the tangent TVector at the rim particle
	dx := -fcurr.y;
	dy := fcurr.x;

	//Normalize so we can scale by the rotational speed
	len := sqrt(dx * dx + dy * dy);

  If Len <>0 then
  begin
	  dx := dx/len;
	  dy := dy/len;
  end;

	fcurr.x := fcurr.x + sp * dx;
	fcurr.y := fcurr.y + sp * dy;

	ox := fprev.x;
	oy := fprev.y;
  fprev.x := fcurr.x;
  fprev.y := fcurr.y;
	px := fprev.x;
	py := fprev.y;

	fcurr.x := FApeEngine.damping * (px - ox);
	fcurr.y := FApeEngine.damping * (py - oy);

	// hold the rim particle in place
	clen := sqrt(fcurr.x * fcurr.x + fcurr.y * fcurr.y);
  if clen<>0 then
  Begin
	  diff := (clen - wr) / clen;
	  fcurr.x := fcurr.x - fcurr.x * diff;
	  fcurr.y := fcurr.y - fcurr.y * diff;
  end;
end;

end.
