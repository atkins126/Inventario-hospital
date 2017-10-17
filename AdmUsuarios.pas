unit AdmUsuarios;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  DBGrids, ComCtrls, DbCtrls, ZDataset, UtilHospital;

type

  { TFAdmUsuarios }

  TFAdmUsuarios = class(TForm)
    BConsDisp: TButton;
    BCrear: TButton;
    BSalir: TButton;
    BCancelar: TButton;
    DS: TDatasource;
    DBGUsuarios: TDBGrid;
    ECedulaNvo: TEdit;
    EUsuario: TEdit;
    EContr1: TEdit;
    EContr2: TEdit;
    ENombreNvo: TEdit;
    Label1: TLabel;
    LConfContr: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    PCtrl: TPageControl;
    TabSheet2: TTabSheet;
    TabSheet1: TTabSheet;
    ZQuery: TZQuery;
    ZQryList: TZQuery;
    procedure BCancelarClick(Sender: TObject);
    procedure BConsDispClick(Sender: TObject);
    procedure BCrearClick(Sender: TObject);
    procedure BCrearKeyPress(Sender: TObject; var Key: char);
    procedure BSalirClick(Sender: TObject);
    procedure EContr1KeyPress(Sender: TObject; var Key: char);
    procedure EContr1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EContr2KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ENombreNvoChange(Sender: TObject);
    procedure ENombreNvoExit(Sender: TObject);
    procedure ENombreNvoKeyPress(Sender: TObject; var Key: char);
    procedure ENombreNvoKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure EUsuarioExit(Sender: TObject);
    procedure EUsuarioKeyPress(Sender: TObject; var Key: char);
    procedure EUsuarioKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure TabSheet2Show(Sender: TObject);
    procedure TabSheet1Show(Sender: TObject);
  private
    { private declarations }
    procedure Enter2Tab(var Key: char);
    procedure ValInicial;
    procedure ActivaBoton;
  public
    { public declarations }
  end;

var
  FAdmUsuarios: TFAdmUsuarios;
  Disponible: boolean;

implementation

{$R *.lfm}

{ TFAdmUsuarios }

procedure TFAdmUsuarios.Enter2Tab(var Key: char);
begin
  if Key=#13 then
  begin
    SelectNext(ActiveControl,true,true);
    Key:=#0
  end;
end;

procedure TFAdmUsuarios.ValInicial;
begin
  Disponible:=false;
  LConfContr.Caption:='';
  EUsuario.Clear;
  EUsuario.Font.Style:=[];
  EUsuario.Font.Color:=clDefault;
  EUsuario.ReadOnly:=false;
  EUsuario.SetFocus;
  EContr1.Clear;
  EContr2.Clear;
  EContr1.Enabled:=false;
  EContr2.Enabled:=false;
  ENombreNvo.Clear;
  ECedulaNvo.Clear;
  ENombreNvo.Enabled:=false;
  ECedulaNvo.Enabled:=false;
  BConsDisp.Enabled:=false;
  ActivaBoton;
end;

procedure TFAdmUsuarios.ActivaBoton;
begin
  BCrear.Enabled:=(ENombreNvo.Text<>'') and (ECedulaNvo.Text<>'') and
    (EContr1.Text=EContr2.Text) and (Length(EContr1.Text)>7) and Disponible;
end;

procedure TFAdmUsuarios.BSalirClick(Sender: TObject);
begin
  Close;
end;

procedure TFAdmUsuarios.EContr1KeyPress(Sender: TObject; var Key: char);
begin
  Enter2Tab(Key);
end;

procedure TFAdmUsuarios.EContr1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  EContr1.Text:=EliminaEspacio(EContr1.Text);
  EContr2.Enabled:=Length(EContr1.Text)>7;
  ActivaBoton;
end;

procedure TFAdmUsuarios.EContr2KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  SonIguales: boolean;
begin
  SonIguales:=EContr2.Text=EContr1.Text;
  ENombreNvo.Enabled:=SonIguales;
  ECedulaNvo.Enabled:=SonIguales;
  if SonIguales then
  begin
    LConfContr.Caption:='Las contraseñas son válidas';
    LConfContr.Font.Color:=clGreen;
  end
  else
  begin
    LConfContr.Caption:='Las contraseñas no coinciden';
    LConfContr.Font.Color:=clRed;
  end;
  ActivaBoton;
