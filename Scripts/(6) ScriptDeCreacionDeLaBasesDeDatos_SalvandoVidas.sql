drop database if exists SalvandoVidas;
create database SalvandoVidas;
use SalvandoVidas;


create table TipoDeMascota(
	  tip_ID 				INT 					NOT NULL AUTO_INCREMENT PRIMARY KEY,
	  tip_Habitat 			VARCHAR(20) 			NOT NULL,
      tip_Denominacion 		VARCHAR(20)				NOT NULL,
      tip_Generalidades 	VARCHAR(200) 			NOT NULL,
      tip_Alimento 			VARCHAR(20) 			NOT NULL,
      tip_Foto			 	BLOB 					NULL DEFAULT ('Por agregar')
);
insert into TipoDeMascota	(tip_Habitat,	tip_Denominacion,	tip_Generalidades,												tip_Alimento,	tip_Foto	)
values						('Tierra', 		'Perro', 			'Juguetones,cariñosos, divertidos, amigables y tiernos.', 		'Purinas',		'tip1.jpg'	),
							('Tierra', 		'Gato', 			'Independientes, tiernos, juguetones y dormilones.', 			'Purinas',		'tip2.jpg'	),
							('Agua', 		'Pez', 				'Tranquilos, Independientes, saludables y comelones.', 			'Plancton',		'tip3.jpg'	),
							('Tierra', 		'Hamster', 			'Inquietos, juguetones, curiosos, peludos y tiernos.', 			'Plantas',		'tip4.jpg'	),
							('Aire', 		'Loro', 			'Melodicos, curiosos, tiernos, charlatanes y buena compañía.', 	'Semillas',		'tip5.jpg'	),
							('Tierra', 		'Conejo', 			'Peludos, saltarines, tiernos, asustadizos y curiosos.', 		'Zanahorias',	'tip6.jpg'	);


create table Mascota(
	  mas_ID				INT 				NOT NULL AUTO_INCREMENT PRIMARY KEY,
      tip_ID 				INT 				NOT NULL,
	  mas_Color 			VARCHAR(20) 		NOT NULL,
	  mas_Sexo 				VARCHAR(20)			NOT NULL,
	  mas_Descripcion 		VARCHAR(200) 		NOT NULL,
	  mas_Foto			 	BLOB 				NULL DEFAULT ('Por agregar'),
      
      foreign key(tip_ID) references TipoDeMascota (tip_ID)
);
insert into Mascota			(tip_ID,	mas_Color,	mas_Sexo,	mas_Descripcion,																mas_Foto			)
values						(1, 		'Negro', 	'Macho', 	'Hermoso cachorro de 6 meses de edad, activo y atento.',						'mas1.jpg'			),
							(2, 		'Gris', 	'Hembra', 	'Tierna gatita de 1 año de edad, cariñosa y cazadora.',							'mas2.jpg'			),
							(3, 		'Blanco', 	'Macho', 	'Pez georama traído de Corea, de 3 años de edad.',								'Por agregar' 		),
							(1, 		'Café', 	'Macho', 	'Perro bulldog de 2 años de edad, juguetón y servicial.',						'mas4.jpg'			),
							(4, 		'Café', 	'Hembra', 	'Hámster de 9 meses de edad, activa y comelona.',								'mas5.jpg'			),
							(5,		 	'Verde', 	'Macho', 	'Loro de 8 meses de edad, charlatán y silbador.',								'mas6.jpg'			),
							(6, 		'Blanco', 	'Macho', 	'Saltarín, comelón, tranquilo y veloz.',										'Por agregar'		),
							(2, 		'Blanco', 	'Macho', 	'Gato de 2 años de edad, perezoso y bastante cariñoso.',						'Por agregar'		),
							(1, 		'Gris', 	'Hembra',	'Perra siberiana de 1 año de edad, demasiado activa.',							'mas.jpg'			),
							(2, 		'Manchado', 'Macho', 	'Gato de colores blanco y negro, de 8 meses, juguetón.',						'Por agregar'		),
							(1, 		'Manchado', 'Macho', 	'Perro criollo, 2 años, tranquilo, sabe jugar con la pelota.',					'mas7.jpg'			),
							(1, 		'Negro', 	'Hembra', 	'Perro chihuahua, de año y medio de edad, bastante juguetón y cariñoso.',		'Por agregar'		),
							(2, 		'Manchado', 'Macho', 	'Gato criollo, aproximadamente 5 años de edad, muy tranquilo y dormilón.',		'Por agregar'		),
							(1, 		'Blanco', 	'Hembra', 	'Perro criollo, 10 meses de edad, extremadamente juguetona.',					'Por agregar'		),
							(6, 		'Blanco', 	'Hembra', 	'Hembra conejo, de unos 4 meses de edad, muy activa.',							'mas8.jpg'			),
							(1, 		'Manchado', 'Macho', 	'Perro husky blanco y negro, de 2 años, tímido.',								'Por agregar'		);
                          
                          
                          
