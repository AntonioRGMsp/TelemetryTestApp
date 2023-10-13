unit ConnectionDB;

interface
uses FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef,
  FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
/// <summary>
///   Interface para aplicarse en cualquier clase que realice conexiones a
///   una base de datos.
/// </summary>
  IConnectionDB = interface ['{186BCF55-5AA9-465C-9695-07901785C970}']
  /// <summary>
  ///   Se encarga de crear la conexion a la BD y dejarla lista para interactuar.
  /// </summary>
    procedure Connect;
  /// <summary>
  ///   Se encarga de cerrar la conexion con la BD
  /// </summary>
    procedure Close;
  /// <summary>
  ///   se encarga de aplicar el patron Singleton para asegurarnos de tener
  ///  solamente una instancia con la conexion a la BD.
  /// </summary>
    function GetInstance : IConnectionDB;
  /// <summary>
  ///     Ignorar esta funcion, es una funcion en etapa de prueba
  /// </summary>
    function GetComponentConnection : TFDConnection;
  end;

implementation

end.
