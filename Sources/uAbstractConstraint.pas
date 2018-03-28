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
unit uAbstractConstraint;

interface

Uses uAbstractITem, uRenderer;

type

  { TAbstractConstraint }

  TAbstractConstraint = Class(TAbstractItem)
  Private
    FRenderer: TAbstractRenderer;
    Fstiffness : double;
  Public
    constructor Create(aStiffness : Double); Reintroduce;
    destructor Destroy; override;

    Function Stiffness : Double; Overload;
    Procedure Stiffness(Value : Double); Overload;

    Procedure SetRenderer(TheRenderer : TAbstractRenderer);

    Procedure Resolve; Virtual; Abstract;
    property Renderer : TAbstractRenderer read FRenderer write SetRenderer;
  end;

implementation

{ TAbstractConstraint }

constructor TAbstractConstraint.Create(aStiffness: Double);
begin
  Inherited Create;
  fstiffness := aStiffness;
end;

destructor TAbstractConstraint.Destroy;
begin
  inherited Destroy;
end;

function TAbstractConstraint.Stiffness: Double;
begin
  Result := Fstiffness;
end;

procedure TAbstractConstraint.SetRenderer(TheRenderer: TAbstractRenderer);
begin
  FRenderer := TheRenderer;
end;

procedure TAbstractConstraint.Stiffness(Value: Double);
begin
  Fstiffness := Value;
end;

end.