create table Funcion(
	fun_ID 				INT 				NOT NULL AUTO_INCREMENT PRIMARY KEY,
    fun_Tipo 			VARCHAR(20) 		NOT NULL,
    fun_Descripción 	VARCHAR(200) 		NOT NULL,
    fun_Horario1 		VARCHAR(20) 		NOT NULL,
    fun_Horario2 		VARCHAR(20) 		NULL,
    fun_Pago			DECIMAL 			NOT NULL
);
insert into Funcion			(fun_Tipo,		fun_Descripción,																		fun_Horario1,		fun_Horario2,		fun_Pago)
values						('Vigilancia', 	'Vigila la propiedad, donde se encuentran los animales.', 								'7:00AM-7:00PM', 	'7:00PM-7:00AM', 	1000000	),
							('Psicólogo', 	'Estudia a los candidatos de adopción.', 												'8:00AM-3:00PM', 		NULL, 			1300000	),
							('Publicista', 	'Encargado del manejo de las redes sociales.', 											'7:00AM-5:00PM', 		NULL, 			1000000	),
							('Veterinario', 'Mantiene saludables a los animales, los alimenta, entrega y vigila su integridad.', 	'5:00AM-2:00PM', 	'2:00AM-10:00PM', 	1500000	),
							('Contador', 	'Administra el dinero obtenido de donaciones y realiza pagos.', 						'7:00AM-5:00PM', 		NULL, 			1300000	),
							('Rescatista', 	'Busca animales en situación de riesgo para su afiliación con la entidad.', 			'7:00AM-5:00PM', 	'7:00PM-7:00AM', 	1300000	);
                            

create table Empleado(
	emp_ID 				INT 				NOT NULL AUTO_INCREMENT PRIMARY KEY,
    emp_Documento 		VARCHAR(10) 		NOT NULL,
    emp_Nombre 			VARCHAR(20) 		NOT NULL,
    emp_Apellido 		VARCHAR(20) 		NOT NULL,
    emp_Fecha 			DATE 				NOT NULL,
    fun_ID 				INT 				NOT NULL,
      
	foreign key(fun_ID) references Funcion (fun_ID)
);
insert into Empleado		(emp_Documento,		emp_Nombre ,		emp_Apellido,		 emp_Fecha,		fun_ID	)
values						('1002798452', 		'Andrés', 			'Naranjo', 			'1990/11/12', 	5		),
							('1004598416', 		'Maria', 			'Garzón', 			'1988/04/20', 	2		),
							('3002745234', 		'Jairo', 			'Castro', 			'1995/03/09', 	1		),
							('1034542458', 		'Felipe', 			'Castañeda', 		'1998/09/15', 	3		),
							('1009875252', 		'Camila', 			'Correa', 			'1986/12/26', 	4		),
							('8009178469', 		'Miguel', 			'Gutierrez', 		'1994/04/17',	4		),
							('2041476411', 		'Brian', 			'Parra', 			'1990/12/31', 	2		),
							('2401111134', 		'Milena', 			'Sandoval', 		'1989/01/24', 	1		),
							('2714614844', 		'Carlos', 			'Sandoval', 		'1991/08/15', 	6		);
                            
                            
                            
