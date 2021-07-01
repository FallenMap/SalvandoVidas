-- TODAS_LAS_MASCOTAS_RESCATADAS
SELECT mascota.mas_ID, tipodemascota.tip_Denominacion, mascota.mas_Color, 
mascota.mas_Sexo, mascota.mas_Descripcion ,mascota.mas_Foto  
FROM 
mascota 
NATURAL JOIN
tipodemascota;


-- Mascotas_no_adoptadas
SELECT mas_ID, tip_Denominacion, mas_Color, mas_Sexo, 
mas_Descripcion, mas_Foto
FROM
(SELECT *
FROM
(SELECT mas_ID
FROM mascota
WHERE mas_ID 
NOT IN
(SELECT mas_ID
FROM aplica
NATURAL JOIN 
adopcion)) AS aliasA
NATURAL JOIN
mascota) AS aliasB
NATURAL JOIN
tipodemascota;



-- TODAS LAS MASCOTAS ADOPTADAS
SELECT mas_ID ,tip_Denominacion ,mas_Color ,
mas_Sexo ,mas_Descripcion ,mas_Foto
FROM
(SELECT *
FROM
(SELECT aliasA.mas_ID
FROM 
(SELECT mas_ID 
FROM mascota) AS aliasA
INNER JOIN 
(SELECT mas_ID
FROM aplica
NATURAL JOIN adopcion) AS aliasB
ON (aliasA.mas_ID = aliasB.mas_ID)) AS aliasC
NATURAL JOIN
mascota) AS aliasD
NATURAL JOIN
tipodemascota;



-- PERROS EN ADOPCION
SELECT mas_ID ,tip_Denominacion ,mas_Color ,
mas_Sexo ,mas_Descripcion ,mas_Foto 
FROM
(SELECT * FROM
(SELECT * FROM
(SELECT mas_ID
FROM mascota) AS aliasA
WHERE mas_id
NOT IN
(SELECT mas_ID
FROM aplica
NATURAL JOIN adopcion)) AS aliasC
NATURAL JOIN mascota) AS aliasD
NATURAL JOIN tipodemascota
WHERE tip_Denominacion = 'Perro';



-- GATOS EN ADOPCION
SELECT mas_ID ,tip_Denominacion ,mas_Color ,
mas_Sexo ,mas_Descripcion ,mas_Foto 
FROM
(SELECT * FROM
(SELECT * FROM
(SELECT mas_ID
FROM mascota) AS aliasA
WHERE mas_id
NOT IN
(SELECT mas_ID
FROM aplica
NATURAL JOIN adopcion)) AS aliasC
NATURAL JOIN mascota) AS aliasD
NATURAL JOIN tipodemascota
WHERE tip_Denominacion = 'Gato';



-- HAMSTERS EN ADOPCION
SELECT mas_ID ,tip_Denominacion ,mas_Color ,
mas_Sexo ,mas_Descripcion ,mas_Foto 
FROM
(SELECT * FROM
(SELECT * FROM
(SELECT mas_ID
FROM mascota) AS aliasA
WHERE mas_id
NOT IN
(SELECT mas_ID
FROM aplica
NATURAL JOIN adopcion)) AS aliasC
NATURAL JOIN mascota) AS aliasD
NATURAL JOIN tipodemascota
WHERE tip_Denominacion = 'Hamster';



-- LOROS EN ADOPCION
SELECT mas_ID ,tip_Denominacion ,mas_Color ,
mas_Sexo ,mas_Descripcion ,mas_Foto 
FROM
(SELECT * FROM
(SELECT * FROM
(SELECT mas_ID
FROM mascota) AS aliasA
WHERE mas_id
NOT IN
(SELECT mas_ID
FROM aplica
NATURAL JOIN adopcion)) AS aliasC
NATURAL JOIN mascota) AS aliasD
NATURAL JOIN tipodemascota
WHERE tip_Denominacion = 'Loro';



-- CONEJOS EN ADOPCION
SELECT mas_ID ,tip_Denominacion ,mas_Color ,
mas_Sexo ,mas_Descripcion ,mas_Foto 
FROM
(SELECT * FROM
(SELECT * FROM
(SELECT mas_ID
FROM mascota) AS aliasA
WHERE mas_id
NOT IN
(SELECT mas_ID
FROM aplica
NATURAL JOIN adopcion)) AS aliasC
NATURAL JOIN mascota) AS aliasD
NATURAL JOIN tipodemascota
WHERE tip_Denominacion = 'Conejo';



-- PECES EN ADOPCION
SELECT mas_ID ,tip_Denominacion ,mas_Color ,
mas_Sexo ,mas_Descripcion ,mas_Foto 
FROM
(SELECT * FROM
(SELECT * FROM
(SELECT mas_ID
FROM mascota) AS aliasA
WHERE mas_id
NOT IN
(SELECT mas_ID
FROM aplica
NATURAL JOIN adopcion)) AS aliasC
NATURAL JOIN mascota) AS aliasD
NATURAL JOIN tipodemascota
WHERE tip_Denominacion = 'Pez';



-- MACHOS EN ADOPCION
SELECT mas_ID ,tip_Denominacion ,mas_Color ,
mas_Sexo ,mas_Descripcion ,mas_Foto 
FROM
(SELECT * FROM
(SELECT * FROM
(SELECT mas_ID
FROM mascota) AS aliasA
WHERE mas_id
NOT IN
(SELECT mas_ID
FROM aplica
NATURAL JOIN adopcion)) AS aliasC
NATURAL JOIN mascota) AS aliasD
NATURAL JOIN tipodemascota
WHERE mas_Sexo IN ('Macho');



