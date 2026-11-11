-- Projeto: Sistema de Gerenciamento de Biblioteca
-- Banco de dados: PostgreSQL

CREATE TABLE usuarios (
    id_usuario SERIAL PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    data_cadastro DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE categorias (
    id_categoria SERIAL PRIMARY KEY,
    nome VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE livros (
    id_livro SERIAL PRIMARY KEY,
    titulo VARCHAR(180) NOT NULL,
    autor VARCHAR(120) NOT NULL,
    isbn VARCHAR(20) UNIQUE,
    ano_publicacao INTEGER CHECK (ano_publicacao BETWEEN 1000 AND 2100),
    quantidade_total INTEGER NOT NULL CHECK (quantidade_total >= 0),
    quantidade_disponivel INTEGER NOT NULL CHECK (
        quantidade_disponivel >= 0
        AND quantidade_disponivel <= quantidade_total
    ),
    id_categoria INTEGER NOT NULL,
    CONSTRAINT fk_livro_categoria
        FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

CREATE TABLE emprestimos (
    id_emprestimo SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    id_livro INTEGER NOT NULL,
    data_emprestimo DATE NOT NULL DEFAULT CURRENT_DATE,
    data_prevista_devolucao DATE NOT NULL,
    data_devolucao DATE,
    status VARCHAR(15) NOT NULL DEFAULT 'ATIVO'
        CHECK (status IN ('ATIVO', 'DEVOLVIDO', 'ATRASADO')),
    CONSTRAINT fk_emprestimo_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    CONSTRAINT fk_emprestimo_livro
        FOREIGN KEY (id_livro) REFERENCES livros(id_livro),
    CONSTRAINT chk_datas
        CHECK (data_prevista_devolucao >= data_emprestimo),
    CONSTRAINT chk_devolucao
        CHECK (data_devolucao IS NULL OR data_devolucao >= data_emprestimo)
);

-- Índices para facilitar consultas frequentes
CREATE INDEX idx_livros_titulo ON livros(titulo);
CREATE INDEX idx_emprestimos_usuario ON emprestimos(id_usuario);
CREATE INDEX idx_emprestimos_status ON emprestimos(status);

-- Dados iniciais
INSERT INTO categorias (nome) VALUES
('Literatura'), ('Tecnologia'), ('História');

INSERT INTO usuarios (nome, email, telefone) VALUES
('Ana Souza', 'ana.souza@email.com', '(67) 99999-1111'),
('Carlos Lima', 'carlos.lima@email.com', '(67) 98888-2222');

INSERT INTO livros
(titulo, autor, isbn, ano_publicacao, quantidade_total, quantidade_disponivel, id_categoria)
VALUES
('Dom Casmurro', 'Machado de Assis', '9788535910663', 1899, 5, 5, 1),
('Introdução à Programação', 'Marina Costa', '9786500000001', 2022, 3, 3, 2),
('História do Brasil', 'Pedro Almeida', '9786500000002', 2020, 4, 4, 3);
