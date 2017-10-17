unit CambioContrasena;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, ZDataset, UtilHospital;

type

  { TFCambContr }

  TFCambContr = class(TForm)
    BCambiar: TButton;
    Bevel1: TBevel;
    BSalir: TButton;
    EConfPassword: TEdit;
    EPasswActual: TEdit;
    EPassword: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    LMensaje: TLabel;
    ZQuery: TZQuery;
    procedure BCambiarClick(Sender: TObject);
    procedure BSalirClick(Sender: TObject);
    procedure EPasswActualChange(Sender: TObject);
    procedure EPasswActualKeyPress(Sender: TObject; var Key: char);
   // procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
    function ActivaBoton: boolean;
    procedure Enter2Tab(var Key: char);
  public
    { public declarations }
  end;

var
  FCambContr: TFCambContr;

implementation

uses principal;

{$R *.lfm}

{ TFCambContr }

function TFCambContr.ActivaBoton: boolean;
begin
  Result:=(Length(EPasswActual.Text)>7) and (Length(EPassword.Text)>7)
           and (Length(EConfPassword.Text)>7)
end;

procedure TFCambContr.Enter2Tab(var Key: char);
begin
  if Key=#13 then
  begin
    SelectNext(ActiveControl,true,true);
    Key:=#0
  end;
end;

procedure TFCambContr.BCambiarClick(Sender: TObject);
begin
  if EPasswActual.Text=Sistema.Usuario.Clave then
    if EPassword.Text=EConfPassword.Text then
    begin
      ZQuery.SQL.Text:='update Usuarios set Clave=:clv where IDUsuario=:ius';
      ZQuery.ParamByName('clv').AsString:=Encriptar(EPassword.Text);
      ZQuery.ParamByName('ius').AsString:=Sistema.Usuario.IDUsuario;
      ZQuery.ExecSQL;
      ShowMessage(' La contraseña ha sido cambiada exitosamente ');
      Sistema.Usuario.IDUsuario:='';
      Sistema.Usuario.Clave:='';
      FPrinc.ActivaMenu(Sistema.Usuario.IDUsuario<>'');
      Close;
    end
    else
    begin
      ShowMessage(' La contraseña nueva no concuerda ');
      EConfPassword.SetFocus;
    end
  else
  begin
    ShowMessage(' Contraseña actual incorrecta ');
    EPasswActual.SetFocus;
  end;
end;

procedure TFCambContr.BSalirClick(Sender: TObject);
begin
  Close;
end;

procedure TFCambContr.EPasswActualChange(Sender: TObject);
begin
  BCambiar.Enabled:=ActivaBoton;
end;

procedure TFCambContr.EPasswActualKeyPress(Sender: TObject; var Key: char);
begin
  Enter2Tab(Key);
end;

               {
procedure TFCambContr.FormKeyPress(Sender: TObject; var Key: char);
begin
  if Key=#13 then
  begin
    SelectNext(ActiveControl,true,true);
    Key:=#0
  end
end;          }

procedure TFCambContr.FormShow(Sender: TObject);
begin
  Color:=Sistema.FormColor;
  LMensaje.Caption:='Usuario activo: '+Sistema.Usuario.IDUsuario;
end;

end.
