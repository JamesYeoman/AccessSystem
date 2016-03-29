-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Thu Mar 17 20:51:49 2016
-- 

BEGIN TRANSACTION;

--
-- Table: accessible_things
--
DROP TABLE accessible_things;

CREATE TABLE accessible_things (
  id varchar(40) NOT NULL,
  name varchar(255) NOT NULL,
  assigned_ip varchar(15) NOT NULL,
  PRIMARY KEY (id)
);

CREATE UNIQUE INDEX name ON accessible_things (name);

--
-- Table: people
--
DROP TABLE people;

CREATE TABLE people (
  id INTEGER PRIMARY KEY NOT NULL,
  parent_id integer,
  name varchar(255) NOT NULL,
  email varchar(255),
  dob datetime NOT NULL,
  address varchar(1024) NOT NULL,
  concessionary_rate boolean NOT NULL DEFAULT 0,
  created_date datetime NOT NULL,
  end_date datetime,
  FOREIGN KEY (parent_id) REFERENCES people(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX people_idx_parent_id ON people (parent_id);

--
-- Table: access_tokens
--
DROP TABLE access_tokens;

CREATE TABLE access_tokens (
  id varchar(255) NOT NULL,
  person_id integer NOT NULL,
  type varchar(20) NOT NULL,
  PRIMARY KEY (person_id, id),
  FOREIGN KEY (person_id) REFERENCES people(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX access_tokens_idx_person_id ON access_tokens (person_id);

--
-- Table: dues
--
DROP TABLE dues;

CREATE TABLE dues (
  person_id integer NOT NULL,
  paid_on_date datetime NOT NULL,
  expires_on_date datetime NOT NULL,
  amount_p integer NOT NULL,
  PRIMARY KEY (person_id, paid_on_date),
  FOREIGN KEY (person_id) REFERENCES people(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX dues_idx_person_id ON dues (person_id);

--
-- Table: allowed
--
DROP TABLE allowed;

CREATE TABLE allowed (
  person_id integer NOT NULL,
  accessible_thing_id varchar(40) NOT NULL,
  is_admin boolean NOT NULL,
  PRIMARY KEY (person_id, accessible_thing_id),
  FOREIGN KEY (accessible_thing_id) REFERENCES accessible_things(id),
  FOREIGN KEY (person_id) REFERENCES people(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX allowed_idx_accessible_thing_id ON allowed (accessible_thing_id);

CREATE INDEX allowed_idx_person_id ON allowed (person_id);

--
-- Table: usage_log
--
DROP TABLE usage_log;

CREATE TABLE usage_log (
  person_id integer,
  accessible_thing_id varchar(40),
  token_id varchar(255) NOT NULL,
  status varchar(20) NOT NULL,
  accessed_date datetime NOT NULL,
  FOREIGN KEY (accessible_thing_id) REFERENCES accessible_things(id),
  FOREIGN KEY (person_id) REFERENCES people(id)
);

CREATE INDEX usage_log_idx_accessible_thing_id ON usage_log (accessible_thing_id);

CREATE INDEX usage_log_idx_person_id ON usage_log (person_id);

COMMIT;
