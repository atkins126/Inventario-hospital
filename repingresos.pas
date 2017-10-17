unit RepIngresos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LR_Class, LR_DBSet, Forms, Controls, Graphics,
  Dialogs, StdCtrls, DBGrids, ComCtrls, ZDataset, ZVDateTimePicker, db,
  UtilHospital;

type

  { TFRepIngresos }

  TFRepIngresos = class(TForm)
    BConsultar: TButton;
    BImprimir: TButton;
    BSalir: TButton;
    DS: TDataSource;
    DTFinal: TZVDateTimePicker;
    DTInicial: TZVDateTimePicker;
    frDBDS: TfrDBDataSet;
    frReport: TfrReport;
    GProducto: TDBGrid;
    Label1: TLabel;
    Label2: TLabel;
    Query: TZQuery;
    SBar: TStatusBar;
    procedure BConsultarClick(Sender: TObject);
    procedure BImprimirClick(Sender: TObject);
    procedure BSalirClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure ValInicio;
  public
    { public declarations }
  end;

var
  FRepIngresos: TFRepIngresos;

implementation

{$R *.lfm}

{ TFRepIngresos }

procedure TFRepIngresos.ValInicio;
begin
  DTInicial.Date:=Date;
  DTFinal.Date:=Date;
  BConsultar.Click;
  SBar.SimpleText:=' Total ingresos: '+IntToStr(Query.RecordCount);
end;

procedure TFRepIngresos.FormShow(Sender: TObject);
begin
  Color:=Sistema.FormColor;
  ValInicio;
end;

procedure TFRepIngresos.BSalirClick(Sender: TObject);
begin
  Close;
end;

procedure TFRepIngresos.BConsultarClick(Sender: TObject);
begin
  if DTInicial.Date<=DTFinal.Date then
  begin
    Query.SQL.Clear;
    Query.SQL.Text:='Select P.Descripcion,I.Altas,I.Fecha,I.Proveedor From '+
      'Ingresos I,Productos P Where Fecha BETWEEN :FEC1 AND :FEC2 and '+
      'I.CodProducto=P.CodProducto order by Fecha';
    Query.ParamByName('FEC1').AsDate:=DTInicial.Date;
    Query.ParamByName('FEC2').AsDate:=DTFinal.Date;
    Query.Open;
    SBar.SimpleText:=' Total ingresos: '+IntToStr(Query.RecordCount);
  end
  else ShowMessage('La fecha inicial seleccionada es MAYOR que la fecha final');
end;

procedure TFRepIngresos.BImprimirClick(Sender: TObject);
begin
  if Query.RecordCount>0 then
    MostrarReporte(frReport,'rpIngreso.lrf')
  else ShowMessage('No hay ingresos para imprimir');
end;

end.
