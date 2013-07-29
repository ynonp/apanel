-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Mon Jul 29 21:01:12 2013
-- 

;
BEGIN TRANSACTION;
--
-- Table: roles
--
CREATE TABLE roles (
  id INTEGER PRIMARY KEY NOT NULL,
  name text NOT NULL
);
CREATE UNIQUE INDEX name_unique ON roles (name);
--
-- Table: user_roles
--
CREATE TABLE user_roles (
  user_id integer NOT NULL,
  role_id integer NOT NULL,
  PRIMARY KEY (user_id, role_id),
  FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX user_roles_idx_role_id ON user_roles (role_id);
CREATE INDEX user_roles_idx_user_id ON user_roles (user_id);
--
-- Table: users
--
CREATE TABLE users (
  id INTEGER PRIMARY KEY NOT NULL,
  active char(1) NOT NULL,
  username text NOT NULL,
  password text NOT NULL,
  password_expires timestamp,
  name text NOT NULL,
  email_address text NOT NULL,
  phone_number text,
  mail_address text
);
CREATE UNIQUE INDEX username_unique ON users (username);
--
-- Table: watched_site
--
CREATE TABLE watched_site (
  id integer NOT NULL,
  site_name text NOT NULL
);
CREATE UNIQUE INDEX site_unique ON watched_site (site_name);
COMMIT;
