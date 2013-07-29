-- Convert schema '/Users/ynonperek/work/projects/apanel/share/migrations/_source/deploy/1/001-auto.yml' to '/Users/ynonperek/work/projects/apanel/share/migrations/_source/deploy/2/001-auto.yml':;

;
BEGIN;

;
CREATE TABLE watched_sites (
  id INTEGER PRIMARY KEY NOT NULL,
  site_name text NOT NULL
);

;
CREATE UNIQUE INDEX site_unique ON watched_sites (site_name);

;

COMMIT;

