CREATE TABLE IF NOT EXISTS criminal_records ( id int(11) NOT NULL UNIQUE auto_increment, offence varchar(250) NOT NULL , reason varchar(250) NOT NULL , time varchar(250) NOT NULL , fine varchar(250) NOT NULL ,user_id varchar(250) NOT NULL, officer_id varchar(250) NOT NULL, jail int(11), created_at int (20), PRIMARY KEY(id))
;
CREATE TABLE IF NOT EXISTS `epc_notes` ( `id` int(11) NOT NULL UNIQUE auto_increment, `title` varchar(250) NOT NULL ,`content` varchar(250) NOT NULL, `user_id` varchar(250) NOT NULL, `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,  PRIMARY KEY(`id`))
;
CREATE TABLE IF NOT EXISTS `epc_bolos` ( `id` int(11) NOT NULL UNIQUE auto_increment, `gender` varchar(250) ,`height` varchar(250), `age` varchar(250), `type_of_crime` varchar(250), `name` varchar(250) , `lastname` varchar(250) , `apperance` varchar(250) , `fine` varchar(250) , `note` varchar(250), `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,  PRIMARY KEY(`id`))
;
ALTER TABLE users ADD COLUMN licencia int(11) DEFAULT 0;
ALTER TABLE users ADD COLUMN foto int DEFAULT 0;