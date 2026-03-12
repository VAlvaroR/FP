
/* Ejercicio 1. Crea un procedimiento de nombre artistas_getList() que devuelva el nombre y apellidos de los artistas separados
por coma con el formato: apellidos,nombre ordenados de forma descendente.*/
/*DELIMITER $$

CREATE PROCEDURE artistas_getList()
begin
select concat(apellidos, ',',nombre) from ARTISTAS order by nombre desc;
end$$

DELIMITER ;

call artistas_getList();*/

/* Ejercicio 2. Crea un procedimiento de nombre artistas_getListAnimales() que devuelva los nombres de los artistas junto con su nif así como
el nombre y peso de los animales que están atendidos por los artistas, ordenados por nif del artista y nombre del animal.*/
/*DELIMITER $$

CREATE PROCEDURE artistas_getListAnimales()
begin
	select ar.nombre, ar.nif, an.nombre, an.peso
    from ARTISTAS ar 
    join ANIMALES_ARTISTAS anAr
    on ar.nif=anAr.nif_artista
    join ANIMALES an
    on an.nombre=anAr.nombre_animal
    order by ar.nif asc, an.nombre asc;
end$$

DELIMITER ;

call artistas_getListAnimales();*/

/* Ejercicio 3. Crea un procedimiento de nombre atracciones_getListConAntiguedad5() que devuelva los datos de las atracciones que hayan comenzado
hace 5 años con respecto a la fecha actual. Tendrás que hacer uso de alguna de las funciones Date Time. Intenta averiguar cual.
Fijarse que este procedimiento es un buen candidato para emplear un parámetro en donde indiquemos el número de años. Lo veremos después cuando
expliquemos el paso de datos por parámetros.*/
/*DELIMITER $$

CREATE PROCEDURE atracciones_getListConAntiguedad5()
begin
	select nombre
    from ATRACCIONES 
    where YEAR(fecha_inicio)>=YEAR(NOW())-5;
end$$

DELIMITER ;

call artistas_getListAnimales();*/

/* Ejercicio4. Crea un procedimiento de nombre animales_Leo_getPista() que muestre los datos de la pista donde trabaja el animal de nombre 'Leo'.
Hacerlo empleando una variable local que guarde el nombre de la pista. Después consultar los datos de la pista empleando dicha variable local.*/
/*DELIMITER $$

CREATE PROCEDURE animales_Leo_getPista()
begin
declare v_nombrePista varchar(50) default '';

select nombre_pista 
into v_nombrePista
from ANIMALES
where nombre like 'leo';

select * 
from PISTAS 
where nombre=v_nombrePista;

end$$

DELIMITER ;

call animales_Leo_getPista();*/

/* Ejercicio5. Crea un procedimiento de nombre atracciones_getUltima() que obtenga los datos de la última atracción celebrada (tabla ATRACCION_DIA),
empleando variables locales. Para ello guarda en una variable el nombre de la última atracción celebrada y busca los datos de dicha atracción. Ten en
cuenta limitar con LIMIT el número de filas que devuelva una consulta si no sabes con certeza que vaya a devolver una única fila y vas a guardar el datos
en una variable.*/
/*DELIMITER $$

CREATE PROCEDURE atracciones_getUltima() 
begin 
declare v_ultimaAtraccion VARCHAR(50) default '';

select nombre_atraccion
into v_ultimaAtraccion 
from ATRACCION_DIA
order by fecha DESC
LIMIT 1;

select * 
from ATRACCIONES
where nombre=v_ultimaAtraccion;

end$$

DELIMITER ;

call atracciones_getUltima();*/

/* Ejercicio6. Crea un procedimiento de nombre atracciones_getArtistaUltima() que obtenga los datos de la atracción y del artista que trabaja en dicha
atracción, cuya fecha de inicio ha empezado más tarde. Emplea dos variables. Una para guardar el nif del artista y otra para guardar el nombre de la atracción.*/
/*DELIMITER $$

CREATE PROCEDURE atracciones_getArtistaUltima()
begin 
declare v_nifUltimoArtista char(9) default '';
declare v_nombreUltimaAtraccion varchar(50) default '';

select nombre_atraccion,nif_artista
into v_nombreUltimaAtraccion,v_nifUltimoArtista
from ATRACCIONES_ARTISTAS
order by fecha_inicio desc
limit 1;

select *
from ATRACCIONES atr , ARTISTAS art
where atr.nombre=v_nombreUltimaAtraccion and art.nif=v_nifUltimoArtista;

end$$

DELIMITER ;

call atracciones_getArtistaUltima();*/

-- PROCEDIMIENTOS CON PARÁMETRO DE ENTRADA

/* Ejercicio 1: Crea un procedimiento de nombre artistas_getAnimalesPorNif que devuelva los animales que cuida un artista. Llevará como parámetro el nif de artista.*/
/*DELIMITER $$

CREATE PROCEDURE artistas_getAnimalesPorNif(v_nifArtista CHAR(9))
begin 

select ani.*
from ANIMALES ani, ANIMALES_ARTISTAS anArt
where ani.nombre=anArt.nombre_animal and anArt.nif_artista=v_nifArtista;

end$$

DELIMITER ;

call artistas_getAnimalesPorNif("11111111A");*/

/* Ejercicio 2: Crea un procedimiento de nombre artistas_getAnimalesPorNombreApel que devuelva los animales que cuida un artista. Llevará como parámetro el nombre y
apellidos del artista. Suponemos que el nombre y apellidos conforman una clave alternativa.*/ 
/*DELIMITER $$

CREATE PROCEDURE artistas_getAnimalesPorNombreApel(v_nombreArtista VARCHAR(45), v_apellidoArtista VARCHAR(100))
begin 
	declare v_nifArtista char(9);
    
	select nif
	into v_nifArtista
	from ARTISTAS
	where apellidos = v_apellidoArtista AND nombre = v_nombreArtista
    limit 1;

	select distinct ani.*
	from ANIMALES ani join ANIMALES_ARTISTAS anArt
	on ani.nombre=anArt.nombre_animal
    where anArt.nif_artista=v_nifArtista
    order by nombre;

end$$

DELIMITER ;

call artistas_getAnimalesPorNombreApel("Juan","Lopez");*/

/* Ejercicio 3: Crea un procedimiento de nombre atracciones_getListConAntiguedad que devuelva los datos de las atracciones que
hayan comenzado hace un número de años con respecto a la fecha actual. Tendrás que hacer uso de alguna de las funciones Date
Time. Intenta averiguar cual.*/

/*DELIMITER $$

CREATE PROCEDURE atracciones_getListConAntiguedad(p_anos INT)
begin 

	SELECT * 
    FROM ATRACCIONES 
    WHERE fecha_inicio BETWEEN DATE_SUB(curdate(), INTERVAL p_anos YEAR) AND  curdate()
    order by nombre;

end$$

DELIMITER ;

call atracciones_getListConAntiguedad(30);*/

/* Ejercicio 4: Crea un procedimiento de nombre artistas_getListMasAnimalesCuida que devuelva los datos del/os artista/s que cuidan a más animales de los indicados
(parámetro que se le envía).
Pista: Como la consulta puede devolver más de un artista no podremos hacer uso de INTO....*/

DELIMITER $$ 

CREATE PROCEDURE artistas_getListMasAnimalesCuida(p_numAni INT) 
BEGIN
	
    SELECT 
    
END$$

DELIMITER ;



