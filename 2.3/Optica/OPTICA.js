
const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const MONGO_URI =
    process.env.MONGODB_URI || "mongodb://localhost:27017/";

mongoose
    .connect(MONGO_URI)
    .then((x) => {
        const databaseName = x.connections[0].name;
        console.log(`Connected to Mongo! Database name: "${databaseName}"`);
    })
    .catch((err) => {
        console.error("Error connecting to mongo: ", err);
    });

// SCHEMA Proveidors

const proveidors = new Schema({
    nom: { type: String, required: true },
    adreça: {
        carrer: String,
        número: Number,
        pis: Number,
        porta: Number,
        ciutat: String,
        codiPostal: String,
        país: String
    },
    telèfon: { type: String, required: true },
    fax: String,
    NIF: { type: String, required: true, unique: true }
});

//SCHEMA ULLERES
const ulleres = new Schema({
    marca: { type: String, required: true },
    graduació: { type: String, required: true },
    tipusMuntura: { type: String, required: true },
    colorMuntura: { type: String, required: true },
    colorVidre: { type: String, required: true },
    preu: { type: Number, required: true },
    proveïdor: {
        type: Schema.Types.ObjectId,
        ref: "proveidors",
        required: true
    }
});

// SCHEMA CLIENTS
const clients = new Schema({
    nom: { type: String, required: true },
    adreçaPostal: { type: String, required: true },
    telèfon: { type: String, required: true },
    correuElectrònic: { type: String, required: true, unique: true },
    dataRegistre: { type: Date, required: true },
    clientRecomanat: {
        type: Schema.Types.ObjectId,
        ref: "clients"
    }
});

// SCHEMA EMPLEAT
const empleatsSchema = new Schema({
    nom: { type: String, required: true },

    telèfon: { type: String, required: true },
    correuElectrònic: { type: String, required: true, unique: true },
    dataContracte: { type: Date, required: true },
    ulleresVenudes: [{
        type: Schema.Types.ObjectId,
        ref: "ulleres"
    }]
});

// SCHEMA BOTIGUES

const botiguesSchema = new Schema({
    adreça: {
        carrer: String,
        número: Number,
        pis: Number,
        porta: Number,
        ciutat: String,
        codiPostal: String,
        país: String
    },
    telèfon: String,
    fax: String,
    NIF: { type: String, required: true },
    empleats: [{
        type: Schema.Types.ObjectId,
        ref: "empleats"
    }],
    ulleres: [{
        type: Schema.Types.ObjectId,
        ref: "ulleres"
    }]
});




const Proveidor = mongoose.model("proveedores", proveidors);
const Ullera = mongoose.model("ulleres", ulleres);
const Client = mongoose.model("clients", clients);
const Empleat = mongoose.model("empleats", empleatsSchema);
const Botiga = mongoose.model("botigues", botiguesSchema);



mongoose
    .connect(MONGO_URI)
    .then((x) => {
        const databaseName = x.connections[0].name;
        console.log(`Connected to Mongo! Database name: "${databaseName}"`);

        const Proveidor = mongoose.model('proveedores', proveidors);
        const Ullera = mongoose.model('ulleres', ulleres);
        const Client = mongoose.model('clients', clients);
        const Empleat = mongoose.model('empleats', empleatsSchema);
        const Botiga = mongoose.model('botigues', botiguesSchema);

        const proveedor = new Proveidor({
            nom: 'Proveedor 1',
            adreça: {
                carrer: 'Calle 1',
                número: 123,
                pis: 4,
                porta: 2,
                ciutat: 'Ciudad 1',
                codiPostal: '12345',
                país: 'País 1',
            },
            telèfon: '123456789',
            fax: '987654321',
            NIF: 'ABCD1234',
        });

        const ullera = new Ullera({
            marca: 'Marca 1',
            graduació: 'Graduació 1',
            tipusMuntura: 'Tipus Muntura 1',
            colorMuntura: 'Color Muntura 1',
            colorVidre: 'Color Vidre 1',
            preu: 10,
            proveïdor: proveedor._id,
        });

        const client = new Client({
            nom: 'Cliente 1',
            adreçaPostal: 'Dirección 1',
            telèfon: '123456789',
            correuElectrònic: 'cliente1@example.com',
            dataRegistre: new Date(),
            clientRecomanat: clients._id,
        });

        const empleat = new Empleat({
            nom: 'Empleado 1',
            telèfon: '123456789',
            correuElectrònic: 'empleado1@example.com',
            dataContracte: new Date(),
            ulleresVenudes: [ullera._id],
        });

        const botiga = new Botiga({
            adreça: {
                carrer: 'Calle Botiga 1',
                número: 10,
                pis: 1,
                porta: 1,
                ciutat: 'Ciudad Botiga 1',
                codiPostal: '54321',
                país: 'País Botiga 1',
            },
            telèfon: '987654321',
            fax: '123456789',
            NIF: 'EFGH5678',
            empleats: [empleat._id],
            ulleres: [ullera._id],
        });

        Promise.all([proveedor.save(), ullera.save(), client.save(), empleat.save(), botiga.save()])
            .then(() => {
                console.log('Documentos guardados correctamente');
                mongoose.connection.close();
            })
            .catch((err) => {
                console.error('Error al guardar los documentos:', err);
                mongoose.connection.close();
            });
    })
    .catch((err) => {
        console.error('Error connecting to mongo: ', err);
    });