create table Candidato(
	can_ID 			INT 					NOT NULL AUTO_INCREMENT PRIMARY KEY,
	can_Documento 	VARCHAR(10) 			NOT NULL,
	can_Nombre 		VARCHAR(20) 			NOT NULL,
	can_Apellido 	VARCHAR(20) 			NOT NULL,
	can_Fecha 		DATE 					NOT NULL,
	can_Residencia 	VARCHAR(45) 			NOT NULL,
	can_Ingreso 	DECIMAL 				NOT NULL,
	can_Estado 		VARCHAR(11) 				NULL DEFAULT ("No evaluado")
);
insert into Candidato		(can_Documento,		can_Nombre ,		can_Apellido,		 can_Fecha,		can_Residencia,			can_Ingreso,	can_Estado	)
values						('80049304', 		'Luis', 			'Díaz', 			'1998/03/15', 	'Cll 36 #1-81 este', 	1000500, 		'Apto'		),
							('1000258096', 		'Fernanda', 		'Caro', 			'1968/04/17', 	'Cr 24 45 - 80',        2455850, 		'Apto'		),
							('24716661', 		'Angel', 			'Pérez', 			'1981/04/16', 	'Cr 2 #31-48',          1456780, 		'Apto'		),
							('1035415246', 		'Luisa', 			'García', 			'1979/04/20', 	'Cll 40 # 2-40 este',   1200500, 		'No Apto'	),
							('27716616', 		'Valentina', 		'Suarez', 			'2000/03/15', 	'Cr 36 37 - 73',        3350850, 		'Apto'		),
							('1028474784', 		'Sebastian', 		'Ramirez', 			'1967/10/30', 	'Cr 31 30 - 20',        1690590, 		'No Apto'	),
							('1000708776', 		'Rodrigo', 			'Peña', 			'2001/04/20', 	'Cll 105 #47-77',       4456870, 		'Apto'		),
							('1031488456', 		'Joel', 			'Pelaez', 			'1993/04/15', 	'Cr 9 #87 -52',         1867950, 		'Apto'		),
							('1009323575', 		'Valeria', 			'Pinzón', 			'1970/03/03', 	'Cll 114 #5-2',         6124673, 		'Apto'		),
							('1032868491', 		'Michael', 			'Alvarez', 			'1970/03/04', 	'Cll 120 #1-10 Norte',  1389670, 		'No Apto'	);
                            
                            
                            
create table Aplica(
	apl_ID 				INT 				NOT NULL AUTO_INCREMENT PRIMARY KEY,
	can_ID 				INT 				NOT NULL,
	mas_ID 				INT 				NOT NULL,
	apl_FechaAplicacion DATE 				NOT NULL,
    
    foreign key(can_ID) references Candidato (can_ID),
    foreign key(mas_ID) references Mascota 	 (mas_ID)
);
insert into Aplica			(can_ID,	mas_ID,		apl_FechaAplicacion	)
values						(1,			10,			'2020/11/01'		),
							(3,			10,			'2020/11/02'		),
							(3,			6,			'2020/11/04'		),
							(9,			6,			'2020/11/06'		),
							(1,			2,			'2020/11/12'		),
							(7,			16,			'2020/11/13'		),
							(1,			14,			'2020/11/14'		),
							(7,			8,			'2020/11/09'		),
							(5,			1,			'2020/11/11'		),
							(5,			9,			'2020/11/21'		),
							(9,			7,			'2020/11/18'		),
							(2,			13,			'2020/11/19'		),
							(2,			4,			'2020/11/13'		),
							(8,			5,			'2020/11/13'		),
							(8,			4,			'2020/11/15'		),
							(5,			5,			'2020/11/12'		),
							(9,			2,			'2020/11/11'		),
							(3,			12,			'2020/11/12'		),
							(1,			3,			'2020/10/29'		),
							(8,			3,			'2020/10/28'		);
                            
                            
                            
