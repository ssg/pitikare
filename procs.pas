unit procs;

interface

uses

  Windows, SysUtils, Dialogs;

const

  cApp = 'Pitikare Commander';
  cVersion = '0.1 alpha';

  Debugging : boolean = true;

  maxStatusLines = 10;

// process help functions

procedure run(const what:string);  

// debug help functions

procedure debug(const src,msg:string);

// report functions

procedure ShowError(const msg:string);

// string functions

function BoolToStr(b:boolean; const sT,sF:string):string;

implementation

uses

  Controls, Forms, mainfrm;

procedure run;
var
  si:TStartupInfo;
  pi:TProcessInformation;
begin
  Screen.Cursor := crHourGlass;
  try
    FillChar(si,SizeOf(si),0);
    si.cb := SizeOf(si);
    if not CreateProcess(NIL,PChar(what),NIL,NIL,false,DETACHED_PROCESS,NIL,NIL,si,pi)
      then raise Exception.Create('Execution failed: '+what);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure status(const src,msg:string);
var
  line:string;
begin
  with fMain.memConsole do begin
    line := FormatDateTime('dd/mm/yyyy hh:nn',Now)+' ['+src+'] '+msg;
    // OutputDebugString(PChar(line));
    with Lines do begin
      while Count > maxStatusLines do Delete(0);
      Add(line);
      SelStart := length(Text);
    end;
  end;
end;

procedure debug;
begin
  if Debugging then status(src,msg);
end;

function BoolToStr;
begin
  if b then Result := sT else Result := sF;
end;

procedure ShowError;
begin
  MessageDlg(msg,mtError,[mbOK],0);
end;

end.
 