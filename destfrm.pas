unit destfrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfDest = class(TForm)
    Label1: TLabel;
    eDestPath: TEdit;
    bOK: TButton;
    bCancel: TButton;
  public
    procedure setData(const s:string);
    function getData:string;
  end;

var
  fDest: TfDest;

implementation

{$R *.DFM}

{ TfDest }

function TfDest.getData: string;
begin
  Result := eDestPath.Text;
end;

procedure TfDest.setData(const s: string);
begin
  eDestPath.Text := s;
end;

end.
