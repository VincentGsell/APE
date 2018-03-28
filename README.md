# APE 2d Physics Engine in ObjectPascal...

Back in 2009, I converted the 2d alpha-stage physics engine APE, from Flash ActionScript to Object Pascal (FPC and delphi).
This engine was initialy wrote by Alec Cove (his site, http://www.cove.org/ape/ doesnt not response anymore - Where are you Alec ? ;))

I put this work today on GitHub because, even some years laters, somebodies asked me if I always got the source : Effetively, this engine is a good start to teach secret behind computer 2d physics. So, It is here for archive.

I made first conversion version from "raw action script", the original one could be found now on several ActionScript dedicated web site. On historical APE site, there was Java and c++ conversion too.

I'll release now this code as is, perhaps it could be usefull for somebody ? I think It could be cool for a 2d casual game, or, as I said, just for teaching purpose : When I translate this code, I do not change Alec's original architecture, which I found right and solid :  I feel the Original ActionScript code very well written : try to keep its Object Model in Pascal version.
Warning : This engine is quite old front of today's standart, if you look for a fats 2d engine, see elewhere. (In this one, for keep it simple for teaching reason, there are *no* optimzation.

## The base concept is simple : 
On grouping Particles with constraints, you'll build model with a real physical response, then, you register Collision interaction and you'll get a "physical Word"

## quick Features : 
- Circles, Rectangles and Wheels particles.
- Spring constraints.
- Groups processing.
- Groups Collision.

## Pure ObjectPascal :
- Lazarus (Win64/32 and Linux Arm tested)
- Delphi (VCL an dFMX) are available.

Here the looks of Pascal Version, in Delphi (FMX) :
## ScreenShots : (Delphi/FMX)

Ape in action with original Car Demo
  ![Alt text](/res/APE2DDelphiFMX.png?raw=true "Ape in action with original Car Demo (Delphu/FMX")

## Demo available
See "Car" examples, which is the original demo provide by original author.
