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
unit uMathUtil;

interface

Uses Math;

Const
  ONE_EIGHTY_OVER_PI = 180 / PI;
  PI_OVER_ONE_EIGHTY = PI / 180;

Function Clamp(n,min,max : Double) : Double;
Function Sign(val : Double) : Integer;

implementation
Function Clamp(n,min,max : Double) : Double;
begin
  If n<min then
    result := min
  else if n> max then
    Result:=max
  else
    Result:=n;
end;

Function Sign(val : Double) : Integer;
begin
  if val<0 then
    result:=-1
  else
    Result:=1;
end;

end.
