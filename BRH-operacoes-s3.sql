--------listar dependentes
select c.nome, d.nome, to_char(d.data_nascimento, 'dd/mm/yyyy')
from brh.dependente d
inner join brh.colaborador c ON c.matricula = d.colaborador --juncao
where to_char(data_nascimento, 'MM') in (4,5,6) --condicao
or lower (d.nome) like '%h%'--2 condicao 
order by c.nome, d.nome;
--------------------------------------------

--listar colab com maior salario
select nome, salario from brh.colaborador
where salario = (select max(salario) from brh.colaborador) --subconsulta p trazer maior salsario
order by salario desc;
-----------------------------------

--senioridade dos colabs (nome, matricula,salario, e nivel senior, ordenar nome e senioridade
--[Júnior: até R$ 3k, --Pleno: R$ 3,1k a R$ 6.k
--Sênior: R$ 6,1k a R$ 20k; --Corpo diretor: acima de R$ 20k]

select c.matricula, c.nome, c.salario, 
case 
    when ((c.salario > 0) and (c.salario <= 3000)) then 'Junior'
    when ((c.salario > 3000) and (c.salario <= 6000)) then 'Pleno'
    when ((c.salario > 6000) and (c.salario <= 20000)) then 'Senior'
    when (c.salario > 20000) then 'Corpo Diretor'
end as Nsenioridade
from brh.colaborador c
order by Nsenioridade, c.nome;

----------------------------------------

--listar qtd colaboradores em projeto
UPDATE brh.projeto
   SET id = id - 4
 WHERE nome != 'BI';

COMMIT;

select d.nome, p.nome, count (*) as quantidade
from brh.departamento d
inner join brh.colaborador c --jucao colb e depto
    on d.sigla = c.departamento
inner join brh.atribuicao a --atribuicao e colab
    on a.colaborador = c.matricula 
inner join brh.projeto p --projeto e atribuicao
    on p.id = a.projeto
group by d.nome, p.nome --count
order by d.nome, p.nome, quantidade;

--------------------------------

--listar colabs com mais de 1 dependentes 
select c.nome colaborador,
    count (*) qtDependentes
from brh.colaborador c
inner join brh.dependente d 
    on c.matricula = d.colaborador
group by c.nome
having count (*) >= 2 
order by qtDependentes desc, c.nome;

----------------------------------------------

--listar faixa etaria dos dependentes
select d.cpf, d.nome, d.data_nascimento, d.parentesco, c.matricula,

trunc (months_between(sysdate, data_nascimento) / 12) as idade,  
    
    case 
        when trunc (months_between(sysdate, data_nascimento) / 12) < 18 then 'Menor de idade'
            else  'ADULTO'
        end as faixa_etaria
from brh.dependente d
inner join brh.colaborador c
 on d.colaborador = c.matricula
order by d.colaborador, c.nome;
-----------------------------------------
--opcionais e desafio
--faixa etaria view------------------------
create or replace view brh.vw_faixa_etaria
as
    select d.cpf, d.nome, d.data_nascimento, d.parentesco, c.matricula,
    trunc (months_between(sysdate, data_nascimento) / 12) as idade,  
    case 
        when trunc (months_between(sysdate, data_nascimento) / 12) < 18 then 'Menor de idade'
            else  'ADULTO'
        end as faixa_etaria
from brh.dependente d
inner join brh.colaborador c
 on d.colaborador = c.matricula
order by d.colaborador, c.nome;


select * from brh.vw_faixa_etaria; -- chamar a view
----------------------------------------------------------
--view senioridade
create or replace view brh.vw_nivel_senioridade
as 
    select c.matricula, c.nome, c.salario, 
    case 
        when ((c.salario > 0) and (c.salario <= 3000)) then 'Junior'
        when ((c.salario > 3000) and (c.salario <= 6000)) then 'Pleno'
        when ((c.salario > 6000) and (c.salario <= 20000)) then 'Senior'
        when (c.salario > 20000) then 'Corpo Diretor'
    end as senioridade
    from brh.colaborador c
    order by senioridade, c.nome;
    
select * from brh.vw_nivel_senioridade;


---------------------------------------------
-- relatorio plano de saude **** incluido depois da mentoria apenas para fixação
select colaborador, sum(valor) as total from (
    select f.colaborador, 100 as valor
    from brh.vw_faixa_etaria f
    where f.parentesco = 'Conjuge'
    union
    select f.colaborador, 50 as valor
    from brh.vw_faixa_etaria f
    where f.parentesco = 'Filho(a)' and f.faixa_etaria = 'ADULTO'
    union all 
    select f.colaborador, 25 as valor 
    from brh.vw_faixa_etaria f
    where f.parentesco = 'Filho(a)' and f.faixa_etaria = 'Menor de idade'
        select c.matricula, 
                case 
                    when c.salario <= 3000 then c.salario * 0.01
                    when c.salario <= 6000 then c.salario * 0.02
                    when c.salario <= 20000 then c.salario * 0.03
                    else c.salario * 0.05
                end as valor
        from brh.colaborador c
)
group by colaborador
order by colaborador;

----------------------------------------
--paginação ******* incluido depois da mentoria, apenas para fixação

select * from (
    select rownum as linha, c.* -- cria o campo linha para contagem das linhas e definir o intervalo de paginas 
        from brh.colaborador c
    order by nome
)
where linha >= 11 and linha <=20; -- define o intervalo de paginas 

--------------------------------

create or replace view brh.vw_faixa_etaria
as
select d.cpf, d.nome, d.data_nascimento, d.parentesco, c.matricula,
trunc (months_between(sysdate, data_nascimento) / 12) as idade,  
    
    case 
        when trunc (months_between(sysdate, data_nascimento) / 12) < 18 then 'Menor de idade'
            else  'ADULTO'
        end as faixa_etaria
from brh.dependente d
inner join brh.colaborador c
 on d.colaborador = c.matricula
order by d.colaborador, c.nome;





