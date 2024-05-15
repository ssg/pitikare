unit fsrep;

interface

uses

  Classes;

type

  TFSReporter = class(TObject)
  protected
    FStatus : string;
    FCurVal,FCurMax : integer;
    FOverVal,FOverMax : integer;
    procedure setStatus(status:string);virtual;
    procedure setVal(newval:integer);virtual;
    procedure setMax(newmax:integer);virtual;
    procedure setOverVal(newval:integer);virtual;
    procedure setOverMax(newmax:integer);virtual;
  public
    CancelNotifier : boolean;

    procedure setProgress(current,total:integer);

    property Status:string read FStatus write setStatus;
    property Value:integer read FCurVal write setVal;
    property Max:integer read FCurMax write setMax;
    property OverValue:integer read FOverVal write setOverVal;
    property OverMax:integer read FOverMax write setOverMax;
  end;

implementation

uses

  SysUtils, procs;

{ TFSReporter }

procedure TFSReporter.setProgress(current, total: integer);
begin
  Max := total;
  Value := current;
  debug('reporter','progress: '+IntToStr(((value*100) div max)));
end;

procedure TFSReporter.setStatus(status: string);
begin
  FStatus := status;
  debug('reporter',status);
end;

procedure TFSReporter.setVal(newval: integer);
begin
  FCurval := newval;
end;

procedure TFSReporter.setMax(newmax: integer);
begin
  FCurMax := newmax;
end;

procedure TFSReporter.setOverVal(newval: integer);
begin
  FOverVal:= newval;
end;

procedure TFSReporter.setOverMax(newmax: integer);
begin
  FOverMax := newmax;
end;

end.
