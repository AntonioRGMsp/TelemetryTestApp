unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.WinXCalendars,
  Vcl.Buttons, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef,
  FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids,
  Vcl.DBGrids, System.Classes, Vcl.Graphics, TelemetryDBConn, Unit2, ThreadTable,
  Row, Table, Thread, FabricaTriggers, Trigger;

type
  TForm1 = class(TForm)
    txtTitle: TStaticText;
    grpControl: TGroupBox;
    btnRun: TBitBtn;
    btnUpdate: TBitBtn;
    clndrpckrCalendar: TCalendarPicker;
    cbbStatus: TComboBox;
    connTelemetry: TFDConnection;
    fdqryRegister: TFDQuery;
    ds1: TDataSource;
    dbgrd1: TDBGrid;
    fdqryGetThread: TFDQuery;
    btnRefresh: TBitBtn;
    btnStop: TBitBtn;
    fdqryChangeStatus: TFDQuery;
    btnReload: TBitBtn;
    grpControlLock: TGroupBox;
    btnRunLock: TBitBtn;
    procedure btnUpdateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnRunClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure btnOpenApp2Click(Sender: TObject);
    procedure btnReloadClick(Sender: TObject);
    procedure btnRunLockClick(Sender: TObject);
  private
    { Private declarations }
    FTelemetryDBConn : TTelemetryDBConn;
    FThreadTable : ITable;
    FFabricaTriggers : TFabricaTriggers;
    FTrigger : ITrigger;
    procedure ChangeStatus(AStatus : String);
    procedure RefreshDataSource;

  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.btnOpenApp2Click(Sender: TObject);
begin
  Form2.Show;
end;

procedure TForm1.btnReloadClick(Sender: TObject);
begin
  RefreshDataSource;
end;

procedure TForm1.btnRunClick(Sender: TObject);
begin
  FTrigger := FFabricaTriggers.CrearTrigger('sincronizador');
  FTrigger.Ejecutar;
  RefreshDataSource;
end;

procedure TForm1.btnRunLockClick(Sender: TObject);
var
  LFecha: TDate;
  LStatus: string;
  LThread: TThread;
  I: Integer;
begin
  try
    LFecha := Now;

    fdqryRegister.Connection.StartTransaction;

    fdqryRegister.SQL.Text := 'SELECT * FROM REGISTRY WHERE NOMBRE = :NOMBRE  FOR UPDATE WITH LOCK';
    fdqryRegister.ParamByName('NOMBRE').AsString := 'ControlTelemetria';
    fdqryRegister.Open;

    fdqryRegister.SQL.Text := 'UPDATE REGISTRY SET STATUS = :STATUS, FECHA = :FECHA WHERE NOMBRE = :NOMBRE';
    fdqryRegister.ParamByName('STATUS').AsString := 'E';
    fdqryRegister.ParamByName('FECHA').AsDate := Now;
    fdqryRegister.ParamByName('NOMBRE').AsString := 'ControlTelemetria';
    fdqryRegister.ExecSQL;
    // Start transaction here
    for I := 0 to 2000 do
    begin
      FThreadTable.SELECT_BY_NAME('ControlTelemetria');
    end;
    fdqryRegister.Connection.Commit;
    ChangeStatus('E');
    RefreshDataSource;
    ShowMessage('APP 1 - Finished');
  except
    ShowMessage('APP 1 - Error');
    fdqryRegister.Connection.Rollback;
  end;
end;

procedure TForm1.btnStopClick(Sender: TObject);
begin
  ChangeStatus('F');
end;

procedure TForm1.btnUpdateClick(Sender: TObject);
var
  LThread : TThread;
begin
  try
    LThread := TThread.Create(cbbStatus.Text, clndrpckrCalendar.Date);
    FThreadTable.UPDATE(LThread);
  finally
    RefreshDataSource;
    FreeAndNil(LThread);
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // DESTROY CLASSES
//  FTelemetryDBConn.Close;
//  FreeAndNil(FTelemetryDBConn);
  FreeAndNil(FFabricaTriggers);
  FThreadTable := nil;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
//  FTelemetryDBConn := TTelemetryDBConn.Create;
//  FTelemetryDBConn.Connect;
  FThreadTable := TThreadTable.Create();
  FFabricaTriggers := TFabricaTriggers.Create;
end;

procedure TForm1.ChangeStatus(AStatus: string);
var
  LThread : TThread;
  LCurrentDate: TDateTime;
begin
  try
    LCurrentDate := Now;
    LThread := TThread.Create(AStatus, LCurrentDate);
    FThreadTable.UPDATE(LThread);
  finally
    RefreshDataSource;
    FreeAndNil(LThread);
  end;
end;

procedure TForm1.RefreshDataSource;
begin
  fdqryGetThread.Refresh;
end;
end.
