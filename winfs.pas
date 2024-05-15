// windows file system

unit winfs;

interface

uses

  Windows, SysUtils, FS, Classes;

const

  defAttributes = faReadOnly or faHidden or faSysFile or faDirectory or faArchive;

  faNormal     = $80;
  faTemporary  = $100;
  faCompressed = $800;
  faOffline    = $1000;

type

  TWinFSItem = class(TFSItem)
    Size : longword;
    Attr : integer;
    Time : TDateTime;
  end;

  TWindowsFileSystem = class(TFileSystem)
  private
    FDriveLetter : char;
    function AttrToStr(attr: integer): string;
  protected
    function getItemCount:integer;override;
    function  getLabel:string;override;
    procedure setLabel(const newlabel:string);override;
    function  getSize:Int64;override;
    function  getFreeSpace:Int64;override;
    function getAttr(attr:integer):string;
  public
    procedure Configure;override;
    procedure setLocation(const loc:string);override;
    function  setParentLocation:string;override;
    function  isRoot:boolean;override;
    procedure readContents;override;
    procedure sortContents(prop:TFSProperty);override;
    function  hasChanged:boolean;override;

    procedure buildPropertyList(list:TFSPropertyList);override;
    procedure getItemProperties(item:TFSItem; list:TFSPropertyList);override;
    function getItemProperty(item:TFSItem; prop:TFSProperty):boolean;override;
    procedure setItemProperty(item:TFSItem; prop:TFSProperty);override;
    function  getItemIcon(item:TFSItem):HICON;override;

    function  createStream(const name:string; mode:integer):TStream;override;

    procedure DeleteItem(item:TFSItem);override;
    procedure RenameItem(item:TFSItem; const newname:string);override;

    procedure CopyItem(item:TFSItem; const destName:string);override;
    procedure MoveItem(item:TFSItem; const newName:string);override;

    procedure getActionList(list:TFSActionList);override;
    procedure performAction(item:TFSItem; action:TFSAction);override;

    class function canHandle(const loc:string):boolean;override;
end;

implementation

{ TWindowsFileSystem }

procedure TWindowsFileSystem.DeleteItem(item: TFSItem);
begin
  if not DeleteFile(Location+item.Name) then raise EFSIOError.Create;
end;

function TWindowsFileSystem.getAttr(attr: integer): string;
begin
  case attr of
    faReadOnly : Result := 'Read only';
    faHidden : Result := 'Hidden';
    faSysFile : Result := 'System';
    faArchive : Result := 'Archive';
    faNormal : Result := 'Normal';
    faTemporary  : Result := 'Temporary';
    faCompressed : Result := 'Compressed';
    faOffline : Result := 'Offline';
    else Result := '';
  end; {case}
end;

function TWindowsFileSystem.getFreeSpace;
begin
  Result := DiskFree(byte(FDriveLetter)-64);
end;

function TWindowsFileSystem.getSize;
begin
  Result := DiskSize(byte(FDriveLetter)-64);
end;

function TWindowsFileSystem.createStream(const name: string; mode:integer): TStream;
begin
  Result := TFileStream.Create(Location+name,mode);
end;

procedure TWindowsFileSystem.readContents;
var
  rec:TSearchRec;
  item:TWinFSItem;
begin
  Items.Clear;
  if FindFirst(Location+'*.*',defAttributes,rec) = 0 then repeat
    if rec.Name <> '.' then begin
      item := TWinFSItem.Create(Self);
      with item do begin
        Name := rec.Name;
        Size := rec.Size;
        Attr := rec.Attr;
        Time := FileDateToDateTime(rec.Time);
        Flags := ifCanRead;
        if rec.Attr and faDirectory <> 0 then begin
          Flags := Flags or ifContainer;
          ImageIndex := 1;
        end;
        if rec.Attr and (faHidden or faSysFile) <> 0 then Flags := Flags or ifHoly;
        if rec.Attr and faReadOnly = 0 then Flags := Flags or ifCanWrite;
      end;
      Items.Add(item);
    end;
  until FindNext(rec) <> 0 else raise EFSIOError.Create;
  FindClose(rec);
