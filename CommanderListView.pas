unit CommanderListView;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  CommCtrl, ComCtrls;

type
  TCommanderListView = class(TListView)
  protected
    procedure KeyDown(var Key:word; Shift:TShiftState);override;
    procedure focusChanged(selectedBefore:boolean; olditem,newitem:TListItem);
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('SSG', [TCommanderListView]);
end;

{ TCommanderListView }

procedure TCommanderListView.focusChanged(selectedBefore: boolean; olditem,
  newitem: TListItem);
begin
end;

procedure TCommanderListView.KeyDown(var Key: word; Shift: TShiftState);
var
  focSel:boolean;
  foc:TListItem;
begin
  foc := ItemFocused;
  focSel := foc.Selected;
  inherited;
  if Shift = [] then begin
    case Key of
      VK_UP, VK_DOWN : focusChanged(focSel,foc,ItemFocused);
    end; {Case}
  end;
end;

end.
