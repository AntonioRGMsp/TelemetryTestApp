unit FabricaTriggers;

interface
uses System.SysUtils, StrUtils, Trigger, TriggerSincronizador;

type
  TFabricaTriggers = class(TObject)
    private
    public
      function CrearTrigger(ANombreTrigger : string) : ITrigger;

  end;

implementation
  function TFabricaTriggers.CrearTrigger(ANombreTrigger: string): ITrigger;
  begin
      // Logic to create the new Trigger.
    case AnsiIndexStr(ANombreTrigger, ['sincronizador']) of
      0:
        begin
          Result := TTriggerSincronizador.create;
        end;
    end;
  end;
end.
