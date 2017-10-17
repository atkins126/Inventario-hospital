unit Despacho;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LR_Class, LR_DBSet, Forms, Controls, Graphics,
  Dialogs, StdCtrls, EditBtn, DBGrids, ExtCtrls, ComCtrls, ZDataset,
  ZVDateTimePicker, db, UtilHospital;

type

  { TFDespacho }
  TFDespacho = class(TForm)
    BCerrar: TButton;
    BCerrar1: TButton;
    Bevel1: TBevel;
    BRegistrar: TButton;
    CbEmpleado: TComboBox;
    CBSolicitante: TComboBox;
    DSProducto: TDataSource;
    EProductoSelect: TEdit;
    frDBDS: TfrDBDataSet;
    frReport: TfrReport;
    GProducto: TDBGrid;
    EProducto: TEdit;
    ECantidad: TEdit;
    ESolicitante: TEdit;
    EHora: TEdit;
    GBDateTime: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    QRegistro: TZQuery;
    QEmpleado: TZQuery;
    SBProductos: TStatusBar;
    Timer1: TTimer;
    DTime: TZVDateTimePicker;
    QDespacho: TZQuery;
    procedure BCerrar1Click(Sender: TObject);
    procedure BCerrarClick(Sender: TObject);
    procedure BRegistrarClick(Sender: TObject);
    procedure CBSolicitanteChange(Sender: TObject);
    procedure EProductoChange(Sender: TObject);
    procedure EProductoEnter(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    procedure frReportGetValue(const ParName: String; var ParValue: Variant);
    procedure GProductoCellClick(Column: TColumn);
    procedure GProductoKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    Procedure grid;
    Procedure MontaGrid;
    Function Activaboton():boolean;
    Procedure Limpiar;
  end;
 type
  //el tipo empleado
  TEmpleado = record
    Nombre: String;
    Codigo: integer;
  end;
  TDespacho = record
    CodProducto,
    Cantidad: integer;
    Descripcion,
    Solicitante,
    Empleado: string;
    Fecha: TDate;
    Hora: TTime;
  end;
var
  FDespacho: TFDespacho;
  Empleado: array of TEmpleado;
  RDespacho: TDespacho;

implementation

{$R *.lfm}

{ TFDespacho }
Procedure TFDespacho.Limpiar;
begin
  Grid;
  EProductoSelect.Clear;
  ECantidad.Text:='0';
  ESolicitante.Clear;
  ESolicitante.Visible:=false;
  CBSolicitante.ItemIndex:=-1;
  CBEmpleado.ItemIndex:=-1;
  RDespacho.CodProducto:=0;
  RDespacho.Solicitante:='';
  RDespacho.Empleado:='';
  RDespacho.Descripcion:='';
  RDespacho.Cantidad:=0;
  DTime.Date:=Date;
end;

Function TFDespacho.Activaboton: Boolean;
begin
  Result:=(EProductoSelect.Text<>'') AND (ECantidad.Text<>'') AND
    (CBSolicitante.ItemIndex<>-1) AND (CbEmpleado.ItemIndex<>-1)
end;

procedure TFDespacho.Grid;
begin
  if QDespacho.RecordCount <> 0 then
    EProductoSelect.Text:=QDespacho['Descripcion']
  else
  begin
    ShowMessage('Producto NO registrado...');
    EProducto.SetFocus;
    EProductoSelect.Clear;
  end;
  ECantidad.Clear;
end;
procedure TFDespacho.MontaGrid;
begin
  QDespacho.SQL.Clear;
  QDespacho.SQL.Text:='select * from almacen.productos where EsValido = true '+
                      'Order By Descripcion';
  QDespacho.Open;
  SBProductos.Panels[0].Text:='Total productos registrados: '+IntToStr(QDespacho.RecordCount);
end;

procedure TFDespacho.BCerrarClick(Sender: TObject);
begin
  close;
end;

procedure TFDespacho.BCerrar1Click(Sender: TObject);
begin
  Limpiar;
end;

procedure TFDespacho.BRegistrarClick(Sender: TObject);
var
  CanClose: Boolean;
begin
  if ActivaBoton then
  begin
    if QDespacho['Cantidad'] = 0 then
      ShowMessage('No hay disponibilidad del producto...')
    else
      begin
        if (ECantidad.Text<>'') AND (StrToInt(Trim(ECantidad.Text))>QDespacho['Cantidad'])then
        begin
          ShowMessage('La CANTIDAD indicada supera la disponibilidad...');
          ECantidad.SetFocus;
        end
        else
        begin
          if ECantidad.Text = '0' then
          begin
            ShowMessage('No ha indicado la cantidad a despachar...');
            ECantidad.SetFocus;
          end
          else
          begin
            CanClose:=(MessageDlg('¿Realmente desea registrar el despacho?',
              mtConfirmation,[mbYes,mbNo],0) = mrYes);
            if CanClose then
            begin
              if CBSolicitante.Text<>'OTRO' then
                RDespacho.Solicitante:=CBSolicitante.Text
              else RDespacho.Solicitante:=Trim(ESolicitante.Text);
              RDespacho.CodProducto:=QDespacho['CodProducto'];
              RDespacho.Cantidad:=StrToInt(ECantidad.Text);
              RDespacho.Descripcion:=EProductoSelect.Text;
              RDespacho.Empleado:=CbEmpleado.Text;
              RDespacho.Fecha:=Date;
              RDespacho.Hora:=Time;
              //Actualizar en la tabla productos
              QRegistro.SQL.Clear;
              QRegistro.SQL.Text:='Update productos Set cantidad='+
                'cantidad-:cant Where CodProducto=:cod';
              QRegistro.ParamByName('cod').AsInteger:=RDespacho.CodProducto;
              QRegistro.ParamByName('cant').AsInteger:=RDespacho.Cantidad;
              QRegistro.ExecSQL;
              //Fin Actualizar en la tabla productos
              //Registra el despacho
              QRegistro.SQL.Clear;
              QRegistro.SQL.Text:='INSERT INTO movimiento (CodProducto, '+
                'CodEmpleado,Solicitante,Cantidad,Fecha,Hora) VALUES (:CodPro,'+
                ':CodEmp,:Sol,:Can,:Fec,:Hor)';
              QRegistro.ParamByName('CodPro').AsInteger:=RDespacho.CodProducto;
              QRegistro.ParamByName('CodEmp').AsInteger:=Empleado[CbEmpleado.ItemIndex].Codigo;
              QRegistro.ParamByName('Sol').AsString:=RDespacho.Solicitante;
              QRegistro.ParamByName('Can').AsInteger:=RDespacho.Cantidad;
              QRegistro.ParamByName('Fec').AsDate:=RDespacho.Fecha;
              QRegistro.ParamByName('Hor').AsTime:=RDespacho.Hora;
              QRegistro.ExecSQL;
              ShowMessage('El despacho se ha efectuado satisfactoriamente. '+
                          'Se procederá a imprimirlo');
              MostrarReporte(frReport,'rpDespacho.lrf');
              MontaGrid;
            end;
            Limpiar;
             //Fin del registro despacho
          end;
        end;
      end;
  end
  else ShowMessage('Faltan datos para el despacho...');
end;

procedure TFDespacho.CBSolicitanteChange(Sender: TObject);
begin
  ESolicitante.Visible:=CBSolicitante.Text='OTRO';
  ESolicitante.Clear;
end;

procedure TFDespacho.EProductoChange(Sender: TObject);
var
  CAD: String;
begin
  CAD:='%'+trim(EProducto.Text)+'%';
  QDespacho.SQL.Clear;
  QDespacho.SQL.Text:='select * from almacen.productos where EsValido = true '+
                      'AND Descripcion Like :SBC Order By Descripcion';
  QDespacho.ParamByName('SBC').AsString:=CAD;
  QDespacho.Open;
  if QDespacho.RecordCount = 0 then
  begin
    showmessage('Producto NO registrado...');
    EProducto.SetFocus;
  end;
end;

procedure TFDespacho.EProductoEnter(Sender: TObject);
begin
  limpiar;
end;

procedure TFDespacho.FormKeyPress(Sender: TObject; var Key: char);
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

procedure TFDespacho.FormShow(Sender: TObject);
var
  Indice: Integer;
begin
  GBDateTime.Enabled:=False;
  //Monta el DBgrid
  MontaGrid;
  //Cargando el CbEmpleado
  QEmpleado.SQL.Clear;
  QEmpleado.SQL.Text:= 'select nombre, apellido, CodEmpleado '+
                      'from almacen.empleados where EsActivo';
  QEmpleado.Open;
  if QEmpleado.RecordCount>0 then
  begin
    SetLength(Empleado,QEmpleado.RecordCount); //Se establece la longitud del vector
    QEmpleado.First;
    Indice:=0;
    CbEmpleado.Clear;
    while NOT QEmpleado.Eof do
    begin
      //Se carga el vector
      Empleado[Indice].Nombre:=QEmpleado['nombre']+' '+QEmpleado['apellido'];
      Empleado[Indice].Codigo:=QEmpleado['CodEmpleado'];
      //Se carga  CbEmpleado
      CbEmpleado.ItemIndex:= Indice;
      CbEmpleado.Items.Add(Empleado[Indice].Nombre);
      QEmpleado.Next;
      Inc(Indice);
    end;
    CbEmpleado.ItemIndex:=-1;
  end;
end;

procedure TFDespacho.frReportGetValue(const ParName: String;
  var ParValue: Variant);
begin
  if ParName='Solicitante' then ParValue:=RDespacho.Solicitante;
  if ParName='Cantidad' then ParValue:=RDespacho.Cantidad;
  if ParName='Descripcion' then ParValue:=RDespacho.Descripcion;
  if ParName='Empleado' then ParValue:=RDespacho.Empleado;
  if ParName='Fecha' then ParValue:=RDespacho.Fecha;
  if ParName='Hora' then ParValue:=RDespacho.Hora;
end;

procedure TFDespacho.GProductoCellClick(Column: TColumn);
begin
  Grid;
end;

procedure TFDespacho.GProductoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Grid;
end;

procedure TFDespacho.Timer1Timer(Sender: TObject);
begin
  EHora.Text:=TimeToStr(Time);
end;

end.

