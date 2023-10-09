unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls,
  Vcl.WinXCalendars, Vcl.Buttons, Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Comp.Client,
  FireDAC.Comp.DataSet, TelemetryDBConn;

type
  TForm2 = class(TForm)
    txtTitle: TStaticText;
    dbgrd1: TDBGrid;
    grpControl: TGroupBox;
    btnUpdate: TBitBtn;
    btnRun: TBitBtn;
    clndrpckrCalendar: TCalendarPicker;
    cbbStatus: TComboBox;
    btnRefresh: TBitBtn;
    btnStop: TBitBtn;
    fdqryGetThread: TFDQuery;
    fdqryChangeStatus: TFDQuery;
    connTelemetry: TFDConnection;
    fdqryRegister: TFDQuery;
    ds1: TDataSource;
    btnReload: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure btnRunClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure btnReloadClick(Sender: TObject);
  private
    { Private declarations }
    FTelemetryDBConn : TTelemetryDBConn;
    procedure ChangeStatus(AStatus : String);
    procedure RefreshDataSource;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FTelemetryDBConn.Close;
  FreeAndNil(FTelemetryDBConn);
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  FTelemetryDBConn := TTelemetryDBConn.Create;
  FTelemetryDBConn.Connect;
end;

procedure TForm2.btnReloadClick(Sender: TObject);
begin
  RefreshDataSource;
end;

procedure TForm2.btnRunClick(Sender: TObject);
begin
  ChangeStatus('ejecutando');
end;

procedure TForm2.btnStopClick(Sender: TObject);
begin
  ChangeStatus('finalizado');
end;

procedure TForm2.btnUpdateClick(Sender: TObject);
begin
  try
    fdqryRegister.SQL.Text := 'UPDATE THREAD SET STATUS = :STATUS, FECHA = :FECHA WHERE ID = 1';
    fdqryRegister.ParamByName('STATUS').AsString := cbbStatus.Text;
    clndrpckrCalendar.DateFormat := 'dd/MM/yyyy';
    fdqryRegister.ParamByName('FECHA').AsDate := clndrpckrCalendar.Date;
    fdqryRegister.ExecSQL;
  finally
    RefreshDataSource;
  end;
end;

procedure TForm2.ChangeStatus(AStatus: string);
begin
  try
    fdqryChangeStatus.SQL.Text := 'UPDATE THREAD SET STATUS = :STATUS WHERE ID = 1';
    fdqryChangeStatus.ParamByName('STATUS').AsString := AStatus;
    fdqryChangeStatus.ExecSQL;
  finally
    RefreshDataSource;
  end;
end;

procedure TForm2.RefreshDataSource;
begin
  fdqryGetThread.Refresh;
end;
end.
