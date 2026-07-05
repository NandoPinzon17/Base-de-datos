DROP table if exists city cascade;
DROP table if exists customer cascade;
DROP table if exists game cascade;
DROP table if exists platform cascade;
DROP table if exists gender cascade;
DROP table if exists store cascade;
DROP table if exists ordex cascade;
DROP table if exists date cascade;
DROP table if exists inventary cascade;


CREATE TABLE city (
    ct serial primary key,
    name_city varchar (50)
);

CREATE TABLE customer (
    cx serial primary key,
    name_customer varchar (50),
    city_id int references city(ct)
);

CREATE TABLE platform (
    pl serial primary key,
    name_platform varchar (50)
);

CREATE TABLE gender (
    ac serial primary key,
    name_gender varchar (50)
);

CREATE TABLE game (
    ga serial primary key,
    name_game varchar (50),
    gender_id int references gender(ac)
);

CREATE TABLE store (
    st serial primary key,
    name_store varchar (50),
    city_id int references city(ct)
);

CREATE TABLE date (
    dt serial primary key,
    name_date varchar (50)
);

CREATE TABLE ordex (
    rr serial primary key,
    name_ordex varchar (50)
);

CREATE TABLE inventary (
    iv serial primary key,
    store_id int references store(st),
    game_id int references game(ga),
    stock_quantity int
);

insert into city(ct,name_city) values
                                   (1,'bogota'),
                                   (2,'cucuta'),
                                   (3,'barranquilla'),
                                   (4,'cartagena'),
                                   (5,'cali'),
                                   (6,'medellin'),
                                   (7,'pereira'),
                                   (8,'bucaramanga'),
                                   (9,'manizales');

insert into platform(pl,name_platform) values
                                           (1,'xbox x'),
                                           (2,'ps5'),
                                           (3,'switch'),
                                           (4,'pc');

insert into gender(ac,name_gender) values
                                       (1,'action'),
                                       (2,'adventura'),
                                       (3,'racing'),
                                       (4,'sports'),
                                       (5,'sandbox'),
                                       (6,'rpg'),
                                       (7,'horror'),
                                       (8,'role playing game');

insert into game(ga,name_game,gender_id) values
                                   (1,'grant theft auto v',1),
                                   (2,'hogwarts legacy deluxe',2),
                                   (3,'mario kart 8',3),
                                   (4,'fc26',4),
                                   (5,'zelda totk',2),
                                   (6,'god of war ragnarok',2),
                                   (7,'minecraft',5),
                                   (8,'elden ring',6),
                                   (9,'resident evil 4 remake',7),
                                   (10,'cyberpunk',6);

insert into ordex(rr,name_ordex) values
                                     (1,'g1001'),
                                     (2,'g1002'),
                                     (3,'g1003'),
                                     (4,'g1004'),
                                     (5,'g1005'),
                                     (6,'g1006'),
                                     (7,'g1007'),
                                     (8,'g1008'),
                                     (9,'g1009'),
                                     (10,'g1010'),
                                     (11,'g1011'),
                                     (12,'g1012'),
                                     (13,'g1013'),
                                     (14,'g1014'),
                                     (15,'g1015'),
                                     (16,'g1016'),
                                     (17,'g1017'),
                                     (18,'g1018'),
                                     (19,'g1019'),
                                     (20,'g1020');

insert into customer (cx,name_customer,city_id) values
                                                    (1,'Epic game',1),
                                                    (2,'Game hosue',2),
                                                    (3,'Game planet',3),
                                                    (4,'Game zone',1),
                                                    (5,'Level up',4),
                                                    (6,'Next level',5),
                                                    (7,'Pixel store',6),
                                                    (8,'Play world',7),
                                                    (9,'Retro games',8),
                                                    (10,'Virtual shop',9);

insert into store(st,name_store,city_id) values
                                             (1,'Store north',1),
                                             (2,'East Hub',2),
                                             (3,'Coast Store',3),
                                             (4,'South Hub',5),
                                             (5,'Store West',6),
                                             (6,'Coffee Center',9);

insert into inventary (store_id,game_id, stock_quantity) values
                                              (1,4,39),
                                              (2,2,28),
                                              (3,3,50),
                                              (4,6,25),
                                              (5,7,88),
                                              (6,8,59);

SELECT * FROM customer;

Busca los clientes que pertenezcan a la ciudad con ID 1 (Bogotá).
SELECT * FROM customer
WHERE city_id = 1;

Muestra el nombre del cliente junto al nombre real de su ciudad.
SELECT c.cx AS cliente_id, c.name_customer AS cliente, ci.name_city AS ciudad
FROM customer c
INNER JOIN city ci ON c.city_id = ci.ct;

Busca todos los juegos que pertenezcan al género 'adventura' (ID 2).
SELECT g.ga AS juego_id, g.name_game AS juego, gen.name_gender AS genero
FROM game g
INNER JOIN gender gen ON g.gender_id = gen.ac
WHERE gen.name_gender = 'adventura';

Busca qué tiendas tienen stock de juegos y muestra cuáles tienen más de 30 unidades disponibles.
SELECT s.name_store AS tienda, g.name_game AS juego, i.stock_quantity AS cantidad
FROM inventary i
INNER JOIN store s ON i.store_id = s.st
INNER JOIN game g ON i.game_id = g.ga
WHERE i.stock_quantity > 30;

¿Cuántos clientes tenemos registrados en total por cada ciudad?
SELECT ci.name_city AS ciudad, COUNT(c.cx) AS total_clientes
FROM customer c
INNER JOIN city ci ON c.city_id = ci.ct
GROUP BY ci.name_city;