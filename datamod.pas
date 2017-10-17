unit DataMod;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, ZConnection, UtilHospital;

type

  { TDMod }

  TDMod = class(TDataModule)
    ZConn: TZConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  DMod: TDMod;

implementation

{$R *.lfm}

{ TDMod }

procedure TDMod.DataModuleCreate(Sender: TObject);
begin
  //datos de la conexión:
  ZConn.Port:=3306;
  ZConn.Connected:=true;
  //se instancia la clase TSistema:
  Sistema:=TSistema.CrearSistema;
end;

end.

