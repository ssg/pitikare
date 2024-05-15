unit panelfr;

interface

uses

  fs, fsrep,

  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  contnrs, ComCtrls, StdCtrls, CommanderListView, ImgList, Mask;

type
  TfrPanel = class(TFrame)
    eStatus: TEdit;
    lvList: TListView;
    ilImages: TImageList;
    eLocation: TComboBox;
    procedure lvListDblClick(Sender: TObject);
    procedure lvListData(Sender: TObject; Item: TListItem);
    procedure lvListDataHint(Sender: TObject; StartIndex,
      EndIndex: Integer);
    procedure lvListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lvListDataFind(Sender: TObject; Find: TItemFind;
      const FindString: String; const FindPosition: TPoint;
      FindData: Pointer; StartIndex: Integer; Direction: TSearchDirection;
      Wrap: Boolean; var Index: Integer);
    procedure lvListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure eLocationKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lvListChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure lvListEnter(Sender: TObject);
  private
    allowSelect : boolean;
    lockFocus : boolean;
    lastFocused : integer;
  public
    ActiveFS : TFileSystem;
    Reporter : TFSReporter;

    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;

    procedure go(const aloc:string);
    procedure Rebuild;
    procedure BuildColumns;
    procedure focusItem(index:integer);

    procedure actionPrevDir;
    procedure actionSelect;
    procedure actionGo;
  end;

  TPanelList = TObjectList;

const

  defScrollGap = 40;

  ActivePanel : TFrPanel = NIL;
  Panels : TPanelList = NIL;

implementation

uses

  ShellAPI, procs;

{$R *.DFM}

procedure TfrPanel.Rebuild;
begin
  if ActiveFS = NIL then exit;
  lvList.Items.Count := ActiveFS.Items.Count;
  Debug('Rebuild','refreshing '+ActiveFS.Location);
  if ActiveFS.Items.Count > 0 then begin
    focusItem(0);
{    lvList.ItemFocused := lvList.Items[0];
    lvList.Scroll(0,-lvList.ViewOrigin.Y);}
    ActiveFS.SortContents(NIL);
    lvList.Invalidate;
  end;
end;

procedure TfrPanel.go;
var
  fs:TFileSystemClass;
begin
  fs := fsFind(aloc);
  if not (ActiveFS is fs) then begin
    if ActiveFS <> NIL then ActiveFS.Free;
    if fs = NIL then begin
      ActiveFS := NIL;
      exit;
    end;
    ActiveFS := fs.Create(Reporter);
    BuildColumns;
  end;
  ActiveFS.setLocation(aloc);
  eLocation.Text := ActiveFS.Location;
  Rebuild;
end;

procedure TfrPanel.BuildColumns;
var
  prop:TFSProperty;
  n:integer;
  t:TListColumn;
begin
  lvList.Columns.Clear;
  with ActiveFS do begin
    for n:=0 to PropertyList.Count-1 do begin
      prop := PropertyList[n] as TFSProperty;
      t := lvList.Columns.Add;
      with prop, t do begin
        Caption := Title;
        Width := CharWidth*8;
        if prop.Alignment = paRight then t.Alignment := taRightJustify;
      end;
    end;
  end;
end;

procedure TfrPanel.lvListDblClick(Sender: TObject);
begin
  actionGo;
end;

procedure TfrPanel.lvListData(Sender: TObject; Item: TListItem);
var
  sl:TStringList;
  fi:TFSItem;
  n:integer;
begin
  if ActiveFS = NIL then exit;
  with ActiveFS do begin
    if item.index > Items.Count-1 then exit;
    fi := Items[item.index] as TFSItem;
  //  item.ImageIndex := fi.ImageIndex;
    item.Data := fi;
    item.Cut := fi.Flags and ifHoly <> 0;

    getItemProperties(fi,PropertyList);

    item.Caption := (PropertyList[0] as TFSProperty).Value;
    for n:=1 to PropertyList.Count-1 do item.SubItems.Add((PropertyList[n] as TFSProperty).Value);
  end;
end;

procedure TfrPanel.lvListDataHint(Sender: TObject; StartIndex,
  EndIndex: Integer);
var
  sl:TStringList;
  n,subn:integer;
begin
  if ActiveFS = NIL then exit;
  sl := TStringList.Create;
  with ActiveFS do for n:=StartIndex to EndIndex do begin
    with lvList.Items[n] do begin
      Data := Items[n];
      ImageIndex := TFSItem(Items[n]).ImageIndex;
      GetItemProperties(TFSItem(Items[n]),PropertyList);
      Caption := (PropertyList[0] as TFSProperty).Value;
      for subn := 1 to sl.Count-1 do SubItems.Add((PropertyList[n] as TFSProperty).Value)
    end;
  end;
  sl.Free;
end;

procedure TfrPanel.lvListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
  function getRelIndex(rel:integer):integer;
  begin
    Result := lastFocused + rel;
    if Result < 0 then Result := 0;
    if Result > lvList.Items.Count-1 then Result := lvList.Items.Count-1;
  end;
