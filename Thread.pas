unit Thread;

interface
uses Row;

type
  TThread = class (TInterfacedObject, IRow)
    private
      FId : Integer;
      FNombre : String;
      FTipo: String;
      FPadreId : Integer;
      FFecha : TDate;
      FStatus : String;
      procedure SetStatus(AStatus : String);
      procedure SetFecha(ADate : TDate);

    public
      constructor Create(AStatus: string; ADate: TDate; ANombre : string; ATipo : String);
      property status : string read FStatus write SetStatus;
      property date : TDate read FFecha write SetFecha;
      property nombre : String read FNombre;

  end;

implementation
  constructor TThread.Create(AStatus: string; ADate: TDate; ANombre : string; ATipo : String);
  begin
    FId := 1;
    FPadreId := 0;
    FStatus := AStatus;
    FFecha := ADate;
    FNombre := ANombre;
    FTipo := ATipo;
  end;

  procedure TThread.SetStatus(AStatus: string);
  begin
    FStatus := AStatus;
  end;

  procedure TThread.SetFecha(ADate: TDate);
  begin
    // Aqui se debe obtener la fecha actual
    FFecha := ADate;
  end;
end.
