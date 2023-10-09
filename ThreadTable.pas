unit ThreadTable;

interface
uses Row, Table, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef,
  FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Thread;

type
  TThreadTable = class (TInterfacedObject, ITable)
    private
      FQueryEditor : TFDQuery;
      procedure UPDATE(ARow: TThread);
    public
      constructor Create(AQueryComponent : TFDQuery);

  end;


implementation
//    fdqryRegister.SQL.Text := 'UPDATE THREAD SET STATUS = :STATUS, FECHA = :FECHA WHERE ID = 1';
//    fdqryRegister.ParamByName('STATUS').AsString := cbbStatus.Text;
//    clndrpckrCalendar.DateFormat := 'dd/MM/yyyy';
//    fdqryRegister.ParamByName('FECHA').AsDate := clndrpckrCalendar.Date;
//    fdqryRegister.ExecSQL;
constructor TThreadTable.Create(AQueryComponent: TFDQuery);
begin
  FQueryEditor := AQueryComponent;
end;

procedure TThreadTable.UPDATE(ARow: TThread);
begin
  FQueryEditor.SQL.Text := 'UPDATE THREAD SET STATUS = :STATUS, FECHA = :FECHA WHERE ID = 1';
  FQueryEditor.ParamByName('STATUS').ASString := ARow.status;
  FQueryEditor.ParamByName('FECHA').AsDate := ARow.date;
  FQueryEditor.ExecSQL;
end;
end.
