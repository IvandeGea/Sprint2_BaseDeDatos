-- 1.Retorna un llistat amb el primer cognom, segon cognom i el nom de tots els/les alumnes. El llistat haurà d'estar ordenat alfabèticament de menor a major pel primer cognom, segon cognom i nom.

SELECT apellido1 , apellido2, nombre
FROM persona
WHERE tipo = 'alumno'
ORDER BY apellido1 , apellido2, nombre DESC;

-- 2.Esbrina el nom i els dos cognoms dels alumnes que no han donat d'alta el seu número de telèfon en la base de dades.

SELECT apellido1 , apellido2, nombre, telefono
FROM persona
WHERE tipo='alumno' 
AND telefono IS NULL
-- 3.Retorna el llistat dels alumnes que van néixer en 1999.

SELECT apellido1 , apellido2, nombre, fecha_nacimiento
FROM persona
WHERE tipo='alumno' 
AND EXTRACT(YEAR FROM fecha_nacimiento) = 1999;

-- 4.Retorna el llistat de professors/es que no han donat d'alta el seu número de telèfon en la base de dades i a més el seu NIF acaba en K.

SELECT apellido1 , apellido2, nombre, telefono, nif
FROM persona
WHERE tipo='profesor' 
AND telefono IS NULL
AND RIGHT(NIF,1) = 'K';

-- 5.Retorna el llistat de les assignatures que s'imparteixen en el primer quadrimestre, en el tercer curs del grau que té l'identificador 7.

SELECT * 
FROM universidad.asignatura
WHERE cuatrimestre= 1
AND curso = 3 AND id_grado = 7;


-- 6 Retorna un llistat dels professors/es juntament amb el nom del departament al qual estan vinculats. El llistat ha de retornar quatre columnes, primer cognom, segon cognom, nom i nom del departament. El resultat estarà ordenat alfabèticament de menor a major pels cognoms i el nom.

SELECT persona.apellido1, persona.apellido2, persona.nombre, departamento.nombre
FROM universidad.persona
INNER JOIN profesor ON  persona.id = profesor.id_profesor
INNER JOIN departamento ON profesor.id_departamento = departamento.id
ORDER BY persona.apellido1, persona.apellido2,persona.nombre ASC;


-- 7. Retorna un llistat amb el nom de les assignatures, any d'inici i any de fi del curs escolar de l'alumne/a amb NIF 26902806M.

SELECT asignatura.nombre, curso_escolar.anyo_inicio, curso_escolar.anyo_fin
FROM universidad.persona
INNER JOIN alumno_se_matricula_asignatura ON  persona.id = alumno_se_matricula_asignatura.id_alumno
INNER JOIN asignatura ON alumno_se_matricula_asignatura.id_asignatura = asignatura.id
INNER JOIN curso_escolar ON alumno_se_matricula_asignatura.id_curso_escolar = curso_escolar.id
WHERE persona.nif = '26902806M'


-- 8. Retorna un llistat amb el nom de tots els departaments que tenen professors/es que imparteixen alguna assignatura en el Grau en Enginyeria Informàtica (Pla 2015).

SELECT DISTINCT departamento.nombre AS 'Departamentos'
FROM universidad.persona
INNER JOIN profesor  ON  persona.id = profesor.id_profesor
INNER JOIN departamento ON profesor.id_departamento = departamento.id
INNER JOIN asignatura ON profesor.id_profesor = asignatura.id_profesor
INNER JOIN grado ON grado.id= asignatura.id_grado
WHERE grado.nombre = 'Grado en Ingeniería Informática (Plan 2015)';

-- 9. Retorna un llistat amb tots els alumnes que s'han matriculat en alguna assignatura durant el curs escolar 2018/2019.

SELECT DISTINCT persona.id, persona.nombre, persona.apellido1,persona.apellido2
FROM universidad.persona
INNER JOIN alumno_se_matricula_asignatura ON persona.id= alumno_se_matricula_asignatura.id_alumno
INNER JOIN curso_escolar ON alumno_se_matricula_asignatura.id_curso_escolar = curso_escolar.id
WHERE curso_escolar.anyo_inicio=2018 AND curso_escolar.anyo_fin=2019


--Resol les 6 següents consultes utilitzant les clàusules LEFT JOIN i RIGHT JOIN.

-- 1. Retorna un llistat amb els noms de tots els professors/es i els departaments que tenen vinculats. El llistat també ha de mostrar aquells professors/es que no tenen cap departament associat. El llistat ha de retornar quatre columnes, nom del departament, primer cognom, segon cognom i nom del professor/a. El resultat estarà ordenat alfabèticament de menor a major pel nom del departament, cognoms i el nom.

SELECT DISTINCT departamento.nombre AS 'Departamento', persona.apellido1, persona.apellido2, persona.nombre
FROM universidad.persona
LEFT JOIN profesor  ON  persona.id = profesor.id_profesor
LEFT JOIN departamento ON profesor.id_departamento = departamento.id;

-- 2. Retorna un llistat amb els professors/es que no estan associats a un departament.

SELECT DISTINCT persona.apellido1, persona.apellido2, persona.nombre
FROM universidad.persona
LEFT JOIN profesor  ON  persona.id = profesor.id_profesor
LEFT JOIN departamento ON profesor.id_departamento = departamento.id
WHERE departamento.nombre IS NULL;


-- 3. Retorna un llistat amb els departaments que no tenen professors/es associats.

SELECT DISTINCT departamento.nombre AS 'Departamento'
FROM universidad.persona
RIGHT JOIN profesor  ON  persona.id = profesor.id_profesor
RIGHT JOIN departamento ON profesor.id_departamento = departamento.id
WHERE persona.nombre IS NULL;


-- 4. Retorna un llistat amb els professors/es que no imparteixen cap assignatura.

SELECT DISTINCT persona.* 
FROM universidad.persona
INNER JOIN profesor  ON  persona.id = profesor.id_profesor
LEFT JOIN asignatura ON profesor.id_profesor = asignatura.id_profesor
WHERE asignatura.nombre IS NULL;


-- 5. Retorna un llistat amb les assignatures que no tenen un professor/a assignat.

SELECT DISTINCT asignatura.* 
FROM universidad.persona
INNER JOIN profesor  ON  persona.id = profesor.id_profesor
RIGHT JOIN asignatura ON profesor.id_profesor = asignatura.id_profesor
WHERE persona.nombre IS NULL;

-- 6. Retorna un llistat amb tots els departaments que no han impartit assignatures en cap curs escolar.

SELECT departamento.nombre AS 'Departamentos'
FROM universidad.asignatura
INNER JOIN profesor  ON  asignatura.id = profesor.id_profesor
RIGHT JOIN departamento ON profesor.id_departamento = departamento.id
WHERE asignatura.nombre IS NULL;