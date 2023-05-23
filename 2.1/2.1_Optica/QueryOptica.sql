-- Llista el total de compres d’un client/a.
SELECT idVendes, data, ulleres_id
FROM VENDES
WHERE client_id= 2
-- Llista les diferents ulleres que ha venut un empleat durant un any.

SELECT DISTINCT idULLERES, marca,Preu, graduacio_vidre_dret,graduacio_vidre_esquerra,muntura,color_muntura
FROM VENDES
INNER JOIN ULLERES ON VENDES.ulleres_id = ULLERES.idULLERES
WHERE VENDES.empleat_id = 3 AND YEAR(VENDES.data) = 2023;


-- Llista els diferents proveïdors que han subministrat ulleres venudes amb èxit per l'òptica.

SELECT DISTINCT PROVEÏDOR.nom, PROVEÏDOR.telefon,PROVEÏDOR.ciutat
FROM ULLERES
INNER JOIN VENDES ON ULLERES.idULLERES=VENDES.ulleres_id
INNER JOIN PROVEÏDOR ON ULLERES.ProveidorId=PROVEÏDOR.idPROVEEDORES
WHERE VENDES.idVendes 


SELECT idComandes, `Data/hora`, tipo_comanda, client_id, productes_id, preu_total, botiga
FROM Comandes
WHERE repartidor_id = 1;