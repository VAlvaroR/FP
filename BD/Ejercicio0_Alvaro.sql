/* 1. Crea una función que dado el código de un pedido devuelva el importe a pagar de ese pedido.*/

DELIMITER //

CREATE FUNCTION importe_pedido (p_codigoPedido INT) RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN
	DECLARE v_importeTotal DECIMAL(10,2);
    
	SELECT sum(cantidad*precio_unidad)
    INTO v_importeTotal
    FROM detalle_pedido
    WHERE codigo_pedido = p_codigoPedido;

	RETURN IFNULL(v_importeTotal, 0);
END//

DELIMITER ;

/* 2. Crea una función que dado el código de un cliente devuelva el total que ha pagado ese cliente.*/

DELIMITER //

CREATE FUNCTION importe_cliente(p_codigoCliente INT) RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN
	DECLARE v_importeTotal DECIMAL(15,2) DEFAULT 0;
    
    SELECT SUM(total)
    INTO v_importeTotal
    FROM pago
    WHERE codigo_cliente=p_codigoCliente;
    
    RETURN IFNULL(v_importeTotal, 0);
END //

DELIMITER ;

/* 3. Crea un procedimiento que haciendo uso de las funciones anteriores, usando cursores y dado un código de cliente, devuelva si un cliente debe dinero o no.
Pasos:
   a. Calcula dentro del procedimiento cuánto es el total de todos los pedidos del cliente.
(deberás realizar una consulta obteniendo todos los pedidos del cliente, y haciendo uso de cursores
podrás calcular este apartado)
   b. Calcula dentro del procedimiento cuánto ha pagado ese cliente.
   c. Compara dentro del procedimiento ambos valores y muestra ‘el cliente lo ha pagado todo’ o ‘el cliente es moroso’.
Si el código del cliente no es correcto el procedimiento se parará.  
*/

DELIMITER //

CREATE PROCEDURE clienteMoroso(IN p_codigoCliente INT)
BEGIN
	DECLARE v_codigoPedido INT;
    DECLARE v_acumulado DECIMAL(10,2) DEFAULT 0;
    DECLARE v_nohaymas INT DEFAULT FALSE;
    DECLARE v_totalPagadoCliente DECIMAL(10,2) DEFAULT 0;
    DECLARE cur_pedido CURSOR FOR 
		SELECT codigo_pedido FROM pedido
        WHERE codigo_cliente= p_codigoCliente;
        
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_nohaymas=TRUE;
    
    IF (select count(*) from cliente where codigo_cliente=p_codigoCliente) = 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Codigo cliente incorrecto';
	END IF;
    
    OPEN cur_pedido;
    
    leer: LOOP
		FETCH cur_pedido INTO v_codigoPedido;
        IF v_nohaymas THEN
			LEAVE leer;
		END IF;
        SET v_acumulado = v_acumulado + importe_pedido(v_codigoPedido);
	END LOOP;
    CLOSE cur_pedido;
    
    SET v_totalPagadoCliente = total_pagado_cliente(p_codigoCliente);
    
    IF v_acumulado > v_totalPagadoCliente then
		SELECT "El cliente es moroso";
	ELSE
		SELECT "El cliente no debe dinero";
	END IF;
    
    
END //

DELIMITER ; 

/* 4. Crea un trigger de nombre trigger_acumulado_clientes que guardará en una tabla el acumulado que llevan pagados los clientes.
   a. Crea una tabla que se llame ‘acumulado_clientes’ que tendrá el codigo del cliente y el total acumulado.
   b. Vuelca en la tabla nueva todos los códigos de clientes y en la columna total acumulado ponle valor 0 por defecto.
   c. Recorre la tabla nueva y consultando la tabla pagos, usando la función del ejercicio 2, actualiza la tabla nueva con los nuevos valores.
   d. Finalmente, crea el trigger que se ejecute cada vez que se inserte un pago en la tabla pagos, deberá actualizar la tabla nueva con el nuevo valor.*/
   
CREATE TABLE acumulado_clientes (codigo_cliente INT PRIMARY KEY, totalAcumulado DECIMAL(10,2) DEFAULT 0);

INSERT INTO acumulado_clientes (codigo_cliente) 
select codigo_cliente from cliente;

UPDATE acumulado_clientes SET totalAcumulado = total_pagado_cliente (codigo_cliente);

DELIMITER $$

CREATE TRIGGER pago_acumulado AFTER INSERT ON pago FOR EACH ROW
BEGIN 
	UPDATE acumulado_clientes
    SET total_acumulado = total_acumulado + new.total
    where codigo_cliente = new.codigo_cliente;
END$$

DELIMITER ;


