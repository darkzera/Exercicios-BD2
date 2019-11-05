01 Crie uma visão onde informando a cidade e a visão pode-se consultar o nome e o número de telefone de todas as pessoas cadastradas no sistema.

CREATE OR REPLACE VIEW q01 AS (
    SELECT p.nome, tel.numero, cidade FROM 
    Pessoas p
    JOIN telefone tel
    ON p.codPessoa = tel.codPessoa
    JOIN endereco endo
    ON p.codEndereco = endo.codEndereco
)

02 - Escreva uma visão onde informando o nome do professor pode-se consultar todas as disciplinas que ele ministrou.

CREATE OR REPLACE VIEW q02 AS (
    SELECT disc.nomeDisciplina, p1.nome 
    FROM turma t
    JOIN pessoa p1
    ON p1.codPessoa = t.codProf
    JOIN disciplina disc
    ON t.codDisciplina = disc.coddisciplina
)
03 - Crie uma trigger que ao ser atualizado um endereço, insere em uma outra tabela de uma única coluna de String todas as colunas do endereço antigo, no seguinte formato:

DELIMITER $$
CREATE TRIGGER TriggerLOGEndereco
AFTER UPDATE ON endereco
FOR EACH ROW 
    BEGIN
        INSERT INTO logEndereco SET
        texto = concat('RUA: ',old.rua,
            '\nNúmero: ',old.numero,
            '\nBairro: ',old.bairro,
            '\nComplemento: ',old.complemento,
            '\nCidade: ',old.cidade,
            '\nUF: ',old.UF,
            '\nCEP: ',old.CEP,
            '\n\n');
END $$ DELIMITER $$;

====================== Simulado 2 ============= 

01 - Usando a base de dados da Universidade, crie uma trigger que apague as linhas da tabela telefone e aluno se sua respectiva pessoa for deletada.
DELIMITER $$
CREATE TRIGGER q01
AFTER DELETE ON Pessoa
for each row
    begin
        delete FROM telefone tel WHERE tel.codPessoa = old.codPessoa;
        delete FROM aluno a WHERE a.codAluno = old.codPessoa;
    end
    $$


02 - Usando a base de dados da Universidade, crie uma trigger que faça o backup de antes e depois da tabela endereço for atualizada, a atributos deste backup devem todos de ser String, concatenando o antes e depois em uma mesma coluna.
DELIMITER $$
CREATE TRIGGER triggerBackupEndereco
AFTER UPDATE ON endereco
FOR EACH ROW
BEGIN
	INSERT INTO backupendereco SET
		codEndereco = CONCAT(old.codEndereco,' -> ',new.codEndereco),
		rua = CONCAT(old.rua,' -> ',new.rua),
		numero = CONCAT(old.numero,' -> ',new.numero),
		bairro = CONCAT(old.bairro,' -> ',new.bairro),
		complemento = CONCAT(old.complemento,' -> ',new.complemento),
		cidade = CONCAT(old.cidade,' -> ',new.cidade),
		UF = CONCAT(old.UF,' -> ',new.UF),
		CEP = CONCAT(old.CEP,' -> ',new.CEP);
END $$

    3. Usando a base de dados da Universidade, crie uma view que dado o nome de um aluno retorne a média das suas notas.
CREATE OR REPLACE VIEW medias AS(
SELECT nome, a.codPart, SUM((nota*peso)/100) media
FROM pessoa p
JOIN participacao a
   ON p.codPessoa = a.codAluno
JOIN avaliacaoPart ap
   ON a.codPart = ap.codPart
JOIN avaliacao v
   ON ap.codAvaliacao = v.codAvaliacao
GROUP BY a.codPart
order by nome)

CREATE OR REPLACE VIEW CR AS(
select nome, AVG(media) media
from medias
GROUP BY nome
)









====================== Simulado 3	 ============= 



    1. (Universidade) Crie uma visão onde informando o código da turma pode-se consultar o nome do aluno com a maior média desta turma.
CREATE OR REPLACE VIEW mediaTurma AS(
	SELECT p.codTurma,p.codAluno, SUM((nota*peso)/100) media
	FROM participacao p
	JOIN avaliacaoPart ap
	   on p.codPart = ap.codPart
	JOIN avaliacao a
	   on ap.codAvaliacao = a.codAvaliacao
	GROUP BY p.codPart 
)

CREATE OR REPLACE VIEW maiorMediaTurma AS(
	SELECT codTurma,nome,MAX(media) media
	FROM mediaTurma m
	JOIN pessoa p
	   ON p.codPessoa = m.codAluno
	GROUP BY codTurma
)

SELECT nome, media
FROM maiorMediaTurma
WHERE codTurma = 5

    2. (Universidade) Crie uma visão onde informando nome do funcionário pode-se consultar o nome do seu chefe imediato com o seu respectivo telefone.
CREATE OR REPLACE VIEW funcionarioChefe AS(
	SELECT p.nome funcionario, e.nome Chefia, numero
	FROM pessoa p
	JOIN funcionario f
	   on p.codPessoa = f.codFuncionario
	JOIN pessoa e
	   ON f.codChefia = e.codPessoa
	JOIN telefone t
	   ON e.codPessoa = t.codPessoa
)

SELECT Chefia, numero
FROM funcionarioChefe
WHERE funcionario = 'Anderson'



    3. (Locadora) Crie uma trigger que ao ser deletado uma tupla na tabela locação, delete todos as tuplas relacionadas com esta locação da tabela itenslocacao. (Obs.: remova todas as chaves estrangeiras para isso)
DELIMITER $$
CREATE TRIGGER triggerApagaIL
AFTER DELETE ON locacoes 
FOR EACH ROW 
BEGIN 
	DELETE FROM itenslocacoes
	WHERE codLocacao = OLD.codLocacao;
END $$

Delete FROM locacoes
WHERE codLocacao = 19

    4. (Locadora) Crie um índice para a coluna titulo na tabela titulos.
CREATE INDEX indiceParaOTitulo 
	ON titulos (titulo)





