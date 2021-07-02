-- ------------------------------------------------------------------------------------
-- Procedimientos relacionados a actualizaciones y borrados

-- procedimiento upgrade mascota
drop procedure if exists proc_up_mascota;
DELIMITER $$
create procedure proc_up_mascota(
	in id 				int,
    in tipo_id 			int,
    in color 			varchar(20),
    in sexo 			varchar(20),
    in descripcion		varchar(200),
    in foto 			blob
)
begin
	declare existe_id int;
	declare existe_tip int;
    select count(*) into existe_id from mascota where mas_ID = id;
    select count(*) into existe_tip from tipodemascota where tip_ID = tipo_id;
    if existe_id = 1 then
		if existe_tip = 1 then
			update mascota set tip_ID = tipo_id where mas_ID = id;
		end if;
		if color != '' then
			update mascota set mas_Color = color where mas_ID = id;
		end if;
		if sexo = 'Macho' or sexo = 'Hembra' then
			update mascota set mas_Sexo = sexo where mas_ID = id;
		end if;    
		if descripcion != '' then
			update mascota set mas_Descripcion = descripcion where mas_ID = id;
		end if;     
		if foto is not null then
			update mascota set mas_Foto = foto where mas_ID = id;
		end if;
	end if;
end; $$
DELIMITER ;

-- Procedimiento delete mascota 
drop procedure if exists proc_del_mascota;
DELIMITER $$
create procedure proc_del_mascota(in id int)
begin
	delete from mascota where mas_ID = id;
end; $$
DELIMITER ;

-- procedimiento upgrade tipodemascota
drop procedure if exists proc_up_tipodemascota;
DELIMITER $$
create procedure proc_up_tipodemascota(
	in id 				int,
    in habitat 			varchar(20),
    in denominacion 	varchar(20),
    in generalidades 	varchar(200),
    in alimento 		varchar(20),
    in foto 			blob
)
begin
	declare existe_id int;
    select count(*) into existe_id from tipodemascota where tip_ID = id;
    if existe_id = 1 then
		if habitat != '' then
			update tipodemascota set tip_Habitat = habitat where tip_ID = id;
		end if;
        if denominacion != '' then
			update tipodemascota set tip_Denominacion = denominacion where tip_ID = id;
		end if;  
		if generalidades != '' then
			update tipodemascota set tip_Generalidades = generalidades where tip_ID = id;
		end if;    
		if alimento != '' then
			update tipodemascota set tip_Alimento = alimento where tip_ID = id;
		end if;     
		if foto is not null then
			update tipodemascota set tip_Foto = foto where tip_ID = id;
		end if;
	end if;
end; $$
DELIMITER ;

-- Procedimiento delete tipodemascota 
drop procedure if exists proc_del_tipodemascota;
DELIMITER $$
create procedure proc_del_tipodemascota(in id int)
begin
	delete from tipodemascota where tip_ID = id;
end; $$
DELIMITER ;

-- procedimiento upgrade candidato
drop procedure if exists proc_up_candidato;
DELIMITER $$
create procedure proc_up_candidato(
    in id 			int,
    in documento 	varchar(10),
    in nombre 		varchar(20),
    in apellido 	varchar(20),
    in fecha 		date,
    in residencia 	varchar(45),
    in ingreso 		decimal(10,0),
    in estado 		varchar(11)
)
begin
    declare existe_id int;
    select count(*) into existe_id from candidato where can_ID = id;
    if existe_id = 1 then
		if documento != '' then
			update candidato set can_Documento = documento where can_ID = id;
		end if;
		if nombre != '' then
			update candidato set can_Nombre = nombre where can_ID = id;
		end if;
		if apellido != '' then
			update candidato set can_Apellido = apellido where can_ID = id;
		end if;  
        if fecha is not null then
			update candidato set can_Fecha = fecha where can_ID = id;
		end if;  
		if residencia != '' then
			update candidato set can_Residencia = residencia where can_ID = id;
		end if;     
		if ingreso > 0 then
			update candidato set can_Ingreso = ingreso where can_ID = id;
		end if;
		if estado is not null then
			update candidato set can_Estado = estado where can_ID = id;
		end if;  
	end if;
