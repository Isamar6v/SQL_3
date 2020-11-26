#####RETO1 (no hay menores, calidad de datos)
USE tienda;

##si no hay nadie, salen todos
###1 ¿Cuál es el nombre de los empleados cuyo sueldo es menor a $10,000?
SELECT nombre, apellido_paterno
FROM empleado
WHERE id_puesto IN
 (SELECT id_puesto
      FROM puesto
      WHERE salario > 10000);

###2 ¿Cuál es la cantidad mínima y máxima de ventas de cada empleado?
SELECT id_empleado, min(total_ventas), max(total_ventas)
FROM
 (SELECT clave, id_empleado, count(*) total_ventas
      FROM venta
      GROUP BY clave, id_empleado) AS sq
GROUP BY id_empleado
ORDER BY clave;

###3 ¿Cuáles claves de venta incluyen artículos cuyos precios son mayores a $5,000? (se repiten claves, distinct para valores unicos)... cardinalidad con group by 
SELECT DISTINCT clave, id_articulo 
FROM venta
WHERE id_articulo IN 
	(SELECT id_articulo 
    FROM articulo 
    WHERE precio > 5000);

##saber cual es mas eficiente en cómputo?... se le agrega EXPLAIN para el tiempo de procesamiento
##otra forma mas completa es con EXPLAIN ANALIZE

 ##extra cuantas personas ganan el minimo y cuantas el maximo
 ##query anidado que el salario es menor que el minimo del select
 
 #####RETO2
 USE tienda;
 
###1 ¿Cuál es el nombre de los empleados que realizaron cada venta?
SELECT clave, nombre, apellido_paterno
FROM venta AS v
JOIN empleado AS e
  ON v.id_empleado = e.id_empleado
ORDER BY clave; ##o por nombre o apellido

##altenativa
SELECT e.nombre, e.apellido_paterno, e.apellido_materno, venta.clave 
FROM empleado AS e 
INNER JOIN venta 
  ON e.id_empleado=venta.id_empleado
ORDER BY clave;


###2 ¿Cuál es el nombre de los artículos que se han vendido?
SELECT clave, nombre
FROM venta AS v
JOIN articulo AS a
  ON v.id_articulo = a.id_articulo
ORDER BY clave;


###3 ¿Cuál es el total de cada venta?
SELECT v.id_venta, SUM(a.precio)
FROM articulo a
JOIN venta v 
  ON a.id_articulo = v.id_articulo
GROUP BY v.id_venta;

##alternativa
SELECT clave, SUM(precio) 
AS total 
FROM venta 
JOIN articulo 
  ON venta.id_articulo = articulo.id_articulo 
GROUP BY clave;

##el subquery (query anidado) debe entenderlo


#####RETO3
###1 Obtener el puesto de un empleado.
CREATE VIEW puestos AS
	SELECT p.nombre AS nombre_puesto,
		CONCAT(e.nombre, ' ',e.apellido_paterno) AS nombre_empleado
	FROM empleado AS e
	JOIN puesto AS p
	ON e.id_puesto = p.id_puesto;
SELECT * FROM puestos;

###2 Saber qué artículos ha vendido cada empleado.
CREATE VIEW articulos_vendidos AS
	SELECT 
		CONCAT(e.nombre,' ',e.apellido_paterno) AS nombre_empleado,
		a.nombre AS nombre_articulo,
		v.clave AS clave_venta
	FROM venta AS v
	JOIN empleado AS e
	ON v.id_empleado = e.id_empleado
	JOIN articulo AS a
	ON v.id_articulo = a.id_articulo;

SELECT * FROM articulos_vendidos;

###3 Saber qué puesto ha tenido más ventas.
CREATE VIEW ventas_puesto AS
	SELECT 
		p.nombre AS puesto, 
		COUNT(v.id_venta) AS ventas_por_puesto 
	FROM venta AS v
	JOIN empleado AS e
	ON v.id_empleado = e.id_empleado
	JOIN puesto AS p
	ON e.id_puesto = p.id_puesto
	GROUP BY p.nombre
	ORDER BY ventas_por_puesto DESC;

SELECT * FROM ventas_puesto;
