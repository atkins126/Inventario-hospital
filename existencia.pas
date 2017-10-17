unit existencia;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, LR_Class, LR_DBSet, Forms, Controls,
  Graphics, Dialogs, DBGrids, StdCtrls, ExtCtrls, ComCtrls, UtilHospital,
  ZDataset;

type

  { TFExistencia }

  TFExistencia = class(TForm)
    BCerrar: TButton;
    BImprimir: TButton;
    DSProducto: TDataSource;
    frDBDS: TfrDBDataSet;
    frReport: TfrReport;
    GProducto: TDBGrid;
    QDespacho: TZQuery;
    RGTipo: TRadioGroup;
    SBProductos: TStatusBar;
    procedure BCerrarClick(Sender: TObject);
    procedure BImprimirClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RGTipoClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  procedure MontaGrid;
  end;

var
  FExistencia: TFExistencia;

implementation

{$R *.lfm}

{ TFExistencia }
procedure TFExistencia.MontaGrid;
var
  CadTodo,CadExistencia: String;
begin
  CadTodo:= 'Select * from almacen.Productos Where EsValido';
  CadExistencia:= 'Select * from almacen.Productos Where Cantidad > 0 AND EsValido';
  QDespacho.SQL.Clear;
  if RGTipo.ItemIndex=0 then
    QDespacho.SQL.Text:= CadTodo
  else
    QDespacho.SQL.Text:= CadExistencia;
  QDespacho.Open;
  SBProductos.Panels[0].Text:='Total productos registrados = '+IntToStr(QDespacho.RecordCount);
end;

procedure TFExistencia.BCerrarClick(Sender: TObject);
begin
  Close;
end;

procedure TFExistencia.BImprimirClick(Sender: TObject);
begin
  if QDespacho.RecordCount>0 then
    MostrarReporte(frReport,'rpExistencia.lrf')
  else ShowMessage('No hay exitencias para reportar');
end;

procedure TFExistencia.FormShow(Sender: TObject);
begin
  MontaGrid;
end;

procedure TFExistencia.RGTipoClick(Sender: TObject);
begin
  MontaGrid;
end;

end.

