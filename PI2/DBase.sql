-- Criação do banco de dados com suporte a caracteres especiais
CREATE DATABASE workflow_atu_apolices
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE workflow_atu_apolices;

-- Tabela de Status com valores pré-definidos
CREATE TABLE tb_status (
    id_status INT PRIMARY KEY AUTO_INCREMENT,
    nome_status ENUM('Pendente', 'Em execução', 'Concluído') NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Origens com valores pré-definidos
CREATE TABLE tb_origens (
    id_origem INT PRIMARY KEY AUTO_INCREMENT,
    nome_origem ENUM('Interno', 'SUSEP', 'Iterno e SUSEP') NOT NULL,
    prioridade_critica BOOLEAN DEFAULT FALSE,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Produtos com valores pré-definidos
CREATE TABLE tb_produtos (
    id_produto INT PRIMARY KEY AUTO_INCREMENT,
    nome_produto ENUM(
        'Garantia Estendida', 
        'Roubo e Quebra de Portateis', 
        'Residencial', 
        'Proteção Financeira'
    ) NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela principal de Demandas
CREATE TABLE tb_demandas (
    id_demanda INT PRIMARY KEY AUTO_INCREMENT,
    id_produto INT NOT NULL,
    id_origem INT NOT NULL,
    id_status INT NOT NULL,
    data_demanda TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    descricao_demanda TEXT NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    ajustes_cumulativos BOOLEAN DEFAULT FALSE,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_produto) REFERENCES tb_produtos(id_produto),
    FOREIGN KEY (id_origem) REFERENCES tb_origens(id_origem),
    FOREIGN KEY (id_status) REFERENCES tb_status(id_status)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Inserção de dados padrão
INSERT INTO tb_status (nome_status) VALUES
('Pendente'),
('Em execução'),
('Concluído');

INSERT INTO tb_origens (nome_origem, prioridade_critica) VALUES
('Interno', FALSE),
('SUSEP', TRUE),
('Iterno e SUSEP', TRUE);

INSERT INTO tb_produtos (nome_produto) VALUES
('Garantia Estendida'),
('Roubo e Quebra de Portateis'),
('Residencial'),
('Proteção Financeira');



-- TESTES
-- Inserção de Demandas de Teste
INSERT INTO tb_demandas (
    id_produto, 
    id_origem, 
    id_status, 
    descricao_demanda, 
    file_path, 
    ajustes_cumulativos
) VALUES
(1, 2, 1, 'Atualização de cobertura para equipamentos industriais', '/uploads/circular123.pdf', TRUE),
(2, 1, 2, 'Ajuste de franquia para notebooks corporativos', '/docs/relatorio_vendas_q2.docx', FALSE),
(4, 3, 3, 'Revisão de cláusulas de rescisão contratual', '/arquivos/termos_2024.pdf', TRUE);

-- Consulta do Backlog Completo
SELECT 
    d.id_demanda AS 'ID',
    p.nome_produto AS 'Produto',
    o.nome_origem AS 'Origem',
    s.nome_status AS 'Status',
    DATE_FORMAT(d.data_demanda, '%d/%m/%Y %H:%i') AS 'Data',
    d.descricao_demanda AS 'Descrição',
    CONCAT('<a href="', d.file_path, '">Download</a>') AS 'Arquivo',
    IF(d.ajustes_cumulativos, 'Sim', 'Não') AS 'Cumulativo'
FROM tb_demandas d
JOIN tb_produtos p ON d.id_produto = p.id_produto
JOIN tb_origens o ON d.id_origem = o.id_origem
JOIN tb_status s ON d.id_status = s.id_status;

-- Atualização de Status via Procedure
CALL AtualizarStatusDemanda(1, 2);  -- Altera demanda 1 para "Em execução"

-- Verificação após atualização
SELECT 
    d.id_demanda,
    s.nome_status AS 'Novo Status'
FROM tb_demandas d
JOIN tb_status s ON d.id_status = s.id_status
WHERE d.id_demanda = 1;

-- Consulta de Demandas Cumulativas
SELECT * FROM tb_demandas 
WHERE ajustes_cumulativos = TRUE;

-- Consulta de Demandas da SUSEP
SELECT 
    d.id_demanda,
    o.nome_origem AS 'Origem Prioritária'
FROM tb_demandas d
JOIN tb_origens o ON d.id_origem = o.id_origem
WHERE o.prioridade_critica = TRUE;
