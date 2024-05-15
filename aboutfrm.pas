unit aboutfrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfAbout = class(TForm)
    Label1: TLabel;
    lbFS: TListBox;
    bClose: TButton;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
  public
    procedure BuildFSList;
  end;

var
  fAbout: TfAbout;

implementation

uses

  FS;

{$R *.DFM}

procedure TfAbout.BuildFSList;
var
  P:PFileSystemRegistration;
begin
  lbFS.Items.BeginUpdate;
  lbFS.Items.Clear;
  P := fsList;
  while P <> NIL do begin
    lbFS.Items.Add(P^.Name);
    P := P^.Next;
  end;
  lbFS.Items.EndUpdate;
end;

procedure TfAbout.FormCreate(Sender: TObject);
begin
  BuildFSList;
end;

end.
