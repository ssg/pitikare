{
Basic filesystem

}

unit fs;

interface

uses

  fsrep,

  Windows, SysUtils, contnrs, Classes;

const

  ifContainer = 1;  // item is container
  ifCanRead   = 2;  // fs can read item
  ifCanWrite  = 4;  // fs can write item
  ifHoly      = 8;  // item is holy
  ifEncrypted = 16; // item requires password

  // property id's

  piName = 1;
  piSize = 2;
  piDate = 3;
  piAttr = 4;

type

  TFSPropertyAlignment = (paLeft,paRight);

  TFileSystem = class;
  TFileSystemClass = class of TFileSystem;

  TFSPropertyList = class(TObjectList);

  TFSProperty = class(TObject)
    id : integer;
    CharWidth : integer;
    Alignment : TFSPropertyAlignment;
    Value : string;
    Title : string;

    constructor Create(aid:integer; const atitle:string; align:TFSPropertyAlignment; width:integer);
  end;

  TFSItem = class(TObject)
  protected
    function getPropertyList:TFSPropertyList;virtual;
  public
    Owner : TFileSystem;
    Flags : integer;

    Size  : Int64;
    Date  : TDateTime;
    Attr  : integer;
    Name  : string;
    ImageIndex : integer;
    Selected : boolean;

    constructor Create(aowner:TFileSystem);
    property Properties:TFSPropertyList read getPropertyList;
  end;

  TFSItemList = class(TObjectList);

  TFSActionList = class(TObjectList);

  TFSAction = class(TObject)
    Name : string;
  end;

  TFileSystem = class(TObject)
  private
    FReporter : TFSReporter;
    FItemList : TFSItemList;
    FPropertyList : TFSPropertyList;
    FLocation : string;
  protected
    function getItemCount:integer;virtual;
    function  getLabel:string;virtual;
    procedure setLabel(const newlabel:string);virtual;
    function  getSize:Int64;virtual;
    function  getFreeSpace:Int64;virtual;
  public
    constructor Create(rep:TFSReporter);
    destructor Destroy;override;

    procedure Configure;virtual;
    procedure setLocation(const loc:string);virtual;
    function  setParentLocation:string;virtual;
    function  isRoot:boolean;virtual;
    procedure readContents;virtual;
    procedure sortContents(prop:TFSProperty);virtual;
    function  hasChanged:boolean;virtual;

    procedure buildPropertyList(list:TFSPropertyList);virtual;
    procedure getItemProperties(item:TFSItem; list:TFSPropertyList);virtual;
    function  getItemProperty(item:TFSItem; prop:TFSProperty):boolean;virtual;
    procedure setItemProperty(item:TFSItem; prop:TFSProperty);virtual;
    function  getItemIcon(item:TFSItem):HICON;virtual;

    function  createStream(const name:string; mode:integer):TStream;virtual;

    procedure DeleteItem(item:TFSItem);virtual;
    procedure RenameItem(item:TFSItem; const newname:string);virtual;

    procedure CopyItem(item:TFSItem; const destName:string);virtual;
    procedure MoveItem(item:TFSItem; const newName:string);virtual;

    procedure getActionList(list:TFSActionList);virtual;
    procedure performAction(item:TFSItem; action:TFSAction);virtual;

    class function canHandle(const loc:string):boolean;virtual;

    property Reporter:TFSReporter read FReporter;
    property Size:Int64 read getSize;
    property FreeSpace:Int64 read getFreeSpace;
    property VolumeLabel:string read getLabel write setLabel;
    property Location:string read FLocation;
    property Items:TFSItemList read FItemList;
    property ItemCount:integer read getItemCount;
    property PropertyList:TFSPropertyList read FPropertyList;
  end;

  EFSException = class(Exception)
    constructor Create;
  end;

  EFSNotSupported = class(EFSException);
  EFSIOError = class(EFSException);

  PFileSystemRegistration = ^TFileSystemRegistration;
  TFileSystemRegistration = record
    Next : PFileSystemRegistration;
    Instance : TFileSystemClass;
    Name : string[75];
  end;

procedure fsRegister(const name:string; fs:TFileSystemClass);
function fsFind(const loc:string):TFileSystemClass;

const

  fsList : PFileSystemRegistration = NIL;

implementation

function fsFind;
var
  P:PFileSystemRegistration;
begin
  P := fsList;
  while P <> NIL do begin
    if P^.Instance.CanHandle(loc) then begin
      Result := P^.Instance;
      exit;
    end;
    P := P^.Next;
  end;
  Result := NIL;
end;  

procedure fsRegister;
var
  P:PFileSystemRegistration;
begin
  New(P);
  P^.Name := Name;
  P^.Instance := fs;
  P^.Next := fsList;
  fsList := P;
