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
unit uCollision;

interface

Uses uVector;

type

  { TCollision }

  TCollision = Class
  private
    Fvn: TVector;
    Fvt: TVector;
    function Getvn: PVector;
    function Getvt: PVector;
    procedure Setvn(const AValue: PVector);
    procedure Setvt(const AValue: PVector);
  Public
    Constructor Create(avn, avt : TVector); virtual;
    destructor destroy; override;

    property vn : PVector read Getvn write Setvn;
    property vt : PVector read Getvt write Setvt;
  end;

implementation

uses
  uLogger;

{ TCollision }

procedure TCollision.Setvn(const AValue: PVector);
begin
  Fvn:=AValue^;
end;

function TCollision.Getvn: PVector;
begin
  result := @fvn;
end;

function TCollision.Getvt: PVector;
begin
  result := @fvt;
end;

procedure TCollision.Setvt(const AValue: PVector);
begin
  Fvt:=AValue^;
end;

constructor TCollision.Create(avn, avt: TVector);
begin
  LogAddObj(self);
  Fvn := avn;
  Fvt := avt;
end;

destructor TCollision.destroy;
begin
  LogRemoveObj(self);
  inherited destroy;
end;

end.
