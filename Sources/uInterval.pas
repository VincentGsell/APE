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
