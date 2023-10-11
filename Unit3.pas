unit Unit3;

interface

uses
 Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.WinXCalendars,
  Vcl.Buttons, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef,
  FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids,
  Vcl.DBGrids, System.Classes, Vcl.Graphics, TelemetryDBConn, ThreadTable,
  Row, Table, Thread, FabricaTriggers, Trigger;

type
  TForm3 = class(TForm)
    fdqryChangeStatus: TFDQuery;
    fdqryGetThread: TFDQuery;
    btnReload: TBitBtn;
    dbgrd1: TDBGrid;
    txtTitle: TStaticText;
    connTelemetry: TFDConnection;
    fdqryRegister: TFDQuery;
    ds1: TDataSource;
    grpControl: TGroupBox;
    btnUpdate: TBitBtn;
    btnRun: TBitBtn;
    clndrpckrCalendar: TCalendarPicker;
    cbbStatus: TComboBox;
    btnRefresh: TBitBtn;
    btnStop: TBitBtn;
    grpLockFB: TGroupBox;
    btnRunLock: TBitBtn;
    btnStopLock: TBitBtn;
    procedure btnUpdateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnRunClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
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
  Form3: TForm3;

implementation


procedure TForm3.btnReloadClick(Sender: TObject);
begin
  RefreshDataSource;
end;

procedure TForm3.btnRunClick(Sender: TObject);
begin
  FTrigger := FFabricaTriggers.CrearTrigger('sincronizador');
  FTrigger.Ejecutar;
  RefreshDataSource;
end;

procedure TForm3.btnRunLockClick(Sender: TObject);
var
  LFecha : TDate;
  LStatus : String;
  LThread : TThread;
  I: Integer;
begin
  try
    fdqryRegister.Connection.StartTransaction;
    fdqryRegister.SQL.Text := 'SELECT * FROM REGISTRY WHERE NOMBRE = :NOMBRE FOR UPDATE WITH LOCK';
    fdqryRegister.ParamByName('NOMBRE').AsString := 'ControlTelemetria';
    fdqryRegister.Open;
    LFecha := fdqryRegister.FieldByName('FECHA').AsDateTime;
    LStatus := fdqryRegister.FieldByName('STATUS').AsString;
    LThread := TThread.Create(LStatus, LFecha);

    // Start transaction here
    for I := 0 to 500 do
      begin
        FThreadTable.SELECT_BY_NAME('ControlTelemetria');
      end;
    ShowMessage('Finished');
    fdqryRegister.Connection.Commit;
  except
    ShowMessage('Error');
    fdqryRegister.Connection.Rollback;
  end;
end;

procedure TForm3.btnStopClick(Sender: TObject);
begin
  ChangeStatus('F');
end;

procedure TForm3.btnUpdateClick(Sender: TObject);
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

procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // DESTROY CLASSES
  FTelemetryDBConn.Close;
  FreeAndNil(FTelemetryDBConn);
  FreeAndNil(FFabricaTriggers);
  FThreadTable := nil;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  FTelemetryDBConn := TTelemetryDBConn.Create;
  FTelemetryDBConn.Connect;
  FThreadTable := TThreadTable.Create();
  FFabricaTriggers := TFabricaTriggers.Create;
end;

procedure TForm3.ChangeStatus(AStatus: string);
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

procedure TForm3.RefreshDataSource;
begin
  fdqryGetThread.Refresh;
end;
end.
