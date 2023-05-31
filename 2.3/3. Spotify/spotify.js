const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const MONGO_URI =
    process.env.MONGODB_URI || "mongodb://localhost:27017/Spotify";



const usuarioSchema = new Schema({
    email: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    nombreUsuario: { type: String, required: true },
    fechaNacimiento: { type: Date, required: true },
    sexo: { type: String, enum: ["Masculino", "Femenino", "Otro"], required: true },
    pais: { type: String, required: true },
    codigoPostal: { type: String, required: true },
    tipo: { type: String, enum: ["Free", "Premium"], required: true },
    subscripciones: [{ type: Schema.Types.ObjectId, ref: 'Subscripcion' }],
    playlists: [{ type: Schema.Types.ObjectId, ref: 'Playlist' }],
    artistasSeguidos: [{ type: Schema.Types.ObjectId, ref: 'Artista' }],
    albumsFavoritos: [{ type: Schema.Types.ObjectId, ref: 'Album' }],
    cancionesFavoritas: [{ type: Schema.Types.ObjectId, ref: 'Cancion' }]
});

const subscripcionSchema = new Schema({
    usuario: { type: Schema.Types.ObjectId, ref: 'Usuario' },
    fechaInicio: { type: Date, required: true },
    fechaRenovacion: { type: Date, required: true },
    formaPago: {
        tipo: { type: String, enum: ["TarjetaCredito", "PayPal"], required: true },
        datosTarjeta: {
            numero: { type: String },
            mesCaducidad: { type: Number },
            anoCaducidad: { type: Number },
            codigoSeguridad: { type: String }
        },
        usuarioPayPal: { type: String }
    },
    pagos: [{ type: Schema.Types.ObjectId, ref: 'Pago' }]
});


const pagoSchema = new Schema({
    subscripcion: { type: Schema.Types.ObjectId, ref: 'Subscripcion' },
    fecha: { type: Date, required: true },
    numeroOrden: { type: String, unique: true, required: true },
    total: { type: Number, required: true }
});


const playlistSchema = new Schema({
    titulo: { type: String, required: true },
    numCanciones: { type: Number, required: true },
    identificadorUnico: { type: String, required: true, unique: true },
    fechaCreacion: { type: Date, required: true },
    eliminada: { type: Boolean, default: false },
    fechaEliminacion: { type: Date },
    canciones: [{ type: Schema.Types.ObjectId, ref: 'Cancion' }],
    usuariosCompartidos: [{
        usuario: { type: Schema.Types.ObjectId, ref: 'Usuario' },
        fechaAgregado: { type: Date, required: true }
    }]
});


const cancionSchema = new Schema({
    titulo: { type: String, required: true },
    duracion: { type: Number, required: true },
    reproducciones: { type: Number, default: 0 },
    album: { type: Schema.Types.ObjectId, ref: 'Album' },
    artistas: [{ type: Schema.Types.ObjectId, ref: 'Artista' }]
});


const albumSchema = new Schema({
    titulo: { type: String, required: true },
    anoPublicacion: { type: Number, required: true },
    imagenPortada: { type: String },
    artista: { type: Schema.Types.ObjectId, ref: 'Artista' },
    canciones: [{ type: Schema.Types.ObjectId, ref: 'Cancion' }]
});


const artistaSchema = new Schema({
    nombre: { type: String, required: true },
    imagen: { type: String },
    relacionados: [{ type: Schema.Types.ObjectId, ref: 'Artista' }]
});


mongoose
    .connect(MONGO_URI)
    .then((x) => {
        const databaseName = x.connections[0].name;
        console.log(`Connected to Mongo! Database name: "Spotify"`);

        const Usuario = mongoose.model('Usuario', usuarioSchema);
        const Subscripcion = mongoose.model('Subscripcion', subscripcionSchema);
        const Pago = mongoose.model('Pago', pagoSchema);
        const Playlist = mongoose.model('PlayList', playlistSchema);
        const Cancion = mongoose.model('Cancion', cancionSchema);
        const Album = mongoose.model('Album', albumSchema);
        const Artista = mongoose.model('Artista', artistaSchema)


        const artista = new Artista({
            nombre: 'Artista 1',
            imagen: 'imagen_artista.jpg',
            relacionados: []
        });


        const cancion = new Cancion({
            titulo: 'Canción 1',
            duracion: 180,
            artistas: [artista._id]
        });

        const album = new Album({
            titulo: 'Álbum 1',
            anoPublicacion: 2022,
            artista: artista._id,
            canciones: [cancion._id]
        });

        const usuario = new Usuario({
            email: 'usuario@example.com',
            password: 'contraseña',
            nombreUsuario: 'Usuario1',
            fechaNacimiento: new Date('1990-01-01'),
            sexo: 'Femenino',
            pais: 'España',
            codigoPostal: '12345',
            tipo: 'Premium',
            subscripciones: [],
            playlists: [],
            artistasSeguidos: [artista._id],
            albumsFavoritos: [album._id],
            cancionesFavoritas: [cancion._id]
        });
        const playlist = new Playlist({
            titulo: 'Mi Playlist',
            numCanciones: 5,
            identificadorUnico: 'PL-123',
            fechaCreacion: new Date(),
            canciones: [cancion._id, cancion._id],
            usuariosCompartidos: [{
                usuario: usuario._id,
                fechaAgregado: new Date()
            }]

        });

        const subscripcion = new Subscripcion({
            usuario: usuario._id,
            fechaInicio: new Date(),
            fechaRenovacion: new Date(),
            formaPago: {
                tipo: 'TarjetaCredito',
                datosTarjeta: {
                    numero: '123456789',
                    mesCaducidad: 12,
                    anoCaducidad: 2023,
                    codigoSeguridad: '123'
                }
            }
        });


        const pago = new Pago({
            subscripcion: subscripcion._id,
            fecha: new Date(),
            numeroOrden: 'ORD-123',
            total: 10.99
        });


        usuario.save();
        subscripcion.save();
        pago.save();
        playlist.save();
        cancion.save();
        album.save();
        artista.save();


    })