create table Adopcion(
	ado_ID 				INT 				NOT NULL AUTO_INCREMENT PRIMARY KEY,
	apl_ID 				INT 				NOT NULL,
	emp_ID 				INT 				NOT NULL,
	ado_Fecha 			DATE 				NOT NULL,
    
    foreign key(apl_ID) references Aplica 	  (apl_ID ),
    foreign key(emp_ID) references Empleado	  (emp_ID)
);
insert into Adopcion		(apl_ID,	emp_ID,		ado_Fecha	)
values						(1,			5,			'2020/11/07'),
							(13,		5,			'2020/11/20'),
							(3,			5,			'2020/11/11'),
							(9,			6,			'2020/11/18'),
							(5,			6,			'2020/11/19'),
							(11,		5,			'2020/11/25'),
							(20,		6,			'2020/11/04'),
							(8,			6,			'2020/11/16'),
							(16,		5,			'2020/11/19'),
							(10,		6,			'2020/11/28');


create table Contribuidor(
	con_ID 			INT 					NOT NULL AUTO_INCREMENT PRIMARY KEY,
	con_Documento 	VARCHAR(10) 			NOT NULL,
	con_Nombre 		VARCHAR(20) 			NOT NULL,
	con_Apellido 	VARCHAR(20) 			NOT NULL,
	con_Fecha 		DATE 					NOT NULL,
	con_Labor		VARCHAR(30) 			NOT NULL,
    con_Foto		BLOB 					NULL DEFAULT ('Por agregar')
);
insert into Contribuidor	(con_Documento,		con_Nombre,		con_Apellido,		con_Fecha,		con_Labor,				con_Foto			)
values						('1005468754',		'Samir',		'Nariño',			'1979/02/12',	'Contratista',			'con1.jpg'			),
							('1001278543',		'Esteban',		'Zamora',			'1983/09/08',	'Medico',				'con2.jpg'			),
							('1000835552',		'Dayanna',		'Garcia',			'1981/07/13',	'Veterinaria',			'Por agregar'		),
							('1006228747',		'Paula',		'Vargas',			'1979/12/11',	'Contador',				'Por agregar'		),
							('1005468754',		'Vanessa',		'Torres',			'1998/07/02',	'Ingeniera de Sistemas','Por agregar'		),
							('1004873012',		'Oscar',		'Franco',			'1970/12/06',	'Mecanico',				'Por agregar'		),
							('1006234232',		'Viviana',		'Vargas',			'2003/07/10',	'Estudiante',			'con3.jpg'			);


create table Donacion(
	don_Numero 		CHAR(6) 				NOT NULL PRIMARY KEY,
	don_Valor 		DECIMAL 				NOT NULL,
	don_Lugar 		VARCHAR(20) 			NOT NULL,
	con_ID 			INT 					NOT NULL,
	don_Fecha 		DATE 					NOT NULL,
    
    foreign key(con_ID) references Contribuidor  (con_ID )
);
insert into Donacion		(don_Numero,		don_Valor,		don_Lugar,		con_ID,		don_Fecha		)
values						('123452',			1000000,		'Bogotá',		5,			'2020/11/02'	),
							('363452',			200000,			'Soacha',		1,			'2020/11/12'	),
							('328563',			900000,			'Sopó',			3,			'2020/11/11'	),
							('292387',			2200000,		'Madrid',		1,			'2020/11/18'	),
							('431224',			2000000,		'Bogotá',		2,			'2020/11/13'	),
							('276541',			600000,			'Bogotá',		4,			'2020/11/12'	),
							('721453',			400000,			'Soacha',		5,			'2020/10/29'	),
							('745124',			50000,			'Soacha',		6,			'2020/11/09'	),
							('745134',			800000,			'Chía',			6,			'2020/11/18'	),
							('847157',			1100000,		'Cota',			2,			'2020/11/13'	),
							('546382',			900000,			'Madrid', 		1,			'2020/11/11'	),
							('292334',			2200000,		'Madrid',		4,			'2020/11/12'	),
							('411224',			1000000,		'Bogotá',		1,			'2020/11/13'	);
                            

