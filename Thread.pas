unit Thread;

interface
uses Row;

type
  /// <summary>
  ///   Clase que representa el Schema del registro Thread
  /// </summary>
  TThread = class (TInterfacedObject, IRow)
    private
      FId : Integer;
      FNombre : String;
      FTipo: String;
      FPadreId : Integer;
      FFecha : TDate;
      FStatus : String;
      /// <summary>
      ///     Cambia el valor del status del registro Thread
      /// </summary>
      /// <param name="AStatus">
      ///     Nombre del status
      /// </param>
      procedure SetStatus(AStatus : String);
      /// <summary>
      ///     Cambia el valor de la fecha del registro Thread
      /// </summary>
      /// <param name="ADate">
      ///     Fecha en formato yyyy-mm-dd
      /// </param>
      procedure SetFecha(ADate : TDate);

    public
      /// <summary>
      ///   Inicializa el Schema al crearse una instancia de esta clase.
      ///  Solo recibe los siguientes parametros porque los demas campos son
      ///  datos fijos.
      /// </summary>
      /// <param name="AStatus">
      ///   Status del registro del Thread
      /// </param>
      /// <param name="ADate">
      ///   Fecha en formato yyyy-mm-dd
      /// </param>
      constructor Create(AStatus: string; ADate: TDate);
      property id : Integer read FId;
      property nombre : String read FNombre;
      property tipo : String read FTipo;
      property padreId : Integer read FPadreId;
      property fecha : TDate read FFecha write SetFecha;
      property status : string read FStatus write SetStatus;
  end;

implementation
  constructor TThread.Create(AStatus: string; ADate: TDate);
  begin
    FId := 1; //El ID esta pendiente de saber si ser� fijo o ser� din�mico.
    FPadreId := 0;
    FStatus := AStatus;
    FFecha := ADate;
    FNombre := 'ControlTelemetria';
    FTipo := 'V';
  end;

  procedure TThread.SetStatus(AStatus: string);
  begin
    FStatus := AStatus;
  end;

  procedure TThread.SetFecha(ADate: TDate);
  begin
    FFecha := ADate;
  end;
end.
