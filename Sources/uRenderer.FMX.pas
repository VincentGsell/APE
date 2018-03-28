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
unit uRenderer.FMX;

interface

Uses uRenderer, FMX.Graphics, Classes, Math, system.Types, System.UITypes, System.SysUtils;

Type

  { TFMXRenderer }

  TFMXRenderer = Class(TAbstractRenderer)
  Private
    FDefaultBrush : TStrokeBrush;
    FCanvas : TCanvas;
    FOffsetX: Integer;
    FOffsetY: Integer;
    procedure SetOffsetX(const AValue: Integer);
    procedure SetOffsetY(const AValue: Integer);
  Public
    Constructor Create(aCanvas : TCanvas); Reintroduce;
    Destructor Destroy; Override;

    Procedure Circle(xcenter,ycenter,Radius, Rotate : Double); Override;
    Procedure Line(x,y,xx,yy : Double); Override;
    Procedure Text(x,y : Double; Text : String); Override;

    procedure SetOffset(X, Y : Integer);
    procedure MoveOffset(byX, byY : Integer);

    property OffsetX : Integer read FOffsetX write SetOffsetX;
    property OffsetY : Integer read FOffsetY write SetOffsetY;
  end;

implementation

{ TFMXRenderer }

procedure TFMXRenderer.Circle(xcenter, ycenter, Radius, Rotate: Double);
begin
  FCanvas.DrawEllipse(Rect(FOffsetX+Round(xcenter-Radius),
                   FOffsetY+Round(ycenter-radius),
                   FOffsetX+Round(xcenter+radius),
                   FOffsetY+Round(ycenter+radius)),
                   1.0,FDefaultBrush);
end;

procedure TFMXRenderer.SetOffsetX(const AValue: Integer);
begin
  if FOffsetX=AValue then exit;
  FOffsetX:=AValue;
end;

procedure TFMXRenderer.SetOffsetY(const AValue: Integer);
begin
  if FOffsetY=AValue then exit;
  FOffsetY:=AValue;
end;

constructor TFMXRenderer.Create(aCanvas: TCanvas);
begin
  inherited Create;
  Assert(Assigned(aCanvas));
  FCanvas:=aCanvas;
  SetOffset(0, 0);
  FDefaultBrush := TStrokeBrush.Create(TBrushKind.Solid, TAlphaColorRec.Blue);
  FCanvas.Stroke.Color := TAlphaColorRec.Blue;
end;

destructor TFMXRenderer.Destroy;
begin
  FreeAndNil(FDefaultBrush);
  inherited;
end;

procedure TFMXRenderer.Line(x, y, xx, yy: Double);
begin
  FCanvas.DrawLine(Pointf(FOffsetX+Round(x),FOffsetY+Round(y)),PointF(FOffsetX+Round(xx),FOffsetY+Round(yy)),1.0,FDefaultBrush);
end;

procedure TFMXRenderer.Text(x, y : Double; Text: String);
begin
//  FCanvas.DrawTextOut(FOffsetX+Round(x),FOffsetY+Round(y),Text);
end;

procedure TFMXRenderer.SetOffset(X, Y: Integer);
begin
  FOffsetX := X;
  FOffsetY := Y;
end;

procedure TFMXRenderer.MoveOffset(byX, byY: Integer);
begin
  FOffsetX := FOffsetX + byX;
  FOffsetY := FOffsetY + byY;
end;

end.
