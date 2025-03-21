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

DROP PROCEDURE IF EXISTS view_messages;

DELIMITER $$

CREATE PROCEDURE view_messages(
 IN input_conversacion_id INT
)
BEGIN

SELECT mensaje_id, remitente_id, contenido 
FROM mensajes
WHERE conversacion_id= input_conversacion_id;


END $$
DELIMITER ;

CALL view_messages(1);
-- Realice un procedimiento almacenado para enviar un mensaje a una conversación.

DROP PROCEDURE IF EXISTS send_message;

DELIMITER $$

CREATE PROCEDURE send_message(
    IN input_conversacion_id INT,
    IN input_remitente_id INT,
    IN input_contenido TEXT
)


BEGIN 

 INSERT INTO mensajes(conversacion_id, remitente_id, contenido) VALUES (input_conversacion_id, input_remitente_id, input_contenido);
END$$
DELIMITER ;

CALL send_message(1,1, "hola, neitas");


-- Modifica la estructura de la tabla para que permita el envio de los mensaje a todos los usuarios o a un usuario en particular. y realice las siguientes consultas.

CREATE TABLE mensajes (
    mensaje_id INT AUTO_INCREMENT PRIMARY KEY,
    conversacion_id INT NOT NULL,
    remitente_id INT NOT NULL,
    destinatario_id INT NULL, -- NULL significa "a todos", un valor específico indica un usuario particular
    contenido TEXT NOT NULL,
    fecha_envio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (conversacion_id) REFERENCES conversaciones(conversacion_id) ON DELETE CASCADE,
    FOREIGN KEY (remitente_id) REFERENCES usuarios(usuario_id) ON DELETE CASCADE,
    FOREIGN KEY (destinatario_id) REFERENCES usuarios(usuario_id) ON DELETE SET NULL
);

-- Realice un procedimiento almacenado que permita visualizar los mensajes de un usuario especifico.

DELIMITER $$

CREATE PROCEDURE VerMensajesUsuario(IN p_usuario_id INT)
BEGIN
    SELECT 
        m.mensaje_id,
        c.nombre_conversacion,
        u1.nombre AS remitente,
        u2.nombre AS destinatario,
        m.contenido,
        m.fecha_envio
    FROM mensajes m
    JOIN conversaciones c ON m.conversacion_id = c.conversacion_id
    JOIN usuarios u1 ON m.remitente_id = u1.usuario_id
    LEFT JOIN usuarios u2 ON m.destinatario_id = u2.usuario_id
    WHERE m.remitente_id = p_usuario_id 
       OR m.destinatario_id = p_usuario_id 
       OR (m.destinatario_id IS NULL AND EXISTS (
           SELECT 1 
           FROM participantes p 
           WHERE p.conversacion_id = m.conversacion_id 
           AND p.usuario_id = p_usuario_id
       ))
    ORDER BY m.fecha_envio DESC;
END $$

DELIMITER ;
-- Realice un procedimiento almacenado que permita eliminar a un usuario que no esta respetando las normas de buena conversación. Agregue una tabla que permita agregar palabra no deseadas. El procedimiento debe inspeccionar la conversación a verificar.

CREATE TABLE palabras_prohibidas (
    palabra_id INT AUTO_INCREMENT PRIMARY KEY,
    palabra VARCHAR(50) NOT NULL UNIQUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$

CREATE PROCEDURE EliminarUsuarioInfractor(IN p_usuario_id INT)
BEGIN
    DECLARE v_mensajes_infractores INT;

    -- Contar mensajes que contienen palabras prohibidas
    SELECT COUNT(*) INTO v_mensajes_infractores
    FROM mensajes m
    JOIN palabras_prohibidas pp
    WHERE m.remitente_id = p_usuario_id
    AND m.contenido REGEXP CONCAT('[[:<:]]', pp.palabra, '[[:>:]]');

    IF v_mensajes_infractores > 0 THEN
        -- Opción 1: Eliminar al usuario de todas las conversaciones
        DELETE FROM participantes WHERE usuario_id = p_usuario_id;
        
        -- Opción 2: Eliminar completamente al usuario (descomentar si es lo deseado)
        -- DELETE FROM usuarios WHERE usuario_id = p_usuario_id;

        SELECT CONCAT('Usuario ', p_usuario_id, ' eliminado por violar normas (', v_mensajes_infractores, ' mensajes infractores).') AS resultado;
    ELSE
        SELECT 'El usuario no ha violado las normas.' AS resultado;
    END IF;
END $$

DELIMITER ;

