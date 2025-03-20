-- Cree un procedimiento almacenado que permita insertar un nuevo usuario retornando un mensaje que indique si la inserción fue satisfactoria.
DROP PROCEDURE IF EXISTS create_user;

DELIMITER $$
CREATE PROCEDURE create_user(
    IN input_nombre VARCHAR(50),
    IN input_email VARCHAR(100),
    IN input_contrasena VARCHAR(100),
    OUT validacion_insercion VARCHAR(255)
)
BEGIN
    DECLARE numero_inicial INTEGER;
    DECLARE numero_final INTEGER;

    SELECT COUNT(usuario_id) INTO numero_inicial FROM usuarios;
    INSERT INTO usuarios(nombre,email,contrasena) VALUES(input_nombre, input_email, input_contrasena);
    SELECT COUNT(usuario_id) INTO numero_final FROM usuarios;

    IF numero_inicial<numero_final THEN
        SET validacion_insercion = 'El registro fue exitoso';
    ELSE 
        SET validacion_insercion = 'El regustro no se completó';
    END IF;


END $$

DELIMITER ;

SET @resultado = '';

CALL create_user('betico', 'betico@gmail.com', 'beticonesuncanson', @resultado);

SELECT @resultado;




-- Cree un procedimiento almacenado que permita eliminar un usuario retornando un mensaje que indique si la inserción fue satisfactoria.
DROP PROCEDURE IF EXISTS delete_user;

DELIMITER $$
CREATE PROCEDURE delete_user(
    IN input_id INT,
    OUT validacion_eliminacion VARCHAR(255)
)
BEGIN
    DECLARE numero_inicial INTEGER;
    DECLARE numero_final INTEGER;

    SELECT COUNT(usuario_id) INTO numero_inicial FROM usuarios;
    DELETE FROM usuarios WHERE usuario_id = input_id;
    SELECT COUNT(usuario_id) INTO numero_final FROM usuarios;

    IF numero_inicial=numero_final THEN
        SET validacion_eliminacion = 'La eliminación no se realizó';
    ELSE 
        SET validacion_eliminacion = 'La eliminación se realizó';
    END IF;
END $$
DELIMITER ;

SET @resultado = '';

CALL delete_user(3, @resultado);

SELECT @resultado;

-- Cree un procedimiento almacenado que permita editar un usuario retornando un mensaje que indique si la inserción fue satisfactoria.
-- Cree un procedimiento almacenado que permita buscar un usuario por su nombre.
-- Realice una consulta que permita iniciar una conversación.
-- Realice un procedimiento almacenado que permita agregar un nuevo participante a la conversación y valide si hay capacidad disponible. La cantidad maxima por cada conversación son 5 usuarios.
-- Realice un procedimiento que permita visualizar los mensaje de una conversación.
-- Realice un procedimiento almacenado para enviar un mensaje a una conversación.
-- Modifica la estructura de la tabla para que permita el envio de los mensaje a todos los usuarios o a un usuario en particular. y realice las siguientes consultas.

-- Realice un procedimiento almacenado que permita visualizar los mensajes de un usuario especifico.

-- Realice un procedimiento almacenado que permita eliminar a un usuario que no esta respetando las normas de buena conversación. Agregue una tabla que permita agregar palabra no deseadas. El procedimiento debe inspeccionar la conversación a verificar.