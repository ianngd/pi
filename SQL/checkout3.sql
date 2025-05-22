-- CRIANDO DATABASE
CREATE DATABASE restaurante;

-- CRIANDO TABELA ITENS DO CARDAPIO
CREATE TABLE `restaurante`.`itenscardapio`( 
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `valor` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`id`));

-- CRIANDO TABELA CLIENTES
CREATE TABLE `restaurante`.`clientes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `telefone` VARCHAR(15) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`));

-- CRIANDO TABELAS DE PEDIDOS
CREATE TABLE `restaurante`.`pedidos` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `idcliente` INT NOT NULL,
  `datapedido` DATE NOT NULL,
  `valortotal` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`idcliente`) REFERENCES `clientes`(`id`)
);

CREATE TABLE `restaurante`.`pedidos_itens` (
  `idpedido` INT NOT NULL,
  `iditem` INT NOT NULL,
  `quantidade` INT NOT NULL,
  FOREIGN KEY (`idpedido`) REFERENCES `pedidos`(`id`),
  FOREIGN KEY (`iditem`) REFERENCES `itenscardapio`(`id`)
);

-- INSERINDO DADOS NA TABELA ITENS DO CARDAPIO
INSERT INTO `restaurante`.`itenscardapio`
(`nome`, `valor`)
VALUES
('Picolé de Limão', 4.00);

INSERT INTO `restaurante`.`itenscardapio`
(`nome`, `valor`)
VALUES
('Chocolate', 9.00);

INSERT INTO `restaurante`.`itenscardapio`
(`nome`, `valor`)
VALUES
('Água com Gás', 5.00);



-- VISUALIZANDO DADOS
SELECT * FROM `restaurante`.`itenscardapio`;

-- INSERINDO DADOS NA TABELA CLIENTES
INSERT INTO `restaurante`.`clientes`
(`nome`,`telefone`,`email`)
VALUES
('Leyri Anne', '67992330103','leyri1000@gmail.com');


INSERT INTO `restaurante`.`clientes`
(`nome`,`telefone`,`email`)
VALUES
('Iann Gabriel', '11967280984','iplay8@gmail.com');

INSERT INTO `restaurante`.`clientes`
(`nome`,`telefone`,`email`)
VALUES
('Maria Hipolita', '1196728098467991473707','mariaipolita@hotmail.com');

SELECT * FROM `restaurante`.`clientes`;



-- INSERINDO DADOS NA TABELA PEDIDOS
INSERT INTO `restaurante`.`pedidos`
(`idcliente`, `datapedido`, `valortotal`)
VALUES
(1, '2025-05-19', 9.00);

INSERT INTO `restaurante`.`pedidos_itens`
(`idpedido`, `iditem`, `quantidade`)
VALUES
(1, 2, 1); -- pedido 1, item 2 (Chocolate), quantidade 1


-- CHECANDO INSERÇÃO

SELECT p.id AS pedido_id, c.nome AS cliente, i.nome AS item,
       pi.quantidade, i.valor, (pi.quantidade * i.valor) AS subtotal
FROM pedidos p
JOIN clientes c ON p.idcliente = c.id
JOIN pedidos_itens pi ON p.id = pi.idpedido
JOIN itenscardapio i ON pi.iditem = i.id;