end; $$
DELIMITER ;

-- Procedimiento delete candidato 
drop procedure if exists proc_del_candidato;
DELIMITER $$
create procedure proc_del_candidato(in id int)
begin
	delete from candidato where can_ID = id;
end; $$
DELIMITER ;

-- Procedimiento delete candidatos no aptos
drop procedure if exists proc_del_candidato_no_apto;
DELIMITER $$
create procedure proc_del_candidato_no_apto()
begin
	delete from candidato where can_Estado = 'No apto';
end; $$
DELIMITER ;

-- procedimiento upgrade adopcion
drop procedure if exists proc_up_adopcion;
DELIMITER $$
create procedure proc_up_adopcion(
    in id 			int,
    in aplicacion_id 		int,
    in empleado_id 		int,
    in fecha 			date	
)
begin
    declare existe_id int;
    select count(*) into existe_id from adopcion where ado_ID = id;
    if existe_id = 1 then
		if aplicacion_id is not null then
			update adopcion set apl_ID = aplicacion_id where ado_ID = id;
		end if;
		if empleado_id is not null then
			update adopcion set emp_ID = empleado_id where ado_ID = id;
		end if;
		if fecha is not null then
			update adopcion set ado_Fecha = fecha where ado_ID = id;
		end if;  
    end if;
end; $$
DELIMITER ;

-- Procedimiento delete adopcion
drop procedure if exists proc_del_adopcion;
DELIMITER $$
create procedure proc_del_adopcion(in id int)
begin
	delete from adopcion where ado_ID = id;
end; $$
DELIMITER ;

-- procedimiento upgrade aplica
drop procedure if exists proc_up_aplica;
DELIMITER $$
create procedure proc_up_aplica(
    in id 			int,
    in candidato_id 		int,
    in mascota_id 		int,
    in fecha 			date	
)
begin
    declare existe_id int;
    select count(*) into existe_id from aplica where apl_ID = id;
    if existe_id = 1 then
		if candidato_id is not null then
			update aplica set can_ID = candidato_id where apl_ID = id;
		end if;
		if mascota_id is not null then
			update aplica set mas_ID = mascota_id where apl_ID = id;
		end if;
		if fecha is not null then
			update aplica set apl_FechaAplicacion = fecha where apl_ID = id;
		end if;  
    end if;
end; $$
DELIMITER ;

-- Procedimiento delete aplica
drop procedure if exists proc_del_aplica;
DELIMITER $$
create procedure proc_del_aplica(in id int)
begin
	delete from aplica where apl_ID = id;
end; $$
DELIMITER ;

-- procedimiento upgrade contribuidor
drop procedure if exists proc_up_contribuidor;
DELIMITER $$
create procedure proc_up_contribuidor(
    in id 				int,
    in documento 		varchar(10),
    in nombre 			varchar(20),
    in apellido 		varchar(20),
    in fecha 			date,	
    in labor			varchar(30),
    in foto 			blob
)
begin
    declare existe_id int;
    select count(*) into existe_id from contribuidor where con_ID = id;
    if existe_id = 1 then
		if documento is not null then
			update contribuidor set con_Documento = documento where con_ID = id;
		end if;
		if nombre is not null then
			update contribuidor set con_Nombre = nombre where con_ID = id;
		end if;
		if apellido is not null then
			update contribuidor set con_Apellido = apellido where con_ID = id;
		end if;  
		if fecha is not null then
			update contribuidor set con_Fecha = fecha where con_ID = id;
		end if;  
		if labor is not null then
			update contribuidor set con_Labor = labor where con_ID = id;
		end if;    
		if foto is not null then
			update contribuidor set con_Foto = foto where con_ID = id;
		end if;
	end if;
