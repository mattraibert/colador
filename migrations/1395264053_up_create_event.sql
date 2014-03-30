CREATE TABLE Event (
    id serial PRIMARY KEY,
    title text not null,
    content text not null,
    citation text not null,
    start_year integer,
    end_year integer
);
