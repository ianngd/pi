-- Criação do banco de dados
CREATE DATABASE worflow_atu_apolices

-- Garantindo o aceitamento de caracteres especiais e acentuação
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE worflow_atu_apolices;

-- Tabela de Status
CREATE TABLE tb_status (
    id_status INT PRIMARY KEY AUTO_INCREMENT,
    nome_status VARCHAR(50) NOT NULL UNIQUE,
    descricao_status VARCHAR(255),
    ativo BOOLEAN DEFAULT TRUE,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Origens
CREATE TABLE tb_origens (
    id_origem INT PRIMARY KEY AUTO_INCREMENT,
    nome_origem VARCHAR(100) NOT NULL UNIQUE,
    descricao_origem VARCHAR(255),
    prioridade_critica BOOLEAN DEFAULT FALSE,
    ativo BOOLEAN DEFAULT TRUE,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Produtos
CREATE TABLE tb_produtos (
    id_produto INT PRIMARY KEY AUTO_INCREMENT,
    nome_produto VARCHAR(150) NOT NULL UNIQUE,
    descricao_produto TEXT,
    categoria VARCHAR(100),
    ativo BOOLEAN DEFAULT TRUE,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Demandas
CREATE TABLE tb_demandas (
    id_demanda INT PRIMARY KEY AUTO_INCREMENT,
    id_produto INT NOT NULL,
    id_origem INT NOT NULL,
    id_status INT NOT NULL,
    data_demanda DATE NOT NULL,
    descricao_demanda TEXT NOT NULL,
    usuario_solicitante VARCHAR(100),
    file_path VARCHAR(500) NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_produto) REFERENCES tb_produtos(id_produto),
    FOREIGN KEY (id_origem) REFERENCES tb_origens(id_origem),
    FOREIGN KEY (id_status) REFERENCES tb_status(id_status)
);
