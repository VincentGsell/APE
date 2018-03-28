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
