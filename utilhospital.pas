unit UtilHospital;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Forms, Controls, DCPrijndael, DCPsha1, StdCtrls, DBGrids,
  Graphics, LR_Class, Dialogs;

type
  //el tipo TUsuario:
  TUsuario = record
    IDUsuario,
    Nombre,
    Cedula,
    Clave: string;
  end;

  //la clase TSistema:
  TSistema = class
    Nombre,
    Version,
    Autor1,
    Autor2: string;
    Usuario: TUsuario;
    FormColor: TColor;
    public
      constructor CrearSistema;
  end;

  procedure MostrarVentana(AClass: TFormClass);
  function EliminaEspacio(Cadena: string): string;
  procedure MostrarReporte(frReporte: TfrReport; Reporte: string);
  function Encriptar(Cadena: string): string;
  function Desencriptar(Cadena: string): string;
  function ExisteCaracter(Cadena: string; Letra: char): boolean;
  procedure EditNumero(var Edit: TEdit; var Key: char);
  procedure AjustaColumnaDBGrid(ADBGrid: TDBGrid);

var
  Sistema: TSistema;

implementation

//la clase TSistema:
constructor TSistema.CrearSistema;
begin
  Nombre:='Sistema de inventario de almacén del Hospital';
  Version:='v1.0';
  Autor1:='Donko Jones  C.I. 10.000.000';
  Autor2:='Misko Jones  C.I. 11.000.000';
  //FormColor:=$F7F5DD;
  FormColor:=$F9F8E6;
end;

procedure MostrarVentana(AClass: TFormClass);
begin
  with AClass.Create(Application) do
    try
      BorderIcons:=[biSystemMenu];
      BorderStyle:=bsSingle;
      KeyPreview:=true;
      Position:=poScreenCenter;
      ShowModal;
    finally Free
    end;
end;

{Elimina todos los espacios en una cadena}
function EliminaEspacio(Cadena: string): string;
begin
  while Pos(' ',Cadena)>0 do Delete(Cadena,Pos(' ',Cadena),1);
  Result:=Cadena;
end;

{Muestra un reporte (LazReport)}
procedure MostrarReporte(frReporte: TfrReport; Reporte: string);
begin
  if FileExists(Reporte) then
  begin
    frReporte.LoadFromFile(Reporte);
    frReporte.ShowReport;
  end
  else ShowMessage('El archivo de reporte no fue encontrado');
end;

{Encripta una cadena de caracteres}
function Encriptar(Cadena: string): string;
var
  DCPr: TDCP_rijndael;
begin
  DCPr:=TDCP_rijndael.Create(nil);
  DCPr.InitStr('',TDCP_sha1);
  Result:=DCPr.EncryptString(Cadena);
  DCPr.Burn;
  DCPr.Free;
end;

{Desencripta una cadena de caracteres}
function Desencriptar(Cadena: string): string;
var
  DCPr: TDCP_rijndael;
begin
  DCPr:=TDCP_rijndael.Create(nil);
  DCPr.InitStr('',TDCP_sha1);
  Result:=DCPr.DecryptString(Cadena);
  DCPr.Burn;
  DCPr.Free;
end;

{Determina si un caracter está dentro de una cadena}
function ExisteCaracter(Cadena: string; Letra: char): boolean;
var
  I: byte;
  Existe: boolean;
begin
  Existe:=false;
  for I:=1 to Length(Cadena) do
  begin
    Existe:=Cadena[I]=Letra;
    if Existe then Break;
  end;
  Result:=Existe;
end;

{Fuerza a un TEdit a aceptar solamente números decimales}
procedure EditNumero(var Edit: TEdit; var Key: char);
begin
  if not (Key in ['0'..'9',',','.',#8]) then Key:=#0
  else
    if (Key='.') then Key:=',';
  if (Key=',') and ExisteCaracter(EDit.Text,',') then Key:=#0
end;

procedure AjustaColumnaDBGrid(ADBGrid: TDBGrid);
const
  Sep=20;   //separador (en pixeles)
var
  Temp,I,AnchoTit: Integer;
  LongMax: array of Integer;
begin
  with ADBGrid do
  begin
    Canvas.Font:=Font;
    SetLength(LongMax,Columns.Count);
    for i:=0 to Columns.Count-1 do
      LongMax[I]:=Canvas.TextWidth(SelectedField.FieldName {Fields[I].FieldName})+Sep;
    DataSource.DataSet.First;
    while not DataSource.DataSet.Eof do
    begin
      for i:=0 to Columns.Count-1 do
      begin
        Temp:=Canvas.TextWidth(Trim(Columns[I].Field.DisplayText))+Sep;
        if Temp>LongMax[I] then LongMax[I]:=Temp;
        //se compara con el caption del título:
        AnchoTit:=Canvas.TextWidth(Columns[I].Title.Caption)+Sep;
        if AnchoTit>LongMax[I] then LongMax[I]:=AnchoTit;
      end;
      DataSource.DataSet.Next;
    end;
    DataSource.DataSet.First;
    for I:=0 to Columns.Count-1 do
      if LongMax[I]>0 then Columns[I].Width:=LongMax[I];
  end;
  LongMax:=nil;
end;

end.
