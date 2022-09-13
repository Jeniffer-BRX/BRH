--LISTAGEM DEPARTamentos

select * from brh.departamento
order by nome

-------------------------------

--LISTA DEPENDENTES

select BRH.COLABORADOR.nome as nome_colaborador, BRH.DEPENDENTE.NOME as nome_dependente, data_nascimento, parentesco from brh.colaborador,brh.dependente
where brh.colaborador.matricula = brh.dependente.colaborador


-------------------------------
-- INSERCAO NOVO COLAB EM PROJETO

INSERT INTO brh.papel (id, nome) VALUES (8, 'Especialista de Negocios'); 

INSERT INTO brh.endereco (cep, uf, cidade, bairro, logradouro) VALUES ('25641-100', 'RJ', 'Rio de Janeiro', 'Lindo Rio', 'Avenida');
insert into brh.colaborador (matricula, nome, cpf, email_pessoal, email_corporativo, salario, departamento, cep, complemento_endereco) 
VALUES ('FL123', 'Fulano de Tal', '176.824.194-55', 'fulanodetal@email.com', 'fulanodetal@corp.com', '8000', 'DEPTI', '25641-100', 'Sitio 9');

INSERT INTO brh.telefone_colaborador (colaborador, numero, tipo) VALUES ('FL123', '(61) 99999-9999', 'M'); 

INSERT INTO brh.projeto (nome, responsavel, inicio, fim) VALUES ('BI', 'FL123', to_date('2022-06-01', 'yyyy-mm-dd'), null);

INSERT INTO brh.atribuicao (projeto, colaborador, papel) VALUES (4, 'fl123', 8);
select * from brh.colaborador where nome = 'Fulano de Tal'

--------------------------------------------
-- relatorio contatos

select c.matricula , c.nome, c.email_corporativo, t.numero 
from brh.colaborador c
inner join brh.telefone_colaborador t
on c.matricula=t.colaborador;

-------------------------------------------
--relatorio analitico

select d.nome as "Nome departamento", d.chefe as "Chefe departamento", ch.nome as "Nome Colaborador", pj.nome as "Nome projeto",
p.nome as "Nome papel", t.numero as "N° Colaborador", dep.nome as "Nome dependente"

from brh.departamento d
inner join brh.colaborador ch
on d.chefe = ch.matricula
inner join brh.colaborador aloc
on d.sigla = aloc.departamento
left join brh.dependente dep
on dep.colaborador = aloc.matricula
left join brh.projeto pj
on pj.responsavel = ch.matricula
inner join brh.papel p
on p.id = pj.id
inner join brh.telefone_colaborador t
on t.colaborador = ch.matricula;
