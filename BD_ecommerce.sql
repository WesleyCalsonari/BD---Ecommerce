-- Criação do banco de dados para o cenário de E-Commerce

-- Cria o banco de dados
CREATE DATABASE IF NOT EXISTS ecommerce;

-- Utiliza o banco de dados
USE ecommerce;

-- Criar tabela cliente
CREATE TABLE cliente(
	idCliente INT AUTO_INCREMENT PRIMARY KEY,
    Fname VARCHAR(10),
    Minit CHAR(3),
    Lname VARCHAR(20),
    CPF CHAR(11) NOT NULL,
    Endereço VARCHAR(30),
    CONSTRAINT unique_cpf_cliente UNIQUE(CPF)
);

-- Criar tabela produto
CREATE TABLE produto(
	idProduto INT AUTO_INCREMENT PRIMARY KEY,
    Pname VARCHAR(10) NOT NULL,
    Classification_kids BOOL DEFAULT FALSE,
    Categoria ENUM('Eletrônico', 'Moda', 'Brinquedos', 'Alimentos', 'Movéis') NOT NULL,
    Avaliação FLOAT DEFAULT 0,
    Size VARCHAR(10)
);

-- Criar Tabela de Pagamentos
CREATE TABLE pagamento(
    idPagamento INT,
    idPagCliente INT,
    TipoPagamento ENUM('Débito', 'Crédito') DEFAULT 'Débito',
    Ncartao VARCHAR(20),
    CodigoSeguranca CHAR(3),
    Limite_Disponivel FLOAT,
    PRIMARY KEY(idPagCliente, idPagamento),
    CONSTRAINT fk_Pagamento_Cliente FOREIGN KEY (idPagCliente) REFERENCES cliente(idCliente)
);

-- Criar tabela pedido
CREATE TABLE pedido(
	idPedido INT AUTO_INCREMENT PRIMARY KEY,
    idPedidoCliente INT,
    StatusPedido ENUM('Cancelado', 'Confirmado', 'Em Processamento') DEFAULT 'Em Processamento',
    DescricaoPedido VARCHAR(255),
    Frete FLOAT DEFAULT 10,
    CONSTRAINT fk_Pedido_Cliente FOREIGN KEY (idPedidoCliente) REFERENCES cliente(idCliente)
		ON UPDATE CASCADE
);

-- Criar tabela estoque
CREATE TABLE estoque(
	idEstoque INT AUTO_INCREMENT PRIMARY KEY,
    Localizacao VARCHAR(255),
    Quantidade INT DEFAULT 0
);

-- Criar tabela fornecedor
CREATE TABLE fornecedor(
	idFornecedor INT AUTO_INCREMENT PRIMARY KEY,
    RazaoSocial VARCHAR(255) NOT NULL,
    CNPJ CHAR(15) NOT NULL,
    Contato CHAR(11) NOT NULL,
    CONSTRAINT unique_fornecedor UNIQUE(CNPJ)
);

-- Criar tabela vendedor
CREATE TABLE vendedor(
	idVendedor INT AUTO_INCREMENT PRIMARY KEY,
    RazaoSocial VARCHAR(255) NOT NULL,
    NomeFantasia VARCHAR(255),
    CNPJ CHAR(15),
    CPF CHAR(11),
    LocalVendedor VARCHAR(255),
    Contato CHAR(11) NOT NULL,
    CONSTRAINT unique_vendedor_CNPJ UNIQUE(CNPJ),
    CONSTRAINT unique_vendedor_CPF UNIQUE(CPF)
);

-- Cria tabela produto_fornecedor
CREATE TABLE produto_fornecedor(
	idProdForn INT,
    idPProduto INT,
    prodQuantidade INT DEFAULT 1,
    PRIMARY KEY (idProdForn, idPProduto),
    CONSTRAINT fk_produto_fornecedor FOREIGN KEY (idProdForn) REFERENCES vendedor(idVendedor),
    CONSTRAINT fk_produto_fornecedor_produto FOREIGN KEY (idPProduto) REFERENCES produto(idProduto)
);

