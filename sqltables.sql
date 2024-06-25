CREATE TABLE user_main(
		id_sql int,
		first_name varchar(1024),
		last_name varchar(1024),
		user_roles varchar(1024)[],
		user_password varchar(32),
		last_login timestamp
);

CREATE TABLE user_permissions(
	id_sql int,
	id_user int,
	user_role varchar(1024)
);

CREATE TABLE user_history (
	id_sql int,
	id_user int,
	reference_table varchar(256),
	reference_id int,
	user_action varchar(256),
	time_occured timestamp
);

CREATE TABLE product_main (
	id_sql int,
	description varchar(10240),
	time_created timestamp
);

CREATE TABLE product_updates (
	id_sql int,
	id_product int,
	id_valueupdated int,
	time_updated timestamp
);

CREATE TABLE product_images (
	id_sql int,
	id_product int,
	images varchar(2048)[],
	time_created timestamp
);

CREATE TABLE product_metadata (
	id_sql int,
	id_product int,
	metadata JSONB
);