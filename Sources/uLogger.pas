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
