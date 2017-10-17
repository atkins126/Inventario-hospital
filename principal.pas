unit Principal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ActnList, ExtCtrls, Buttons, ZDataset, UtilHospital;

type

  { TFPrinc }

  TFPrinc = class(TForm)
    ActIngrMaterial: TAction;
    ActEmpleados: TAction;
    ActAcerca: TAction;
    ActDetalle: TAction;
    ActDespacho: TAction;
    ActExistencia: TAction;
    ActIngresos: TAction;
    ActAdmUsuarios: TAction;
    ActCmbContr: TAction;
    ActCmbUsuario: TAction;
    ActSalir: TAction;
    ActionList: TActionList;
    ImgLogo: TImage;
    MainMenu: TMainMenu;
    MenuItem1: TMenuItem;
    MnExistencia: TMenuItem;
    MnIngresos: TMenuItem;
    MenuItem12: TMenuItem;
    MnAdmin: TMenuItem;
    MnCmbClave: TMenuItem;
    MnIngSistema: TMenuItem;
    MenuItem16: TMenuItem;
    MnIngreso: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MnEmpleados: TMenuItem;
    MnDespacho: TMenuItem;
    MnDetalle: TMenuItem;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    ZQuery: TZQuery;
    procedure ActAcercaExecute(Sender: TObject);
    procedure ActAdmUsuariosExecute(Sender: TObject);
    procedure ActCmbContrExecute(Sender: TObject);
    procedure ActCmbUsuarioExecute(Sender: TObject);
    procedure ActDespachoExecute(Sender: TObject);
    procedure ActDetalleExecute(Sender: TObject);
    procedure ActEmpleadosExecute(Sender: TObject);
    procedure ActExistenciaExecute(Sender: TObject);
    procedure ActIngresosExecute(Sender: TObject);
    procedure ActIngrMaterialExecute(Sender: TObject);
    procedure ActSalirExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    procedure ActivaMenu(Opc: boolean);
  end;

var
  FPrinc: TFPrinc;

implementation

{$R *.lfm}

uses DataMod,IngrMaterial,Empleados,Detalle,Despacho,Existencia,RepIngresos,
  AdmUsuarios,CambioContrasena,CambioUsuario,Acerca;

{ TFPrinc }

procedure TFPrinc.ActivaMenu(Opc: boolean);
begin
  MnIngreso.Enabled:=Opc;
  MnDespacho.Enabled:=Opc;
  MnDetalle.Enabled:=Opc;
  MnExistencia.Enabled:=Opc;
  MnIngresos.Enabled:=Opc;
  MnEmpleados.Enabled:=Opc;
  //MnIngSistema.Enabled:=Opc;
  MnCmbClave.Enabled:=Opc;
  MnAdmin.Enabled:=Opc;
end;

procedure TFPrinc.ActIngrMaterialExecute(Sender: TObject);
begin
  MostrarVentana(TFIngrMaterial);
end;

procedure TFPrinc.ActEmpleadosExecute(Sender: TObject);
begin
  MostrarVentana(TFEmpleados);
end;

procedure TFPrinc.ActExistenciaExecute(Sender: TObject);
begin
  MostrarVentana(TFExistencia);
end;

procedure TFPrinc.ActIngresosExecute(Sender: TObject);
begin
  MostrarVentana(TFRepIngresos);
end;

procedure TFPrinc.ActAcercaExecute(Sender: TObject);
begin
  MostrarVentana(TFAcerca);
end;

procedure TFPrinc.ActAdmUsuariosExecute(Sender: TObject);
begin
  MostrarVentana(TFAdmUsuarios);
end;

procedure TFPrinc.ActCmbContrExecute(Sender: TObject);
begin
  MostrarVentana(TFCambContr);
end;

procedure TFPrinc.ActCmbUsuarioExecute(Sender: TObject);
begin
  MostrarVentana(TFCambioUsuario);
end;

procedure TFPrinc.ActDespachoExecute(Sender: TObject);
begin
  MostrarVentana(TFDespacho);
end;

procedure TFPrinc.ActDetalleExecute(Sender: TObject);
begin
  MostrarVentana(TFDetalle);
end;

procedure TFPrinc.ActSalirExecute(Sender: TObject);
var
  CanClose: boolean;
begin
  FormCloseQuery(Self,CanClose);
end;

procedure TFPrinc.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose:=(MessageDlg('¿Desea salir del sistema?',mtConfirmation,
            [mbYes,mbNo],0) = mrYes);
  if CanClose then
  begin
    DMod.ZConn.Connected:=false;
    Application.Terminate;
  end;
end;

procedure TFPrinc.FormShow(Sender: TObject);
begin
  Application.Title:=Sistema.Nombre+' '+Sistema.Version;
  ImgLogo.Hint:=Application.Title;
  Caption:=Application.Title;
  Color:=Sistema.FormColor;
  ActivaMenu(false);
  //se revisa si hay ya algún usuario creado, sino a crearlo:
  ZQuery.SQL.Text:='select * from Usuarios limit 1';
  ZQuery.Open;
  if ZQuery.IsEmpty then MostrarVentana(TFAdmUsuarios);
end;

end.
