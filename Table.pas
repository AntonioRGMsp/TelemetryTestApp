unit Table;

interface
uses Thread;

type
  /// <summary>
  ///   Interface que define los metodos que debe tener la clase que
  ///  interactua con la tabla donde se encuentra el registro del THREAD
  ///  que guarda el estado de la app sincronizador.
  /// </summary>
  ITable = interface ['{DC824003-55C0-445C-BD83-CE0E15DC6D7F}']
    /// <summary>
    ///   Actualiza el registro del sincronizador
    /// </summary>
    /// <param name="ARow">
    ///   Es un objeto de tipo Thread que contiene los datos que se quieren
    ///  actualizar en el registro
    /// </param>
    procedure UPDATE( ARow: TThread );
    /// <summary>
    ///   Actualiza el registro del sincronizador a traves de una transaccion
    ///  y ademas utiliza LOCK para bloquear el registro mientras se ejecuta
    ///  la transaccion, cuando la transaccion termina se libera automaticamente
    ///  el registro del sincronizador.
    /// </summary>
    /// <param name="ARow">
    ///   Es un objeto de tipo Thread que contiene los datos que se quieren
    ///  actualizar en el registro
    /// </param>
    procedure UPDATE_LOCK(ARow : TThread);
    /// <summary>
    ///   Realiza la busqueda del registro del sincronizador a traves del nombre.
    ///  Por el momento no se una la PK ID porque aun desconocemos el valor que
    ///  va a tener, de momento de usa el nombre porque sabemos que este es un
    ///  dato fijo hasta el momento.
    /// </summary>
    /// <param name="AName">
    ///   Nombre del registro del sincronizador
    /// </param>
    /// <returns>
    ///   Devuelve un objeto con los datos del registro del sincronizador
    /// </returns>
    function SELECT_BY_NAME(AName : String) : TThread;
    /// <summary>
    ///   Crea el registro del sincronizador
    /// </summary>
    /// <param name="AThread">
    ///   Es un objeto de tipo Thread que contiene los datos del registro,
    ///  no acepta ningun dato NULL.
    /// </param>
    procedure INSERT(AThread : TThread);
  end;

implementation

end.
