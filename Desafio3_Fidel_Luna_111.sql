
--Creación tabla usuarios--

CREATE TABLE usuarios( id serial, email varchar, nombre varchar, apellido varchar, rol varchar);
INSERT INTO usuarios(id, email, nombre, apellido, rol) VALUES ('1', 'fidel.luna@gmail.com', 'Fidel', 'Luna','Administrador'); 
INSERT INTO usuarios(id, email, nombre, apellido, rol) VALUES ('2', 'belen.luna@gmail.com', 'Belen', 'Luna','Usuario'); 
INSERT INTO usuarios(id, email, nombre, apellido, rol) VALUES ('3', 'catalina.luna@gmail.com', 'Catalina', 'Luna','Usuario'); 
INSERT INTO usuarios(id, email, nombre, apellido, rol) VALUES ('4', 'constanza.luna@gmail.com', 'Constanza', 'Luna','Usuario'); 
INSERT INTO usuarios(id, email, nombre, apellido, rol) VALUES ('5', 'nicole.sepulveda@gmail.com', 'Nicole', 'Sepúlveda','Usuario');
SELECT * FROM usuarios

--Creación tabla post--
CREATE TABLE post( id serial, titulo varchar, contenido text, fecha_creacion timestamp, fecha_actualizacion timestamp, destacado boolean, usuario_id bigint);
INSERT INTO post( titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) values ( 'Vida saludable', 'Hacer ejercicios ayuda a tener una vida saludable', '2023-10-01', '2023-10-20', 'true', '1');
INSERT INTO post( titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) values ( 'Rutina de sueño', 'Se debe dormir bien para que el cuerpo se mantenga bien', '2023-10-05', '2023-10-20', 'true', '1');
INSERT INTO post( titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) values ( 'Sushi', 'Comer sushi aumenta la felicidad en las personas', '2023-10-06', '2023-10-21', 'true', '3');
INSERT INTO post( titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) values ( 'Estudiar', 'Los niños tienen la responsabilidad de estudiar y hacer tareas', '2023-01-01', '2023-10-15', 'false', '5');
INSERT INTO post( titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) values ( 'Descanso', 'Es bueno no hacer nada algunos días de la semana', '2023-03-01', '2023-10-01', 'false', null);
SELECT * FROM post;

--Creación tabla comentarios--
CREATE TABLE comentarios( id serial, contenido text, fecha_creación timestamp, usuario_id bigint, post_id bigint );
INSERT INTO comentarios( contenido, fecha_creación, usuario_id, post_id) VALUES ( 'Es difícil mantener una vida saludable', '2023_10_05', '1', '1');
INSERT INTO comentarios( contenido, fecha_creación, usuario_id, post_id) VALUES ( 'No puedo mantener una vida saludable', '2023_10_07', '2', '1');
INSERT INTO comentarios( contenido, fecha_creación, usuario_id, post_id) VALUES ( 'Siempre intento mantener una vida saludable', '2023_10_15', '3', '1');
INSERT INTO comentarios( contenido, fecha_creación, usuario_id, post_id) VALUES ( 'Me cuesta dormir mucho', '2023_10_06', '1', '2');
INSERT INTO comentarios( contenido, fecha_creación, usuario_id, post_id) VALUES ( 'Suelo dormir poco', '2023_10_09', '2', '2');
SELECT * FROM comentarios;


--Consultas solicitadas--
-- Cruza los datos de la tabla usuarios y posts, mostrando las siguientes columnas:
--nombre y email del usuario junto al título y contenido del post --


SELECT u.nombre, u.email, p.titulo, p.contenido
FROM usuarios u
JOIN post p ON u.id = p.usuario_id;

--Muestra el id, título y contenido de los posts de los administradores.--

SELECT p.id, p.titulo, p.contenido
FROM usuarios u
JOIN post p ON u.id = p.usuario_id
WHERE u.rol = 'Administrador';

--Cuenta la cantidad de posts de cada usuario.--

SELECT u.id, u.email, COUNT(p.id) AS cantidad_de_posts
FROM usuarios u
LEFT JOIN Post p ON U.id = p.usuario_id
GROUP BY u.id, u.email
ORDER BY u.id;

--Muestra el email del usuario que ha creado más posts.--

SELECT u.email
FROM usuarios u
LEFT JOIN Post p ON u.id = p.usuario_id
GROUP BY u.email
ORDER BY COUNT(p.id) DESC
LIMIT 1;

--Muestra la fecha del último post de cada usuario.--

SELECT u.id, u.email, MAX(p.fecha_creacion) AS fecha_ultimo_post
FROM usuarios u
LEFT JOIN post p ON u.id = p.usuario_id
GROUP BY u.id, u.email
ORDER BY u.id;

--Muestra el título y contenido del post (artículo) con más comentarios--

SELECT p.titulo, p.contenido
FROM post p
LEFT JOIN 
    (SELECT post_id, COUNT(*) AS num_comentarios
    FROM Comentarios
    GROUP BY post_id
    ORDER BY num_comentarios DESC
    LIMIT 1) 
	AS MaxComentarios ON p.id = MaxComentarios.post_id;

--Muestra en una tabla el título de cada post, el contenido de cada post y el contenido
--de cada comentario asociado a los posts mostrados, junto con el email del usuario
--que lo escribió.--

SELECT
    p.titulo AS "Título del Post",
    P.contenido AS "Contenido del Post",
    c.contenido AS "Contenido del Comentario",
    u.email AS "Email del Usuario"
FROM post p
LEFT JOIN comentarios c ON p.id = c.post_id
LEFT JOIN usuarios u ON c.usuario_id = U.id;

--Muestra el contenido del último comentario de cada usuario.--

SELECT u.email AS "Email del Usuario", c.contenido AS "Último Comentario"
FROM usuarios u
LEFT JOIN
    (SELECT usuario_id, MAX("fecha_creación") AS fecha_maxima
    FROM comentarios
    GROUP BY usuario_id)
	AS ComentariosRecientes ON U.id = ComentariosRecientes.usuario_id
LEFT JOIN comentarios c ON ComentariosRecientes.fecha_maxima = c."fecha_creación";

--Muestra los emails de los usuarios que no han escrito ningún comentario.--

SELECT u.email
FROM usuarios u
LEFT JOIN comentarios c ON u.id = c.usuario_id
GROUP BY u.email
HAVING COUNT(c.id) = 0;



