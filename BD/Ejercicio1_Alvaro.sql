/* 1Modifica la tabla cliente para anadir estas columnas: descuento de tipo DECIMAL(5,2) y
codigo_promocional de tipo VARCHAR(20).*/

-- ALTER TABLE cliente ADD COLUMN descuento DECIMAL(5,2), ADD COLUMN codigo_promocional VARCHAR(20);

/* 2Crea una funcion llamada calcular_descuento que reciba el valor de limite_credito y devuelva
el descuento que corresponde segun estas reglas: menor de 10000 -> 0; entre 10000 y
30000 -> 5; entre 30001 y 60000 -> 10; mayor de 60000 -> 15.*/

/* DELIMITER $$

CREATE FUNCTION calcular_descuento(p_limiteCredito DECIMAL(15,2)) RETURNS DECIMAL(5,2)
BEGIN
	DECLARE v_descuento DECIMAL(5,2) DEFAULT 0;
    
    IF (p_limiteCredito < 10000) THEN
		SET v_descuento = 0;
	ELSEIF (p_limiteCredito <= 30000) THEN
		SET v_descuento = 5;
	ELSEIF (p_limiteCredito <= 60000) THEN
		SET v_descuento = 10;
	ELSEIF (p_limiteCredito > 60000) THEN
		SET v_descuento = 15;
	END IF;
    
    RETURN v_descuento;
    
END$$

DELIMITER ;*/

/* 3Crea un procedimiento llamado actualizar_columna_descuento que recorra todos los clientes
mediante un cursor, calcule el descuento con la funcion anterior y actualice la columna
descuento.*/

/*DELIMITER $$

CREATE PROCEDURE actualizar_columna_descuento ()
BEGIN
	DECLARE v_codigoCliente INT;
	DECLARE v_nohaymas INT DEFAULT FALSE;
    DECLARE cur_cliente CURSOR FOR
		SELECT codigo_cliente from cliente;
        
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_nohaymas=TRUE;
	
    OPEN cur_cliente;
    
    leer:LOOP
		FETCH cur_cliente INTO v_codigoCliente;
        IF v_nohaymas THEN
			LEAVE leer;
		END IF;
        
        UPDATE cliente SET descuento = calcular_descuento(limite_credito) WHERE codigo_cliente=v_codigoCliente;
	END LOOP;
    
    CLOSE cur_cliente;

END $$

DELIMITER ;*/


/* 4Crea un procedimiento llamado crear_codigo_promocional que reciba como entrada
nombre_cliente, ciudad y pais, y devuelva como salida un codigo con este formato: las 2
primeras letras del nombre del cliente, las 3 primeras letras de la ciudad, las 2 primeras
letras del pais, un guion y los 2 ultimos digitos del ano actual.*/

/*DELIMITER $$

CREATE PROCEDURE crear_codigo_promocional (IN p_nombreCliente VARCHAR(50), IN p_ciudad VARCHAR(50), IN p_pais VARCHAR(50), OUT p_codigo VARCHAR(50))
BEGIN

	SET p_codigo = CONCAT(LEFT(p_nombreCliente,2),LEFT(p_ciudad,3), LEFT(p_pais,2),"-",right(left(curdate(),4),2));

END $$


DELIMITER ;

call crear_codigo_promocional("Alvaro","Malaga","España", @hola);
select @hola;*/

/* 5Crea un procedimiento llamado actualizar_columna_codigo_promocional que recorra todos
los clientes mediante un cursor, llame al procedimiento anterior y actualice la columna
codigo_promocional.*/

/*DELIMITER $$ 

CREATE PROCEDURE actualizar_columna_codigo_promocional()
BEGIN 
	DECLARE v_nohaymas INT DEFAULT FALSE;
    DECLARE v_codigoCliente INT;
    DECLARE v_nombreCliente VARCHAR(50);
    DECLARE v_ciudadCliente VARCHAR(50);
    DECLARE v_paisCliente VARCHAR(50);
    DECLARE cur_cliente CURSOR FOR
		SELECT codigo_cliente, nombre_cliente, ciudad, pais from cliente;
	
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_nohaymas = TRUE;
    
    OPEN cur_cliente;
    
    leer:LOOP
		FETCH cur_cliente INTO v_codigoCliente, v_nombreCliente, v_ciudadCliente, v_paisCliente;
		
        IF v_nohaymas THEN
			LEAVE leer;
		END IF;
        
        call crear_codigo_promocional(v_nombreCliente,v_ciudadCliente,v_paisCliente, @codigo_prom);
        
        UPDATE cliente SET codigo_promocional = @codigo_prom WHERE codigo_cliente = v_codigoCliente;
	
	END LOOP;
    
    CLOSE cur_cliente;
END$$

DELIMITER ;

call actualizar_columna_codigo_promocional();*/

/* 6Crea un procedimiento llamado crear_lista_codigos_clientes que devuelva en una unica
cadena todos los valores de la columna codigo_promocional, separados por punto y coma.*/

DELIMITER $$

CREATE PROCEDURE crear_lista_codigos_clientes(OUT p_cadena VARCHAR(50))
BEGIN

	

END$$

DELIMITER ;



