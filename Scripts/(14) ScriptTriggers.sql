-- TipoDeMascota (No tiene FK)

ALTER TABLE tipodemascota
ADD CONSTRAINT
CHECK (tip_Habitat IN ('Agua','Aire','Tierra'));

-- Mascota

ALTER TABLE mascota
DROP CONSTRAINT mascota_ibfk_1;

ALTER TABLE mascota
ADD CONSTRAINT 
FOREIGN KEY (tip_ID) REFERENCES tipodemascota (tip_ID) 
ON DELETE CASCADE 
ON UPDATE CASCADE;

ALTER TABLE mascota
ADD CONSTRAINT
CHECK (mas_Sexo IN ('Macho', 'Hembra'));

-- Aplica

ALTER TABLE aplica
DROP CONSTRAINT aplica_ibfk_1,
DROP CONSTRAINT aplica_ibfk_2;

ALTER TABLE aplica
ADD CONSTRAINT
FOREIGN KEY (can_ID) REFERENCES candidato (can_ID)
ON DELETE CASCADE
ON UPDATE CASCADE,
ADD CONSTRAINT
FOREIGN KEY (mas_ID) REFERENCES mascota (mas_ID)
ON DELETE CASCADE
ON UPDATE CASCADE;

DROP TRIGGER IF EXISTS tr_aplica_fecha;
DELIMITER |
CREATE TRIGGER tr_aplica_fecha BEFORE INSERT ON aplica
	FOR EACH ROW
    BEGIN
		IF NEW.apl_FechaAplicacion != CURDATE() THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'apl_FechaAplicacion DEBE SER UNA FECHA IGUAL A LA ACTUAL';
		ELSEIF NEW.can_ID NOT IN (SELECT can_ID FROM candidato WHERE can_Estado = 'Apto') THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'SE ELIGIÓ UN CANDIDATO NO APTO O NO EVALUADO';
        END IF;
    END |
DELIMITER ;

-- Candidato (No tiene FK)

ALTER TABLE candidato
ADD CONSTRAINT
CHECK (can_Estado IN ('Apto', 'No Apto', 'No evaluado'));

DROP TRIGGER IF EXISTS tr_candidato_fecha;
DELIMITER |
CREATE TRIGGER tr_candidato_fecha BEFORE INSERT ON candidato
	FOR EACH ROW
    BEGIN
		IF TIMESTAMPDIFF(YEAR, NEW.can_Fecha, CURDATE()) < 18 THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'DEBES SER MAYOR DE EDAD';
        END IF;
    END |
DELIMITER ;

-- Adopcion

ALTER TABLE adopcion
DROP CONSTRAINT adopcion_ibfk_1,
DROP CONSTRAINT adopcion_ibfk_2;

ALTER TABLE adopcion
ADD CONSTRAINT
FOREIGN KEY (apl_ID) REFERENCES aplica (apl_ID)
ON DELETE CASCADE
ON UPDATE CASCADE,
ADD CONSTRAINT
FOREIGN KEY (emp_ID) REFERENCES empleado (emp_ID)
ON DELETE CASCADE
ON UPDATE CASCADE;

DROP TRIGGER IF EXISTS tr_adopcion_fecha;
DELIMITER |
CREATE TRIGGER tr_adopcion_fecha BEFORE INSERT ON adopcion
	FOR EACH ROW
    BEGIN
		IF NEW.ado_Fecha != CURDATE() THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ado_Fecha DEBE SER UNA FECHA IGUAL A LA ACTUAL';
        END IF;
    END |
DELIMITER ;

-- Empleado

ALTER TABLE empleado
DROP CONSTRAINT empleado_ibfk_1;

ALTER TABLE empleado
ADD CONSTRAINT
FOREIGN KEY (fun_ID) REFERENCES funcion (fun_ID)
ON DELETE CASCADE
ON UPDATE CASCADE;

DROP TRIGGER IF EXISTS tr_empleado_fecha;
DELIMITER |
CREATE TRIGGER tr_empleado_fecha BEFORE INSERT ON empleado
	FOR EACH ROW
    BEGIN
		IF TIMESTAMPDIFF(YEAR, NEW.emp_Fecha, CURDATE()) < 18 THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'DEBES SER MAYOR DE EDAD';
        END IF;
    END |
DELIMITER ;

-- Funcion (No tiene FK)

-- PagoEmpleado

ALTER TABLE pagoempleado
DROP CONSTRAINT pagoempleado_ibfk_2;

ALTER TABLE pagoempleado
ADD CONSTRAINT
FOREIGN KEY (emp_ID) REFERENCES empleado (emp_ID)
ON DELETE CASCADE
ON UPDATE CASCADE;

DROP TRIGGER IF EXISTS tr_pagoempleado_binsert;
DELIMITER |
CREATE TRIGGER tr_pagoempleado_binsert BEFORE INSERT ON pagoempleado
	FOR EACH ROW
    BEGIN
		DECLARE pagoFuncion FLOAT DEFAULT 0.0;
        DECLARE pagoAdicional FLOAT DEFAULT 0.0;
        DECLARE pagoTotal FLOAT DEFAULT 0.0;
        
        IF NEW.pag_Fecha != CURDATE() THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'paf_Fecha DEBE SER UNA FECHA IGUAL A LA ACTUAL';
        END IF;
        
		SELECT fun_pago INTO pagoFuncion FROM funcion NATURAL JOIN Empleado WHERE emp_id = NEW.emp_ID;
        IF NEW.pad_ID IS NOT NULL THEN
			SELECT pad_valor INTO pagoAdicional FROM pagoadicionalempleado WHERE pad_ID = NEW.pad_ID;
        END IF;
        SET pagoTotal = pagoFuncion + pagoAdicional;
        
        SET NEW.pag_Total = pagoTotal;
    END |
