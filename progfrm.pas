unit progfrm;

interface

uses

  fsrep,

  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls;

type
  TfProgress = class(TForm)
    Label1: TLabel;
    pbCurrent: TProgressBar;
    Label2: TLabel;
    pbOverall: TProgressBar;
    Bevel1: TBevel;
    bCancel: TButton;
    eCurrent: TEdit;
    lOverall: TLabel;
    lCurrent: TLabel;
    tUpdate: TTimer;
  public
    Reporter : TFSReporter;
  end;

var
  fProgress: TfProgress;

implementation

{$R *.DFM}

end.
