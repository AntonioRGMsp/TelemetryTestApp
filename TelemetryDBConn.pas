unit TelemetryDBConn;

interface
uses ConnectionDB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef,
  FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids,
  Vcl.Dialogs;

type
  TTelemetryDBConn = class(TInterfacedObject, IConnectionDB)
    private
      FDConnectionDB : TFDConnection;
      FInstance : IConnectionDB;

    public
      procedure Connect;
      procedure Close;
      function GetInstance : IConnectionDB;
  end;

implementation
  procedure TTelemetryDBConn.Connect;
  begin
    FDConnectionDB := TFDConnection.Create(nil);
    FDConnectionDB.Params.DriverID := 'FB';
    FDConnectionDB.Params.Database := 'C:\data\TELEMETRY.FDB';
    FDConnectionDB.Params.UserName := 'SYSDBA';
    FDConnectionDB.Params.Password := 'masterkey';
    FDConnectionDB.Params.Add('port=3050');
    FDConnectionDB.Connected := True;
  end;

  procedure TTelemetryDBConn.Close;
  begin
    FDConnectionDB.Close;
  end;

  function TTelemetryDBConn.GetInstance: IConnectionDB;
  begin
    if not Assigned (FInstance) then
      FInstance := TTelemetryDBConn.Create;

    Result := FInstance;
  end;

end.
