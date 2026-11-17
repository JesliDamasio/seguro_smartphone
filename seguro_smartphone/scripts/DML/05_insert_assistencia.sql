
USE SeguroSmartphone;
GO

INSERT INTO dbo.assistencia_tecnica
(nm_razao_social, nr_cnpj, nr_telefone, ds_cidade, sg_uf, fl_ativa)
SELECT
    v.nm_razao_social,
    v.nr_cnpj,
    v.nr_telefone,
    v.ds_cidade,
    v.sg_uf,
    v.fl_ativa
FROM (VALUES
    ('Assistencia Tech Sul', '00000000000001', '48991110001', 'Criciuma', 'SC', 1),
    ('Smart Repair', '00000000000002', '48991110002', 'Tubarão', 'SC', 1),
    ('Mobile Center', '00000000000003', '48991110003', 'Ararangua', 'SC', 1),
    ('Conserta Phone', '00000000000004', '48991110004', 'Icara', 'SC', 1),
    ('Tech Solutions', '00000000000005', '48991110005', 'Florianopolis', 'SC', 1),
    ('Repara Smart', '00000000000006', '48991110006', 'Joinville', 'SC', 1),
    ('Cell Assist', '00000000000007', '48991110007', 'Blumenau', 'SC', 1),
    ('Digital Service', '00000000000008', '48991110008', 'Lages', 'SC', 1),
    ('Phone Care', '00000000000009', '48991110009', 'Chapeco', 'SC', 1),
    ('Smart Fix', '00000000000010', '48991110010', 'Tubarão', 'SC', 1),
    ('Tecno Celular', '00000000000011', '48991110011', 'Criciuma', 'SC', 1),
    ('Center Mobile', '00000000000012', '48991110012', 'Sao Jose', 'SC', 1),
    ('Master Phone', '00000000000013', '48991110013', 'Palhoca', 'SC', 1),
    ('Help Smartphone', '00000000000014', '48991110014', 'Itajai', 'SC', 1),
    ('Reparo Express', '00000000000015', '48991110015', 'Balneario Camboriu', 'SC', 1),
    ('Phone Expert', '00000000000016', '48991110016', 'Brusque', 'SC', 1),
    ('Smart Doctor', '00000000000017', '48991110017', 'Tubarao', 'SC', 1),
    ('Tecno Repair', '00000000000018', '48991110018', 'Sao Bento do Sul', 'SC', 1),
    ('Mobile Tech', '00000000000019', '48991110019', 'Rio do Sul', 'SC', 1),
    ('Assist Phone', '00000000000020', '48991110020', 'Jaragua do Sul', 'SC', 1)
) AS v(nm_razao_social, nr_cnpj, nr_telefone, ds_cidade, sg_uf, fl_ativa)
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.assistencia_tecnica a
    WHERE a.nr_cnpj = v.nr_cnpj
);
GO
