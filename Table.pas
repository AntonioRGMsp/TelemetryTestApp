unit Table;

interface
uses Thread;

type
  ITable = interface ['{DC824003-55C0-445C-BD83-CE0E15DC6D7F}']
    procedure UPDATE( ARow: TThread );
    function SELECT_BY_NAME(AName : String) : TThread;
    procedure INSERT(AThread : TThread);
  end;

implementation

end.
