unit TriggerSincronizador;

interface
uses System.SysUtils, Trigger, ThreadTable, Table, Thread, Vcl.Dialogs;

type
  TTriggerSincronizador = class(TInterfacedObject, ITrigger)
  private
    FThreadTable : ITable;
    function ExisteRegistro : Boolean;
  public
    constructor Create;
    procedure Ejecutar;
    procedure CrearRegistro;
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
    begin
      ShowMessage('NO EXISTE');
      CrearRegistro;
      ShowMessage('CREADO');
    end;

end;


procedure TTriggerSincronizador.CrearRegistro;
var
  LThread : TThread;
  LCurrentDate: TDateTime;
begin
  LCurrentDate := Now;
  LThread := TThread.Create('P', LCurrentDate);
  FThreadTable.INSERT(LThread);
end;

function TTriggerSincronizador.ExisteRegistro: Boolean;
var
  LThread : TThread;

begin
  LThread := FThreadTable.SELECT_BY_NAME('ControlTelemetria');
  if(LThread.status = '' ) then
    Result := False
  else
    Result := True;
end;

end.
