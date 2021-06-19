-- Actualizaciones y borrados

/* Todas las actualizaciones y borrados son accesibles por el administrador */

/* Todas las actualizaciones y borrados mostrados en este script se planean extender a
 Procedimientos almacenados o funciones por lo cual son ejemplos de su aplicación */

/* Todos los borrados borraran una fila de la tabla y se usaran solo en caso de haber cometido 
un error al ingresar la información, pues luego de utilizar la información en otras tablas
el eliminar una fila puede ser perjudicial para la base de datos*/

-- ----------------------------------------------------------------------------------------------
-- Tabla mascotas
-- -Accede Veterinario

-- Actualización (Todos los parametros pueden variar dentro de sus posibilidades) :
/* Se usara en caso de que el veterinario vea algun detalle que fue dificil obsevar para el 
rescatista al momento de ingresar la información */
Update mascota 
set tip_ID = 1, mas_color = 'gris',
 mas_Sexo = 'Macho',
 mas_Descripcion = 'Su raza suele necesitar cuidados especiales',
 mas_Foto = null 
 where mas_ID = 12;

-- Borrado 
Delete from mascota where mas_ID = 11;

-- ----------------------------------------------------------------------------------------------
-- Tabla Tipo de Mascota
-- -Accede Veterinario

-- Actualización
Update tipodemascota set tip_Habitat = '',
tip_Denominacion = '',
tip_Generalidades = '',
tip_Alimento = '',
tip_Foto = null;

-- Borrado
Delete from tipodemascota where tip_ID = 7;

-- ----------------------------------------------------------------------------------------------
-- Tabla Candidato
-- -Accede Publicista

-- Actualización
Update candidato set can_Documento = '1247891344',
can_Nombre = 'Santiago',
can_Apellido = 'Rodriguez',
can_Fecha = '1998-04-04',
can_Residencia = 'cll 12 # 23b -10 norte',
can_Ingreso = 12000000,
can_Estado = default
where can_ID = 2;


-- Borrado
Delete from candidato where can_ID = 4;
/*Unico borrado que puede ser ejecutado siempre que sea posible*/
Delete from candidato where can_Estado = 'No apto';

-- ----------------------------------------------------------------------------------------------
-- Tabla Adopción
-- -Accede Veterinario

-- Actualización
Update adopcion set apl_ID = 3,
emp_ID = 2,
ado_Fecha = '2020/11/14'
where ado_ID = 4;

-- Borrado
Delete from adopcion where ado_ID = 4;

-- ----------------------------------------------------------------------------------------------
-- Tabla Aplica
-- - Accede Publicista
-- - Accede Veterinario

-- Actualización
Update aplica set
can_ID = 2,
mas_ID = 3,
apl_FechaAplicacion = '2021/01/01'
where apl_ID = 4;
-- Borrado
Delete from aplica where apl_ID = 2;

-- ----------------------------------------------------------------------------------------------
-- Tabla Contribuidor
-- - Accede Publicista
-- - Accede Contador

-- Actualización
Update contribuidor set
con_Documento = '1234123',
con_Nombre = 'Javier',
con_Apellido = 'Espinoza',
con_Fecha = '2021-02-24',
con_Labor = 'Empresario',
con_Foto = default
where con_ID = 1;
-- Borrado
Delete from contribuidor where con_ID = 7;
-- ----------------------------------------------------------------------------------------------
-- Tabla Donacion
-- - Accede Contador

-- Actualización
Update donacion set
don_Valor = 120000,
don_Lugar = 'Bogota D.C.',
con_ID = 5,
don_Fecha = '2021-04-23'
where don_Numero = '12345';
-- Borrado
Delete from donacion where don_Numero = '123435';
-- ----------------------------------------------------------------------------------------------

-- Tabla Pago Empleado
-- - Accede Contador

-- Actualización
Update pagoempleado set
emp_ID = 3,
pad_ID = 3,
pag_Total = 130000,
pag_Total = 130000,
pag_Fecha = '2020-01-03'
where pag_Numero = '1234567';
-- Borrado
Delete from pagoempleado where pag_Numero = '1234567';

-- ----------------------------------------------------------------------------------------------
-- Tabla Pago Adicional Empleado
-- - Accede Contador

-- Actualización
Update pagoadicionalempleado set
pad_Valor = 1300000,
pad_Descripción = 'Vacunas'
where pad_ID = 3;
-- Borrado
Delete from pagoadicionalempleado where pad_ID = 4;
-- ----------------------------------------------------------------------------------------------
-- Tabla Economia
-- - Accede Contador

-- Actualización
Update Economia set
eco_Total = 94000,
eco_Fecha = '2020-12-12'
where eco_ID = 2;
-- Borrado
Delete from economia where eco_ID = 3;
-- ----------------------------------------------------------------------------------------------
-- Tabla vw_Aptitud
-- - Accede Psicólogo

-- Actualización
Update vw_Aptitud set can_estado = 'Apto' where can_id = 2;