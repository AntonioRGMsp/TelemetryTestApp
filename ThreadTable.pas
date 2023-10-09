unit ThreadTable;

interface
uses Row, Table, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef,
  FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Thread,
  TelemetryDBConn, ConnectionDB;

type
  TThreadTable = class (TInterfacedObject, ITable)
    private
      FQueryEditor : TFDQuery;
      FDBConnection : IConnectionDB;
    public
      //constructor Create(AQueryComponent : TFDQuery);
      constructor Create();
      procedure UPDATE(ARow: TThread);
      function SELECT_BY_NAME(AName : String) : TThread;
  end;


implementation
//    fdqryRegister.SQL.Text := 'UPDATE THREAD SET STATUS = :STATUS, FECHA = :FECHA WHERE ID = 1';
//    fdqryRegister.ParamByName('STATUS').AsString := cbbStatus.Text;
//    clndrpckrCalendar.DateFormat := 'dd/MM/yyyy';
//    fdqryRegister.ParamByName('FECHA').AsDate := clndrpckrCalendar.Date;
//    fdqryRegister.ExecSQL;
constructor TThreadTable.Create();
begin
  FQueryEditor := TFDQuery.Create(nil);
  FQueryEditor.ConnectionName := 'TestConn';
end;

procedure TThreadTable.UPDATE(ARow: TThread);
begin
  FQueryEditor.SQL.Text := 'UPDATE REGISTRY SET STATUS = :STATUS, FECHA = :FECHA WHERE ID = 1';
  FQueryEditor.ParamByName('STATUS').ASString := ARow.status;
  FQueryEditor.ParamByName('FECHA').AsDate := ARow.date;
  FQueryEditor.ExecSQL;
end;

function TThreadTable.SELECT_BY_NAME(AName: string): TThread;
var
  LId : Integer;
  LNombre : String;
  LTipo: String;
  LPadreId : Integer;
  LFecha : TDate;
  LStatus : String;
  LThread : TThread;
begin
  FQueryEditor.SQL.Text := 'SELECT * FROM REGISTRY WHERE NOMBRE = :NOMBRE';
  FQueryEditor.ParamByName('NOMBRE').AsString := AName;
  FQueryEditor.Open;
  LId := FQueryEditor.FieldByName('ID').AsInteger;
  LNombre := FQueryEditor.FieldByName('NOMBRE').AsString;
  LTipo := FQueryEditor.FieldByName('TIPO').AsString;
  LPadreId := FQueryEditor.FieldByName('PADRE_ID').AsInteger;
  LFecha := FQueryEditor.FieldByName('FECHA').AsDateTime;
  LStatus := FQueryEditor.FieldByName('STATUS').AsString;
  LThread := TThread.Create(LStatus, LFecha, LNombre, LTipo);
  Result := LThread;
end;
end.
