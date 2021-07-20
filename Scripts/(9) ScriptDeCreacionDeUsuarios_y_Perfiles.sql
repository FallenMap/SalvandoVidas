-- Creacion de perfiles
DROP ROLE IF EXISTS Administrador;
DROP ROLE IF EXISTS Publicista;
DROP ROLE IF EXISTS Psicologo;
DROP ROLE IF EXISTS Contador;
DROP ROLE IF EXISTS Veterinario;
DROP ROLE IF EXISTS Candidato;
DROP ROLE IF EXISTS Invitado;
DROP ROLE IF EXISTS Rescatista;

CREATE ROLE Administrador;
CREATE ROLE Publicista;
CREATE ROLE Psicologo;
CREATE ROLE Contador;
CREATE ROLE Veterinario;
CREATE ROLE Candidato;
CREATE ROLE Invitado;
CREATE ROLE Rescatista;

-- Asignación de permisos a perfiles

-- Permisos de perfil Administrador
GRANT ALL PRIVILEGES ON SalvandoVidas.* TO Administrador;

-- Permisos de perfil Publicista
GRANT SELECT 			ON SalvandoVidas.Mascota 			TO Publicista;
GRANT SELECT 			ON SalvandoVidas.TipoDeMascota		TO Publicista;
GRANT ALL PRIVILEGES 	ON SalvandoVidas.Candidato 			TO Publicista;
GRANT SELECT 			ON SalvandoVidas.Adopcion 			TO Publicista;
GRANT ALL PRIVILEGES 	ON SalvandoVidas.Aplica 			TO Publicista;
GRANT ALL PRIVILEGES 	ON SalvandoVidas.Contribuidor 		TO Publicista;
GRANT SELECT 			ON SalvandoVidas.vw_NoAdopt 		TO Publicista;
GRANT SELECT 			ON SalvandoVidas.vw_Horario 		TO Publicista;
GRANT EXECUTE			ON  SalvandoVidas.* 				TO Publicista;
-- Permisos de perfil Psicólogo
GRANT SELECT 			ON SalvandoVidas.Candidato 		TO Psicologo;
GRANT SELECT, UPDATE	ON SalvandoVidas.vw_Aptitud		TO Psicologo;
GRANT SELECT 			ON SalvandoVidas.vw_Horario		TO Psicologo;
GRANT EXECUTE			ON  SalvandoVidas.* 			TO Psicologo;
-- Permisos de perfil Contador
GRANT SELECT 			ON SalvandoVidas.Empleado 						TO Contador;
GRANT SELECT 			ON SalvandoVidas.Candidato						TO Contador;
GRANT ALL PRIVILEGES 	ON SalvandoVidas.Contribuidor					TO Contador;
GRANT ALL PRIVILEGES	ON SalvandoVidas.Donacion						TO Contador;
GRANT ALL PRIVILEGES 	ON SalvandoVidas.PagoEmpleado					TO Contador;
GRANT ALL PRIVILEGES 	ON SalvandoVidas.PagoAdicionalEmpleado			TO Contador;
GRANT ALL PRIVILEGES	ON SalvandoVidas.Economia						TO Contador;
GRANT SELECT 			ON SalvandoVidas.vw_Horario						TO Contador;
GRANT EXECUTE			ON  SalvandoVidas.* 							TO Contador;
-- Permisos de perfil Veterinario
GRANT ALL PRIVILEGES 	ON SalvandoVidas.Mascota 						TO Veterinario;
GRANT ALL PRIVILEGES 	ON SalvandoVidas.TipoDeMascota 					TO Veterinario;
GRANT SELECT 			ON SalvandoVidas.Candidato 						TO Veterinario;
GRANT ALL PRIVILEGES	ON SalvandoVidas.Adopcion 						TO Veterinario;
GRANT ALL PRIVILEGES 	ON SalvandoVidas.Aplica 						TO Veterinario;
GRANT SELECT		 	ON SalvandoVidas.vw_NoAdopt 					TO Veterinario;
GRANT SELECT 			ON SalvandoVidas.vw_Horario 					TO Veterinario;
GRANT EXECUTE			ON  SalvandoVidas.* 							TO Veterinario;
-- Permisos de perfil Candidato
GRANT SELECT 			ON SalvandoVidas.Candidato 						TO Candidato;
GRANT SELECT 			ON SalvandoVidas.Adopcion 						TO Candidato;
GRANT SELECT 			ON SalvandoVidas.Aplica							TO Candidato;
GRANT SELECT 			ON SalvandoVidas.vw_NoAdopt 					TO Candidato;

