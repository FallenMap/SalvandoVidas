-- Script de creación de Indices

-- Se crea un indice en el color de la mascota 
-- Los candidatos a adopción suelen estar muy interesados en el color de su mascota
CREATE INDEX indic_MascotaColor ON Mascota(mas_color);

-- Se crea un indice en el sexo de la mascota
-- Los candidatos a adopción suelen estar interesados en el sexo de su mascota
CREATE INDEX indic_MascotaSexo  ON Mascota(mas_sexo);

-- Se crea indice en la fecha de aplicación
-- Puede ser de utilidad para la ONG ver las aplicaciones a adopcion de acuerdo a una fecha
CREATE INDEX indic_AplicaFecha  ON Aplica(apl_FechaAplicacion);

-- Se crea indice en la fecha de adopcion
-- Puede ser de utilidad para la ONG ver las adopciones de acuerdo a una fecha
CREATE INDEX indic_AdopcionFecha  ON Adopcion(ado_Fecha);

-- Se crea indice en la fecha de donacion
-- Puede ser de utilidad para la ONG ver las donaciones de acuerdo a una fecha
CREATE INDEX indic_DonacionFecha  ON Donacion(don_Fecha);