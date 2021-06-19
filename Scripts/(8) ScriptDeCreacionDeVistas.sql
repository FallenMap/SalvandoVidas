DROP VIEW IF EXISTS vw_Aptitud;
DROP VIEW IF EXISTS vw_NoAdopt;
DROP VIEW IF EXISTS vw_Horario;

-- PRIMERA VISTA
CREATE VIEW vw_Aptitud AS
	SELECT can_id, can_estado FROM candidato;



-- SEGUNDA VISTA
CREATE VIEW vw_NoAdopt AS
	SELECT mas_ID, tip_ID, mas_Color, mas_Sexo, 
	mas_Descripcion, mas_Foto
	FROM
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
	tipodemascota;


-- TERCERA VISTA
CREATE VIEW vw_Horario AS 
	SELECT emp_ID, fun_Tipo, fun_Descripción, fun_Horario1, fun_Horario2
	FROM funcion 
	NATURAL JOIN empleado;