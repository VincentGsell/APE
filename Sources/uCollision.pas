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
