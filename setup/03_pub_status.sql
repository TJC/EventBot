BEGIN;
create table pub_status (id serial primary key, name varchar(16) unique);
insert into pub_status (name) values ('Closed');
alter table pubs add status integer not null default 1 references pub_status(id);
COMMIT;
