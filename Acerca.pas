unit Acerca;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, UtilHospital;

type

  { TFAcerca }

  TFAcerca = class(TForm)
    Button1: TButton;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    LAutor1: TLabel;
    LAutor2: TLabel;
    Label4: TLabel;
    LVersion: TLabel;
    LTitulo: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FAcerca: TFAcerca;

implementation

{$R *.lfm}

{ TFAcerca }

procedure TFAcerca.FormShow(Sender: TObject);
begin
  Color:=Sistema.FormColor;
  //los datos:
  LTitulo.Caption:=Sistema.Nombre;
  LVersion.Caption:=Sistema.Version;
  LAutor1.Caption:=Sistema.Autor1;
  LAutor2.Caption:=Sistema.Autor2;
end;

procedure TFAcerca.Button1Click(Sender: TObject);
begin
  Close;
end;

end.

