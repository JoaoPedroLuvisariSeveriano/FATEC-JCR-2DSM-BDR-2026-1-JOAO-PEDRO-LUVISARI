-- ==============================================================================
-- ARQUIVO: schema.sql
-- ATIVIDADE: Prática Aula 12 - Índices
-- ==============================================================================

-- Preparação do Ambiente e Importação de Dados
DROP TABLE IF EXISTS carro, pessoa; 

CREATE TABLE IF NOT EXISTS pessoa ( 
    id_pessoa INTEGER PRIMARY KEY, 
    nome VARCHAR(100) NOT NULL, 
    nascimento DATE 
); 

CREATE TABLE IF NOT EXISTS carro ( 
    id_carro INTEGER PRIMARY KEY, 
    placa CHAR(7) NOT NULL, 
    ano INTEGER, 
    id_pessoa INTEGER NOT NULL, 
    FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa) ON DELETE CASCADE 
); 

-- ATENÇÃO: Ajuste os caminhos abaixo para o local real no seu computador
COPY pessoa (id_pessoa, nome, nascimento) 
FROM 'C:/caminho/aula3_pessoa.csv' DELIMITER ',' CSV HEADER; 

COPY carro (id_carro, placa, ano, id_pessoa) 
FROM 'C:/caminho/aula3_carro.csv' DELIMITER ',' CSV HEADER; 

-- ==============================================================================
-- EXERCÍCIO 1
-- ==============================================================================
-- Parte A
EXPLAIN ANALYZE SELECT * FROM pessoa WHERE nome = 'Ana Silva';
EXPLAIN ANALYZE SELECT * FROM pessoa WHERE nome = 'João Santos';

-- Parte B
CREATE INDEX idx_pessoa_nome ON pessoa (nome); 

-- Parte C (Repetindo a Parte A com índice)
EXPLAIN ANALYZE SELECT * FROM pessoa WHERE nome = 'Ana Silva';
EXPLAIN ANALYZE SELECT * FROM pessoa WHERE nome = 'João Santos';

-- ==============================================================================
-- EXERCÍCIO 2
-- ==============================================================================
-- Parte A
DROP INDEX IF EXISTS idx_pessoa_nome; 
EXPLAIN ANALYZE SELECT * FROM pessoa WHERE nascimento >= DATE '1970-01-01'; 

-- Parte B
CREATE INDEX idx_pessoa_nascimento ON pessoa (nascimento); 

-- Parte C
EXPLAIN ANALYZE SELECT * FROM pessoa WHERE nascimento >= DATE '1970-01-01'; 

-- ==============================================================================
-- EXERCÍCIO 3
-- ==============================================================================
-- Parte A
DROP INDEX IF EXISTS idx_pessoa_nascimento; 
EXPLAIN ANALYZE SELECT * FROM pessoa WHERE nascimento >= DATE '2000-01-01' AND nome = 'Ana Silva'; 

-- Parte B
CREATE INDEX idx_pessoa_nascimento_nome ON pessoa (nascimento, nome); 

-- Parte C
EXPLAIN ANALYZE SELECT * FROM pessoa WHERE nascimento >= DATE '2000-01-01' AND nome = 'Ana Silva'; 

-- Parte D
EXPLAIN ANALYZE SELECT * FROM pessoa WHERE nome = 'Ana Silva'; 

-- ==============================================================================
-- EXERCÍCIO 4
-- ==============================================================================
-- Parte A
DROP INDEX IF EXISTS idx_pessoa_nascimento_nome; 
CREATE INDEX idx_pessoa_nascimento ON pessoa (nascimento); 
CREATE INDEX idx_pessoa_nome ON pessoa (nome); 

-- Parte B
EXPLAIN ANALYZE SELECT * FROM pessoa WHERE nascimento >= DATE '2000-01-01' AND nome = 'Ana Silva'; 

-- ==============================================================================
-- EXERCÍCIO 5
-- ==============================================================================
-- Limpeza prévia
DROP INDEX IF EXISTS idx_pessoa_nascimento; 
DROP INDEX IF EXISTS idx_pessoa_nome; 

-- Consulta inicial
EXPLAIN ANALYZE SELECT * FROM carro WHERE ano BETWEEN 2015 AND 2020; 

-- Criação do índice adequado
CREATE INDEX idx_carro_ano ON carro (ano);

-- Consulta otimizada
EXPLAIN ANALYZE SELECT * FROM carro WHERE ano BETWEEN 2015 AND 2020; 

-- ==============================================================================
-- EXERCÍCIO 6
-- ==============================================================================
-- Limpeza prévia
DROP INDEX IF EXISTS idx_carro_ano;

-- Criação dos índices para otimizar o JOIN
CREATE INDEX idx_pessoa_nome ON pessoa(nome);
CREATE INDEX idx_carro_id_pessoa ON carro(id_pessoa);

-- Consulta Otimizada
EXPLAIN ANALYZE 
SELECT p.nome, c.placa 
FROM pessoa p 
JOIN carro c ON p.id_pessoa = c.id_pessoa 
WHERE p.nome = 'Ana Silva'; 

-- ==============================================================================
-- EXERCÍCIO 7
-- ==============================================================================
-- Limpeza prévia
DROP INDEX IF EXISTS idx_pessoa_nome;
DROP INDEX IF EXISTS idx_carro_id_pessoa;

-- Criação dos índices focados no JOIN e Filtros
-- Justificativa na seção teórica abaixo
CREATE INDEX idx_pessoa_nascimento ON pessoa (nascimento);
CREATE INDEX idx_carro_id_pessoa_ano ON carro (id_pessoa, ano);

EXPLAIN ANALYZE 
SELECT p.nome, c.placa, c.ano 
FROM pessoa p 
JOIN carro c ON p.id_pessoa = c.id_pessoa 
WHERE p.nascimento >= DATE '1980-01-01' AND c.ano >= 2018;

-- ==============================================================================
-- EXERCÍCIO 8
-- ==============================================================================
-- Limpeza prévia
DROP INDEX IF EXISTS idx_pessoa_nascimento;
DROP INDEX IF EXISTS idx_carro_id_pessoa_ano;

-- Parte A
EXPLAIN ANALYZE SELECT * FROM pessoa WHERE nascimento BETWEEN DATE '1980-01-01' AND DATE '1990-12-31'; 

-- Parte B
CREATE EXTENSION IF NOT EXISTS btree_gist; 
CREATE INDEX idx_pessoa_nascimento_gist ON pessoa USING GIST (nascimento); 

-- Parte C
EXPLAIN ANALYZE SELECT * FROM pessoa WHERE nascimento BETWEEN DATE '1980-01-01' AND DATE '1990-12-31';