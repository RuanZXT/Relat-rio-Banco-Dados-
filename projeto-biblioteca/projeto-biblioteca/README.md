# Sistema de Gerenciamento de Biblioteca

Projeto acadêmico do Módulo 3, integrando modelagem e manipulação de banco de dados com controle de versão.

## Objetivo
Organizar o cadastro de usuários, categorias, livros e empréstimos, permitindo consultar o acervo e acompanhar devoluções.

## Tecnologias
- PostgreSQL (SQL)
- Git para controle de versão
- GitHub para hospedagem do repositório

## Estrutura
- `banco.sql`: criação das tabelas, restrições, índices e dados iniciais.
- `consultas.sql`: exemplos de INSERT, UPDATE, DELETE e SELECT, além do fluxo de empréstimo/devolução.
- `modelo_er.png`: representação visual das entidades e relacionamentos.
- `relatorio.pdf`: relatório acadêmico do projeto.

## Como executar
1. Instale o PostgreSQL e crie um banco chamado `biblioteca`.
2. Abra o SQL Shell (psql) ou uma ferramenta como pgAdmin.
3. Execute primeiro o arquivo `banco.sql`.
4. Execute `consultas.sql` para testar as operações.
5. Observe que as operações de empréstimo e devolução usam transações (`BEGIN`/`COMMIT`).

Exemplo pelo terminal:
```bash
createdb biblioteca
psql -d biblioteca -f banco.sql
psql -d biblioteca -f consultas.sql
```

## Modelo de dados
- `usuarios`: pessoas que utilizam a biblioteca.
- `categorias`: classificação dos livros.
- `livros`: dados bibliográficos e controle de quantidade.
- `emprestimos`: vínculo entre usuário e livro, com datas e situação.

Relacionamentos:
- Uma categoria pode possuir vários livros (1:N).
- Um usuário pode realizar vários empréstimos (1:N).
- Um livro pode aparecer em vários empréstimos ao longo do tempo (1:N).

## Regras e restrições
- Campos essenciais não aceitam valores nulos.
- E-mail do usuário e ISBN do livro são únicos.
- Chaves estrangeiras impedem empréstimos associados a usuários ou livros inexistentes.
- Quantidades não podem ser negativas e a quantidade disponível não pode superar o total.
- O status do empréstimo aceita apenas ATIVO, DEVOLVIDO ou ATRASADO.
- As datas de devolução não podem ser anteriores à data do empréstimo.

## Git e GitHub
Inicialize o repositório na pasta do projeto:
```bash
git init
git add .
git commit -m "Estrutura inicial do projeto de biblioteca"
git branch -M main
git remote add origin https://github.com/SEU-USUARIO/projeto-biblioteca.git
git push -u origin main
```

Sugestão de commits frequentes e explicativos:
```bash
git add banco.sql
git commit -m "Cria tabelas e restrições do banco de dados"

git add consultas.sql
git commit -m "Adiciona operações CRUD e consultas do sistema"

git add modelo_er.png
git commit -m "Adiciona diagrama entidade relacionamento"

git add README.md relatorio.pdf
git commit -m "Documenta projeto e adiciona relatório acadêmico"
```
Substitua `SEU-USUARIO` pelo seu usuário do GitHub e crie o repositório vazio no site antes de executar `git remote add`.
