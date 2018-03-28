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
unit uInterval;

interface

type

  { TInterval }

  TInterval = Class
  private
    Fmax: Double;
    Fmin: Double;
    procedure Setmax(const AValue: Double);
    procedure Setmin(const AValue: Double);
  Public
    Constructor Create(amin,amax : Double); virtual;
    destructor Destroy; override;

    property min : Double read Fmin write Setmin;
    property max : Double read Fmax write Setmax;
  end;

implementation

uses SysUtils, uLogger;

{ Interval }

procedure TInterval.Setmax(const AValue: Double);
begin
  if Fmax=AValue then exit;
  Fmax:=AValue;
end;

procedure TInterval.Setmin(const AValue: Double);
begin
  if Fmin=AValue then exit;
  Fmin:=AValue;
end;

constructor TInterval.Create(amin, amax: Double);
begin
  LogAddObj(self);
  fmin:=amin;
  fmax:=amax;
end;

destructor TInterval.Destroy;
begin
  LogRemoveObj(self);
  inherited Destroy;
end;

end.
