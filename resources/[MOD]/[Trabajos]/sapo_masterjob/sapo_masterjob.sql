INSERT INTO `addon_account` (name, label, shared) VALUES
    -- ambulance
	('society_ambulance', 'LSMC', 1),
    -- police
	('society_police', 'LSPD', 1),
    -- mechanic
    ('society_mechanic', 'Mecánico', 1),
    -- taxi
	('society_taxi', 'Taxi', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
    -- ambulance
	('society_ambulance', 'LSMC', 1),
    -- police
	('society_police', 'LSPD', 1),
    -- mechanic
    ('society_mechanic', 'Mecánico', 1),
    -- taxi
	('society_taxi', 'Taxi', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
    -- ambulance
	('society_ambulance', 'LSMC', 1),
    -- police
	('society_police', 'LSPD', 1),
    -- mechanic
    ('society_mechanic', 'Mecánico', 1),
    -- taxi
	('society_taxi', 'Taxi', 1)
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
    -- ambulance
	('ambulance',0,'ambulance','Paramedico',800, '{}', '{}'),
	('ambulance',1,'doctor','Medico Adjunto',1200, '{}', '{}'),
	('ambulance',2,'chief_doctor','Cirujano',1600, '{}', '{}'),
	('ambulance',3,'boss','Jefe',2000, '{}', '{}'),
    -- police
    ('police', 0, 'recruit', 'Recluta', 800, '{}', '{}'),
	('police', 1, 'officer', 'Oficial', 1000, '{}', '{}'),
	('police', 2, 'sergeant', 'Sargento', 1200, '{}', '{}'),
	('police', 3, 'lieutenant', 'Teniente', 1400, '{}', '{}'),
	('police', 4, 'chief', 'Sub-Capitan', 1600, '{}', '{}'),
	('police', 5, 'boss', 'Capitan', 2000, '{}', '{}'),
    -- mechanic
    ('mechanic',0,'recrue','Recluta',800,'{}','{}'),
    ('mechanic',1,'novice','Novato',1000,'{}','{}'),
    ('mechanic',2,'experimente','Experomentado',1200,'{}','{}'),
    ('mechanic',3,'chief',"Limpia Tuercas",1400,'{}','{}'),
    ('mechanic',4,'boss','Jefe',2000,'{}','{}'),
    -- taxi
    ('taxi',0,'recrue','Recluta',800, '{}', '{}'),
	('taxi',1,'novice','Novato',1000, '{}', '{}'),
	('taxi',2,'experimente','Experimentado',1200, '{}', '{}'),
	('taxi',3,'uber','Uber',1400, '{}', '{}'),
	('taxi',4,'boss','Jefe',2000, '{}', '{}'),
    -- gopostal
    ('mailjob',0,'employee','Empleado',750,'{}','{}'),
    -- garbage
    ('garbage', 0, 'employee', 'Empleado', 750, '{}','{}')
;

INSERT INTO `jobs` (name, label) VALUES
    -- ambulance
	('ambulance','LSMC'),
    -- police
    ('police', 'LSPD'),
    -- mechanic
    ('mechanic', 'Mecánico'),
    -- taxi
	('taxi', 'Taxi'),
    -- gopostal
    ('mailjob', 'Repartidor'),
    -- garbage
    ('garbage', 'Basurero')
;

INSERT INTO `items` (name, label, limit) VALUES
	('bandage','Venda', 20),
	('medikit','Medikit', 5),
    ('gazbottle', 'Botella de gas', 2),
    ('fixtool', 'Herramienta de reparacion', 2),
    ('carotool', 'Herramienta de reparacion de carroceria', 2),
    ('blowpipe', 'Soplete', 2),
    ('fixkit', 'Kit de reparación', 3),
    ('carokit', 'Kit de reparación', 3)
;

ALTER TABLE `users`
	ADD `is_dead` TINYINT(1) NULL DEFAULT '0'
;

CREATE TABLE `fine_types` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`label` varchar(255) DEFAULT NULL,
	`amount` int(11) DEFAULT NULL,
	`category` int(11) DEFAULT NULL,

	PRIMARY KEY (`id`)
);

INSERT INTO `fine_types` (label, amount, category) VALUES
	('Mal uso del claxon', 1000, 0),
	('Cruzando ilegalmente una línea continua', 1500, 0),
	('Conducir en el lado equivocado de la carretera', 2000, 0),
	('Giro ilegal en U', 1000, 0),
	('Conducir ilegalmente fuera de la carretera', 2000, 0),
	('Rechazar una orden legal', 3000, 0),
	('Detener ilegalmente un vehículo', 1000, 0),
	('Estacionamiento ilegal', 2000, 0),
	('A falta de ceder a la derecha', 2000, 0),
	('Incumplimiento de la información del vehículo', 2000, 0),
	('No parar en una señal de Stop', 1500, 0),
	('No parar en un semaforo rojo', 1000, 0),
	('Paso ilegal', 1000, 0),
	('Conducir un vehículo ilegal', 5000, 0),
	('Conducir sin licencia', 3000, 0),
	('Accidente con fuga', 10000, 0),
	('Exceso de velocidad por < 5 mph', 1000, 0),
	('Exceso de velocidad por 5-15 mph', 1500, 0),
	('Exceso de velocidad por 15-30 mph', 2000, 0),
	('Exceso de velocidad por > 30 mph', 3000, 0),
	('Impedir el flujo de tráfico', 1000, 1),
	('Intoxicación pública', 2000, 1),
	('Conducta desordenada', 3000, 1),
	('Obstrucción de la justicia', 6000, 1),
	('Insultos hacia los civiles', 2000, 1),
	('Falta de respeto a un oficial', 5000, 1),
	('Amenaza verbal hacia un civil', 3000, 1),
	('Amenaza verbal hacia un oficial', 6000, 1),
	('Proporcionar información falsa', 15000, 1),
	('Intento de corrupción', 15000, 1),
	('Blandiendo un arma en los límites de la ciudad', 2000, 2),
	('Blandiendo un arma letal en los límites de la ciudad', 6000, 2),
	('Sin licencia de armas de fuego', 10000, 2),
	('Posesión de un arma ilegal', 20000, 2),
	('Posesión de herramientas de robo', 2000, 2),
	('Acoso y/o violacion', 10000, 2),
	('Intención de vender, comprar droga', 2000, 2),
	('Fabricación de una sustancia ilegal', 5000, 2),
	('Posesión de una sustancia ilegal', 2000, 2),
	('Secuestro de un Civilan', 20000, 2),
	('Secuestro de un Oficial', 100000, 2),
	('Robo', 30000, 2),
	('Robo de joyeria mano armada', 80000, 2),
	('Robo de banco mano armada', 500000, 2),
	('Robo a un civil', 20000, 3),
	('Robo a un oficial', 50000, 3),
	('Intento de asesinato de un civil', 300000, 3),
	('Intento de asesinato de un oficial', 500000, 3),
	('Asesinato de un civil', 1000000, 3),
	('Asesinato de un oficial', 5000000, 3),
	('Homicidio involuntario', 200000, 3),
	('Fraude', 80000, 2)
;
