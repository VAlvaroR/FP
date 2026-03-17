
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

/* Ejercicio 4: Crea un procedimiento de nombre artistas_getListMasAnimalesCuida que devuelva los datos del/os artista/s que cuidan a más animales
de los indicados (parámetro que se le envía).
Pista: Como la consulta puede devolver más de un artista no podremos hacer uso de INTO....*/

/* DELIMITER $$ 

CREATE PROCEDURE artistas_getListMasAnimalesCuida(p_numAni INT) 
BEGIN
	SELECT art.* FROM ARTISTAS art
    WHERE art.nif IN (SELECT anArt.nif_artista
			   from ANIMALES_ARTISTAS anArt
               GROUP BY nif_artista 
               having p_numAni < count(*))
	ORDER BY nif;

    
END$$

DELIMITER ;

call artistas_getListMasAnimalesCuida(1);*/

/* Ejercicio 5: Crea un procedimiento de nombre atracciones_getListPorFecha que devuelva los datos de las atracciones que han comenzado
a partir de la fecha indicada.
Pista: Recordar que las fechas son tratadas como cadenas...y tener en cuenta el formato.
Añade una nueva atracción con la fecha de inicio actual.
Llama al procedimiento empleando la fecha actual menos 3 días (haz uso de la función DATE_SUB y curdate)*/

/*DELIMITER $$

CREATE PROCEDURE atracciones_getListPorFecha(p_fechaInd char(10))
begin
	SELECT * 
    FROM ATRACCIONES 
    WHERE fecha_inicio > p_fechaInd
    ORDER BY nombre;

end$$

DELIMITER ;

call atracciones_getListPorFecha('2001-01-01');
call atracciones_getListPorFecha(DATE_SUB(curdate(), INTERVAL 3 DAY));*/


/* Ejercicio 6: Crea un procedimiento de nombre pistas_add y que añada una nueva pista.
Nota: Aún no vimos la validación de datos que tendría que darse en el paso de parámetros. 
En este caso podríamos tener condiciones if en el que se comprueba sin el aforo es mayor que cero....
Se puede hacer uso de la función ROW_COUNT() para saber cuantas filas fueron añadidas, borradas o modificadas.
Importante: Los parámetros deben de tener el mismo tipo de dato y tamaño que el que está definido a nivel de columnas en la tabla PISTAS.*/

/*DELIMITER $$

CREATE PROCEDURE pistas_add(p_nombre VARCHAR(50), p_aforo smallint)
begin
	insert into PISTAS (nombre, aforo) VALUES (p_nombre, p_aforo);
	select row_count();
	
end$$

DELIMITER ;

CALL pistas_add('El gran misil',134);*/


/* Ejercicio 7: Crea un procedimiento de nombre atracciones_update que permita modificar los datos de una atracción
(no se permite actualizar su clave primaria).
Modifica la fecha de inicio de la atracción 'El gran felino' y ponla un día después de la que tiene ahora mismo.
Pista: Tendrás que guardar las ganancias y la fecha de inicio que tiene para poder enviar ese dato al procedimiento.
Comprueba como al llamar al método con una atracción que no existe, row_count va a devolver 0.*/

/*DELIMITER $$

CREATE PROCEDURE atracciones_update(p_nombre varchar(50), p_fecIni DATE, p_ganancias decimal(8,2))
begin
	
    UPDATE ATRACCIONES SET fecha_inicio = p_fecIni, ganancias = p_ganancias 
    WHERE nombre = p_nombre;
	
    SELECT row_count();
    
end$$

DELIMITER ;*/


/* Ejercicio 8: Crea un procedimiento de nombre pistas_delete que borre una pista por su nombre. Haz que borre en
base al patrón nombre% (empleando el Like). Borra la atracción que hayas añadido en el ejercicio 6 mandando las
primeras letras (ten cuidado de que no haya otra atracción con esas letras al comienzo).
Pista: Emplea la función CONCAT paraPISTAS el LIKE*/

/*DELIMITER $$

CREATE PROCEDURE pistas_delete(p_nombre VARCHAR(50))
BEGIN
	DELETE FROM PISTAS WHERE nombre LIKE concat(p_nombre,'%');

END$$

DELIMITER ;

CALL pistas_delete('El gran m');*/

-- PROCEDIMIENTOS CON PARÁMETRO DE SALIDA

/* Ejercicio 1
Crea un procedimiento de nombre pistas_getAforo al que se le pase el nombre de una pista y devuelve en forma de parámetro
de salida su aforo.*/
/*DELIMITER $$ 

CREATE PROCEDURE pistas_getAforo(p_nombre VARCHAR(50), OUT p_aforo smallint)
begin
	SELECT aforo INTO p_aforo FROM PISTAS WHERE nombre=p_nombre;
	
end$$

DELIMITER ;

CALL pistas_getAforo('LATERAL1',@aforo);	
SELECT @aforo;*/

/* Ejercicio 2
Crea un procedimiento de nombre artistas_getNumAnimalesCuida al que se le pase el nif de un artista y que devuelva en forma
de parámetro de salida a cuantos animales cuida.*/
/*DELIMITER $$ 

CREATE PROCEDURE artistas_getNumAnimalesCuida(p_nif VARCHAR(50), OUT p_numAni smallint)
BEGIN
	select count(*) into p_numAni from ANIMALES_ARTISTAS where nif = p_nif;
	
END$$

DELIMITER ;

CALL artistas_getNumAnimalesCuida('11111111A',@numAnimales);	
SELECT @numAnimales;*/