-- Cria tabela produto_pedido
CREATE TABLE produto_pedido(
	idPPproduto INT,
    idPPpedido INT,
    ppQuantidade INT DEFAULT 1,
    ppStatus ENUM('Disponível', 'Sem Estoque') DEFAULT 'Disponível',
    PRIMARY KEY (idPPproduto, idPPpedido),
    CONSTRAINT fk_produto_pedido_produto FOREIGN KEY (idPPproduto) REFERENCES produto(idProduto),
    CONSTRAINT fk_produto_pedido_pedido FOREIGN KEY (idPPpedido) REFERENCES pedido(idPedido)
);

-- Cria tabela estoque_produto
CREATE TABLE estoque_produto(
	idESPproduto INT,
    idESPestoque INT,
    ESPlocalizacao VARCHAR(255) NOT NULL,
    PRIMARY KEY (idESPproduto, idESPestoque),
    CONSTRAINT fk_estoque_produto_produto FOREIGN KEY (idESPproduto) REFERENCES produto(idProduto),
    CONSTRAINT fk_estoque_produto_estoque FOREIGN KEY (idESPestoque) REFERENCES estoque(idEstoque)
);

-- Cria tabela produto_vendedor
CREATE TABLE produto_vendedor(
	idPVvendedor INT,
    idPVproduto INT,
    pvQuantidade INT NOT NULL,
    PRIMARY KEY (idPVvendedor, idPVproduto),
    CONSTRAINT fk_produto_vendedor_produto FOREIGN KEY (idPVproduto) REFERENCES produto(idProduto),
    CONSTRAINT fk_produto_vendedor_vendedor FOREIGN KEY (idPVvendedor) REFERENCES vendedor(idVendedor)
);

-- Inserção dos dados

-- ========================
-- 1. CLIENTES
-- ========================
INSERT INTO cliente (Fname, Minit, Lname, CPF, Endereço)
VALUES
('Ana', 'M', 'Silva', '12345678901', 'Rua das Flores, 45'),
('Bruno', 'T', 'Oliveira', '23456789012', 'Av. Paulista, 1200'),
('Carla', 'R', 'Souza', '34567890123', 'Rua das Acácias, 89'),
('Diego', 'F', 'Pereira', '45678901234', 'Rua do Sol, 15'),
('Eduarda', 'L', 'Mendes', '56789012345', 'Rua Central, 300');

-- ========================
-- 2. PRODUTOS
-- ========================
INSERT INTO produto (Pname, Classification_kids, Categoria, Avaliação, Size)
VALUES
('SmartTV', FALSE, 'Eletrônico', 4.7, '55pol'),
('Camiseta', FALSE, 'Moda', 4.2, 'M'),
('Boneca', TRUE, 'Brinquedos', 4.5, NULL),
('Cadeira', FALSE, 'Movéis', 4.1, NULL),
('Chocolate', TRUE, 'Alimentos', 4.9, '100g'),
('Notebook', FALSE, 'Eletrônico', 4.8, '15pol'),
('Tênis', FALSE, 'Moda', 4.4, '42');

-- ========================
-- 3. ESTOQUE
-- ========================
INSERT INTO estoque (Localizacao, Quantidade)
VALUES
('Centro SP', 300),
('Guarulhos', 150),
('Campinas', 200);

-- ========================
-- 4. FORNECEDOR
-- ========================
INSERT INTO fornecedor (RazaoSocial, CNPJ, Contato)
VALUES
('TechParts Ltda', '12345678000199', '11987654321'),
('MoveisAlpha SA', '23456789000188', '11876543210'),
('DocesBrasil Ltda', '34567890000177', '11765432109');