DELIMITER ;

DROP TRIGGER IF EXISTS tr_pagoempleado_ainsert;
DELIMITER |
CREATE TRIGGER tr_pagoempleado_ainsert AFTER INSERT ON pagoempleado
	FOR EACH ROW
    BEGIN
		INSERT INTO economia VALUES (NULL,NULL, NEW.pag_numero,-NEW.pag_total, NEW.pag_fecha);
    END |
DELIMITER ;

DROP TRIGGER IF EXISTS tr_pagoempleado_aupdate;
DELIMITER |
CREATE TRIGGER tr_pagoempleado_aupdate BEFORE UPDATE ON pagoempleado
	FOR EACH ROW
    BEGIN 
    DECLARE pagoFuncion FLOAT DEFAULT 0.0;
	DECLARE pagoAdicional FLOAT DEFAULT 0.0;
	DECLARE pagoTotal FLOAT DEFAULT 0.0;
	SELECT fun_pago INTO pagoFuncion FROM funcion NATURAL JOIN Empleado WHERE emp_id = NEW.emp_ID;
        IF NEW.pad_ID IS NOT NULL THEN
			SELECT pad_valor INTO pagoAdicional FROM pagoadicionalempleado WHERE pad_ID = NEW.pad_ID;
        END IF;
        SET pagoTotal = pagoFuncion + pagoAdicional;
        
        SET NEW.pag_Total = pagoTotal;	
        UPDATE economia SET eco_total = -pagoTotal WHERE Economia.pag_Numero = OLD.pag_Numero;
    END |
DELIMITER ;

-- PagoAdicionalEmpleado (No tiene FK)

DROP TRIGGER IF EXISTS tr_pagoadicionalempleado_valor;
DELIMITER |
CREATE TRIGGER tr_pagoadicionalempleado_valor AFTER UPDATE ON pagoadicionalempleado
	FOR EACH ROW
    BEGIN 
		DECLARE diferencia FLOAT DEFAULT 0.0;
		IF NEW.pad_valor != OLD.pad_valor THEN
			SET diferencia = NEW.pad_valor - OLD.pad_valor;
			UPDATE pagoempleado SET pag_total = pag_total + diferencia WHERE pad_id = OLD.pad_id;
        END IF;
    END |
DELIMITER ;

-- Economia

ALTER TABLE economia
DROP CONSTRAINT economia_ibfk_1,
DROP CONSTRAINT economia_ibfk_2;

ALTER TABLE economia 
ADD CONSTRAINT
FOREIGN KEY (don_NUMERO) REFERENCES donacion (don_NUMERO)
ON DELETE CASCADE
ON UPDATE CASCADE,
ADD CONSTRAINT 
FOREIGN KEY (pag_Numero) REFERENCES pagoempleado (pag_Numero)
ON DELETE CASCADE
ON UPDATE CASCADE;

DROP TRIGGER IF EXISTS tr_economia_fecha;
DELIMITER |
CREATE TRIGGER tr_economia_fecha BEFORE INSERT ON economia
	FOR EACH ROW
    BEGIN
		IF NEW.eco_Fecha != CURDATE() THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'eco_Fecha DEBE SER UNA FECHA IGUAL A LA ACTUAL';
        END IF;
    END |
DELIMITER ;

-- Donacion

ALTER TABLE donacion
DROP CONSTRAINT donacion_ibfk_1;

ALTER TABLE donacion
ADD CONSTRAINT
FOREIGN KEY (con_ID) REFERENCES contribuidor (con_ID)
ON DELETE CASCADE
ON UPDATE CASCADE;

DROP TRIGGER IF EXISTS tr_donacion_binsert;
DELIMITER |
CREATE TRIGGER tr_donacion_binsert BEFORE INSERT ON donacion
	FOR EACH ROW
    BEGIN 
		IF NEW.don_Fecha != CURDATE() THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'don_Fecha DEBE SER UNA FECHA IGUAL A LA ACTUAL';
        END IF;
        
    END |
DELIMITER ;

DROP TRIGGER IF EXISTS tr_donacion_ainsert;
DELIMITER |
CREATE TRIGGER tr_donacion_ainsert AFTER INSERT ON donacion
	FOR EACH ROW
    BEGIN 
		INSERT INTO economia VALUES (NULL,NEW.don_numero,NULL, NEW.don_valor,NEW.don_fecha);
    END |
DELIMITER ;

DROP TRIGGER IF EXISTS tr_donacion_aupdate;
DELIMITER |
CREATE TRIGGER tr_donacion_aupdate AFTER UPDATE ON donacion
	FOR EACH ROW
    BEGIN
		UPDATE economia SET eco_total = NEW.don_valor WHERE don_numero = NEW.don_numero;
    END |
DELIMITER ;

-- Contribuidor (No tiene FK)

DROP TRIGGER IF EXISTS tr_contribuidor_fecha;
DELIMITER |
CREATE TRIGGER tr_contribuidor_fecha BEFORE INSERT ON contribuidor
	FOR EACH ROW
    BEGIN 
		IF TIMESTAMPDIFF(YEAR, NEW.con_Fecha, CURDATE()) < 18 THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'DEBES SER MAYOR DE EDAD';
        END IF;
    END |
DELIMITER ;