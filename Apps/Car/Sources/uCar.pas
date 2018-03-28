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