end; $$
DELIMITER ;

-- Procedimiento delete contribuidor
drop procedure if exists proc_del_contribuidor;
DELIMITER $$
create procedure proc_del_contribuidor(in id int)
begin
	delete from contribuidor where con_ID = id;
end; $$
DELIMITER ;

-- procedimiento upgrade donacion
drop procedure if exists proc_up_donacion;
DELIMITER $$
create procedure proc_up_donacion(
    in id 			char(6),
    in valor 			decimal(10,0),
    in lugar 			varchar(20),
    in contribuidor_id 		int,
    in fecha 			date
)
begin
    declare existe_id int;
    select count(*) into existe_id from donacion where don_Numero = id;
    if existe_id = 1 then
		if valor is not null then
			update donacion set don_Valor = valor where don_Numero = id;
		end if;
		if lugar is not null then
			update donacion set don_Lugar = lugar where don_Numero = id;
		end if;
		if contribuidor_id is not null then
			update donacion set con_ID = contribuidor_id where don_Numero = id;
		end if;  
		if fecha is not null then
			update donacion set don_Fecha = fecha where don_Numero = id;
		end if;  
	end if;
end; $$
DELIMITER ;

-- Procedimiento delete donacion
drop procedure if exists proc_del_donacion;
DELIMITER $$
create procedure proc_del_donacion(in id char(6))
begin
	delete from donacion where don_Numero = id;
end; $$
DELIMITER ;

-- procedimiento upgrade pagoempleado
drop procedure if exists proc_up_pagoempleado;
DELIMITER $$
create procedure proc_up_pagoempleado(
    in id 			char(7),
    in empleado_id 		int,
    in pagoadicionalempleado_id int,
    in total 			decimal(10,0),
    in fecha 			date
)
begin
    declare existe_id int;
    select count(*) into existe_id from pagoempleado where pag_Numero = id;
    if existe_id = 1 then
		if empleado_id is not null then
			update pagoempleado set emp_ID = empleado_id where pag_Numero = id;
		end if;
		if pagoadicionalempleado_id is not null then
			update pagoempleado set pad_ID = pagoadicionalempleado_id where pag_Numero = id;
		end if;
		if total is not null then
			update pagoempleado set pag_Total = total where pag_Numero = id;
		end if;  
		if fecha is not null then
			update pagoempleado set pag_Fecha = fecha where pag_Numero = id;
		end if;  
	end if;
end; $$
DELIMITER ;

-- Procedimiento delete pagoempleado
drop procedure if exists proc_del_pagoempleado;
DELIMITER $$
create procedure proc_del_pagoempleado(in id char(7))
begin
	delete from pagoempleado where pag_Numero = id;
end; $$
DELIMITER ;

-- procedimiento upgrade pagoadicionalempleado
drop procedure if exists proc_up_pagoadicionalempleado;
DELIMITER $$
create procedure proc_up_pagoadicionalempleado(
    in id 			int,
    in valor 			decimal(10,0),
    in descripcion 		varchar(200)
)
begin
    declare existe_id int;
    select count(*) into existe_id from pagoadicionalempleado where pad_ID = id;
    if existe_id = 1 then
		if valor is not null then
			update pagoadicionalempleado set pad_Valor = valor where pad_ID = id;
		end if;
		if descripcion is not null then
			update pagoadicionalempleado set pad_Descripción = descripcion where pad_ID = id;
		end if;
	end if;
end; $$
DELIMITER ;

-- Procedimiento delete pagoadicionalempleado
drop procedure if exists proc_del_pagoadicionalempleado;
DELIMITER $$
create procedure proc_del_pagoadicionalempleado(in id int)
begin
	delete from pagoadicionalempleado where pad_ID = id;
end; $$
DELIMITER ;