end;

procedure TFAdmUsuarios.ENombreNvoChange(Sender: TObject);
begin
  ActivaBoton;
end;

procedure TFAdmUsuarios.ENombreNvoExit(Sender: TObject);
begin
  ENombreNvo.Text:=Trim(ENombreNvo.Text);
end;

procedure TFAdmUsuarios.ENombreNvoKeyPress(Sender: TObject; var Key: char);
begin
  Enter2Tab(Key);
end;

procedure TFAdmUsuarios.ENombreNvoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  ActivaBoton;
end;

procedure TFAdmUsuarios.EUsuarioExit(Sender: TObject);
begin
  EUsuario.Text:=EliminaEspacio(EUsuario.Text);
  if EUsuario.Text='usuario' then
  begin
    ShowMessage('Deberá escoger un nombre de usuario distinto a "usuario".');
    EUsuario.Clear;
    EUsuario.SetFocus;
  end;
end;

procedure TFAdmUsuarios.EUsuarioKeyPress(Sender: TObject; var Key: char);
begin
  Enter2Tab(Key);
end;

procedure TFAdmUsuarios.EUsuarioKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  EUsuario.Text:=EliminaEspacio(EUsuario.Text);
  BConsDisp.Enabled:=Length(EUsuario.Text)>5;
end;

procedure TFAdmUsuarios.FormCreate(Sender: TObject);
begin
  Color:=Sistema.FormColor;
  ZQuery.SQL.Text:='select IDUsuario from Usuarios limit 1';
  ZQuery.Open;
  if ZQuery.IsEmpty then PCtrl.ActivePageIndex:=1
  else PCtrl.ActivePageIndex:=0;
end;

procedure TFAdmUsuarios.TabSheet2Show(Sender: TObject);
begin
  ValInicial;
end;

procedure TFAdmUsuarios.TabSheet1Show(Sender: TObject);
begin
  ZQryList.Open;
  AjustaColumnaDBGrid(DBGUsuarios);
 // DBGUsuarios.SetFocus;
end;

procedure TFAdmUsuarios.BConsDispClick(Sender: TObject);
begin
  ZQuery.SQL.Text:='select IDUsuario from Usuarios where IDUsuario=:ius limit 1';
  ZQuery.ParamByName('ius').AsString:=EUsuario.Text;
  ZQuery.Open;
  if ZQuery.RecordCount>0 then
  begin
    ShowMessage('El nombre de usuario ya existe. Intente otro.');
    EUsuario.SetFocus;
  end
  else
  begin
    ShowMessage('El nombre de usuario está disponible.');
    Disponible:=true;
    EUsuario.Font.Style:=[fsBold];
    EUsuario.Font.Color:=clGreen;
    EUsuario.ReadOnly:=true;
    EContr1.Enabled:=true;
    EContr1.SetFocus;
  end;
end;

procedure TFAdmUsuarios.BCancelarClick(Sender: TObject);
begin
  ValInicial;
end;

procedure TFAdmUsuarios.BCrearClick(Sender: TObject);
begin
  ZQuery.SQL.Text:='insert into Usuarios (IDUsuario,Clave,Cedula,Nombre,'+
    'EsActivo) values (:ius,:clv,:ced,:nom,1)';
  ZQuery.ParamByName('ius').AsString:=EUsuario.Text;
  ZQuery.ParamByName('clv').AsString:=Encriptar(EContr1.Text);
  ZQuery.ParamByName('ced').AsString:=ECedulaNvo.Text;
  ZQuery.ParamByName('nom').AsString:=ENombreNvo.Text;
  ZQuery.ExecSQL;
  TabSheet1.TabVisible:=true;
  ZQryList.SQL.Text:='select * from Usuarios';
  ZQryList.Open;
  ShowMessage('El usuario fue creado exitosamente.');
  ValInicial;
end;

procedure TFAdmUsuarios.BCrearKeyPress(Sender: TObject; var Key: char);
begin
  BCrearClick(Self);
  Enter2Tab(Key);
end;

end.
