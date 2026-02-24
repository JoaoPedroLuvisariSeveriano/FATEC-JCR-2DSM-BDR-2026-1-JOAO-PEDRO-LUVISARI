CREATE DATABASE queimadas_db;

USE queimadas_db;

CREATE TABLE focos_calor ( estado VARCHAR(50), bioma VARCHAR(50), data_ocorrencia DATE

INSERT INTO focos_calor (estado, bioma, data_ocorrencia) VALUES ('Amazonas', 'Amazônia', '2025-02-01'), ('Mato Grosso', 'Cerrado', '2025-02-03'), ('Pará', 'Amazônia', '2025-02-05');

SELECT * FROM focos_calor;