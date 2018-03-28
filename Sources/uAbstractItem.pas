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