/* Ejercicio 3
Crea un procedimiento de nombre animales_getNombreAforo al que se le pase el nombre de un animal y devuelva, empleando un
parámetro de salida y haciendo uso del procedimiento creado en el ejercicio 1, de una cadena con el formato: NombreAnimal:peso:pista:aforo
Pista: Emplea la función CONCAT*/
/*DELIMITER $$ 

CREATE PROCEDURE animales_getNombreAforo(p_nombreAnimal VARCHAR(50), OUT p_sal VARCHAR(100))
BEGIN
	DECLARE v_peso float;
    DECLARE v_aforo smallint;
    DECLARE v_nombrePista varchar(50);
    
    SELECT nombre_pista, peso
    INTO v_nombrePista, v_peso
    FROM ANIMALES
    where nombre=p_nombreAnimal;
    
    CALL pistas_getAforo(v_nombrePista, v_aforo);
    
    SET p_sal = CONCAT(p_nombreAnimal,':',v_peso,':',v_nombrePista,':',v_aforo);
	
END$$
DELIMITER ;*/


/* Ejercicio 4
Crea un procedimiento de nombre artistas_getNumAtracAnimal al que se le pase los apellidos y nombre de un artista y devuelva,
empleando un parámetro de salida, el número de atracciones en las que trabaja y el número de animales que cuida (empleando el
procedimiento del ejercicio 2) con el formato: nif:NumAtracciones:NumAnimales.
Nota: Suponemos que no hay artistas con el mismo nombre y apellidos.*/
/*DELIMITER $$

CREATE PROCEDURE artistas_getNumAtracAnimal(p_apellidos VARCHAR(100), p_nombre VARCHAR(45), OUT p_sal VARCHAR(100))
BEGIN
	DECLARE v_nif char(9);
    DECLARE v_numAtracciones smallint;
    DECLARE v_numAnimales varchar(50);
    
    SELECT nif
    INTO v_nif
    FROM ARTISTAS
    WHERE nombre = p_nombre AND p_apellidos = apellidos;
    
    SELECT count(*)
    INTO v_numAtracciones
    FROM ATRACCIONES_ARTISTAS
    where fecha_fin is null and nif_artista=v_nif;
    
    CALL artistas_getNumAnimalesCuida(v_nif, v_numAtracciones);
    
    SET p_sal = CONCAT(v_nif,':',v_numAtracciones,':',v_numAnimales);
	
END$$
DELIMITER ;*/

-- PROCEDIMIENTOS CON PARÁMETRO DE ENTRADA/SALIDA

/* Ejercicio 1
Crea un procedimiento de nombre pistas_addAforo al que se le envíe como parámetros el nombre de la pista y una cantidad que representa el incremento del aforo.
El procedimiento debe devolver en el mismo parámetro el nuevo aforo de la pista.
Nota: Aún no vimos el uso de IF pero en este método habría que tener en cuenta si el aforo es superior al rango de un smallint...*/

/*DELIMITER $$

CREATE PROCEDURE pistas_addAforo(p_nombrePista VARCHAR(50), INOUT p_incrAforo smallint)
BEGIN
	UPDATE PISTAS SET aforo = aforo + p_incrAforo where nombre = p_nombrePista;
    
    select aforo into p_incrAforo from pistas where nombre=p_nombrePista;

END$$

DELIMITER ;

SET @dato = 50;	-- Incremento de aforo
CALL pistas_addAforo('LATERAL1',@dato);	
SELECT @dato;*/

/* Ejercicio 2
Crea un procedimiento de nombre artistas_getNombreCompleto al que se le pase como parámetro el nif y devuelva en el mismo parámetro el nombre completo con el formato: apellidos, nombre*/

/*DELIMITER $$

CREATE PROCEDURE artistas_getNombreCompleto(INOUT p_nif varchar(147))
BEGIN
	select concat(apellidos,', ',nombre) into p_nif from artistas where nif = p_nif;

END$$

DELIMITER ;

SET @dato = '11111111A';	
CALL artistas_getNombreCompleto(@dato);	
SELECT @dato;*/

/* Ejercicio 3
Crea un procedimiento de nombre animales_addAforo al que se le envíe como parámetros el nombre del animal y el incremento del aforo en la pista en la que trabaja el animal. 
Debe de hacer uso del procedimiento creado en el ejercicio 1 y debe de devolver empleando los dos parámetros anteriores, el nombre de la pista y su nuevo aforo.*/

/*DELIMITER $$

CREATE PROCEDURE animales_addAforo(INOUT p_nombre VARCHAR(50), INOUT p_incrAforo smallint)
BEGIN

	select nombre_pista into p_nombre from ANIMALES where nombre=p_nombre;
    call pistas_addAforo(p_nombre,p_incrAforo);
    
END$$

DELIMITER ;

SET @nombre = 'Princesa1';
SET @aforo = 10;

CALL animales_addAforo(@nombre,@aforo);	
SELECT @nombre,@aforo;*/

