===================== LISTA 6 ==========
1. Crie uma visão onde informando o titulo e a visão pode-se consultar quais pessoas locaram o titulo informado.
CREATE VIEW L6E1 AS(
    SELECT nome, titulo
    FROM pessoas p
    JOIN locacoes l
    ON p.codPessoa = l.codDependente
    JOIN itensLocacoes i
    ON l.codLocacao = i.codLocacao
    JOIN titulos t
    ON i.codTitulo = t.codTitulo
)

SELECT nome
FROM l6e1
WHERE titulo = 'homem-aranha'

2. Crie uma visão onde informando data pode-se consultar o dependente, funcionário e valor da locação realizada.
CREATE OR REPLACE VIEW l6e2 AS(
    SELECT d.nome AS dependente, f.nome funcionario, valor, dataLocacao
    FROM pessoas d
    JOIN locacoes l
    ON d.codPessoa = l.codDependente
    JOIN pessoas f
    ON f.codPessoa = l.codFuncionario
)

SELECT dependente, funcionario, valor
FROM l6e2
WHERE dataLocacao LIKE '%2012-04-23%'

3. Crie uma visão onde informando a data podem-se consultar os títulos locados nesta data.
CREATE OR REPLACE VIEW l06e03 AS(
    SELECT dataLocacao, titulo
    FROM locacoes l
    JOIN itensLocacoes i
    ON l.codLocacao = i.codLocacao
    JOIN titulos t
    ON i.codTitulo = t.codTitulo
)

SELECT titulo
FROM l06e03
WHERE dataLocacao LIKE '%2012-02-16%'

4. Crie uma visão onde informando o nome do cliente podem-se consultar os seus dependentes.

5. Crie uma visão onde informando a data de devolução informe quais clientes devem fazer devoluções para esta data.


6. Crie uma visão onde informando o titulo pode-se consultar seu respectivo gênero, classificação, e valor de locação.
CREATE OR REPLACE VIEW l06e06 AS(
    SELECT titulo, genero, classificacao, valor
    FROM titulos t
    JOIN categorias c
    ON t.codCategoria = c.codCategoria
)
SELECT genero, classificacao, valor
FROM l06e06
WHERE titulo = 'Na cama'

7. Crie uma visão onde informando o nome do dependente consulte as datas e títulos de suas locações.
CREATE VIEW l06e07 as(
    SELECT nome, dataLocacao, titulo
    FROM pessoas p
    JOIN locacoes l
    ON p.codPessoa = l.codDependente
    JOIN itenslocacoes i
    ON l.codLocacao = i.codLocacao
    JOIN titulos t
    ON i.codTitulo = t.codTitulo)


SELECT dataLocacao, titulo
FROM l06e07
WHERE nome = 'Leonildo'

8. Crie uma visão onde informando o nome da pessoa consulte seu endereço completo e telefones, não exiba na consultas as chaves primárias e estrangeiras.
CREATE VIEW l06e08 AS(
    SELECT nome, rua, e.numero, cidade, bairro, CEP, UF, complemento, t.numero telefone
    FROM pessoas p
    JOIN enderecos e
    ON p.codEndereco = e.codEndereco
    JOIN telefones t
    ON t.codPessoa = p.codPessoa
)

SELECT *
FROM l06e08
WHERE nome = 'Leonildo'

===================== LISTA 7 ==========
7º Lista de exercícios
Visões (Views)

1. Crie uma visão onde informando a o nome do professor e a visão pode-se consultar o nome das disciplinas que este professor ministrou e suas respectivas disciplinas que são pré-requisito.
CREATE OR REPLACE VIEW l07E01 AS (
    SELECT nome professor, d.nomeDisciplina disciplina, p.nomeDisciplina prerequisito
    FROM pessoa e
    JOIN turma t
    ON e.codPessoa = t.codProf
    JOIN disciplina d
    ON t.codDisciplina = d.codDisciplina
    LEFT JOIN disciplina p
    ON d.prerequisito = p.codDisciplina
)

