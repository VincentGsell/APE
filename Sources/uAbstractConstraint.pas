unit uAbstractConstraint;

interface

Uses uAbstractITem, uRenderer;

type

  { TAbstractConstraint }

  TAbstractConstraint = Class(TAbstractItem)
  Private
    FRenderer: TAbstractRenderer;
    Fstiffness : double;
  Public
    constructor Create(aStiffness : Double); Reintroduce;
    destructor Destroy; override;

    Function Stiffness : Double; Overload;
    Procedure Stiffness(Value : Double); Overload;

    Procedure SetRenderer(TheRenderer : TAbstractRenderer);

    Procedure Resolve; Virtual; Abstract;
    property Renderer : TAbstractRenderer read FRenderer write SetRenderer;
  end;

implementation

{ TAbstractConstraint }

constructor TAbstractConstraint.Create(aStiffness: Double);
begin
  Inherited Create;
  fstiffness := aStiffness;
end;

destructor TAbstractConstraint.Destroy;
begin
  inherited Destroy;
end;

function TAbstractConstraint.Stiffness: Double;
begin
  Result := Fstiffness;
end;

procedure TAbstractConstraint.SetRenderer(TheRenderer: TAbstractRenderer);
begin
  FRenderer := TheRenderer;
end;

procedure TAbstractConstraint.Stiffness(Value: Double);
begin
  Fstiffness := Value;
end;

end.


