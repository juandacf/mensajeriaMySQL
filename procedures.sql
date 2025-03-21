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

    SELECT COUNT(usuario_id) INTO numero_inicial FROM usuarios WHERE usuario_id=input_id;
    INSERT INTO usuarios(nombre,email,contrasena) VALUES(input_nombre, input_email, input_contrasena);
    SELECT COUNT(usuario_id) INTO numero_final FROM usuarios WHERE usuario_id=input_id;

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

    SELECT COUNT(usuario_id) INTO numero_inicial FROM usuarios WHERE usuario_id=input_id;
    DELETE FROM usuarios WHERE usuario_id = input_id;
    SELECT COUNT(usuario_id) INTO numero_final FROM usuarios WHERE usuario_id=input_id;

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

DROP PROCEDURE IF EXISTS update_user;

DELIMITER $$

CREATE PROCEDURE update_user(
    IN input_id INT,
    IN new_name VARCHAR(50),
    IN new_email VARCHAR(100),
    IN new_password VARCHAR(100),
    OUT validation_message VARCHAR(100)
)
BEGIN
DECLARE initial_name VARCHAR (50);
DECLARE final_name  VARCHAR (100);

SET validation_message = 'Los datos no pudieron ser actualizados.';
SELECT nombre INTO initial_name FROM usuarios WHERE usuario_id=input_id;

UPDATE usuarios
SET nombre=new_name,
email = new_email,
contrasena= new_password
WHERE usuario_id = input_id;

SELECT nombre INTO final_name FROM usuarios WHERE usuario_id=input_id;

SET validation_message = 'Los datos pudieron ser actualizados.';

END $$
DELIMITER ;

SET @resultado = '';
CALL update_user (1, "juanchito", "juanchito@gmail.com", "juanchito123", @resultado);
SELECT @resultado;






-- Cree un procedimiento almacenado que permita buscar un usuario por su nombre.

DROP PROCEDURE IF EXISTS find_by_name;

DELIMITER $$
CREATE PROCEDURE find_by_name ( 
    IN input_name VARCHAR(50)
)
BEGIN

SELECT usuario_id, nombre, email, contrasena, fecha_creacion 
FROM usuarios 
WHERE nombre=input_name;

END$$
DELIMITER ;




-- Realice una consulta que permita iniciar una conversación.

DROP PROCEDURE IF EXISTS start_conversation;

DELIMITER $$
CREATE PROCEDURE start_conversation(
    IN input_conversation_name VARCHAR(100)
)
BEGIN
    INSERT INTO conversaciones (nombre_conversacion) VALUES (input_conversation_name);
END$$
DELIMITER ;

CALL start_conversation ("nueva conversación!!!");

SELECT * FROM conversaciones;





-- Realice un procedimiento almacenado que permita agregar un nuevo participante a la conversación y valide si hay capacidad disponible. La cantidad maxima por cada conversación son 5 usuarios.

DROP PROCEDURE IF EXISTS  add_participant;

DELIMITER $$
CREATE PROCEDURE add_participant(
    IN input_idConversation INT,
    IN input_idUser INT,
    OUT final_message VARCHAR(100)
)

BEGIN
    DECLARE current_users INT;
    
    SELECT COUNT(participante_id) INTO current_users FROM participantes WHERE conversacion_id = input_idConversation;

    IF current_users < 5 THEN
        INSERT INTO participantes(conversacion_id, usuario_id) VALUES (input_idConversation, input_idUser);
        SET final_message = 'El usuario pudo ser añadido a la conversación';
    ELSE
        SET final_message = 'El usuario no pudo ser añadido a la conversación. El límite  de 5 usuarios fue alcanzado.';
    END IF;
    
END $$
DELIMITER ;

SET @mensaje = '';
CALL add_participant(1,1, @mensaje);

SELECT @mensaje;
-- Realice un procedimiento que permita visualizar los mensaje de una conversación.
-- Realice un procedimiento almacenado para enviar un mensaje a una conversación.
-- Modifica la estructura de la tabla para que permita el envio de los mensaje a todos los usuarios o a un usuario en particular. y realice las siguientes consultas.

-- Realice un procedimiento almacenado que permita visualizar los mensajes de un usuario especifico.

-- Realice un procedimiento almacenado que permita eliminar a un usuario que no esta respetando las normas de buena conversación. Agregue una tabla que permita agregar palabra no deseadas. El procedimiento debe inspeccionar la conversación a verificar.