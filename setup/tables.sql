BEGIN;

CREATE TABLE events (
    id SERIAL PRIMARY KEY,
    startdate DATE,
    starttime VARCHAR(64),
    place     VARCHAR(128),
    url       VARCHAR(256),
    lat_long  POINT,         -- (latitude, longitude)
    comments  TEXT    
);

CREATE TABLE people (
    id SERIAL PRIMARY KEY,
    name VARCHAR(64),
    email VARCHAR(128)
);

CREATE TABLE attendees (
    event INTEGER REFERENCES events(id) ON DELETE CASCADE,
    person INTEGER REFERENCES people(id) ON DELETE CASCADE,
    status  VARCHAR(5) CHECK (status IN ('Yes', 'No', 'Maybe')),
    -- status was NOT NULL.. long story..
    "comment" VARCHAR(80),
    PRIMARY KEY (event,person)
);

COMMIT;
