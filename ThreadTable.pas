unit ThreadTable;

interface
uses Row, Table, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef,
  FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Thread,
  Vcl.Dialogs, TelemetryDBConn, ConnectionDB;

type
  /// <summary>
  ///   Clase encargada de interactuar con la tabla del registro del Thread
  ///  a traves de consultas SQL
  /// </summary>
  TThreadTable = class (TInterfacedObject, ITable)
    private
      FQueryEditor : TFDQuery;
      FDBConnection : TFDConnection;

    public
      /// <summary>
      ///     Inicializa la instancia de TFDQuery y se configura la conexion
      ///  a la DB.
      /// </summary>
      constructor Create;
      /// <summary>
      ///   Actualiza el registro del Thread
      /// </summary>
      /// <param name="ARow">
      ///   Recibe el Schema del Thread con sus respectivos datos.
      /// </param>
      procedure UPDATE(ARow: TThread);
      /// <summary>
      ///   Realiza una transaccion que bloquea el registro mientras este se
      ///   actualiza, cuando termina de actualizarse el registro se libera el
      ///   registro para posteriores modificaciones.
      /// </summary>
      /// <param name="ARow">
      ///   Recibe el Schema del Thread con sus respectivos datos.
      /// </param>
      procedure UPDATE_LOCK(ARow : TThread);
      /// <summary>
      ///   Busca el registro del Thread a trabés de su nombre
      /// </summary>
      /// <param name="AName">
      ///   Nombre del Thread que se almacena en el registro
      /// </param>
      /// <returns>
      ///   Si el registro existe retorna un objeto TThread cumpliendo con todos
      ///  sus datos, en caso de no encontrarse, estos datos se retornan vacios.
      /// </returns>
      function SELECT_BY_NAME(AName : String) : TThread;
      /// <summary>
      ///   Crea el registro del Thread
      /// </summary>
      /// <param name="AThread">
      ///   Schema del registro del Thread con todos los datos requeridos.
      /// </param>
      procedure INSERT(AThread : TThread);
  end;


implementation
uses Unit1;

constructor TThreadTable.Create;
begin
  FQueryEditor := TFDQuery.Create(nil);
  // Conexion de TFDQuery con la DB
  FQueryEditor.ConnectionName := 'TestConn';
  FQueryEditor.Connection := Form1.connection;
end;

procedure TThreadTable.UPDATE(ARow: TThread);
begin
  FQueryEditor.SQL.Text := 'UPDATE REGISTRY SET STATUS = :STATUS, FECHA = :FECHA WHERE ID = 1';
  FQueryEditor.ParamByName('STATUS').ASString := ARow.status;
  FQueryEditor.ParamByName('FECHA').AsDate := ARow.fecha;
  FQueryEditor.ExecSQL;
end;

procedure TThreadTable.INSERT(AThread: TThread);
var
  LQuery : string;
begin
  LQuery := 'INSERT INTO REGISTRY (id, nombre, tipo, padre_id, fecha, status)';
  LQuery := LQuery + 'VALUES (:ID, :NOMBRE, :TIPO,:PADRE_ID,:FECHA,:STATUS)';
  FQueryEditor.SQL.Text := LQuery;
  FQueryEditor.ParamByName('ID').AsInteger := AThread.id;
  FQueryEditor.ParamByName('NOMBRE').AsString := AThread.nombre;
  FQueryEditor.ParamByName('TIPO').ASString := AThread.tipo;
  FQueryEditor.ParamByName('PADRE_ID').AsInteger := AThread.padreId;
  FQueryEditor.ParamByName('FECHA').AsDate := AThread.fecha;
  FQueryEditor.ParamByName('STATUS').AsString := AThread.status;
  try
    FQueryEditor.ExecSQL;
  finally

  end;

end;

procedure TThreadTable.UPDATE_LOCK(ARow: TThread);
var
  I :Integer;
begin
  try
    FQueryEditor.Connection.StartTransaction;
    // Con esta query se bloquea el registro
    FQueryEditor.SQL.Text := 'SELECT * FROM REGISTRY WHERE ID=1 FOR UPDATE WITH LOCK';
    FQueryEditor.Open();
    UPDATE(ARow);
    for I := 0 to 2000 do
    begin
      SELECT_BY_NAME(ARow.nombre);
    end;
    // Con Commit se libera el registro y se guardan todos los cambios que
    // se realizaron durante la transaccion
    FQueryEditor.Connection.Commit;
    ShowMessage('Lock successfully');
  except
    // Con Commit se libera el registro y deshace todos los cambios que
    // se realizaron durante la transaccion
    FQueryEditor.Connection.Rollback;
    ShowMessage('Error on lock');
  end;
end;

function TThreadTable.SELECT_BY_NAME(AName: string): TThread;
var
  LFecha : TDate;
  LStatus : String;
  LThread : TThread;
begin
  FQueryEditor.SQL.Text := 'SELECT * FROM REGISTRY WHERE NOMBRE = :NOMBRE';
  FQueryEditor.ParamByName('NOMBRE').AsString := AName;
  FQueryEditor.Open;
  LFecha := FQueryEditor.FieldByName('FECHA').AsDateTime;
  LStatus := FQueryEditor.FieldByName('STATUS').AsString;
  LThread := TThread.Create(LStatus, LFecha);
  Result := LThread;
end;

end.
