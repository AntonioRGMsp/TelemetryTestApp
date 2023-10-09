unit TriggerSincronizador;

interface
uses Trigger, ThreadTable, Table, Thread, Vcl.Dialogs;

type
  TTriggerSincronizador = class(TInterfacedObject, ITrigger)
  private
    FThreadTable : ITable;
    function ExisteRegistro : Boolean;
  public
    procedure Ejecutar;
    constructor Create;
  end;

implementation
constructor TTriggerSincronizador.Create;
begin
   FThreadTable := TThreadTable.Create;
end;

procedure TTriggerSincronizador.Ejecutar;
begin
  // Logica para decidir  si se debe lanzar el sincronizador o no
  if   ExisteRegistro then
    ShowMessage('SI EXISTE')
  else
    ShowMessage('NO EXISTE')
end;

function TTriggerSincronizador.ExisteRegistro: Boolean;
var
  LThread : TThread;
begin
  LThread := FThreadTable.SELECT_BY_NAME('ControlTelemetria');
  if(LThread.nombre = '') then
    Result := False
  else
    Result := True;
end;

end.
