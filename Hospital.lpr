program Hospital;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, zvdatetimectrls, IngrMaterial, DataMod, zcomponent, Principal,
  UtilHospital, Despacho, Empleados,
  { you can add units after this }
  translations, Acerca, Detalle, Existencia, RepIngresos, AdmUsuarios,
CambioContrasena, CambioUsuario;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  TranslateUnitResourceStrings('LCLStrConsts','Languages/lclstrconsts.%s.po','es','');
  TranslateUnitResourceStrings('Lr_const','Languages/lr_const.%s.po','es','');
  Application.Initialize;
  Application.CreateForm(TDMod, DMod);
  Application.CreateForm(TFPrinc, FPrinc);
  Application.Run;
end.

