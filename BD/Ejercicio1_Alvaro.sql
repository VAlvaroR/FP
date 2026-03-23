/* 1Modifica la tabla cliente para anadir estas columnas: descuento de tipo DECIMAL(5,2) y
codigo_promocional de tipo VARCHAR(20).*/

ALTER TABLE cliente ADD COLUMN descuento DECIMAL(5,2), ADD COLUMN codigo_promocional VARCHAR(20);

/* 2Crea una funcion llamada calcular_descuento que reciba el valor de limite_credito y devuelva
el descuento que corresponde segun estas reglas: menor de 10000 -> 0; entre 10000 y
30000 -> 5; entre 30001 y 60000 -> 10; mayor de 60000 -> 15.*/

DELIMITER $$

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

DELIMITER ;

/* 3Crea un procedimiento llamado actualizar_columna_descuento que recorra todos los clientes
mediante un cursor, calcule el descuento con la funcion anterior y actualice la columna
descuento.*/

DELIMITER $$

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

DELIMITER ;