end;

procedure TWindowsFileSystem.RenameItem(item: TFSItem;
  const newname: string);
begin
  if not RenameFile(Location+item.Name,newname) then EFSIOError.Create;
end;

procedure TWindowsFileSystem.setLocation(const loc: string);
var
  s:string;
begin
  s := IncludeTrailingBackslash(ExpandFileName(loc));
  ChDir(s);
  if IOResult <> 0 then raise EFSIOError.CreateFmt('Couldnt access to %s',[s]);
  inherited setLocation(s);
  FDriveLetter := upcase(Location[1]);
end;

class function TWindowsFileSystem.CanHandle(const loc: string): boolean;
begin
  Result := false;
  if length(loc) > 1 then
    if ((upcase(loc[1]) in ['A'..'Z']) and (loc[2]=':')) or ((loc[1]='\') and (loc[2]='\')) then Result := true;
end;

function CopyProgress(TotalFileSize,TotalBytesTransferred,StreamSize,
  StreamBytesTransferred:Int64; dwStreamNumber,dwCallBackReason:DWORD;
  hSourceFile,hDestinationFile:THandle; FS:TFileSystem):DWORD;stdcall;
begin
  FS.Reporter.setProgress(TotalBytesTransferred,TotalFileSize);
  Result := PROGRESS_CONTINUE;
end;

procedure TWindowsFileSystem.CopyItem;
begin
  if not CopyFileEx(PChar(Location+item.Name),PChar(destName),@CopyProgress,Self,
    @Reporter.CancelNotifier,COPY_FILE_RESTARTABLE) then raise EFSIOError.Create;
end;

function TWindowsFileSystem.AttrToStr(attr: integer): string;
  function hm(i:integer; const exp:string):string;
  begin
    if attr and i <> 0 then
      Result := exp+' '
    else
      Result := '';
  end;
begin
  Result := hm(faReadOnly,'r/o')+
            hm(faHidden,'hid')+
            hm(faSysFile,'sys')+
            hm(faArchive,'arc')+
            hm(faNormal,'nrm')+
            hm(faTemporary,'tmp')+
            hm(faCompressed,'lzw')+
            hm(faOffline,'off');
end;

procedure TWindowsFileSystem.buildPropertyList(list: TFSPropertyList);
begin
  inherited;
end;

procedure TWindowsFileSystem.Configure;
begin
  inherited;
end;

procedure TWindowsFileSystem.getActionList(list: TFSActionList);
begin
  inherited;
end;

function TWindowsFileSystem.getItemCount: integer;
begin
  Result := Items.Count;
end;

function TWindowsFileSystem.getItemIcon(item: TFSItem): HICON;
begin
  Result := $FFFFFFFF;
end;

procedure TWindowsFileSystem.getItemProperties(item: TFSItem;
  list: TFSPropertyList);
begin
  inherited;
end;

function TWindowsFileSystem.getItemProperty(item: TFSItem;
  prop: TFSProperty): boolean;
begin

end;

function TWindowsFileSystem.getLabel: string;
begin

end;

function TWindowsFileSystem.hasChanged: boolean;
begin

end;

function TWindowsFileSystem.isRoot: boolean;
begin

end;

procedure TWindowsFileSystem.MoveItem(item: TFSItem;
  const newName: string);
begin
  inherited;

end;

procedure TWindowsFileSystem.performAction(item: TFSItem;
  action: TFSAction);
begin
  inherited;

end;

procedure TWindowsFileSystem.setItemProperty(item: TFSItem;
  prop: TFSProperty);
begin
  inherited;

end;

procedure TWindowsFileSystem.setLabel(const newlabel: string);
begin
  inherited;

end;

function TWindowsFileSystem.setParentLocation: string;
var
  temp:string;
begin
  temp := Location;
  setLength(temp,length(temp)-1);
  Result := ExtractFileName(temp);
  setLocation(temp+'\..');
end;

procedure TWindowsFileSystem.sortContents(prop: TFSProperty);
begin
  inherited;
end;

initialization
begin
  fsRegister('Native',TWindowsFileSystem);
end;

end.
