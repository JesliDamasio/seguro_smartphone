
USE SeguroSmartphone;
GO

INSERT INTO dbo.modelo_aparelho
(cd_fabricante, nm_modelo, vl_mercado_referencia)
SELECT
    f.cd_fabricante,
    v.nm_modelo,
    v.vl_mercado_referencia
FROM (VALUES
    ('Apple', 'iPhone 15', 4500.00),
    ('Apple', 'iPhone 15 Pro', 6200.00),
    ('Samsung', 'Galaxy S24', 4200.00),
    ('Samsung', 'Galaxy A55', 2200.00),
    ('Motorola', 'Moto G84', 1600.00),
    ('Motorola', 'Edge 50 Pro', 3500.00),
    ('Xiaomi', 'Redmi Note 13', 1400.00),
    ('Xiaomi', 'Poco X6 Pro', 2300.00),
    ('Huawei', 'Pura 70', 5000.00),
    ('LG', 'K62', 1200.00),
    ('Sony', 'Xperia 10 V', 2800.00),
    ('Asus', 'Zenfone 10', 4000.00),
    ('Realme', 'Realme 12 Pro', 2500.00),
    ('Oppo', 'Reno 11', 2700.00),
    ('OnePlus', 'OnePlus 12', 5500.00),
    ('Nokia', 'G42', 1300.00),
    ('Google', 'Pixel 8', 3800.00),
    ('TCL', 'TCL 40', 1100.00),
    ('Infinix', 'Note 30', 1500.00),
    ('Honor', 'Honor 90', 2900.00)
) AS v(nm_fabricante, nm_modelo, vl_mercado_referencia)
INNER JOIN dbo.fabricante f
    ON f.nm_fabricante = v.nm_fabricante
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.modelo_aparelho m
    WHERE m.cd_fabricante = f.cd_fabricante
      AND m.nm_modelo = v.nm_modelo
);
GO
