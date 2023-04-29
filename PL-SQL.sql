/* 
Actividad de aprendizaje.
Funciones almacenadas
Temario: B

Curso: Taller II
Catedrático: Jorge Pérez.

	Nombre alumno: Luis Carlos Pérez
	Carné:	2021027
	Código técnico: IN5BM
    Grupo: 2
	Fecha: 14/02/2022
    
*/


/*
INDICACIONES GENERAL:
Remplazar los guiones bajos que están al final del nombre de la base de datos por su primer nombre y primer apellido, tanto en el drop, create y use. 
Ejemplo: db_funciones_jorge_perez
Luego resuelva los problemas que se le plantean.

*/

DROP DATABASE IF EXISTS df_funciones_luis_perez;
CREATE DATABASE df_funciones_luis_perez;
USE df_funciones_luis_perez;

CREATE TABLE resultados (
	id INT AUTO_INCREMENT NOT NULL,
    area DECIMAL(10,2),
    pares VARCHAR(45),
    mayor INT,
    PRIMARY KEY PK_Funciones_Id (id)
);

-- INSTRUCCIONES:

-- 1. Crear un procedimiento almacenado para insertar registros en la tabla Resultados
DELIMITER $$
drop procedure if exists sp_resultados_create $$
create procedure sp_resultados_create(
	in _area decimal(10,2),
    in _pares varchar(45),
    in _mayor int
    )
begin
	insert into resultados(
		area,
		pares,
		mayor
    ) 
    values(
		_area,
        _pares,
        _mayor
    );
end$$
DELIMITER ;

-- 2. Crear una función para calcular el área de un trapecio.
DELIMITER $$
drop function if exists fn_area_trapecio $$
create function fn_area_trapecio(
	base_mayor int, 
	base_menor int, 
	altura int
)
returns decimal(10,2)
reads sql data deterministic
begin
	declare area_trapecio decimal(10,2);
    set area_trapecio = base_mayor + base_menor;
    set area_trapecio = area_trapecio * altura;
    set area_trapecio = area_trapecio / 2;
    return area_trapecio;
end$$
DELIMITER ;


-- 3. Crear una función que acumule en una variable todos los números pares del 1 al N.
DELIMITER $$
drop function if exists fn_num_pares$$
create function fn_num_pares(limite int)
returns varchar(255)
reads sql data deterministic
	begin
		declare  i int;
		declare resultado varchar(255) default " ";
		set i = 0;
		
		ciclo: repeat
        set i = i + 1;
        if i % 2 = 0 then
			set resultado = concat(resultado, i, " | ");
		else 
			iterate ciclo;
		end if;
			until i = limite 
		end repeat ciclo;
		
		return resultado;
	end$$
DELIMITER ;

-- 4. Crear una función para calcular el número Mayor de 4 números enteros.
DELIMITER $$
drop function if exists fn_num_mayor $$
create function fn_num_mayor(num1 int, num2 int, num3 int, num4 int)
returns int
reads sql data deterministic 
	begin
		declare mayor int;
		if num1 = num2 and num2 = num3 and num3 = num4 then
				set mayor = 0;
			elseif num1 > num2 and num1 > num3 and num1 > num4 then
				set mayor = num1;
			elseif num2 > num3 and num2 > num4 then
				set mayor = num2;
			elseif num3 > num4 then
				set mayor = num3;
			else
				set mayor = num4;
			end if;
		return mayor;
	end $$
DELIMITER ;

-- 5. Llamar al procedimiento almacenado creado anteriormente para insertar el resultado de las funciones en la tabla Resultados.
call sp_resultados_create(fn_area_trapecio(6,5,2), fn_num_pares(12), fn_num_mayor(2,4,5,10));


-- 6. Crear y llamar el procedimiento almacenado para listar todos los registros de la tabla resultados.
DELIMITER $$
drop procedure if exists sp_resultados_read $$
create procedure sp_resultados_read()
	begin
		select 
			resultados.id,
            resultados.area,
            resultados.pares,
            resultados.mayor
		from
            resultados;
	end $$
DELIMITER ;

call sp_resultados_read();



/*
OBSERVACIONES: Para resolver el ejercicio 1 y 5 debe crear procedimientos
almacenados correspondientes a un CRUD siguiendo la convensión de nombres 
especificado en clase, favor de ver el vídeo que le proporcione el profesor.
https://www.youtube.com/watch?v=4IaU3oNkrdI
*/
