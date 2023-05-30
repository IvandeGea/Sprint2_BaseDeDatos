//  1. Escriu una consulta per mostrar tots els documents en la col·lecció Restaurants.
db.Restaurants.find({})

// 2 Escriu una consulta per mostrar el restaurant_id, name, borough i cuisine de tots els documents en la col·lecció Restaurants.
db.Restaurants.find({}, { restaurant_id: 1, name: 1, borough: 1, cuisine: 1 })

// 3. Escriu una consulta per mostrar el restaurant_id, name, borough i cuisine, però excloent el camp _id per tots els documents en la col·lecció Restaurants.
db.Restaurants.find({}, { restaurant_id: 1, name: 1, borough: 1, cuisine: 1, _id: 0 })

// 4. Escriu una consulta per mostrar restaurant_id, name, borough i zip code, però excloent el camp _id per tots els documents en la col·lecció Restaurants.
db.Restaurants.find({}, { restaurant_id: 1, name: 1, borough: 1, "address.zipcode": 1, _id: 0 })

// 5. Escriu una consulta per mostrar tots els restaurants que estan en el Bronx.
db.Restaurants.find({ borough: "Bronx" })

// 6. Escriu una consulta per mostrar els primers 5 restaurants que estan en el Bronx.
db.Restaurants.find({ borough: "Bronx" }).limit(5)

// 7. Escriu una consulta per mostrar els 5 restaurants després de saltar els primers 5 que siguin del Bronx.
db.Restaurants.find({ borough: "Bronx" }).skip(5).limit(5)

// 8. Escriu una consulta per trobar els restaurants que tenen algun score més gran de 90.
db.Restaurants.find({ "grades.score": { $gt: 90 } })

// 9. Escriu una consulta per trobar els restaurants que tenen un score més gran que 80 però menys que 100.
db.Restaurants.find({ "grades.score": { $gt: 80, $lt: 100 } })

// 10.  Escriu una consulta per trobar els restaurants que estan situats en una longitud inferior a -95.754168.
db.Restaurants.find({ "address.coord.0": { $lt: -95.754168 } })

// 11 Escriu una consulta de MongoDB per a trobar els restaurants que no cuinen menjar 'American ' i tenen algun score superior a 70 i longitud inferior a -65.754168.

db.Restaurants.find({
    cuisine: { $ne: "American " }, "grades.score": { $gt: 70 }, "address.coord.0": { $lt: -65.754168 }
})

// 12 Escriu una consulta per trobar els restaurants que no preparen menjar 'American' i tenen algun score superior a 70 i que, a més, es localitzen en longituds inferiors a -65.754168. Nota: Fes aquesta consulta sense utilitzar operador $and.
db.Restaurants.find({
    cuisine: { $ne: "American " }, "grades.score": { $gt: 70 }, "address.coord.0": { $lt: -65.754168 }
})
// 13 Escriu una consulta per trobar els restaurants que no preparen menjar 'American ', tenen alguna nota 'A' i no pertanyen a Brooklyn. S'ha de mostrar el document segons la cuisine en ordre descendent.
db.Restaurants.find({
    cuisine: { $ne: "American " }, "grades.grade": "A", borough: { $ne: "Brooklyn" }
}).sort({ cuisine: -1 })

// 14 Escriu una consulta per trobar el restaurant_id, name, borough i cuisine per a aquells restaurants que contenen 'Wil' en les tres primeres lletres en el seu nom.

db.Restaurants.find({ name: /^Wil/ }, { restaurant_id: 1, name: 1, borough: 1, cuisine: 1 })

// 15. Escriu una consulta per trobar el restaurant_id, name, borough i cuisine per a aquells restaurants que contenen 'ces' en les últimes tres lletres en el seu nom.
db.Restaurants.find({ name: /ces$/ }, { restaurant_id: 1, name: 1, borough: 1, cuisine: 1 })

// 16. Escriu una consulta per trobar el restaurant_id, name, borough i cuisine per a aquells restaurants que contenen 'Reg' en qualsevol lloc del seu nom.

db.Restaurants.find({ name: /Reg/ }, { restaurant_id: 1, name: 1, borough: 1, cuisine: 1 })

// 17. Escriu una consulta per trobar els restaurants que pertanyen al Bronx i preparen plats Americans o xinesos.

db.Restaurants.find({
    borough: "Bronx", $or: [{ cuisine: "American " }, { cuisine: "Chinese" }]
})

// 18. Escriu una consulta per trobar el restaurant_id, name, borough i cuisine per aquells restaurants que pertanyen a Staten Island, Queens, Bronx o Brooklyn.

