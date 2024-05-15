unit mainfrm;

interface

uses

  panelfr,

  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ComCtrls, ExtCtrls, StdCtrls, ToolWin;

type

  TfMain = class(TForm)
    mmMain: TMainMenu;
    Dosya1: TMenuItem;
    Duzen1: TMenuItem;
    Yardim1: TMenuItem;
    PitikareCommanderHakkinda1: TMenuItem;
    Biiileryap1: TMenuItem;
    N1: TMenuItem;
    Programdancik1: TMenuItem;
    Bunelan1: TMenuItem;
    cbConsole: TCoolBar;
    pConsole: TPanel;
    memConsole: TMemo;
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PitikareCommanderHakkinda1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  public
    procedure RefreshPanels;
    procedure AddPanel(const location:string);
    function getTargetPanel:TfrPanel;
    function askDestination(const title:string; var path:string):boolean;

    procedure doCopy;
  end;

var
  fMain: TfMain;

implementation

uses

  fs, destfrm, procs, aboutfrm;

{$R *.DFM}

procedure TfMain.AddPanel;
var
  Panel:TfrPanel;
  i:integer;
begin
  Panel := TfrPanel.Create(Self);
  i := Panels.Add(Panel);
  with Panel do begin
    Name := 'p'+IntToStr(i);
    Align := alLeft;
    Parent := Self;
    Width := ClientWidth div 2;
    Go(location);
  end;
end;

procedure TfMain.FormShow(Sender: TObject);
begin
  AddPanel('C:\');
  AddPanel('D:\');
//  AddPanel('D:\Delphi5\');
end;

procedure TfMain.RefreshPanels;
var
  n:integer;
  panel:TfrPanel;
begin
  for n:=0 to Panels.Count-1 do begin
    panel := Panels[n] as TfrPanel;
    panel.Rebuild;
  end;
end;

procedure TfMain.FormResize(Sender: TObject);
var
  n,cnt:integer;
  panel:TfrPanel;
begin
  cnt := Panels.Count;
  for n:=0 to cnt-1 do begin
    panel := Panels[n] as TfrPanel;
    panel.Width := ClientWidth div cnt;
  end;
end;

procedure TfMain.PitikareCommanderHakkinda1Click(Sender: TObject);
begin
  Application.CreateForm(TfAbout,fAbout);
  fAbout.ShowModal;
  fAbout.Free;
end;

procedure TfMain.FormCreate(Sender: TObject);
begin
  debug('Init',cApp+' '+cVersion);
end;

procedure TfMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  ctrl:boolean;
begin
  ctrl := ssCtrl in Shift;
  case Key of
    VK_F10 : debug('MemDump','AllocMemCount='+IntToStr(AllocMemCount));
    byte('R') : if ctrl and (activePanel <> NIL) then ActivePanel.Rebuild else exit;
    VK_F5 : doCopy;
    else exit;
  end; {case}
  Key := 0;
end;

procedure TfMain.doCopy;
var
  destPath:string;
  targetPanel:TfrPanel;
  n:integer;
  item:TFSItem;
begin
  targetPanel := getTargetPanel;
  if targetPanel <> NIL then destPath := targetPanel.ActiveFS.Location;
  if not askDestination('Copy to',destPath) then exit;
  with ActivePanel.ActiveFS do begin
    for n:=0 to Items.Count-1 do begin
      item := Items[n] as TFSItem;
      if item.Selected then CopyItem(item,destPath+item.Name);
    end;
  end;
end;

function TfMain.getTargetPanel: TfrPanel;
var
  n:integer;
begin
  for n:=0 to Panels.Count-1 do begin
    Result := Panels[n] as TfrPanel;
    if Result <> ActivePanel then exit;
  end;
  Result := NIL;
end;

function TfMain.askDestination(const title: string;
  var path: string): boolean;
begin
  Application.CreateForm(TfDest,fDest);
  fDest.setData(path);
  if fDest.ShowModal = mrOK then begin
    path := fDest.getData;
    Result := true;
  end else Result := false;
  fDest.Free;
end;

end.