SELECT disciplina, prerequisito
FROM l07E01
WHERE professor = 'Maycon'

2. Crie uma visão onde informando o nome do professor e o número de faltas pode-se consultar todos os alunos que tiveram ao menos este número de faltas informado.
CREATE OR REPLACE VIEW l07e02A AS(
    SELECT e.nome Aluno,e2.nome Professor, SUM(falta) somaFalta
    FROM participacao p
    JOIN presenca r
    ON p.codPart = r.codPart
    JOIN pessoa e
    ON p.codAluno = e.codPessoa
    JOIN turma t
    ON p.codTurma = t.codTurma
    JOIN pessoa e2
    ON t.codProf = e2.codPessoa
    GROUP BY codAluno, codProf
)

SELECT Aluno
FROM l07e02A
WHERE Professor = 'Milton'
AND somaFalta >=27;

3. Escreva um comando SQL que consulte o nome dos 3 alunos com a maior média geral.
SELECT nome, AVG((nota*peso)/100) mediaGeral
FROM pessoa e
JOIN participacao p
ON e.codPessoa = p.codAluno
JOIN avaliacaoPart ap
ON p.codPart = ap.codPart
JOIN avaliacao a
ON ap.codAvaliacao = a.codAvaliacao
GROUP BY codAluno
ORDER BY mediaGeral DESC LIMIT 3

4. Escreva um comando SQL que consulte o nome de todos os alunos com suas respectivas faltas em cada disciplina.
CREATE OR REPLACE VIEW l07E04 AS (
    SELECT nome aluno, nomeDisciplina, SUM(falta) faltas
    FROM pessoa p
    JOIN participacao a
    ON p.codPessoa = a.codAluno
    JOIN presenca r
    ON a.codPart = r.codPart
    JOIN turma t
    ON a.codTurma = t.codTurma
    JOIN disciplina d
    ON d.codDisciplina = t.codDisciplina
    GROUP BY a.codPart
    ORDER BY aluno
)

SELECT nomeDisciplina, faltas
FROM l07E04
WHERE aluno = 'Renisson'

5. Crie uma visão onde informando o nome do aluno e o curso pode-se consultar quantos créditos ele já cumpriu.
CREATE OR REPLACE VIEW media AS(
    SELECT p.codPart, SUM((nota*peso)/100) media
    FROM participacao p
    JOIN avaliacaoPart ap
    ON p.codPart = ap.codPart
    JOIN avaliacao a
    ON a.codAvaliacao = ap.codAvaliacao
    GROUP BY p.codPart
)

CREATE OR REPLACE VIEW pFalta AS(
    SELECT p.codPart,(100*SUM(falta))/(count(p.codPart)*2) porcentFalta
    FROM participacao p
    JOIN presenca r
    ON p.codPart = r.codPart
    GROUP BY r.codPart
)

CREATE OR REPLACE VIEW L07E05 AS(
    SELECT nome, nomeCurso, sum(credito) 'creditoCumprido'
    FROM pessoa e
    JOIN aluno a
    ON e.codPessoa = a.codAluno
    JOIN curso c
    ON a.codCurso = c.codCurso
    JOIN participacao p
    ON a.codAluno = p.codAluno
    JOIN turma t
    ON t.codTurma = p.codTurma
    JOIN disciplina d
    ON t.codDisciplina = d.codDisciplina
    JOIN pFalta pf
    ON p.codPart = pf.codPart
    JOIN media m
    ON p.codPart = m.codPart
    WHERE porcentFalta <= 25 AND m.media>=60
    GROUP BY a.codAluno
)

SELECT creditoCumprido
FROM L07E05
WHERE nomeCurso = 'TADS' AND nome = 'Emerson'

