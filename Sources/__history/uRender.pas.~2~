unit uRenderer;

interface

uses uVector;

Type

  { TAbstractRenderer }

  TAbstractRenderer = Class
  public
    constructor Create; virtual;
    destructor Destroy; override;
    Procedure Rectangle(xcenter,ycenter,Width, height, Rotate : Double);
    Procedure Circle(xcenter,ycenter,Radius, Rotate : Double); Virtual; Abstract;
    Procedure Line(x,y,xx,yy : Double); virtual; abstract;
    Procedure Text(x,y : Double; Text : String); Virtual; Abstract;
  end;

  { TTracer }

  TTracer = class
  private
    FAngle: Double;
    FDir : TVector;
    Fposx: Double;
    Fposy: Double;
    function GetDir: PVector;
    procedure Setangle(const Value: Double);
    procedure SetDir(const AValue: PVector);
    procedure Setposx(const AValue: Double);
    procedure Setposy(const AValue: Double);
  public
    constructor create(startX,StartY : double); virtual;
    destructor Destroy; override;

    procedure stepby(value : Double);

    property Angle : Double read FAngle write Setangle;
    property posx : Double read Fposx write Setposx;
    property posy : Double read Fposy write Setposy;
    property dir : PVector read GetDir write SetDir;
  end;

implementation

uses Math, uLogger;

{ TAbstractRenderer }

constructor TAbstractRenderer.Create;
begin
  LogAddObj(self);
end;

destructor TAbstractRenderer.Destroy;
begin
  LogRemoveObj(self);
  inherited Destroy;
end;

procedure TAbstractRenderer.Rectangle(xcenter, ycenter, Width, height,
  Rotate: Double);
var a : TTracer;
  x1,y1,x2,y2,x3,y3,x4,y4 : Double;
begin
  a:=TTracer.create(xcenter,ycenter);
  try
    a.Angle:=DegToRad(Rotate+180);
    a.stepby(width/2);
    a.Angle:=DegToRad(Rotate+90);
    a.stepby(height/2);

    x1:=a.posx;
    y1:=a.posy;

    a.Angle:=DegToRad(Rotate);
    a.stepby(width);
    x2:=a.posx;
    y2:=a.posy;

    a.Angle:=DegToRad(Rotate-90);
    a.stepby(height);
    x3:=a.posx;
    y3:=a.posy;

    a.Angle:=DegToRad(Rotate+180);
    a.stepby(width);
    x4:=a.posx;
    y4:=a.posy;

    Line(x1,y1,x2,y2);
    Line(x2,y2,x3,y3);
    Line(x3,y3,x4,y4);
    Line(x4,y4,x1,y1);
  finally
    a.Free;
  end;
end;

{ TTracer }

constructor TTracer.create(startX, StartY: double);
begin
  LogAddObj(self);
  fposx:=startX;
  fposy:=StartY;
  fdir:=Vector(1,0);
end;

destructor TTracer.Destroy;
begin
  LogRemoveObj(self);
  inherited Destroy;
end;

procedure TTracer.Setangle(const Value: Double);
begin
  FAngle := Value;
  ResetAngle(@fdir);
  TurnAngle(@fdir, Value);
end;

function TTracer.GetDir: PVector;
begin
  result := @fdir;
end;

procedure TTracer.SetDir(const AValue: PVector);
begin
  fdir := AValue^;
end;

procedure TTracer.Setposx(const AValue: Double);
begin
  if Fposx=AValue then exit;
  Fposx:=AValue;
end;

procedure TTracer.Setposy(const AValue: Double);
begin
  if Fposy=AValue then exit;
  Fposy:=AValue;
end;

procedure TTracer.stepby(value: Double);
var a : Double;
begin
  a:=FAngle;
  fdir.x:=value;
  fdir.y:=0;
  TurnAngle(@fdir, a);
  posx:=posx+fdir.x;
  posy:=posy+fdir.y;
end;

end.