end;

procedure fsUnregisterAll;
  procedure Unreg(P:PFileSystemRegistration);
  begin
    if P = NIL then exit;
    if P^.Next <> NIL then Unreg(P^.Next);
    Dispose(P);
  end;
begin
  Unreg(fsList);
end;

{ TFileSystem }

constructor TFileSystem.Create;
begin
  inherited Create;
  FItemList := TFSItemList.Create;
  FReporter := rep;
  FPropertyList := TFSPropertyList.Create;
  BuildPropertyList(FPropertyList);
end;

destructor TFileSystem.Destroy;
begin
  inherited;
  FPropertyList.Free;
  FItemList.Free;
end;

class function TFileSystem.canHandle(const loc: string): boolean;
begin
  Result := false;
end;

procedure TFileSystem.Configure;
begin
  // do nothing
end;

procedure TFileSystem.CopyItem(item: TFSItem; const destName: string);
begin
  raise EFSNotSupported.Create;
end;

procedure TFileSystem.DeleteItem(item: TFSItem);
begin
  raise EFSNotSupported.Create;
end;

procedure TFileSystem.getActionList(list: TFSActionList);
begin
  // do nothing
end;

function TFileSystem.getFreeSpace: Int64;
begin
  raise EFSNotSupported.Create;
end;

function TFileSystem.getItemCount: integer;
begin
  Result := FItemList.Count;
end;

function TFileSystem.getItemIcon(item: TFSItem): HICON;
begin
  if item.Flags and ifContainer <> 0 then Result := 1 else Result := 0;
end;

procedure TFileSystem.getItemProperties(item: TFSItem;
  list: TFSPropertyList);
var
  n:integer;
begin
  for n:=0 to list.Count-1 do getItemProperty(item, list[n] as TFSProperty);
end;

function TFileSystem.getItemProperty;
begin
  with prop, item do case id of
    piName : Value := Name;
    piSize : Value := FormatFloat('#,##0',Size);
    piDate : Value := FormatDateTime('dd/mm/yyyy hh:nn',Date);
    piAttr : Value := IntToHex(item.Attr,4);
    else begin
      Result := false;
      exit;
    end;
  end; {case}
  Result := true;
end;

function TFileSystem.getLabel: string;
begin
  Result := '';
end;

function TFileSystem.getSize: Int64;
begin
  Result := -1;
end;

function TFileSystem.hasChanged: boolean;
begin
  Result := false;
end;

function TFileSystem.isRoot: boolean;
begin
  Result := true;
end;

procedure TFileSystem.MoveItem(item: TFSItem; const newName: string);
begin
  raise EFSNotSupported.Create;
end;

procedure TFileSystem.performAction(item: TFSItem; action: TFSAction);
begin
  // no actions
end;

procedure TFileSystem.readContents;
begin
  // no content
end;

procedure TFileSystem.RenameItem(item: TFSItem; const newname:string);
begin
  raise EFSNotSupported.Create;
end;

procedure TFileSystem.setItemProperty(item: TFSItem; prop: TFSProperty);
begin
  raise EFSNotSupported.Create;
end;

procedure TFileSystem.setLabel(const newlabel: string);
begin
  raise EFSNotSupported.Create;
end;

procedure TFileSystem.setLocation(const loc: string);
begin
  FLocation := loc;
end;

function TFileSystem.setParentLocation;
begin
  raise EFSNotSupported.Create;
end;

procedure TFileSystem.buildPropertyList(list: TFSPropertyList);
  procedure add(id:integer; const title:string; al:TFSPropertyAlignment; charwidth:integer);
  begin
    list.Add(TFSProperty.Create(id,title,al,charwidth));
  end;
begin
  add(piName,'Name',paLeft,20);
  add(piSize,'Size',paRight,11);
  add(piAttr,'Attr',paLeft,10);
  add(piDate,'Date',paLeft,16);
end;

procedure TFileSystem.sortContents(prop: TFSProperty);
begin
  // do nothing
end;

function TFileSystem.createStream(const name: string;
  mode: integer): TStream;
begin
  raise EFSNotSupported.Create;
end;

{ EFSException }

constructor EFSException.Create;
begin
  inherited Create('');
end;

{ TFSProperty }

constructor TFSProperty.Create;
begin
  inherited Create;
  id := aid;
  Title := atitle;
  Alignment := align;
  CharWidth := width;
end;

{ TFSItem }

constructor TFSItem.Create(aowner: TFileSystem);
begin
  inherited Create;
  Owner := aowner;
end;

function TFSItem.getPropertyList: TFSPropertyList;
begin
  Result := Owner.PropertyList;
end;

initialization
begin
end;

finalization
begin
  fsUnregisterAll;
end;

end.