-- ========================
-- 5. VENDEDOR
-- ========================
INSERT INTO vendedor (RazaoSocial, NomeFantasia, CNPJ, CPF, LocalVendedor, Contato)
VALUES
('TechStore Ltda', 'TechStore', '11122233000144', NULL, 'São Paulo', '11999998888'),
('ModaViva Ltda', 'ModaViva', '22233344000155', NULL, 'Campinas', '11988887777'),
('PlayKids Ltda', 'PlayKids', '33344455000166', NULL, 'Guarulhos', '11977776666'),
('MoveisTop Ltda', 'MoveisTop', '44455566000177', NULL, 'São Bernardo', '11966665555'),
('DoceSabor Ltda', 'DoceSabor', '55566677000188', NULL, 'Osasco', '11955554444');

-- ========================
-- 6. PAGAMENTO
-- ========================
INSERT INTO pagamento (idPagamento, idPagCliente, TipoPagamento, Ncartao, CodigoSeguranca, Limite_Disponivel)
VALUES
(1, 1, 'Crédito', '5555444433331111', '123', 5000),
(1, 2, 'Débito', '4444333322221111', '456', 1500),
(1, 3, 'Crédito', '3333222211110000', '789', 3500),
(1, 4, 'Crédito', '6666555544443333', '147', 2000),
(1, 5, 'Débito', '7777666655554444', '258', 1000);

-- ========================
-- 7. PEDIDOS
-- ========================
INSERT INTO pedido (idPedidoCliente, StatusPedido, DescricaoPedido, Frete)
VALUES
(1, 'Confirmado', 'Compra de SmartTV e Chocolate', 50),
(2, 'Em Processamento', 'Compra de Tênis e Camiseta', 25),
(3, 'Cancelado', 'Compra de Cadeira', 0),
(4, 'Confirmado', 'Compra de Boneca', 15),
(5, 'Em Processamento', 'Compra de Notebook', 40);

-- ========================
-- 8. PRODUTO_FORNECEDOR
-- ========================
INSERT INTO produto_fornecedor (idProdForn, idPProduto, prodQuantidade)
VALUES
(1, 1, 50),
(1, 6, 30),
(2, 4, 40),
(3, 5, 100);

-- ========================
-- 9. PRODUTO_PEDIDO
-- ========================
INSERT INTO produto_pedido (idPPproduto, idPPpedido, ppQuantidade, ppStatus)
VALUES
(1, 1, 1, 'Disponível'),
(5, 1, 3, 'Disponível'),
(7, 2, 1, 'Disponível'),
(2, 2, 2, 'Disponível'),
(4, 3, 1, 'Sem Estoque'),
(3, 4, 1, 'Disponível'),
(6, 5, 1, 'Disponível');

-- ========================
-- 10. ESTOQUE_PRODUTO
-- ========================
INSERT INTO estoque_produto (idESPproduto, idESPestoque, ESPlocalizacao)
VALUES
(1, 1, 'Centro SP'),
(2, 3, 'Campinas'),
(3, 2, 'Guarulhos'),
(4, 2, 'Guarulhos'),
(5, 3, 'Campinas'),
(6, 1, 'Centro SP'),
(7, 3, 'Campinas');

-- ========================
-- 11. PRODUTO_VENDEDOR
-- ========================
INSERT INTO produto_vendedor (idPVvendedor, idPVproduto, pvQuantidade)
VALUES
(1, 1, 20),
(1, 6, 15),
(2, 2, 50),
(2, 7, 25),
(3, 3, 30),
(4, 4, 20),
(5, 5, 80);

-- Consultas Realizadas no BD

-- Quantidade total de clientes
SELECT COUNT(*) AS total_clientes FROM cliente;

-- Quantidade total de produtos
SELECT COUNT(*) AS total_produtos FROM produto;

-- Quantidade total de pedidos realizados
SELECT COUNT(*) AS total_pedidos FROM pedido;

-- Quantidade de vendedores cadastrados
SELECT COUNT(*) AS total_vendedores FROM vendedor;

-- Quantidade de fornecedores cadastrados
SELECT COUNT(*) AS total_fornecedores FROM fornecedor;

-- Quantidade de estoques (locais de armazenamento)
SELECT COUNT(*) AS total_estoques FROM estoque;

