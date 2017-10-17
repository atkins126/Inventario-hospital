unit Empleados;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, ExtCtrls, DbCtrls, DBGrids, ComCtrls, ZDataset, db, UtilHospital;

type
  TEmpleado = record
    CodEmpleado: integer;
    Cedula: string;
  end;
  { TFEmpleados }

  TFEmpleados = class(TForm)
    BBConsultar: TBitBtn;
    BCerrar: TButton;
    BGuardar: TButton;
    CBCedula: TComboBox;
    CBCargo: TComboBox;
    CBTelefono: TComboBox;
    CBModificar: TCheckBox;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBGrid: TDBGrid;
    DS: TDataSource;
    EActivo: TEdit;
    ECedula: TEdit;
    ENombre: TEdit;
    EApellido: TEdit;
    ETelefono: TEdit;
    GroupBox1: TGroupBox;
    GBDatosPersonales: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    LActivo: TLabel;
    QryLista: TZQuery;
    RGActivo: TRadioGroup;
    Query: TZQuery;
    SBar: TStatusBar;
    procedure BBConsultarClick(Sender: TObject);
    procedure BCerrarClick(Sender: TObject);
    procedure BGuardarClick(Sender: TObject);
    procedure CBModificarChange(Sender: TObject);
    procedure DBGridCellClick(Column: TColumn);
    procedure DBGridKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ECedulaChange(Sender: TObject);
    procedure ENombreChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure ValInicial;
    procedure CargarEmpleado;
    procedure ActivarControles(Opcion: boolean);
    procedure ActivarGuardar;
    function  EmpEsActivo: string;
  public
    { public declarations }
  end;

var
  FEmpleados: TFEmpleados;
  Empleado: TEmpleado;

implementation

{$R *.lfm}

{ TFEmpleados }

procedure TFEmpleados.ValInicial;
begin
  Empleado.Cedula:='';
  Empleado.CodEmpleado:=0;
  //El listado de empleados:
  QryLista.SQL.Text:='select concat(Nombre," ",Apellido) as Nom,CodEmpleado,'+
    'Cedula,Telefono,Cargo,EsActivo from Empleados order by Apellido';
  QryLista.Open;
  EActivo.Text:=EmpEsActivo;
  BGuardar.Caption:='Guardar';
  SBar.SimpleText:=' Total empleados registrados: '+IntToStr(QryLista.RecordCount);
  //Componentes:
  ActivarControles(false);
  BBConsultar.Enabled:=false;
  ECedula.Clear;
  CBCedula.ItemIndex:=0;
  ENombre.Clear;
  EApellido.Clear;
  ETelefono.Clear;
  CBTelefono.ItemIndex:=-1;
  CBCargo.ItemIndex:=-1;
  CBModificar.Enabled:=False;
  CBModificar.Checked:=false;
  BGuardar.Enabled:=False;
end;

procedure TFEmpleados.CargarEmpleado;
begin
  Empleado.CodEmpleado:=Query['CodEmpleado'];
  Empleado.Cedula:=Query['Cedula'];
  ENombre.Text:=Query['Nombre'];
  EApellido.Text:=Query['Apellido'];
  if Query['Telefono']<>null then
  begin
    CBTelefono.ItemIndex:=CBTelefono.Items.IndexOf(Copy(Query['Telefono'],1,5));
    ETelefono.Text:=Copy(Query['Telefono'],6,Length(Query['Telefono'])-5);
  end;
  CBCargo.ItemIndex:=CBCargo.Items.IndexOf(Query['Cargo']);
  if Query['EsActivo'] then RGActivo.ItemIndex:=0
                       else RGActivo.ItemIndex:=1;
  ActivarControles(false);
  BGuardar.Caption:='Actualizar';
  CBModificar.Enabled:=true;
end;

procedure TFEmpleados.ActivarControles(Opcion: boolean);
begin
  ENombre.ReadOnly:=not Opcion;
  EApellido.ReadOnly:=not Opcion;
  CBTelefono.Enabled:=Opcion;
  ETelefono.ReadOnly:=not Opcion;
  CBCargo.Enabled:=Opcion;
