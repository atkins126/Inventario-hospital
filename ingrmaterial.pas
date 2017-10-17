unit IngrMaterial;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Dialogs, StdCtrls,
  DBGrids, ComCtrls, ZDataset, db, UtilHospital;

type

  { TFIngrMaterial }

  TFIngrMaterial = class(TForm)
    BGuardar: TButton;
    Button2: TButton;
    ChBNvo: TCheckBox;
    DataSource1: TDataSource;
    DS: TDataSource;
    DBGrid: TDBGrid;
    ECantidad: TEdit;
    EDescr: TEdit;
    EProveedor: TEdit;
    EPrecio: TEdit;
    EProducto: TEdit;
    EUnidad: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    LDescr: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    LCantidad: TLabel;
    Label6: TLabel;
    QryLista: TZQuery;
    QryListaCodProducto: TLargeintField;
    Query1: TZQuery;
    QueryCantidad: TLargeintField;
    QueryCantidad1: TLargeintField;
    QueryCantidad2: TLargeintField;
    QueryCodProducto: TLargeintField;
    QueryCodProducto1: TLargeintField;
    QueryDescripcion: TStringField;
    QueryDescripcion1: TStringField;
    QueryDescripcion2: TStringField;
    QueryEsValido: TSmallintField;
    QueryEsValido1: TSmallintField;
    QueryEsValido2: TSmallintField;
    QueryPrecio: TLargeintField;
    QueryPrecio1: TLargeintField;
    QueryPrecio2: TLargeintField;
    QueryUnidadMedida: TStringField;
    QueryUnidadMedida1: TStringField;
    Query: TZQuery;
    QueryUnidadMedida2: TStringField;
    SBar: TStatusBar;
    procedure BGuardarClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ChBNvoChange(Sender: TObject);
    procedure DBGridCellClick(Column: TColumn);
    procedure DBGridKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ECantidadExit(Sender: TObject);
    procedure ECantidadChange(Sender: TObject);
    procedure EPrecioChange(Sender: TObject);
    procedure EPrecioKeyPress(Sender: TObject; var Key: char);
    procedure EProductoChange(Sender: TObject);
    procedure EProductoKeyPress(Sender: TObject; var Key: char);
    procedure EUnidadChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure ValInicial;
    procedure CargarProducto;
    procedure ActivarControles(Opcion: boolean);
    procedure ActivarBGuardar;
  public
    { public declarations }
  end;

var
  FIngrMaterial: TFIngrMaterial;
  PrecioActual: integer;

implementation

//uses DataMod;

{$R *.lfm}

{ TFIngrMaterial }

procedure TFIngrMaterial.ValInicial;
begin
  PrecioActual:=0;
  QryLista.SQL.Text:='select * from productos order by Descripcion';
  QryLista.Open;
  BGuardar.Caption:='Guardar';
  SBar.SimpleText:=' Total productos registrados: '+IntToStr(QryLista.RecordCount);
  ActivarControles(false);
  //gb datos producto:
  EDescr.Clear;
  EUnidad.Clear;
  ChBNvo.Enabled:=false;
  //gb precio/existencia:
  ECantidad.Text:='0';
  EPrecio.Text:='0';
  EProducto.Clear;
  EProducto.SetFocus;
  EProveedor.Clear;
  ActivarBGuardar;
end;

procedure TFIngrMaterial.CargarProducto;
begin
  if QryLista.RecordCount>0 then
  begin
    LCantidad.Caption:='Cantidad a agregar:';
    EDescr.Text:=QryLista['Descripcion'];
    EUnidad.Text:=QryLista['UnidadMedida'];
    EPrecio.Text:=QryLista['Precio'];
    BGuardar.Caption:='Actualizar';
  end;
end;

procedure TFIngrMaterial.ActivarControles(Opcion: boolean);
begin
  EUnidad.ReadOnly:=not Opcion;
  ECantidad.ReadOnly:=not Opcion;
  EPrecio.ReadOnly:=not Opcion;
  EDescr.ReadOnly:=not Opcion;
end;

procedure TFIngrMaterial.ActivarBGuardar;
begin
  BGuardar.Enabled:=(EDescr.Text<>'') and (EUnidad.Text<>'') and
                    (EProveedor.Text<>'');
end;

procedure TFIngrMaterial.EProductoChange(Sender: TObject);
begin
  LCantidad.Caption:='Cantidad:';
  QryLista.SQL.Text:='select * from productos where Descripcion like :dsc '+
                     'order by Descripcion';
  QryLista.ParamByName('dsc').AsString:='%'+EProducto.Text+'%';
  QryLista.Open;
  EDescr.Text:=EProducto.Text;
  EUnidad.Clear;
  ActivarBGuardar;
  if QryLista.RecordCount=0 then
  begin
    BGuardar.Caption:='Guardar';
    ChBNvo.Visible:=false;
  end;
end;

procedure TFIngrMaterial.EProductoKeyPress(Sender: TObject; var Key: char);
begin
  if Key=#13 then
    if QryLista.RecordCount>0 then DBGrid.SetFocus
    else
    begin
      ActivarControles(true);
      EUnidad.SetFocus;
    end;
end;

procedure TFIngrMaterial.EUnidadChange(Sender: TObject);
begin
  Query.SQL.Text:='select Descripcion,UnidadMedida from productos where '+
    'Descripcion=:dsc and UnidadMedida like :umd';
  Query.ParamByName('dsc').AsString:=Trim(EDescr.Text);
  Query.ParamByName('umd').AsString:=EUnidad.Text;
  Query.Open;
  ChBNvo.Enabled:=(Query.RecordCount=0) and (QryLista.RecordCount>0);
  ActivarBGuardar;
