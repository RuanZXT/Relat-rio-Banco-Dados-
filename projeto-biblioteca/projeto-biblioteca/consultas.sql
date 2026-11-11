-- Consultas e operações de manipulação
-- Execute após banco.sql no PostgreSQL.

-- 1. CONSULTAR todos os livros e suas categorias
SELECT l.id_livro, l.titulo, l.autor, c.nome AS categoria,
       l.quantidade_total, l.quantidade_disponivel
FROM livros l
JOIN categorias c ON c.id_categoria = l.id_categoria
ORDER BY l.titulo;

-- 2. INSERIR um novo usuário
INSERT INTO usuarios (nome, email, telefone)
VALUES ('João Pereira', 'joao.pereira@email.com', '(67) 97777-3333');

-- 3. ATUALIZAR telefone de um usuário
UPDATE usuarios
SET telefone = '(67) 96666-4444'
WHERE email = 'joao.pereira@email.com';

-- 4. REGISTRAR um empréstimo (exemplo: livro 1 para usuário 1)
-- A quantidade disponível é reduzida dentro de uma transação.
BEGIN;
UPDATE livros
SET quantidade_disponivel = quantidade_disponivel - 1
WHERE id_livro = 1 AND quantidade_disponivel > 0;

INSERT INTO emprestimos
(id_usuario, id_livro, data_emprestimo, data_prevista_devolucao)
VALUES (1, 1, CURRENT_DATE, CURRENT_DATE + INTERVAL '7 days');
COMMIT;

-- 5. CONSULTAR empréstimos ativos e dados do usuário/livro
SELECT e.id_emprestimo, u.nome AS usuario, l.titulo AS livro,
       e.data_emprestimo, e.data_prevista_devolucao, e.status
FROM emprestimos e
JOIN usuarios u ON u.id_usuario = e.id_usuario
JOIN livros l ON l.id_livro = e.id_livro
WHERE e.status = 'ATIVO'
ORDER BY e.data_prevista_devolucao;

-- 6. REGISTRAR devolução do empréstimo de número 1
BEGIN;
UPDATE emprestimos
SET data_devolucao = CURRENT_DATE, status = 'DEVOLVIDO'
WHERE id_emprestimo = 1 AND status = 'ATIVO';

UPDATE livros
SET quantidade_disponivel = quantidade_disponivel + 1
WHERE id_livro = (
    SELECT id_livro FROM emprestimos WHERE id_emprestimo = 1
);
COMMIT;

-- 7. REMOVER usuário de teste (somente se não possuir empréstimos)
DELETE FROM usuarios
WHERE email = 'joao.pereira@email.com'
  AND NOT EXISTS (
      SELECT 1 FROM emprestimos e
      WHERE e.id_usuario = usuarios.id_usuario
  );

-- 8. CONSULTAR livros com estoque baixo
SELECT titulo, quantidade_disponivel
FROM livros
WHERE quantidade_disponivel <= 1
ORDER BY quantidade_disponivel, titulo;

-- 9. CONSULTAR quantidade de empréstimos por usuário
SELECT u.nome, COUNT(e.id_emprestimo) AS total_emprestimos
FROM usuarios u
LEFT JOIN emprestimos e ON e.id_usuario = u.id_usuario
GROUP BY u.id_usuario, u.nome
ORDER BY total_emprestimos DESC;