end;

procedure TFEmpleados.ActivarGuardar;
begin
  BGuardar.Enabled:=(ENombre.Text<>'') and (EApellido.Text<>'')
                    and (CBCargo.Text<>'');
end;

function TFEmpleados.EmpEsActivo: string;
begin
  if QryLista['EsActivo']=1 then Result:='SÍ'
                            else Result:='NO';
end;

procedure TFEmpleados.BCerrarClick(Sender: TObject);
begin
  Close;
end;

procedure TFEmpleados.BGuardarClick(Sender: TObject);
var
  Mensaje,Mensaje2: string;
begin
  if BGuardar.Caption='Guardar' then Mensaje2:='guardado'
                                else Mensaje2:='actualizado';
  if (MessageDlg('¿Realmente desea '+LowerCase(BGuardar.Caption)+
     ' este empleado?',mtConfirmation,[mbYes,mbNo],0) = mrYes) then
  begin
    Query.SQL.Clear;
    if BGuardar.Caption='Guardar' then
    begin
      Query.SQL.Text:='insert into Empleados (Cedula,Nombre,Apellido,Telefono,'+
        'Cargo,EsActivo) values (:ced,:nom,:apl,:tlf,:crg,:eac)';
      Mensaje:='guardó';
    end
    else
    begin
      Query.SQL.Text:='update Empleados set Cedula=:ced,Nombre=:nom,'+
        'Apellido=:apl,Telefono=:tlf,Cargo=:crg,EsActivo=:eac where '+
        'CodEmpleado=:cde';
      Query.ParamByName('cde').AsInteger:=Empleado.CodEmpleado;
      Mensaje:='actualizó';
    end;
    Query.ParamByName('ced').AsString:=Empleado.Cedula;
    Query.ParamByName('nom').AsString:=Trim(ENombre.Text);
    Query.ParamByName('apl').AsString:=Trim(EApellido.Text);
    Query.ParamByName('tlf').AsString:=CBTelefono.Text+ETelefono.Text;
    Query.ParamByName('crg').AsString:=CBCargo.Text;
    if RGActivo.ItemIndex=0 then Query.ParamByName('eac').AsSmallInt:=1
                            else Query.ParamByName('eac').AsSmallInt:=0;
    Query.ExecSQL;
    ShowMessage('El empleado se '+Mensaje+' exitosamente');
  end
  else ShowMessage('El empleado NO fue '+Mensaje2);
  ValInicial;
end;

procedure TFEmpleados.CBModificarChange(Sender: TObject);
begin
  ActivarControles(CBModificar.Checked);
  BGuardar.Enabled:=CBModificar.Checked;
end;

procedure TFEmpleados.DBGridCellClick(Column: TColumn);
begin
  EActivo.Text:=EmpEsActivo;
end;

procedure TFEmpleados.DBGridKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  EActivo.Text:=EmpEsActivo;
end;

procedure TFEmpleados.ECedulaChange(Sender: TObject);
begin
  BBConsultar.Enabled:=ECedula.Text<>'';
  Empleado.Cedula:=CBCedula.Text+ECedula.Text;
end;

procedure TFEmpleados.ENombreChange(Sender: TObject);
begin
  ActivarGuardar;
end;

procedure TFEmpleados.BBConsultarClick(Sender: TObject);
begin
  Empleado.Cedula:=CBCedula.Text+ECedula.Text;
  Query.SQL.Text:='select * from empleados where Cedula=:cdl';
  Query.ParamByName('cdl').AsString:=Empleado.Cedula;
  Query.Open;
  if Query.RecordCount>0 then CargarEmpleado
  else
  begin
    ShowMessage('Esta cédula no está registrada');
    ActivarControles(true);
    ENombre.SetFocus;
  end;
end;

procedure TFEmpleados.FormShow(Sender: TObject);
begin
  Color:=Sistema.FormColor;
  ValInicial;
end;

end.