begin
  if (Shift = [ssCtrl]) and (Key = VK_PRIOR) then actionPrevDir
  else if (Shift=[]) then begin
    with lvList do if Items.Count > 0 then case Key of
      VK_INSERT, VK_SPACE : actionSelect;
      VK_RETURN : actionGo;
      VK_UP : focusItem(getRelIndex(-1));
      VK_DOWN : focusItem(getRelIndex(1));
      VK_HOME : focusItem(0);
      VK_END : focusItem(Items.Count-1);
      VK_PRIOR : focusItem(getRelIndex(-VisibleRowCount));
      VK_NEXT : focusItem(getRelIndex(VisibleRowCount));
      else exit;
    end; {case}
  end else exit;
  Key := 0;
end;

procedure TfrPanel.actionPrevDir;
var
  prev : string;
  parent : string;
  item:TListItem;
begin
  with ActiveFS do begin
    if isRoot then exit;
    setParentLocation;
    item := lvList.FindCaption(0,prev,false,true,false);
    if item <> NIL then begin
      lvList.ItemFocused := item;
      lvList.Scroll(0,(item.Top-defScrollGap)-lvList.ViewOrigin.Y);
      lvList.Invalidate;
    end;
  end;
end;

procedure TfrPanel.actionSelect;
var
  item:TListItem;
begin
  item := lvList.ItemFocused;
  if item <> NIL then begin
    allowSelect := true;
    item.Selected := not item.Selected;
    item := lvList.GetNextItem(item,sdBelow,[isNone]);
    if item <> NIL then lvList.ItemFocused := item;
    allowSelect := false;
  end;
end;

procedure TfrPanel.actionGo;
var
  item:TListItem;
  fs:TFSItem;
begin
  if ActiveFS = NIL then exit;
  item := lvList.ItemFocused;
  if item = NIL then exit;
  fs := ActiveFS.Items[item.index] as TFSItem;
  if fs.Flags and ifContainer <> 0 then Go(ActiveFS.Location+item.Caption)
                                   else run(ActiveFS.Location+item.Caption);
end;

procedure TfrPanel.lvListDataFind(Sender: TObject; Find: TItemFind;
  const FindString: String; const FindPosition: TPoint; FindData: Pointer;
  StartIndex: Integer; Direction: TSearchDirection; Wrap: Boolean;
  var Index: Integer);
var
  n:integer;
  item:TFSItem;
  found:boolean;
begin
  found := false;
  for n:=0 to ActiveFS.Items.Count-1 do begin
    item := ActiveFS.Items[n] as TFSItem;
    case Find of
      ifData : found := FindData = item;
      ifPartialString : found := pos(FindString,item.Name) > 0;
      ifExactString : found := FindString = item.Name;
      else begin
        ShowMessage('Unsupported search method '+IntToStr(integer(Find)));
        exit;
      end;
    end; {case}
    if found then begin
      Index := n;
      exit;
    end;
  end;
end;

procedure TfrPanel.lvListSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if (not allowSelect) and (Item <> NIL) then begin
    allowSelect := true;
    Item.Selected := not Selected;
    allowSelect := false;
  end;
end;

procedure TfrPanel.eLocationKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_RETURN then begin
    Go(eLocation.Text);
    Key := 0;
  end;
end;

constructor TfrPanel.Create(AOwner: TComponent);
begin
  inherited;
  Reporter := TFSReporter.Create;
  if lvList.ItemFocused = NIL
    then lastFocused := -1
    else lastFocused := lvList.ItemFocused.index;
end;

procedure TfrPanel.focusItem;
var
  Bounds:TRect;
  h:integer;
  item:TListItem;
begin
  if index = lastFocused then exit;
  lockFocus := true;
  with lvList do begin
    if Items.Count = 0 then exit;
    item := Items[index];
    ItemFocused := item;
    Bounds := item.DisplayRect(drBounds);
    h := lvList.Height-24;
    if Bounds.Bottom > h then Scroll(0,Bounds.Bottom-h);
    if Bounds.Top < 24 then Scroll(0,Bounds.Top-24);
    UpdateItems(lastFocused,lastFocused);
    lastFocused := index;
  end;
  lockFocus := false;
end;

procedure TfrPanel.lvListChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  if Change = ctState then begin
    TFSItem(ActiveFS.Items[Item.Index]).Selected := Item.Selected;
    if not lockFocus then
      if lvList.ItemFocused <> NIL then lastFocused := lvList.ItemFocused.index;
  end;
end;

procedure TfrPanel.lvListEnter(Sender: TObject);
begin
  ActivePanel := Self;
end;

destructor TfrPanel.Destroy;
begin
  Reporter.Free;
  inherited;
end;

initialization
begin
  Panels := TPanelList.Create;
  Panels.OwnsObjects := false;
end;

finalization
begin
  Panels.Free;
end;

end.
