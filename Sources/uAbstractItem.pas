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
unit uAbstractItem;

interface

uses
  uRenderer;

Type
  { TAbstractItem }

  TAbstractItem = class
  private
    FVisible : Boolean;
    FAlwaysRepaint : Boolean;
    function GetAR: Boolean;
    function GetVisible: Boolean;
    procedure SetAR(const Value: Boolean);
    procedure SetVisible(const Value: Boolean);
  Public
    Constructor Create; Virtual;
    destructor Destroy; override;

    Procedure Init; Virtual; Abstract;
    Procedure Paint(WithRender : TAbstractRenderer); Virtual; Abstract;
    Procedure CleanUp; Virtual; Abstract;
    Property Visible : Boolean read GetVisible Write SetVisible;
    Property AlwaysRepaint : Boolean read GetAR Write SetAR;
  end;

implementation

uses uLogger;

{ TAbstractItem }

constructor TAbstractItem.Create;
begin
  LogAddObj(self);
  Visible := true;
  AlwaysRepaint := False;
end;

destructor TAbstractItem.Destroy;
begin
  LogRemoveObj(self);
  inherited Destroy;
end;

function TAbstractItem.GetAR: Boolean;
begin
  Result := FAlwaysRepaint;
end;

function TAbstractItem.GetVisible: Boolean;
begin
  Result := FVisible;
end;

procedure TAbstractItem.SetAR(const Value: Boolean);
begin
  FAlwaysRepaint := Value;
end;

procedure TAbstractItem.SetVisible(const Value: Boolean);
begin
   FVisible := Value;
end;

end.