-- Listar todos os clientes e seus pedidos
SELECT 
    c.idCliente,
    CONCAT(c.Fname, ' ', c.Lname) AS Cliente,
    p.idPedido,
    p.StatusPedido,
    p.DescricaoPedido
FROM cliente c
LEFT JOIN pedido p ON c.idCliente = p.idPedidoCliente
ORDER BY c.idCliente;

-- Listar produtos e seus vendedores
SELECT 
    v.NomeFantasia AS Vendedor,
    pr.Pname AS Produto,
    pv.pvQuantidade AS Quantidade_Disponível
FROM produto_vendedor pv
JOIN vendedor v ON pv.idPVvendedor = v.idVendedor
JOIN produto pr ON pv.idPVproduto = pr.idProduto
ORDER BY v.NomeFantasia;

-- Listar produtos e seus fornecedores
SELECT 
    f.RazaoSocial AS Fornecedor,
    p.Pname AS Produto,
    pf.prodQuantidade AS Qtde_Fornecida
FROM produto_fornecedor pf
JOIN fornecedor f ON pf.idProdForn = f.idFornecedor
JOIN produto p ON pf.idPProduto = p.idProduto
ORDER BY f.RazaoSocial;

-- Listar pedidos com os produtos comprados
SELECT 
    pe.idPedido AS Pedido,
    c.Fname AS Cliente,
    pr.Pname AS Produto,
    pp.ppQuantidade AS Quantidade,
    pp.ppStatus AS Status_Produto
FROM pedido pe
JOIN cliente c ON pe.idPedidoCliente = c.idCliente
JOIN produto_pedido pp ON pp.idPPpedido = pe.idPedido
JOIN produto pr ON pr.idProduto = pp.idPPproduto
ORDER BY pe.idPedido;

-- Mostrar estoque por produto
SELECT 
    p.Pname AS Produto,
    e.Localizacao,
    e.Quantidade AS Qtde_Estoque
FROM estoque_produto ep
JOIN produto p ON ep.idESPproduto = p.idProduto
JOIN estoque e ON ep.idESPestoque = e.idEstoque
ORDER BY e.Localizacao;

-- Quantidade de pedidos por cliente
SELECT 
    CONCAT(c.Fname, ' ', c.Lname) AS Cliente,
    COUNT(p.idPedido) AS Qtde_Pedidos
FROM cliente c
LEFT JOIN pedido p ON c.idCliente = p.idPedidoCliente
GROUP BY c.idCliente
ORDER BY Qtde_Pedidos DESC;

-- Produtos mais vendidos (com base em produto_pedido)
SELECT 
    pr.Pname AS Produto,
    SUM(pp.ppQuantidade) AS Total_Vendido
FROM produto_pedido pp
JOIN produto pr ON pp.idPPproduto = pr.idProduto
GROUP BY pr.Pname
ORDER BY Total_Vendido DESC;

-- Valor total de fretes pagos por status de pedido
SELECT 
    StatusPedido,
    SUM(Frete) AS Total_Frete
FROM pedido
GROUP BY StatusPedido;

-- Quantidade média de produtos por pedido
SELECT 
    AVG(produtos_por_pedido) AS media_produtos_por_pedido
FROM (
    SELECT idPPpedido, SUM(ppQuantidade) AS produtos_por_pedido
    FROM produto_pedido
    GROUP BY idPPpedido
) AS sub;

-- Quantidade de produtos disponíveis por categoria
SELECT 
    Categoria,
    COUNT(*) AS Total_Produtos
FROM produto
GROUP BY Categoria
ORDER BY Total_Produtos DESC;

-- Clientes que realizaram pedidos confirmados
SELECT DISTINCT
    CONCAT(c.Fname, ' ', c.Lname) AS Cliente,
    p.StatusPedido
FROM pedido p
JOIN cliente c ON p.idPedidoCliente = c.idCliente
WHERE p.StatusPedido = 'Confirmado';