-- procedimiento upgrade Economia
drop procedure if exists proc_up_economia;
DELIMITER $$
create procedure proc_up_economia(
    in id 			int,
    in donacion 	char(6),
    in pago			char(7),
    in total 		decimal(10,0),
    in fecha 		date
)
begin
    declare existe_id int;
    select count(*) into existe_id from economia where eco_ID = id;
    if existe_id = 1 then
		if donacion != '' then
			update economia set don_Numero = donacion where eco_ID = id;
		end if;
        if pago != '' then
			update economia set pag_Numero = pago where eco_ID = id;
		end if;
        if total is not null then
			update economia set eco_Total = total where eco_ID = id;
		end if;
		if fecha is not null then
			update economia set eco_Fecha = fecha where eco_ID = id;
		end if;  
	end if;
end; $$
DELIMITER ;

-- Procedimiento delete pagoadicionalempleado
drop procedure if exists proc_del_economia;
DELIMITER $$
create procedure proc_del_economia(in id int)
begin
	delete from economia where eco_ID = id;
end; $$
DELIMITER ;

-- procedimiento upgrade vw_Aptitud
drop procedure if exists proc_up_vw_aptitud;
DELIMITER $$
create procedure proc_up_vw_aptitud(
    in id 			int,
    in estado 		varchar(11)
)
begin
    declare existe_id int;
    select count(*) into existe_id from vw_aptitud where can_ID = id;
    if existe_id = 1 then
		if estado = 'Aplica' or estado = 'No aplica' or estado = 'No evaluado' then
			update vw_aptitud set can_Estado = estado where can_ID = id;
		end if;  
	end if;
end; $$
DELIMITER ;

-- Procedimiento delete vw_aptitud
drop procedure if exists proc_del_vw_aptitud;
DELIMITER $$
create procedure proc_del_vw_aptitud(in id int)
begin
	delete from vw_aptitud where can_ID = id;
end; $$
DELIMITER ;

-- ------------------------------------------------------------------------------------
-- Procedimientos relacionados a consultas

-- Procedimiento consulta mascotas por denominacion
drop procedure if exists proc_cons_denominacion_mas_enadopcion;
DELIMITER $$
create procedure proc_cons_denominacion_mas_enadopcion(in denominacion varchar(20))
begin
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
	WHERE tip_Denominacion = denominacion;
end; $$
DELIMITER ;

-- Procedimiento consulta mascotas por sexo
drop procedure if exists proc_cons_sexo_mas_enadopcion;
DELIMITER $$
create procedure proc_cons_sexo_mas_enadopcion(in sexo varchar(20))
begin
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
	WHERE mas_Sexo IN (sexo);
end; $$
DELIMITER ;

-- Procedimiento consulta empleado por profesion
drop procedure if exists proc_cons_empleado;
DELIMITER $$
create procedure proc_cons_empleado(in profesion varchar(20))
begin
SELECT *
FROM empleado
NATURAL JOIN funcion
WHERE fun_tipo = profesion;
end; $$
DELIMITER ;

-- Procedimiento consulta aptitud candidatos
drop procedure if exists proc_cons_aptitud_candidato;
DELIMITER $$
create procedure proc_cons_aptitud_candidato(in estado varchar(11))
begin
SELECT *
FROM candidato
WHERE can_Estado = estado;
end; $$
DELIMITER ;

-- ----------------------------------------------------------------------
-- Funciones relacionadas con consultas
SET GLOBAL log_bin_trust_function_creators = 1;

-- Funcion que devuelve el saldo total
drop function if exists fun_saldo;
DELIMITER $$
create function fun_saldo() returns int
begin
declare total int;
SELECT SUM(eco_Total) into total
FROM economia;
return total;
end; $$
DELIMITER ;

-- Funcion que devuelve la cantidad de mascotas por sexo
drop  function if exists fun_cantidad_mascotas_sexo;
DELIMITER $$
create function fun_cantidad_mascotas_sexo(sexo varchar(20)) returns int
begin
	declare cantidad int;
	SELECT COUNT(*) into cantidad FROM
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
	IN (sexo);
    return cantidad;
end; $$
DELIMITER ;