6. Crie uma visão onde informando o número créditos pode-se consultar o nome dos alunos e o curso que ele faz que tem no máximo este crédito informado.
CREATE OR REPLACE VIEW L07E06 AS (
    SELECT nome,SUM(credito) totalCredito, nomeCurso
    FROM pessoa e
    JOIN aluno a
    ON e.codPessoa = a.codAluno
    JOIN participacao p
    ON a.codAluno = p.codAluno
    JOIN turma t
    ON p.codTurma = t.codTurma
    JOIN disciplina d
    ON t.codDisciplina = d.codDisciplina
    JOIN curso c
    ON a.codCurso = c.codCurso
    GROUP BY c.codCurso
)

SELECT nome, nomeCurso
FROM L07E06
WHERE totalCredito >= 30




===================== LISTA 8 ==========
ALTER TABLE locacoes 
DROP FOREIGN KEY locacoes_FK1, DROP FOREIGN KEY locacoes_FK2;

ALTER TABLE locacoes
DROP COLUMN codFuncionario, DROP COLUMN codDependente; 

DELIMITER $$
CREATE TRIGGER TriggerHistoricosTitulos
AFTER UPDATE ON titulos
FOR EACH ROW 
    BEGIN
        INSERT INTO HistoricoTitulos SET
        user = CURRENT_USER(),
        dataAtualizacao = CURRENT_TIMESTAMP(),
        OLDcodTitulo = old.codTitulo,
        OLDcodCategoria = old.codCategoria,
        OLDtitulo = old.titulo,
        OLDgenero = old.genero,
        OLDclassificacao = old.classificacao,
        OLDano = old.ano,
        NEWcodTitulo = new.codTitulo,
        NEWcodCategoria = new.codCategoria,
        NEWtitulo = new.titulo,
        NEWgenero = new.genero,
        NEWclassificacao = new.classificacao,
        NEWano = new.ano;
END $$ DELIMITER;

UPDATE titulos SET classificacao = 15
WHERE classificacao = 14;

SELECT *
FROM titulos

SELECT *
FROM historicoTitulos














===================== LISTA 9 ==========
01 Crie uma trigger que ao ser inserido, atualizado ou deletado uma nota na tabela AvaliacaoPart, atualize corretamente a sua respectiva media na tabela participação.

DELIMITER $$
CREATE TRIGGER atualizaMedia
AFTER UPDATE ON avaliacaoPart
FOR EACH ROW 
BEGIN
	UPDATE participacao SET media = (SELECT media FROM media WHERE codPart = OLD.codPart)
	WHERE codPart = OLD.codPart;
END $$ DELIMITER;



02 – Crie uma trigger que ao ser inserido, atualizado ou deletado uma falta na tabela Presença, atualize a coluna status na tebela Participacao obedecendo a seguinte regra, se o numero de faltas for maior que 25% o atributo estatus receberá “REPROVADO POR FALTA”. 
• Obs¹.: Cada credito de disciplina equivale a 18 aulas.
• Obs².: Você deve de criar a coluna status na tabela Participacao.
DELIMITER $$
CREATE TRIGGER atualizaStatus
AFTER UPDATE ON presenca
FOR EACH ROW 
BEGIN
	UPDATE participacao SET status = 'REPROVADO POR FALTA'
	WHERE (SELECT porcentFalta FROM pFalta WHERE codPart = OLD.codPart) > 25 AND codPart = OLD.codPart;
END $$ DELIMITER;
03 – Crie uma trigger que registre em uma tabela (LOGPessoa), a data com aaaa/mm/dd/hh/mm/ss, usuário que efetuou a alteração e todos os dados antigos (antes da atualização) da tabela pessoa.

DELIMITER 
$$
CREATE TRIGGER log 
AFTER UPDATE on Pessoa
FOR EACH ROW
    BEGIN
        insert into logPessoa set 
        usuario = CURRENT_USER(),
        dataAtualizacao = CURRENT_TIMESTAMP(),
        codPessoa = old.codPessoa,
        codEndereco = old.codEndereco,
        nome = old.nome,
        sobreNome = old.sobreNome,
        CPF = old.CPF,
        email = old.email,
        dataNascimento = old.dataNascimento,
        DataCadastro = old.DataCadastro,
        codAdm = old.codAdm;
END
$$
