CREATE TABLE Event (
    id serial PRIMARY KEY,
    title text not null,
    content text not null,
    citation text not null,
    "years#start_year" integer,
    "years#end_year" integer
);
