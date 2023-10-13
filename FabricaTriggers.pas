unit FabricaTriggers;

interface
uses System.SysUtils, StrUtils, Trigger, TriggerSincronizador;

type
  /// <summary>
  //    Clase encargada de crear instancias de las clases que tienen
  //  como objetivo actuar como triggers o de lanzar otras apps.
  /// </summary>
  TFabricaTriggers = class(TObject)
    private
    public
      /// <summary>
      ///   Funcion encargada de crear la instancia de la clase trigger
      ///  correspondiente
      /// </summary>
      /// <param name="ANombreTrigger">
      ///    Nombre del trigger que se necesita crear
      /// </param>
      /// <returns>
      ///     Devuelve la instancia del trigger solicitado
      /// </returns>
      function CrearTrigger(ANombreTrigger : string) : ITrigger;

  end;

implementation
  function TFabricaTriggers.CrearTrigger(ANombreTrigger: string): ITrigger;
  begin
      // Condiciones para crear el trigger solicitado
    case AnsiIndexStr(ANombreTrigger, ['sincronizador']) of
      0:
        begin
          Result := TTriggerSincronizador.create;
        end;
    end;
  end;
end.