db.Restaurants.find({
    borough: { $in: ["Staten Island", "Queens", "Bronx", "Brooklyn"] }
}, { restaurant_id: 1, name: 1, borough: 1, cuisine: 1 })

//19. Escriu una consulta per trobar el restaurant_id, name, borough i cuisine per a aquells restaurants que NO pertanyen a Staten Island, Queens, Bronx o Brooklyn.

db.Restaurants.find({
    borough: { $nin: ["Staten Island", "Queens", "Bronx", "Brooklyn"] }
}, { restaurant_id: 1, name: 1, borough: 1, cuisine: 1 })

//20. Escriu una consulta per trobar el restaurant_id, name, borough i cuisine per a aquells restaurants que aconsegueixin una nota menor que 10.

db.Restaurants.find({ "grades.score": { $lt: 10 } }, { restaurant_id: 1, name: 1, borough: 1, cuisine: 1 })

// 21. Escriu una consulta per trobar el restaurant_id, name, borough i cuisine per a aquells restaurants que preparen marisc ('seafood') excepte si són 'American ', 'Chinese' o el name del restaurant comença amb lletres 'Wil'.

db.Restaurants.find({
    cuisine: "seafood",
    $nor: [
        { cuisine: "American " },
        { cuisine: "Chinese" },
        { name: /^Wil/ }
    ]
}, { restaurant_id: 1, name: 1, borough: 1, cuisine: 1 })

// 22. Escriu una consulta per trobar el restaurant_id, name i grades per a aquells restaurants que aconsegueixin un grade de "A" i un score d'11 amb un ISODate "2014-08-11T00:00:00Z"

db.Restaurants.find({
    "grades.grade": "A", "grades.score": 11, "grades.date": ISODate("2014-08-11T00:00:00Z")
}, { restaurant_id: 1, name: 1, grades: 1 })

// 23. Escriu una consulta per trobar el restaurant_id, name i grades per a aquells restaurants on el 2n element de l'array de graus conté un grade de "A" i un score 9 amb un ISODate "2014-08-11T00:00:00Z".

db.Restaurants.find({
    "grades.1.grade": "A", "grades.1.score": 9,
    "grades.1.date": ISODate("2014-08-11T00:00:00Z")
}, { restaurant_id: 1, name: 1, grades: 1 })

// 24. Escriu una consulta per trobar el restaurant_id, name, adreça i ubicació geogràfica per a aquells restaurants on el segon element de l'array coord conté un valor entre 42 i 52.

db.Restaurants.find({
    "address.coord.1": { $gte: 42, $lte: 52 }
}, { restaurant_id: 1, name: 1, "address.building": 1, "address.street": 1, "address.coord": 1 })

// 25. Escriu una consulta per organitzar els restaurants per nom en ordre ascendent.

db.Restaurants.find().sort({ name: 1 })

// 26. Escriu una consulta per organitzar els restaurants per nom en ordre descendent.

db.Restaurants.find().sort({ name: -1 })

// 27. Escriu una consulta per organitzar els restaurants pel nom de la cuisine en ordre ascendent i pel barri en ordre descendent.

db.Restaurants.find().sort({ cuisine: 1, borough: -1 })

// 28. Escriu una consulta per saber si les direccions contenen el carrer.

db.Restaurants.find({ "address.street": { $exists: true, $ne: "" } })

// 29 Escriu una consulta que seleccioni tots els documents en la col·lecció de restaurants on els valors del camp coord és de tipus Double.

db.Restaurants.find({ "address.coord": { $type: "double" } })

// 30 Escriu una consulta que seleccioni el restaurant_id, name i grade per a aquells restaurants que retornen 0 com a residu després de dividir algun dels seus score per 7.

db.Restaurants.find({
    "grades.score": { $mod: [7, 0] }
}, { restaurant_id: 1, name: 1, "grades.grade": 1 })

// 31 .Escriu una consulta per trobar el name de restaurant, borough, longitud, latitud i cuisine per a aquells restaurants que contenen 'mon' en algun lloc del seu name.

db.Restaurants.find({ name: /mon/ },
    { name: 1, borough: 1, "address.coord": 1, cuisine: 1 })

// 32. Escriu una consulta per trobar el name de restaurant, borough, longitud, latitud i cuisine per a aquells restaurants que contenen 'Mad' com a primeres tres lletres del seu name.

db.Restaurants.find({ name: /^Mad/ },
    { name: 1, borough: 1, "address.coord": 1, cuisine: 1 }
)