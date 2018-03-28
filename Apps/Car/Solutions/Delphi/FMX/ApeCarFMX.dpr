program ApeCarFMX;

uses
  System.StartUpCopy,
  FMX.Forms,
  fmain in 'fmain.pas' {FormCar},
  uAbstractCollection in '..\..\..\..\..\Sources\uAbstractCollection.pas',
  uAbstractConstraint in '..\..\..\..\..\Sources\uAbstractConstraint.pas',
  uAbstractItem in '..\..\..\..\..\Sources\uAbstractItem.pas',
  uAbstractParticle in '..\..\..\..\..\Sources\uAbstractParticle.pas',
  uApeEngine in '..\..\..\..\..\Sources\uApeEngine.pas',
  uCircleParticle in '..\..\..\..\..\Sources\uCircleParticle.pas',
  uCollision in '..\..\..\..\..\Sources\uCollision.pas',
  uCollisionDetector in '..\..\..\..\..\Sources\uCollisionDetector.pas',
  uCollisionResolver in '..\..\..\..\..\Sources\uCollisionResolver.pas',
  uComposite in '..\..\..\..\..\Sources\uComposite.pas',
  uGroup in '..\..\..\..\..\Sources\uGroup.pas',
  uInterval in '..\..\..\..\..\Sources\uInterval.pas',
  uLogger in '..\..\..\..\..\Sources\uLogger.pas',
  uMathUtil in '..\..\..\..\..\Sources\uMathUtil.pas',
  uRectangleParticle in '..\..\..\..\..\Sources\uRectangleParticle.pas',
  uRenderer in '..\..\..\..\..\Sources\uRenderer.pas',
  uRenderer.FMX in '..\..\..\..\..\Sources\uRenderer.FMX.pas',
  uRimParticle in '..\..\..\..\..\Sources\uRimParticle.pas',
  uSpringConstraint in '..\..\..\..\..\Sources\uSpringConstraint.pas',
  uSpringConstraintParticle in '..\..\..\..\..\Sources\uSpringConstraintParticle.pas',
  uSprite in '..\..\..\..\..\Sources\uSprite.pas',
  uVector in '..\..\..\..\..\Sources\uVector.pas',
  uWheelParticle in '..\..\..\..\..\Sources\uWheelParticle.pas',
  uBridge in '..\..\..\Sources\uBridge.pas',
  uCapsule in '..\..\..\Sources\uCapsule.pas',
  uCar in '..\..\..\Sources\uCar.pas',
  uRectComposite in '..\..\..\Sources\uRectComposite.pas',
  uRotator in '..\..\..\Sources\uRotator.pas',
  uSurfaces in '..\..\..\Sources\uSurfaces.pas',
  uSwingDoor in '..\..\..\Sources\uSwingDoor.pas',
  uCarLevel in '..\..\..\Sources\uCarLevel.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormCar, FormCar);
  Application.Run;
end.
