CREATE TABLE user_main(
	id_sql int,
	first_name varchar(1024),
	last_name varchar(1024),
	user_roles varchar(1024)[],
	user_password varchar(32),
	last_login timestamp,
	PRIMARY KEY (id_sql, first_name, last_name)
);

CREATE TABLE user_permissions(
	id_sql int,
	id_user int,
	user_role varchar(1024),
	PRIMARY KEY(id_sql, id_user, user_role),
	FOREIGN KEY (id_sql) REFERENCES user_main(id_sql)
);

CREATE TABLE user_history (
	id_sql int,
	id_user int,
	reference_table varchar(256),
	reference_id int,
	user_action varchar(256),
	time_occured timestamp,
	PRIMARY KEY (id_sql, id_user, reference_id, user_action),
	FOREIGN KEY (id_user) REFERENCES user_main(id_sql)
);

CREATE TABLE customer_main(
	id_sql int,
	first_name varchar(256),
	last_name varchar(256),
	customer_password varchar(32),
	id_strip varchar(256),
	PRIMARY KEY (id_sql)
);

CREATE TABLE customer_updates(
	id_sql int,
	id_customer int,
	table_updated varchar(256),
	data_update varchar(256),
	data_previous varchar(256),
	PRIMARY KEY (id_sql, id_customer),
	FOREIGN KEY (id_customer) REFERENCES customer_main(id_sql)
);

CREATE TABLE customer_location(
	id_sql int,
	id_customer int,
	address_one varchar(256),
	address_two varchar(256),
	zipcode varchar(10),
	country varchar(256),
	state varchar(256),
	PRIMARY KEY (id_sql, id_customer, address_one, address_two, zipcode, country, state),
	FOREIGN KEY (id_customer) REFERENCES customer_main(id_sql)
);

CREATE TABLE customer_purchase (
	id_sql int,
	id_customer int,
	id_variant int, 
	id_address int,
	PRIMARY KEY (id_sql, id_customer, id_variant, id_address),
	FOREIGN KEY (id_variant) REFERENCES variant_main(id_sql),
	FOREIGN KEY (id_customer) REFERENCES customer_main(id_sql),
	FOREIGN KEY (id_address) REFERENCES customer_location(id_sql)
);

CREATE TABLE product_main (
	id_sql int,
	description varchar(10240),
	time_created timestamp,
	PRIMARY KEY (id_sql, description)
);

CREATE TABLE product_updates (
	id_sql int,
	id_product int,
	id_valueupdated int,
	time_updated timestamp,
	PRIMARY KEY (id_sql, id_product),
	FOREIGN KEY (id_product) REFERENCES product_main(id_sql)
);

CREATE TABLE product_images (
	id_sql int,
	id_product int,
	images varchar(2048),
	time_created timestamp,
	PRIMARY KEY (id_sql, id_product),
	FOREIGN KEY (id_product) REFERENCES product_main(id_sql)
);

CREATE TABLE product_metadata (
	id_sql int,
	id_product int,
	metadata JSONB,
	PRIMARY KEY(id_sql, id_product),
	FOREIGN KEY (id_product) REFERENCES product_main(id_sql)
);

CREATE TABLE variant_main (
	id_sql int,
	id_product int,
	barcode varchar(16),
	sku varchar(128),
	PRIMARY KEY(id_sql, id_product, barcode, sku),
	FOREIGN KEY (id_product) REFERENCES product_main(id_sql)
);

CREATE TABLE variant_cost (
	id_sql int,
	id_variant int,
	variant_cost NUMERIC(15,6),
	variant_map NUMERIC(15,6),
	variant_price NUMERIC(15,6),
	variant_shipping NUMERIC(15,6),
	currentcy_type char(3),
	PRIMARY KEY(id_sql, id_variant),
	FOREIGN KEY (id_variant) REFERENCES variant_main(id_sql)
);

CREATE TABLE variant_metadata (
	id_sql int,
	id_variant int,
	metadata JSONB,
	PRIMARY KEY(id_sql, id_variant),
	FOREIGN KEY (id_variant) REFERENCES variant_main(id_sql)
);