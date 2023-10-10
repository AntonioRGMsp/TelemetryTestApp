unit TriggerSincronizador;

interface
uses System.SysUtils, System.DateUtils, Trigger, ThreadTable, Table, Thread, Vcl.Dialogs;

type
  TTriggerSincronizador = class(TInterfacedObject, ITrigger)
  private
    FThread : TThread;
    FThreadTable : ITable;
    procedure CrearRegistro;
    procedure ActualizarRegistro(AStatus : String; AFecha : TDate);
    function ExisteRegistro : Boolean;
  public
    constructor Create;
    procedure Ejecutar;

  end;

implementation
constructor TTriggerSincronizador.Create;
begin
   FThreadTable := TThreadTable.Create;
end;

procedure TTriggerSincronizador.Ejecutar;
var
  LCurrentDate: TDateTime;
begin
  LCurrentDate := Now;
  // Logica para decidir  si se debe lanzar el sincronizador o no
  if   ExisteRegistro then
    begin
      ShowMessage('SI EXISTE');
      if (( IsToday(FThread.fecha) = False) AND (FThread.status = 'P')) then
        begin
          ShowMessage('EJECUTAR');
          ActualizarRegistro('E', LCurrentDate);
        end
      else
        ShowMessage('NO EJECUTAR')
    end
  else
    begin
      ShowMessage('NO EXISTE');
      CrearRegistro;
      ShowMessage('CREADO');
    end;

end;


procedure TTriggerSincronizador.CrearRegistro;
var
  LCurrentDate: TDateTime;
begin
  LCurrentDate := Now;
  FThread := TThread.Create('P', LCurrentDate);
  FThreadTable.INSERT(FThread);
end;

procedure TTriggerSincronizador.ActualizarRegistro(AStatus: string; AFecha: TDate);
begin
  FThread := TThread.Create(AStatus, AFecha);
  FThreadTable.UPDATE(FThread);
end;

function TTriggerSincronizador.ExisteRegistro: Boolean;
begin
  FThread := FThreadTable.SELECT_BY_NAME('ControlTelemetria');
  if(FThread.status = '' ) then
    Result := False
  else
    Result := True;
end;

end.
