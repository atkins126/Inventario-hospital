unit CambioUsuario;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, ZDataset, UtilHospital;

type

  { TFCambioUsuario }

  TFCambioUsuario = class(TForm)
    BAceptar: TButton;
    BSalir: TButton;
    CBSalir: TCheckBox;
    EUsuario: TEdit;
    EContrasena: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    LUsrActivo: TLabel;
    ZQuery: TZQuery;
    procedure BAceptarClick(Sender: TObject);
    procedure BSalirClick(Sender: TObject);
    procedure CBSalirChange(Sender: TObject);
    procedure EContrasenaKeyPress(Sender: TObject; var Key: char);
    procedure EContrasenaKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EUsuarioKeyPress(Sender: TObject; var Key: char);
    procedure EUsuarioKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
    procedure ValInicial;
    procedure Enter2Tab(var Key: char);
    procedure ActivaBoton;
  public
    { public declarations }
  end;

var
  FCambioUsuario: TFCambioUsuario;

implementation

uses principal;

{$R *.lfm}

{ TFCambioUsuario }

procedure TFCambioUsuario.ValInicial;
begin
  EUsuario.Clear;
  EContrasena.Clear;
  EContrasena.Enabled:=false;
  ActivaBoton;
  EUsuario.SetFocus;
end;

procedure TFCambioUsuario.Enter2Tab(var Key: char);
begin
  if Key=#13 then
  begin
    SelectNext(ActiveControl,true,true);
    Key:=#0
  end;
end;

procedure TFCambioUsuario.ActivaBoton;
begin
  BAceptar.Enabled:=(EUsuario.Text<>'') and (EContrasena.Text<>'')
    and (Length(EContrasena.Text)>7);
end;

procedure TFCambioUsuario.BAceptarClick(Sender: TObject);
begin
  if CBSalir.Checked then
  begin
    Sistema.Usuario.IDUsuario:='';
    Sistema.Usuario.Clave:='';
    ShowMessage('El usuario '+EUsuario.Text+' ha cerrado la sesión.');
    Close;
  end
  else
  begin
    ZQuery.SQL.Text:='select IDUsuario,Clave,EsActivo from Usuarios '+
      'where IDUsuario=:ius and Clave=:clv limit 1';
    ZQuery.ParamByName('ius').AsString:=EUsuario.Text;
    ZQuery.ParamByName('clv').AsString:=Encriptar(EContrasena.Text);
    ZQuery.Open;
    if ZQuery.RecordCount>0 then
    begin
      Sistema.Usuario.IDUsuario:=EUsuario.Text;
      Sistema.Usuario.Clave:=EContrasena.Text;
      ShowMessage('El usuario '+EUsuario.Text+' ha entrado en sesión.');
      Close;
    end
    else
    begin
      ShowMessage('El usuario y/o contraseña es (son) incorrecto(s). Intente de nuevo');
      ValInicial;
    end;
  end;
  FPrinc.ActivaMenu(Sistema.Usuario.IDUsuario<>'');
end;

procedure TFCambioUsuario.BSalirClick(Sender: TObject);
begin
  Close;
end;

procedure TFCambioUsuario.CBSalirChange(Sender: TObject);
begin
  BAceptar.Enabled:=CBSalir.Checked;
end;

procedure TFCambioUsuario.EContrasenaKeyPress(Sender: TObject; var Key: char);
begin
  Enter2Tab(Key);
end;

procedure TFCambioUsuario.EContrasenaKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  ActivaBoton;
end;

procedure TFCambioUsuario.EUsuarioKeyPress(Sender: TObject; var Key: char);
begin
  Enter2Tab(Key);
end;

procedure TFCambioUsuario.EUsuarioKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  EUsuario.Text:=EliminaEspacio(EUsuario.Text);
  EContrasena.Enabled:=Length(EUsuario.Text)>5;
  ActivaBoton;
end;

procedure TFCambioUsuario.FormShow(Sender: TObject);
begin
  Color:=Sistema.FormColor;
  if Sistema.Usuario.IDUsuario<>'' then
    LUsrActivo.Caption:='Usuario activo: '+Sistema.Usuario.IDUsuario
  else LUsrActivo.Caption:='No hay ningún usuario activo';
  CBSalir.Enabled:=Sistema.Usuario.IDUsuario<>'';
  ValInicial;
end;

end.
