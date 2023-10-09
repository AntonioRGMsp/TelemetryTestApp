unit Thread;

interface
uses Row;

type
  TThread = class (TInterfacedObject, IRow)
    private
      FStatus : string;
      FDate : TDate;
      FId : Integer;
      procedure SetStatus(AStatus : String);
      procedure SetDate(ADate : TDate);

    public
      constructor Create(AStatus : string ; ADate : TDate);
      property status : string read FStatus write SetStatus;
      property date : TDate read FDate write SetDate;


  end;

implementation
  constructor TThread.Create(AStatus: string; ADate: TDate);
  begin
    FStatus := AStatus;
    FDate := ADate;
  end;

  procedure TThread.SetStatus(AStatus: string);
  begin
    FStatus := AStatus;
  end;

  procedure TThread.SetDate(ADate: TDate);
  begin
    FDate := ADate;
  end;
end.