end;

procedure TFIngrMaterial.FormShow(Sender: TObject);
begin
  Color:=Sistema.FormColor;
  LDescr.Caption:='Descripción'+#13+'del producto';
  ValInicial;
end;

procedure TFIngrMaterial.EPrecioKeyPress(Sender: TObject; var Key: char);
begin
  EditNumero(EPrecio,Key);
end;

procedure TFIngrMaterial.BGuardarClick(Sender: TObject);
var
  //CodProd,
  Mensaje,Mensaje2: string;
  CodProd: integer;
begin
  if BGuardar.Caption='Guardar' then Mensaje2:='guardado'
                                else Mensaje2:='actualizado';
  if (MessageDlg('¿Realmente desea '+LowerCase(BGuardar.Caption)+
     ' este producto?',mtConfirmation,[mbYes,mbNo],0) = mrYes) then
  begin
    if BGuardar.Caption='Guardar' then
    begin
      Query.SQL.Text:='insert into Productos (Descripcion,UnidadMedida,Cantidad,'+
        'Precio) values (:dsc,:umd,:cnt,:prc)';
      Mensaje:='guardó';
    end
    else
    begin
      Query.SQL.Text:='update Productos set Descripcion=:dsc,UnidadMedida=:umd,'+
        'Cantidad=Cantidad+:cnt,Precio=:prc where CodProducto=:cdp';
      Query.ParamByName('cdp').AsInteger:=QryLista['CodProducto'];
      Mensaje:='actualizó';
    end;
    Query.ParamByName('dsc').AsString:=Trim(EDescr.Text);
    Query.ParamByName('umd').AsString:=Trim(EUnidad.Text);
    Query.ParamByName('cnt').AsInteger:=StrToInt(ECantidad.Text);
    Query.ParamByName('prc').AsInteger:=StrToInt(EPrecio.Text);
    Query.ExecSQL;
    //se obtiene el código del producto ingresado:
    if BGuardar.Caption='Guardar' then
    begin
      Query1.SQL.Clear;
      Query1.SQL.Text:='select CodProducto from productos order by CodProducto desc limit 1';
      Query1.Open;
      //Query1.First;
      //showmessage('1');
      CodProd:=Query1['CodProducto'];
    end
    else CodProd:=QryLista['CodProducto'];
    {if BGuardar.Caption='Guardar' then CodProd:='last_insert_id()'
    else CodProd:=IntToStr(QryLista['CodProducto']);}
    //se añade el ingreso:
    Query.SQL.Text:='insert into Ingresos (CodProducto,Altas,Fecha,Proveedor) '+
                    'values (:cdp,:alt,:fch,:prv)';
    Query.ParamByName('cdp').AsInteger:=CodProd;
    Query.ParamByName('alt').AsInteger:=StrToInt(ECantidad.Text);
    Query.ParamByName('fch').AsDate:=Date;
    Query.ParamByName('prv').AsString:=Trim(EProveedor.Text);
    Query.ExecSQL;
    ShowMessage('El producto se '+Mensaje+' exitosamente');
  end
  else ShowMessage('El producto NO fue '+Mensaje2);
  ValInicial;
end;

procedure TFIngrMaterial.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TFIngrMaterial.ChBNvoChange(Sender: TObject);
begin
  if ChBNvo.Checked then
  begin
    BGuardar.Caption:='Guardar';
    EPrecio.Text:='0';
  end
  else
  begin
    BGuardar.Caption:='Actualizar';
    EPrecio.Text:=IntToStr(PrecioActual);
  end;
  ActivarBGuardar;
end;

procedure TFIngrMaterial.DBGridCellClick(Column: TColumn);
begin
  CargarProducto;
  ActivarControles(true);
  ECantidad.SetFocus;
end;

procedure TFIngrMaterial.DBGridKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=13 then
  begin
    ActivarControles(true);
    ECantidad.SetFocus;
  end;
  CargarProducto;
end;

procedure TFIngrMaterial.EPrecioChange(Sender: TObject);
begin
  if EPrecio.Text<>'' then
  begin
    PrecioActual:=StrToInt(EPrecio.Text);
    ActivarBGuardar;
    //BGuardar.Enabled:=PrecioActual<>DBGrid.Columns.Items[3].Field.AsInteger;
    BGuardar.Enabled:=StrToInt(EPrecio.Text)<>DBGrid.Columns.Items[3].Field.AsInteger;
  end;
end;

procedure TFIngrMaterial.ECantidadExit(Sender: TObject);
begin
  if TEdit(Sender).Text='' then TEdit(Sender).Text:='0';
end;

procedure TFIngrMaterial.ECantidadChange(Sender: TObject);
begin
  ActivarBGuardar;
end;

end.

{

if ECantidad.Text<>'0' then
  begin
    if (MessageDlg('¿Realmente desea añadir esta cantidad a este producto?',
        mtConfirmation,[mbYes,mbNo],0) = mrYes) then
    begin
      Query.SQL.Text:='update Productos set Cantidad=Cantidad+:cnt,'+
        'Precio=:prc where CodProducto=:cdp';
      Query.ParamByName('cnt').AsInteger:=StrToInt(ECantidad.Text);
      Query.ParamByName('prc').AsInteger:=StrToInt(EPrecio.Text);
      Query.ParamByName('cdp').AsInteger:=QryLista['CodProducto'];
      Query.ExecSQL;
      ShowMessage('Los datos fueron actualizados exitosamente');
    end
    else ShowMessage('Los datos NO fueron actualizados');
    ValInicial;
  end;

  }
