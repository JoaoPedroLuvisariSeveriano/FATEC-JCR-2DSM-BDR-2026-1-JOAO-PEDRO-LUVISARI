-- 1. Criar o banco de dados
CREATE DATABASE bd_escola;

-- Conectar ao banco bd_escola antes de rodar os próximos comandos

-- 2. Criar tabelas
CREATE TABLE cursos (
    id_curso SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE alunos (
    id_aluno SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    idade INT,
    id_curso INT REFERENCES cursos(id_curso)
);

-- 3. Inserir dados (INSERT)
INSERT INTO cursos (nome) VALUES ('Engenharia Civil');

INSERT INTO alunos (nome, idade, id_curso) VALUES ('João Silva', 22, 1);

-- Inserindo múltiplos registros
INSERT INTO cursos (nome) VALUES
('Análise de Sistemas'),
('Computação'),
('Matemática');

INSERT INTO alunos (nome, idade, id_curso) VALUES
('Maria Souza', 20, 3),
('Carlos Lima', 25, 4);

-- 4. Atualizar dados (UPDATE)
UPDATE alunos
SET idade = 23
WHERE nome = 'João Silva';

UPDATE alunos
SET idade = 21, id_curso = 1
WHERE nome = 'Maria Souza';

-- 5. Excluir dados (DELETE)
DELETE FROM alunos
WHERE nome = 'Carlos Lima';

-- Excluir todos os registros da tabela alunos
DELETE FROM alunos;

-- 6. TRUNCATE (apagar todos os registros rapidamente)
TRUNCATE TABLE alunos;

-- 7. Transações (COMMIT e ROLLBACK)
-- Exemplo de rollback
BEGIN;
DELETE FROM alunos WHERE nome = 'Maria Souza';
ROLLBACK; -- desfaz a exclusão

-- Exemplo de commit
BEGIN;
UPDATE alunos SET idade = 27, id_curso = 1
WHERE nome = 'Maria Souza';
COMMIT; -- salva permanentemente
