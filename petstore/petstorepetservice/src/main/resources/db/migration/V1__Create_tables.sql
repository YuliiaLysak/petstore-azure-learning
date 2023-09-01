create table category
(
    id                bigserial     not null primary key,
    name              varchar(64)   not null unique
);

create table tag
(
    id                bigserial     not null primary key,
    name              varchar(64)   not null unique
);

create table pet
(
    id                bigserial     not null primary key,
    name              varchar(64)   not null unique,
    category_id       bigserial     not null,
    photoURL          varchar(255)  not null,
    status            varchar(64)   not null,
    constraint fk_category foreign key (category_id) references category(id)
);

create table pet_tag
(
    pet_id            bigserial     not null references pet (id) on delete cascade,
    tag_id            bigserial     not null references tag (id) on delete cascade,
    constraint pet_tag_pkey primary key (pet_id, tag_id)
);
