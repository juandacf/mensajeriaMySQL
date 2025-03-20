CREATE DATABASE IF NOT EXISTS mensajeria;
USE mensajeria;

CREATE TABLE usuarios (
    usuario_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    contrasena VARCHAR(100) NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE conversaciones (
    conversacion_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_conversacion VARCHAR(100) NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE participantes (
    participante_id INT AUTO_INCREMENT PRIMARY KEY,
    conversacion_id INT NOT NULL,
    usuario_id INT NOT NULL,
    fecha_union TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (conversacion_id) REFERENCES conversaciones(conversacion_id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id) ON DELETE CASCADE
);

CREATE TABLE mensajes (
    mensaje_id INT AUTO_INCREMENT PRIMARY KEY,
    conversacion_id INT NOT NULL,
    remitente_id INT NOT NULL,
    contenido TEXT NOT NULL,
    fecha_envio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (conversacion_id) REFERENCES conversaciones(conversacion_id) ON DELETE CASCADE,
    FOREIGN KEY (remitente_id) REFERENCES usuarios(usuario_id) ON DELETE CASCADE
);


INSERT INTO usuarios (nombre, email, contrasena)
VALUES ('Juan Pérez', 'juan.perez@example.com', 'password123'),
('María López', 'maria.lopez@example.com', 'maria1234'),
('Carlos Martínez', 'carlos.martinez@example.com', 'carlo_pass'),
('Ana Fernández', 'ana.fernandez@example.com', 'ana2023'),
('Luis Gómez', 'luis.gomez@example.com', 'luis_pass'),
('Lucía Rivera', 'lucia.rivera@example.com', 'lucia2023'),
('Pedro Ortiz', 'pedro.ortiz@example.com', 'pedro_pass'),
('Sofía Blanco', 'sofia.blanco@example.com', 'sofiablanco123'),
('Miguel Rojas', 'miguel.rojas@example.com', 'miguerojas2023'),
('Carla Ruiz', 'carla.ruiz@example.com', 'carlitaaruiz');