-- HEMBRAS EN ADOPCION
SELECT mas_ID ,tip_Denominacion ,mas_Color ,
mas_Sexo ,mas_Descripcion ,mas_Foto 
FROM
(SELECT * FROM
(SELECT * FROM
(SELECT mas_ID
FROM mascota) AS aliasA
WHERE mas_id
NOT IN
(SELECT mas_ID
FROM aplica
NATURAL JOIN adopcion)) AS aliasC
NATURAL JOIN mascota) AS aliasD
NATURAL JOIN tipodemascota
WHERE mas_Sexo IN ('Hembra');



-- TODOS LOS EMPLEADOS
SELECT * 
FROM empleado
NATURAL JOIN funcion;



-- EMPLEADOS VIGILANTES
SELECT *
FROM empleado
NATURAL JOIN funcion
WHERE fun_tipo = 'Vigilancia';



-- EMPLEADOS PSICOLOGOS
SELECT *
FROM empleado
NATURAL JOIN funcion
WHERE fun_tipo = 'Psicólogo';



-- EMPLEADOS PUBLICISTAS
SELECT *
FROM empleado
NATURAL JOIN funcion
WHERE fun_tipo = 'Publicista';



-- EMPLEADOS VETERINARIOS
SELECT *
FROM empleado
NATURAL JOIN funcion
WHERE fun_tipo = 'Veterinario';



-- EMPLEADOS CONTADORES
SELECT *
FROM empleado
NATURAL JOIN funcion
WHERE fun_tipo = 'Contador';



-- EMPLEADOS RESCATISTAS
SELECT *
FROM empleado
NATURAL JOIN funcion
WHERE fun_tipo = 'Rescatista';



-- CANDIDATOS APTOS
SELECT *
FROM candidato
WHERE can_Estado = 'Apto';



-- CANDIDATOS NO APTOS
SELECT *
FROM candidato
WHERE can_Estado = 'No Apto';



-- TODOS LOS CONTRIBUIDORES Y DONACIONES
SELECT *
FROM donacion
NATURAL JOIN
contribuidor;



-- EMPLEADOS CON PAGOS ADICIONALES
SELECT *
FROM empleado
NATURAL JOIN
(SELECT * 
FROM pagoempleado
NATURAL JOIN pagoadicionalempleado) AS aliasA;



-- SALDO DE SALVANDO VIDAS
SELECT SUM(eco_Total) AS Saldo
FROM economia;



-- SUELDO SEGÚN FUNCIÓN
SELECT fun_Tipo, fun_Pago
FROM funcion;



-- INFORMACIÓN BÁSICA DE APLICACIONES QUE NO SON ADOPCIONES
SELECT apl_ID, apl_FechaAplicacion, can_Nombre, can_Apellido, mas_Foto FROM
(SELECT aliasA.apl_ID FROM
(SELECT *
FROM aplica) AS aliasA
LEFT JOIN 
(SELECT *
FROM adopcion) AS aliasB
ON aliasA.apl_ID = aliasB.apl_ID
WHERE ado_ID IS NULL) AS aliasC
NATURAL JOIN candidato
NATURAL JOIN  mascota
NATURAL JOIN aplica;


-- ********CONSULTAS NUEVAS************


-- CANTIDAD DE MASCOTAS NO ADOPTADAS QUE SON HEMBRAS
SELECT COUNT(*) AS HembrasParaAdoptar FROM
(SELECT * FROM
(SELECT mas_ID
FROM mascota
WHERE mas_ID 
NOT IN
(SELECT mas_ID
FROM aplica
NATURAL JOIN 
adopcion)) AS aliasA
NATURAL JOIN
mascota) AS aliasB
NATURAL JOIN
tipodemascota
WHERE mas_Sexo
IN ('Hembra');



-- CANTIDAD DE MASCOTAS NO ADOPTADAS QUE SON MACHOS
SELECT COUNT(*) AS MachosParaAdoptar FROM
(SELECT * FROM
(SELECT mas_ID
FROM mascota
WHERE mas_ID 
NOT IN
(SELECT mas_ID
FROM aplica
NATURAL JOIN 
adopcion)) AS aliasA
NATURAL JOIN
mascota) AS aliasB
NATURAL JOIN
tipodemascota
WHERE mas_Sexo
IN ('Macho');



-- INFORMACIÓN DE CADA MASCOTA QUE QUIERE SER ADOPTADA JUNTO CON LA CANTIDAD DE CANDIDATOS
SELECT mas_ID, COUNT(*) AS NumeroCandidatos, apl_FechaAplicacion, tip_ID, mas_Color,
mas_Sexo, mas_Descripcion, mas_Foto
FROM aplica
NATURAL JOIN mascota
GROUP BY mas_ID;



-- INFORMACIÓN DE LAS MASCOTAS QUE TIENEN MAS DE UN CANDIDATOS
SELECT mas_ID, COUNT(*) AS NumeroCandidatos, apl_FechaAplicacion, tip_ID, mas_Color,
mas_Sexo, mas_Descripcion, mas_Foto
FROM aplica
NATURAL JOIN mascota
GROUP BY mas_ID
HAVING COUNT(*) >1;



-- EGRESOS TOTALES VS INGRESOS
SELECT * FROM
((SELECT SUM(pag_Total) AS EgresosTotales FROM pagoempleado) AS ALIASA
JOIN
(SELECT SUM(don_Valor) AS IngresosTotales FROM donacion)AS ALIASB)

