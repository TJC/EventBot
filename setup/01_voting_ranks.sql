BEGIN;

ALTER TABLE votes ADD COLUMN rank INTEGER NOT NULL DEFAULT 0;

ALTER TABLE votes DROP CONSTRAINT votes_pkey;
ALTER TABLE votes ADD PRIMARY KEY (
    election, person, pub, rank
);

COMMIT;
