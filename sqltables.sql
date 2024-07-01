SELECT
    table_schema || '.' || table_name
FROM
    information_schema.tables
WHERE
    table_type = 'BASE TABLE'
AND
    table_schema NOT IN ('pg_catalog', 'information_schema');



DROP TABLE admin_main;

CREATE TABLE admin_main(
	id_sql SERIAL UNIQUE NOT NULL,
	site_name varchar(512) NOT NULL,
	site_description varchar(512) NOT NULL,	
	site_createdat timestamp NOT NULL,
	PRIMARY KEY (id_sql, site_name, site_description, site_createdat)
);

CREATE TABLE admin_locations(
	id_sql SERIAL UNIQUE NOT NULL,
	id_site int NOT NULL,
	location_name varchar(512) NOT NULL,
	address_one varchar(512) NOT NULL,
	address_two varchar(512),
	PRIMARY KEY (id_sql, id_site, location_name, address_one, address_two),
	FOREIGN KEY (id_site) REFERENCES admin_main(id_sql)
);

-- Note: a shard key is a handshake code between other servers on the network
CREATE TABLE admin_shards(
	id_sql SERIAL UNIQUE NOT NULL,
	id_admin int NOT NULL,
	shard_table varchar(256) UNIQUE NOT NULL,
	shard_key varchar(256) NOT NULL,
	shard_ip varchar(64) NOT NULL,
	shard_createdat timestamp NOT NULL,
	PRIMARY KEY (id_sql, shard_table, shard_key, shard_ip, shard_createdat),
	FOREIGN KEY (id_admin) REFERENCES admin_main(id_sql)
);

DROP TABLE user_main;

CREATE TABLE user_main(
	id_sql SERIAL UNIQUE NOT NULL,
	first_name varchar(1024) NOT NULL,
	last_name varchar(1024) NOT NULL,
	user_password varchar(32) NOT NULL,
	user_createdat timestamp NOT NULL,
	last_login timestamp,
	PRIMARY KEY (id_sql, first_name, last_name)
);

DROP TABLE user_permissions;

CREATE TABLE user_permissions(
	id_sql SERIAL UNIQUE NOT NULL,
	id_user int NOT NULL,
	user_role varchar(1024) NOT NULL,
	PRIMARY KEY(id_sql, id_user, user_role),
	FOREIGN KEY (id_sql) REFERENCES user_main(id_sql)
);

CREATE TABLE user_history (
	id_sql SERIAL UNIQUE NOT NULL,
	id_user int NOT NULL,
	reference_table varchar(256) NOT NULL,
	reference_id int NOT NULL,
	user_action varchar(256) NOT NULL,
	time_occured timestamp NOT NULL,
	PRIMARY KEY (id_sql, id_user, reference_id, user_action),
	FOREIGN KEY (id_user) REFERENCES user_main(id_sql)
);

CREATE TABLE customer_main(
	id_sql SERIAL UNIQUE NOT NULL,
	first_name varchar(256) NOT NULL,
	last_name varchar(256) NOT NULL,
	customer_password varchar(32) NOT NULL,
	id_strip varchar(256),
	PRIMARY KEY (id_sql)
);

CREATE TABLE updates(
	id_sql SERIAL,
	id_source int NOT NULL,
	source_updated varchar(256) NOT NULL,
	data_update varchar(4096) NOT NULL,
	data_previous varchar(4096) NOT NULL,
	PRIMARY KEY (id_sql, id_customer),
	FOREIGN KEY (id_customer) REFERENCES customer_main(id_sql)
);

DROP TABLE customer_location;

CREATE TABLE customer_location(
	id_sql SERIAL NOT NULL UNIQUE,
	id_customer int NOT NULL,
	address_one varchar(256) NOT NULL,
	address_two varchar(256),
	zipcode varchar(10) NOT NULL,
	country varchar(256) NOT NULL,
	state varchar(256) NOT NULL,
	PRIMARY KEY (id_sql, id_customer, address_one, address_two, zipcode, country, state),
	FOREIGN KEY (id_customer) REFERENCES customer_main(id_sql)
);

CREATE TABLE customer_purchase (
	id_sql SERIAL UNIQUE NOT NULL,
	id_customer int NOT NULL,
	id_variant int NOT NULL, 
	id_address int NOT NULL,
	paid NUMERIC(15,6) NOT NULL,
	PRIMARY KEY (id_sql, id_customer, id_variant, id_address),
	FOREIGN KEY (id_variant) REFERENCES variant_main(id_sql),
	FOREIGN KEY (id_customer) REFERENCES customer_main(id_sql),
	FOREIGN KEY (id_address) REFERENCES customer_location(id_sql)
);

CREATE TABLE product_main (
	id_sql SERIAL UNIQUE NOT NULL,
	description varchar(10240) NOT NULL,
	time_created timestamp NOT NULL,
	PRIMARY KEY (id_sql, description)
);

CREATE TABLE product_images (
	id_sql SERIAL UNIQUE NOT NULL,
	id_product int NOT NULL,
	image varchar(2048) NOT NULL,
	alttag varchar(2048)NOT NULL,
	location varchar(2048) NOT NULL,
	location_type varchar(256) NOT NULL, 
	time_created timestamp NOT NULL,
	PRIMARY KEY (id_sql, id_product),
	FOREIGN KEY (id_product) REFERENCES product_main(id_sql)
);

CREATE TABLE metadata (
	id_sql SERIAL UNIQUE NOT NULL,
	id_table int UNIQUE NOT NULL,
	metadata JSONB,
	PRIMARY KEY(id_sql, id_table)
);

DROP TABLE variant_main;

CREATE TABLE variant_main (
	id_sql SERIAL UNIQUE NOT NULL,
	id_product int NOT NULL,
	barcode varchar(32) NOT NULL,
	sku varchar(128) UNIQUE NOT NULL,
	PRIMARY KEY(id_sql, id_product, barcode, sku),
	FOREIGN KEY (id_product) REFERENCES product_main(id_sql)
);

CREATE TABLE variant_cost (
	id_sql SERIAL UNIQUE NOT NULL,
	id_variant int UNIQUE NOT NULL,
	variant_cost NUMERIC(15,6) NOT NULL,
	variant_map NUMERIC(15,6) NOT NULL,
	variant_price NUMERIC(15,6) NOT NULL,
	variant_shipping NUMERIC(15,6) NOT NULL,
	currentcy_type char(3),
	PRIMARY KEY(id_sql, id_variant),
	FOREIGN KEY (id_variant) REFERENCES variant_main(id_sql)
);