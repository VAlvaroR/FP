/*Ejercicio 1
Crea una función de nombre utilidades_getMesEnLetra a la que se le pase un número y devuelva el nombre del mes. En caso de que el número no se corresponda con ningún mes, debe devolver null.

Fijarse que esta función es determinista.
Llama a la función directamente y guarda el resultado en una variable de sesión.
Llama a la función para que muestre los meses en letra en los que se celebró la atracción 'El gran felino'.
Llama a la función para que muestre las atracciones que se celebraron en ABRIL (busca por la cadena ABRIL) (recuerda hacer uso de COLLATE).
Nota: Indicar que Mysql ya dispone de dicha función, a la que se le pasa una fecha y devuelve el mes en forma de cadena: monthname().*/

DELIMITER //

CREATE FUNCTION utilidades_getMesEnLetra() RETURNS 