-- Permisos de perfil Invitado
GRANT SELECT 			ON SalvandoVidas.vw_NoAdopt 					TO Invitado;

-- Permisos de perfil Rescatista
GRANT ALL PRIVILEGES 	ON SalvandoVidas.Mascota 						TO Rescatista;
GRANT SELECT 			ON SalvandoVidas.TipoDeMascota 					TO Rescatista;
GRANT SELECT		 	ON SalvandoVidas.vw_NoAdopt 					TO Rescatista;
GRANT SELECT 			ON SalvandoVidas.vw_Horario 					TO Rescatista;
GRANT EXECUTE			ON  SalvandoVidas.* 							TO Rescatista;
-- Creación de usuarios
DROP USER IF EXISTS 'admin'@'localhost', 'Anonimo'@'localhost';
DROP USER IF EXISTS 'ANaranjo'@'localhost', 'MGarzon'@'localhost', 'FCastañeda'@'localhost', 'CCorrea'@'localhost', 'MGutierrez'@'localhost', 'BParra'@'localhost', 'CSandoval'@'localhost';
DROP USER IF EXISTS 'LDiaz'@'localhost', 'FCaro'@'localhost', 'APerez'@'localhost', 'LGarcia'@'localhost';
DROP USER IF EXISTS 'VSuarez'@'localhost', 'SRamirez'@'localhost', 'RPeña'@'localhost', 'JPelaez'@'localhost', 'VPinzon'@'localhost', 'MAlvarez'@'localhost';
-- Administrador
CREATE USER 'admin'@'localhost' IDENTIFIED BY '12345';

-- Usuarios empleados
CREATE USER 'ANaranjo'@'localhost' 		IDENTIFIED BY '12345';
CREATE USER 'MGarzon'@'localhost' 		IDENTIFIED BY '12345';
CREATE USER 'FCastañeda'@'localhost' 	IDENTIFIED BY '12345';
CREATE USER 'CCorrea'@'localhost' 		IDENTIFIED BY '12345';
CREATE USER 'MGutierrez'@'localhost' 	IDENTIFIED BY '12345';
CREATE USER 'BParra'@'localhost' 		IDENTIFIED BY '12345';
CREATE USER 'CSandoval'@'localhost' 	IDENTIFIED BY '12345';

-- Usuarios Candidatos
CREATE USER 'LDiaz'@'localhost' 		IDENTIFIED BY '12345';
CREATE USER 'FCaro'@'localhost' 		IDENTIFIED BY '12345';
CREATE USER 'APerez'@'localhost' 		IDENTIFIED BY '12345';
CREATE USER 'LGarcia'@'localhost' 		IDENTIFIED BY '12345';
CREATE USER 'VSuarez'@'localhost' 		IDENTIFIED BY '12345';
CREATE USER 'SRamirez'@'localhost' 		IDENTIFIED BY '12345';
CREATE USER 'RPeña'@'localhost' 		IDENTIFIED BY '12345';
CREATE USER 'JPelaez'@'localhost' 		IDENTIFIED BY '12345';
CREATE USER 'VPinzon'@'localhost' 		IDENTIFIED BY '12345';
CREATE USER 'MAlvarez'@'localhost' 		IDENTIFIED BY '12345';

-- Usuario Invitado
CREATE USER 'Anonimo'@'localhost' 		IDENTIFIED BY '12345';

-- Asignación de perfiles a usuarios
GRANT Administrador TO 'admin'@'localhost';
GRANT Publicista 	TO 'FCastañeda'@'localhost';
GRANT Psicologo 	TO 'MGarzon'@'localhost', 'BParra'@'localhost'; 
GRANT Contador 		TO 'ANaranjo'@'localhost';
GRANT Veterinario 	TO 'CCorrea'@'localhost', 'MGutierrez'@'localhost';
GRANT Rescatista 	TO 'CSandoval'@'localhost';
GRANT Candidato 	TO 'LDiaz'@'localhost', 'FCaro'@'localhost', 'APerez'@'localhost', 'LGarcia'@'localhost';
GRANT Candidato 	TO 'VSuarez'@'localhost', 'SRamirez'@'localhost', 'RPeña'@'localhost', 'JPelaez'@'localhost', 'VPinzon'@'localhost', 'MAlvarez'@'localhost';
GRANT Invitado 		TO 'Anonimo'@'localhost';

FLUSH PRIVILEGES;