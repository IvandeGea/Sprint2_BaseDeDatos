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

--RESUMEN

-- Retorna el nombre total d'alumnes que hi ha.

SELECT persona.*
FROM universidad.persona
WHERE tipo='alumno'

-- Calcula quants alumnes van néixer en 1999.

SELECT COUNT(*)
FROM universidad.persona
WHERE tipo='alumno' 
AND EXTRACT(YEAR FROM fecha_nacimiento) = 1999;

--Calcula quants professors/es hi ha en cada departament. El resultat només ha de mostrar dues columnes, una amb el nom del departament i una altra amb el nombre de professors/es que hi ha en aquest departament. El resultat només ha d'incloure els departaments que tenen professors/es associats i haurà d'estar ordenat de major a menor pel nombre de professors/es.

SELECT DISTINCT departamento.nombre, COUNT(profesor.id_profesor) AS 'Numero de Profesores'
FROM universidad.persona
RIGHT JOIN profesor ON persona.id= profesor.id_profesor
LEFT JOIN departamento ON profesor.id_departamento= departamento.id
GROUP BY departamento.nombre
ORDER BY COUNT(profesor.id_profesor) DESC;

-- Retorna un llistat amb tots els departaments i el nombre de professors/es que hi ha en cadascun d'ells. Tingui en compte que poden existir departaments que no tenen professors/es associats. Aquests departaments també han d'aparèixer en el llistat.

SELECT DISTINCT departamento.nombre, persona.nombre 
FROM universidad.persona
RIGHT JOIN profesor ON persona.id= profesor.id_profesor
RIGHT JOIN departamento ON profesor.id_departamento= departamento.id
-- Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun. Tingues en compte que poden existir graus que no tenen assignatures associades. Aquests graus també han d'aparèixer en el llistat. El resultat haurà d'estar ordenat de major a menor pel nombre d'assignatures.

SELECT DISTINCT grado.nombre, asignatura.nombre
FROM universidad.asignatura
RIGHT JOIN grado ON asignatura.id_grado = grado.id

-- Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun, dels graus que tinguin més de 40 assignatures associades.

LEFT JOIN universidad.asignatura ON grado.id = asignatura.id_grado
GROUP BY grado.nombre
HAVING COUNT(asignatura.id) > 40
ORDER BY total_asignaturas DESC;

-- Retorna un llistat que mostri el nom dels graus i la suma del nombre total de crèdits que hi ha per a cada tipus d'assignatura. El resultat ha de tenir tres columnes: nom del grau, tipus d'assignatura i la suma dels crèdits de totes les assignatures que hi ha d'aquest tipus.

SELECT grado.nombre, asignatura.tipo, SUM(asignatura.creditos) AS total_creditos
FROM asignatura
INNER JOIN grado ON asignatura.id_grado = grado.id
GROUP BY grado.nombre, asignatura.tipo;

-- Retorna un llistat que mostri quants alumnes s'han matriculat d'alguna assignatura en cadascun dels cursos escolars. El resultat haurà de mostrar dues columnes, una columna amb l'any d'inici del curs escolar i una altra amb el nombre d'alumnes matriculats.

SELECT curso_escolar.anyo_inicio, COUNT(persona.nombre)
FROM universidad.persona
LEFT JOIN alumno_se_matricula_asignatura ON persona.id = alumno_se_matricula_asignatura.id_alumno
LEFT JOIN curso_escolar ON alumno_se_matricula_asignatura.id_curso_escolar = curso_escolar.id
WHERE curso_escolar.anyo_inicio IS NOT NULL
GROUP BY curso_escolar.anyo_inicio;


-- Retorna un llistat amb el nombre d'assignatures que imparteix cada professor/a. El llistat ha de tenir en compte aquells professors/es que no imparteixen cap assignatura. El resultat mostrarà cinc columnes: id, nom, primer cognom, segon cognom i nombre d'assignatures. El resultat estarà ordenat de major a menor pel nombre d'assignatures.

SELECT persona.id, persona.nombre, persona.apellido1, persona.apellido2, asignatura.nombre
FROM universidad.persona
LEFT JOIN profesor ON persona.id= profesor.id_profesor
LEFT JOIN asignatura ON profesor.id_profesor=asignatura.id_profesor

-- Retorna totes les dades de l'alumne/a més jove.

SELECT *
FROM universidad.persona
LEFT JOIN alumno_se_matricula_asignatura ON persona.id= alumno_se_matricula_asignatura.id_alumno
LEFT JOIN asignatura ON alumno_se_matricula_asignatura.id_asignatura=asignatura.id
LEFT JOIN curso_escolar ON alumno_se_matricula_asignatura.id_curso_escolar=curso_escolar.id
LEFT JOIN grado ON asignatura.id_grado = grado.id
WHERE persona.tipo = 'alumno'
ORDER BY fecha_nacimiento ASC LIMIT 1;


-- Retorna un llistat amb els professors/es que tenen un departament associat i que no imparteixen cap assignatura.

SELECT DISTINCT Persona.nombre, persona.apellido1, persona.apellido2
FROM universidad.persona
RIGHT JOIN profesor ON persona.id=profesor.id_profesor
LEFT JOIN asignatura ON profesor.id_profesor=asignatura.id_profesor
WHERE asignatura.id IS NULL AND profesor.id_departamento IS NOT NULL