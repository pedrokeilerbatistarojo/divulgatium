-- Crear usuario 'divulgatium-app'
CREATE USER 'divulgatium-app'@'%' IDENTIFIED BY 'db-p@55w0rd/*';

-- Crear base de datos 'divulgatium-app' y asignar privilegios
CREATE DATABASE IF NOT EXISTS `divulgatium-app`;
GRANT ALL PRIVILEGES ON `divulgatium-app`.* TO 'divulgatium-app'@'%';

