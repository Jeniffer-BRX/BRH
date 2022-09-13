--1. PROCEDURE DE INSERCAO DE PROJETOS, COMO TEMOS CAMPOS NAO NULOS, PRECISOU COLOCAR OS CAMPOS DE NOME, RESP E DATA DE INCIO
create or replace procedure brh.insere_projeto(
    p_nome in projeto.nome%type,
    p_responsavel in projeto.responsavel%type)   
is 
begin
    insert into brh.projeto (nome,responsavel,inicio)
    values (p_nome,p_responsavel,sysdate);
end;
---------
-- teste
EXECUTE brh.insere_projeto('Teste procedure5', 'T123', '06/09/2022'); 
 

-------------------------------------------------------

--2. brh.calcula_idade que informa a idade a partir de uma data.

create or replace function brh.calcula_idade (p_data date)
return number
is
    v_data_retorno number;
begin
    select floor(months_between(to_date(sysdate),to_date(p_data))/12)
    into v_data_retorno from dual;
    return v_data_retorno;
end;
---
set serveroutput on

DECLARE
    v_idade NUMBER;
BEGIN
    v_idade := calcula_idade('03/11/1994');
    dbms_output.put_line('A idade é: ' || v_idade);
END;
--
select d.*, brh.calcula_idade(d.data_nascimento) idade from brh.dependente d; --chamar do banco, pego da monitoria, esta retornando numero com virgula

--------------------------------------------------
-- 4. Criar function finaliza_projeto-----------
create or replace function brh.finaliza_projeto (p_id IN brh.projeto.id%type)
RETURN brh.projeto.fim%type 
IS
v_data_termino brh.projeto.fim%type;
BEGIN
    SELECT fim INTO v_data_termino FROM brh.projeto WHERE id = p_id;
    IF v_data_termino IS NOT NULL THEN
        dbms_output.put_line(v_data_termino);
        RETURN v_data_termino;
    ELSE
        UPDATE brh.projeto SET fim = sysdate WHERE id = p_id;
        dbms_output.put_line(v_data_termino);
        RETURN v_data_termino;
    END IF;
END;
---
DECLARE
v_tp DATE;
BEGIN
v_tp := brh.finaliza_projeto(1);
END;


