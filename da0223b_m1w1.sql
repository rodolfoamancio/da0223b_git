-----------------------------------------------------------------------------
-- Mãos na massa
-- O que é SQL e como usá-lo
-- Professor: Rodolfo Amancio 
-----------------------------------------------------------------------------

-- Primeiro select

SELECT * FROM customers LIMIT 10;

-- Exemplo distinct

SELECT DISTINCT customer_state FROM customers;

-- Exemplo where

SELECT * FROM customers WHERE customer_state = "MG";

SELECT * FROM customers WHERE customer_state = 'MG';

-- Exemplo like

SELECT * FROM customers WHERE customer_state LIKE "S%";

-- Exemplo GROUP BY

SELECT
	customer_state,
	COUNT(customer_id)
FROM customers
GROUP BY customer_state;

-----------------------------------------------------------------------------
-- Quantos categorias de produtos existem no e-commerce em análise ?
-----------------------------------------------------------------------------

SELECT DISTINCT product_category_name FROM products;

SELECT COUNT(DISTINCT product_category_name) FROM products;

-----------------------------------------------------------------------------
-- Quantos clientes existem por estado?
-----------------------------------------------------------------------------

SELECT
	customer_state,
	COUNT(customer_id) AS numero_clientes
FROM customers
GROUP BY customer_state
ORDER BY numero_clientes DESC;

-----------------------------------------------------------------------------
-- Quantos clientes existem em MG?
-----------------------------------------------------------------------------

SELECT
	COUNT(customer_id)
FROM customers
WHERE customer_state = "MG";

SELECT
	customer_state,
	COUNT(customer_id) AS numero_clientes
FROM customers
GROUP BY customer_state
HAVING numero_clientes > 10000;

-----------------------------------------------------------------------------
-- Os valores das compras são diferentes entre diferentes formas de 
-- pagamento?
-----------------------------------------------------------------------------

SELECT * FROM order_payments LIMIT 50;

SELECT DISTINCT payment_type FROM order_payments;

SELECT 
	SUM(payment_value),
	AVG(payment_value)
FROM order_payments
WHERE payment_type = 'credit_card'; 

SELECT
	payment_type ,
	SUM(payment_value)
FROM order_payments
GROUP BY payment_type;


SELECT
	payment_type,
	AVG(payment_value),
	SUM(payment_value)
FROM order_payments
GROUP BY payment_type;

SELECT
	payment_type,
	MIN(payment_value) AS min_pagamento,
	ROUND(AVG(payment_value), 2) AS media_pagamento,
	MAX(payment_value) AS max_pagamento,
	SUM(payment_value)/1000000 AS total_pagamento_milhoes
FROM order_payments 
WHERE NOT payment_type = "not_defined"
GROUP BY payment_type;

-----------------------------------------------------------------------------
-- Quantos clientes existem por região?
-----------------------------------------------------------------------------

SELECT 
	*,
	CASE
		WHEN customer_state IN ("MT", "MS", "DF", "GO") THEN "centro-oeste"
		WHEN customer_state IN ("SP", "MG", "RJ", "ES") THEN "sudeste"
		WHEN customer_state IN ("AC", "AM", "AP", "PA", "RO", "RR", "TO") THEN "norte"
		WHEN customer_state IN ("AL", "BA", "CE", "MA", "PI", "PE", "PB", "RN", "SE") THEN "nordeste"
		WHEN customer_state IN ("PR", "RS", "SC") THEN "sul"
		ELSE "vazio"
	END AS regiao
FROM customers
LIMIT 50

SELECT 
	CASE
		WHEN customer_state IN ("MT", "MS", "DF", "GO") THEN "centro-oeste"
		WHEN customer_state IN ("SP", "MG", "RJ", "ES") THEN "sudeste"
		WHEN customer_state IN ("AC", "AM", "AP", "PA", "RO", "RR", "TO") THEN "norte"
		WHEN customer_state IN ("AL", "BA", "CE", "MA", "PI", "PE", "PB", "RN", "SE") THEN "nordeste"
		WHEN customer_state IN ("PR", "RS", "SC") THEN "sul"
		ELSE "vazio"
	END AS regiao,
	COUNT(DISTINCT customer_unique_id) AS numero_clientes
FROM customers
GROUP BY regiao
ORDER BY numero_clientes DESC

-----------------------------------------------------------------------------
-- Qual o total de pedidos por ano?
-----------------------------------------------------------------------------

SELECT 
	*
FROM orders;

/*
SUBSTRING(<coluna>, <onde_começa>, <tamamho>)
*/
SELECT
	*,
	SUBSTRING(order_purchase_timestamp, 1, 4) AS ano
FROM orders 
LIMIT 50;


SELECT
	SUBSTRING(order_purchase_timestamp, 1, 4) AS ano,
	COUNT(DISTINCT order_id) AS total_pedidos
FROM orders
GROUP BY ano
ORDER BY ano DESC;

-----------------------------------------------------------------------------
-- E por mês e ano?
-----------------------------------------------------------------------------

SELECT 
	*,
	SUBSTRING(order_purchase_timestamp, 1, 4) AS ano,
	SUBSTRING(order_purchase_timestamp, 6, 2) AS mes
FROM orders 
LIMIT 10

SELECT 
	SUBSTRING(order_purchase_timestamp, 1, 4) AS ano,
	SUBSTRING(order_purchase_timestamp, 6, 2) AS mes,
	COUNT(DISTINCT order_id) AS total_pedidos
FROM orders
GROUP BY ano, mes
ORDER BY ano, mes

SELECT *
FROM orders
LIMIT 10

-- Outra forma de acesar dia, mês, ano


SELECT 
	order_purchase_timestamp,
	STRFTIME("%H", order_purchase_timestamp) 
FROM orders
LIMIT 10

SELECT 
	order_purchase_timestamp,
	STRFTIME("%Y", order_purchase_timestamp) 
FROM orders
LIMIT 10


SELECT
	STRFTIME('%Y', order_purchase_timestamp) AS ano,
	STRFTIME('%m', order_purchase_timestamp) AS mes,
	COUNT(DISTINCT order_id) AS total_pedidos
FROM orders
GROUP BY ano, mes
ORDER BY ano, mes