create table PagoAdicionalEmpleado(
	pad_ID 				INT 				NOT NULL AUTO_INCREMENT PRIMARY KEY,
	pad_Valor 			DECIMAL 			NOT NULL,
	pad_Descripción		VARCHAR(200) 		NOT NULL
);
insert into PagoAdicionalEmpleado		(pad_Valor,		pad_Descripción					)
values									(200000,		'Medicamentos'					),
										(300000,		'Alimentos para los animales'	),
										(150000,		'Alimentación y transporte'		);



create table PagoEmpleado(
  pag_Numero 		CHAR(7) 		NOT NULL PRIMARY KEY,
  emp_ID 			INT 			NOT NULL,
  pad_ID 			INT 			NULL,
  pag_Total 		DECIMAL 		NOT NULL,
  pag_Fecha 		DATE 			NOT NULL,
  
  foreign key(pad_ID) references PagoAdicionalEmpleado  (pad_ID ),
  foreign key(emp_ID) references Empleado  (emp_ID )
);
insert into PagoEmpleado		(pag_Numero,		emp_ID, 		pad_ID,		pag_Total,		  pag_Fecha	)
values							('1010200',			2,				NULL,		'1300000',		'2020/12/08'),
								('1010201',			1,				NULL,		'1300000',		'2020/12/08'),
								('1010202',			3,				NULL,		'1000000',		'2020/12/08'),
								('1010203',			8,				NULL,		'1000000',		'2020/12/08'),
								('1010204',			5,				1,			'1700000',		'2020/12/08'),
								('1010205',			6,				2,			'1800000',		'2020/12/08'),
								('1010206',			7,				NULL,		'1300000',		'2020/12/08'),
								('1010207',			4,				NULL,		'1000000',		'2020/12/08'),
								('1010208',			9,				3,			'1450000',		'2020/12/08');



create table Economia(
	eco_ID 					INT 		NOT NULL AUTO_INCREMENT PRIMARY KEY,
	don_Numero 				CHAR(6) 	NULL,
	pag_Numero 				CHAR(7) 	NULL,
	eco_Total 				DECIMAL 	NOT NULL,
	eco_Fecha 				DATE 		NOT NULL,
  
  foreign key(don_Numero) references Donacion  		(don_Numero ),
  foreign key(pag_Numero) references PagoEmpleado  (pag_Numero)
);
insert into Economia		(don_Numero,		pag_Numero, 		eco_Total,		eco_Fecha		)
values						('123452',			'1010200',			-300000,		'2020/12/08'	),
							('363452',			'1010201',			-1100000,		'2020/12/08'	),
							('328563',			'1010202',			-100000,		'2020/12/08'	),
							('292387',			'1010203',			1200000,		'2020/12/08'	),
							('431224',			'1010204',			300000,			'2020/12/08'	),
							('276541',			'1010205',			-1200000,		'2020/12/08'	),
							('721453',			'1010206',			-900000,		'2020/12/08'	),
							('745124',			'1010207',			-950000,		'2020/12/08'	),
							('745134',			'1010208',			-650000,		'2020/12/08'	),
							('847157',			NULL,				1100000,		'2020/12/08'	),
							('546382',			NULL,				900000,			'2020/12/08'	),
							('292334',			NULL,				2200000,		'2020/12/08'	),
							('411224',			NULL,				1000000,		'2020/12/08'	);
