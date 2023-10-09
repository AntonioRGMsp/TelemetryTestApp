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
    btnOpenApp2: TBitBtn;
    btnReload: TBitBtn;
    procedure btnUpdateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnRunClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure btnOpenApp2Click(Sender: TObject);
    procedure btnReloadClick(Sender: TObject);
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
  //RefreshDataSource;
end;

procedure TForm1.btnRunClick(Sender: TObject);
begin
  //ChangeStatus('ejecutando');
  FTrigger := FFabricaTriggers.CrearTrigger('sincronizador');
  FTrigger.Ejecutar;
end;

procedure TForm1.btnStopClick(Sender: TObject);
begin
  //ChangeStatus('finalizado');
end;

procedure TForm1.btnUpdateClick(Sender: TObject);
var
  LThread : TThread;
begin
//  fdqryRegister.SQL.BeginUpdate;
//  try
//    fdqryRegister.SQL.Add('UPDATE THREAD');
//    fdqryRegister.SQL.Add('SET STATUS = :STATUS, FECHA = :FECHA');
//    fdqryRegister.SQL.Add('WHERE ID = 1');
//  finally
//    fdqryRegister.SQL.EndUpdate;
//  end;
  try
    //LThread := TThread.Create(cbbStatus.Text, clndrpckrCalendar.Date);
    //FThreadTable.UPDATE(LThread);
//    fdqryRegister.SQL.Text := 'UPDATE THREAD SET STATUS = :STATUS, FECHA = :FECHA WHERE ID = 1';
//    fdqryRegister.ParamByName('STATUS').AsString := cbbStatus.Text;
//    clndrpckrCalendar.DateFormat := 'dd/MM/yyyy';
//    fdqryRegister.ParamByName('FECHA').AsDate := clndrpckrCalendar.Date;
//    fdqryRegister.ExecSQL;
  finally
    //RefreshDataSource;
    FreeAndNil(LThread);
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // DESTROY CLASSES
  FTelemetryDBConn.Close;
  FreeAndNil(FTelemetryDBConn);
  FreeAndNil(FFabricaTriggers);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FTelemetryDBConn := TTelemetryDBConn.Create;
  FTelemetryDBConn.Connect;
  //FThreadTable := TThreadTable.Create(fdqryRegister);
  FFabricaTriggers := TFabricaTriggers.Create;
end;

procedure TForm1.ChangeStatus(AStatus: string);
var
  LThread : TThread;
  LCurrentDate: TDateTime;
begin
  try
    LCurrentDate := Now;
    //LThread := TThread.Create(AStatus, LCurrentDate);
    FThreadTable.UPDATE(LThread);
//    fdqryChangeStatus.SQL.Text := 'UPDATE THREAD SET STATUS = :STATUS WHERE ID = 1';
//    fdqryChangeStatus.ParamByName('STATUS').AsString := AStatus;
//    fdqryChangeStatus.ExecSQL;
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
