unit Detalle;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LR_Class, LR_DBSet, Forms, Controls, Graphics,
  Dialogs, DBGrids, StdCtrls, ExtCtrls, ZVDateTimePicker, ZDataset, db,
  UtilHospital;

type

  { TFDetalle }

  TFDetalle = class(TForm)
    Bevel1: TBevel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    DSProducto: TDataSource;
    DTInicial: TZVDateTimePicker;
    DTFinal: TZVDateTimePicker;
    frDBDS: TfrDBDataSet;
    frReport: TfrReport;
    GProducto: TDBGrid;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    QDespacho: TZQuery;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FDetalle: TFDetalle;

implementation

{$R *.lfm}

uses DataMod;

{ TFDetalle }

procedure TFDetalle.FormKeyPress(Sender: TObject; var Key: char);
begin
  if Key=#13 then
  begin
    {
     if ActiveControl.ClassType=TButton then
     begin
       TButton(Sender).Click;
     end;
    }
    SelectNext(ActiveControl,true,true);
    Key:=#0;
  end;
end;

procedure TFDetalle.Button1Click(Sender: TObject);
begin
  if DTInicial.Date<DTFinal.Date then
  begin
    QDespacho.SQL.Clear;
    QDespacho.SQL.Text:='Select CodDespacho,Productos.Descripcion as producto,'+
      'Concat(Empleados.nombre," ",Empleados.Apellido) as Empleado,Solicitante,'+
      'Movimiento.Cantidad,Fecha,Hora From Almacen.Movimiento,Almacen.Productos,'+
      'Almacen.Empleados Where Movimiento.EsValido AND Movimiento.CodProducto='+
      'Productos.CodProducto AND Movimiento.CodEmpleado=Empleados.CodEmpleado '+
      'AND Fecha BETWEEN :FEC1 AND :FEC2 Order By Hora';
    QDespacho.ParamByName('FEC1').AsDate:=DTInicial.Date;
    QDespacho.ParamByName('FEC2').AsDate:=DTFinal.Date;
    QDespacho.Open
  end
  else ShowMessage('La fecha inicial seleccionada es MAYOR que la fecha final');
end;

procedure TFDetalle.Button2Click(Sender: TObject);
begin
  if QDespacho.RecordCount>0 then
    MostrarReporte(frReport,'rpDetalle.lrf')
  else ShowMessage('No hay movimientos para imprimir');
end;

procedure TFDetalle.Button3Click(Sender: TObject);
begin
  Close;
end;

procedure TFDetalle.FormShow(Sender: TObject);
begin
  QDespacho.SQL.Clear;
  QDespacho.SQL.Text:='Select CodDespacho, Productos.Descripcion as producto,'+
    'Concat(Empleados.nombre," ",Empleados.Apellido) as Empleado,Solicitante,'+
    'Movimiento.Cantidad,Fecha, Hora From Almacen.Movimiento, Almacen.Productos,'+
    'Almacen.Empleados Where Movimiento.EsValido AND Movimiento.CodProducto='+
    'Productos.CodProducto AND Movimiento.CodEmpleado=Empleados.CodEmpleado '+
    'Order By Hora';
  QDespacho.Open;
end;

end.

