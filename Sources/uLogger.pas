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
unit uLogger;

interface

{$DEFINE USE_LOGGER} // log to a file
{$DEFINE CLEAR_LOG_ON_RUN} // clear the log file on each run

procedure Log(msg : AnsiString);
procedure LogClassNotFreed(aclass : tobject);
procedure LogAddObj(obj : TObject);
procedure LogRemoveObj(obj : TObject);

implementation

uses SysUtils, Classes;

var
  fLog : TFileStream;
  fObjs: TList;

procedure Log(msg: AnsiString);
begin
{$IFDEF USE_LOGGER}
  msg := '[' + DateTimeToStr(Now) + '] ' + msg + #13#10;
  fLog.WriteBuffer(msg[1], length(msg));
{$ENDIF}
end;

procedure LogClassNotFreed(aclass: tobject);
//var
//  i : PtrInt;
begin
//  i := PtrInt(pointer(aClass));
//  Log(format('Class (%d) %s not freed some place in code.', [i, aclass.ClassName]));
end;

procedure LogAddObj(obj: TObject);
begin
  FObjs.Add(obj);
end;

procedure LogRemoveObj(obj: TObject);
begin
  FObjs.Remove(obj);
end;

procedure ReportLogObjs;
var
  i : Integer;
begin
  for i := 0 to fObjs.Count -1 do
    LogClassNotFreed(TObject(fObjs[i]));
end;

initialization
{$IFDEF USE_LOGGER}
  {$IFNDEF CLEAR_LOG_ON_RUN}
    if(FileExists(ChangeFileExt(ParamStr(0), '.log'))) then
      begin
        fLog := TFileStream.Create(ChangeFileExt(ParamStr(0), '.log'), fmOpenWrite);
        fLog.Position := fLog.Size;
      end
    else
  {$ENDIF}
    fLog := TFileStream.Create(ChangeFileExt(ParamStr(0), '.log'), fmCreate);
  fObjs := TList.Create;
{$ENDIF}

finalization
{$IFDEF USE_LOGGER}
  ReportLogObjs;
  fLog.Free;
  fObjs.Free;
{$ENDIF}

end.
