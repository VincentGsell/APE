unit uRenderer.GDI;

interface

Uses uRenderer, Graphics, Classes, Math;

Type

  { TGDIRenderer }

  TGDIRenderer = Class(TAbstractRenderer)
  Private
    FCanvas : TCanvas;
    FOffsetX: Integer;
    FOffsetY: Integer;
    procedure SetOffsetX(const AValue: Integer);
    procedure SetOffsetY(const AValue: Integer);
  Public
    Constructor Create(aCanvas : TCanvas); Reintroduce;

    Procedure Circle(xcenter,ycenter,Radius, Rotate : Double); Override;
    Procedure Line(x,y,xx,yy : Double); Override;
    Procedure Text(x,y : Double; Text : String); Override;

    procedure SetOffset(X, Y : Integer);
    procedure MoveOffset(byX, byY : Integer);

    property OffsetX : Integer read FOffsetX write SetOffsetX;
    property OffsetY : Integer read FOffsetY write SetOffsetY;
  end;

implementation

{ TGDIRenderer }

procedure TGDIRenderer.Circle(xcenter, ycenter, Radius, Rotate: Double);
begin
  FCanvas.Ellipse( FOffsetX+Round(xcenter-Radius),
                   FOffsetY+Round(ycenter-radius),
                   FOffsetX+Round(xcenter+radius),
                   FOffsetY+Round(ycenter+radius));
end;

procedure TGDIRenderer.SetOffsetX(const AValue: Integer);
begin
  if FOffsetX=AValue then exit;
  FOffsetX:=AValue;
end;

procedure TGDIRenderer.SetOffsetY(const AValue: Integer);
begin
  if FOffsetY=AValue then exit;
  FOffsetY:=AValue;
end;

constructor TGDIRenderer.Create(aCanvas: TCanvas);
begin
  inherited Create;
  Assert(Assigned(aCanvas));
  FCanvas:=aCanvas;
  SetOffset(0, 0);
end;

procedure TGDIRenderer.Line(x, y, xx, yy: Double);
begin
  FCanvas.MoveTo(FOffsetX+Round(x),FOffsetY+Round(y));
  FCanvas.LineTo(FOffsetX+Round(xx),FOffsetY+Round(yy));
end;

procedure TGDIRenderer.Text(x, y : Double; Text: String);
begin
  FCanvas.TextOut(FOffsetX+Round(x),FOffsetY+Round(y),Text);
end;

procedure TGDIRenderer.SetOffset(X, Y: Integer);
begin
  FOffsetX := X;
  FOffsetY := Y;
end;

procedure TGDIRenderer.MoveOffset(byX, byY: Integer);
begin
  FOffsetX := FOffsetX + byX;
  FOffsetY := FOffsetY + byY;
end;

end.