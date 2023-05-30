const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const autopopulate = require('mongoose-autopopulate');


const canalSchema = new Schema({
    nombre: { type: String, required: true },
    descripcion: { type: String, required: true },
    fechaCreacion: { type: Date, required: true }
});

const usuarioSchema = new Schema({
    email: { type: String, required: true },
    password: { type: String, required: true },
    nombreUsuario: { type: String, required: true },
    fechaNacimiento: { type: Date, required: true },
    sexo: { type: String, required: true },
    pais: { type: String, required: true },
    codigoPostal: { type: String, required: true },
    canales: [{ type: Schema.Types.ObjectId, ref: 'Canal', autopopulate: true }],
    suscripciones: [{ type: Schema.Types.ObjectId, ref: 'Canal', autopopulate: true }]
});

const videoSchema = new Schema({
    titulo: { type: String, required: true },
    descripcion: { type: String, required: true },
    grandaria: { type: Number, required: true },
    nombreArchivo: { type: String, required: true },
    duracion: { type: Number, required: true },
    thumbnail: { type: String, required: true },
    reproducciones: { type: Number, default: 0 },
    estado: { type: String, enum: ['publico', 'oculto', 'privado'], required: true },
    etiquetas: [{ type: Schema.Types.ObjectId, ref: 'Etiqueta', autopopulate: true }],
    usuario: { type: Schema.Types.ObjectId, ref: 'Usuario', required: true, autopopulate: true },
    fechaHoraPublicacion: { type: Date, required: true },
});

const etiquetaSchema = new Schema({
    nombre: { type: String, required: true },
});

const likeDislikeVideoSchema = new Schema({
    usuario: { type: Schema.Types.ObjectId, ref: 'Usuario', required: true, autopopulate: true },
    video: { type: Schema.Types.ObjectId, ref: 'Video', required: true, autopopulate: true },
    tipo: { type: String, enum: ['like', 'dislike'], required: true },
    fechaHora: { type: Date, required: true },
});

const playlistSchema = new Schema({
    nombre: { type: String, required: true },
    fechaCreacion: { type: Date, required: true },
    estado: { type: String, enum: ['publica', 'privada'], required: true },
    videos: [{ type: Schema.Types.ObjectId, ref: 'Video', autopopulate: true }],
    usuario: { type: Schema.Types.ObjectId, ref: 'Usuario', autopopulate: true }
});

const comentarioSchema = new Schema({
    texto: { type: String, required: true },
    fechaHora: { type: Date, required: true },
    usuario: { type: Schema.Types.ObjectId, ref: 'Usuario', required: true, autopopulate: true },
    video: { type: Schema.Types.ObjectId, ref: 'Video', required: true, autopopulate: true },
});

const likeDislikeComentarioSchema = new Schema({
    usuario: { type: Schema.Types.ObjectId, ref: 'Usuario', required: true, autopopulate: true },
    comentario: { type: Schema.Types.ObjectId, ref: 'Comentario', required: true, autopopulate: true },
    tipo: { type: String, enum: ['like', 'dislike'], required: true, },
    fechaHora: { type: Date, required: true },
});


usuarioSchema.plugin(require('mongoose-autopopulate'));
videoSchema.plugin(require('mongoose-autopopulate'));
canalSchema.plugin(require('mongoose-autopopulate'));
likeDislikeVideoSchema.plugin(require('mongoose-autopopulate'));
playlistSchema.plugin(require('mongoose-autopopulate'));
comentarioSchema.plugin(require('mongoose-autopopulate'));
likeDislikeComentarioSchema.plugin(require('mongoose-autopopulate'))

const Usuario = mongoose.model('Usuario', usuarioSchema);
const Video = mongoose.model('Video', videoSchema);
const Etiqueta = mongoose.model('Etiqueta', etiquetaSchema);
const Canal = mongoose.model('Canal', canalSchema);
const LikeDislikeVideo = mongoose.model('LikeDislikeVideo', likeDislikeVideoSchema);
const Playlist = mongoose.model('Playlist', playlistSchema);
const Comentario = mongoose.model('Comentario', comentarioSchema);
const LikeDislikeComentario = mongoose.model('LikeDislikeComentario', likeDislikeComentarioSchema);




const MONGO_URI =
    process.env.MONGODB_URI || "mongodb://localhost:27017/Youtube";

mongoose
    .connect(MONGO_URI)
    .then((x) => {
        const databaseName = x.connections[0].name;
        console.log(`Connected to Mongo! Database name: ${databaseName}`);

        const canal = new Canal({
            nombre: 'Mi Canal',
            descripcion: 'Descripción de mi canal',
            fechaCreacion: new Date(),
        });

        const usuario = new Usuario({
            email: 'usuario@example.com',
            password: 'contraseña',
            nombreUsuario: 'Usuario1',
            fechaNacimiento: new Date('1990-01-01'),
            sexo: 'masculino',
            pais: 'España',
            codigoPostal: '12345',
            canales: [canal._id],
            suscripciones: [canal._id]
        });

        const etiqueta = new Etiqueta({
            nombre: 'divertido'
        });


        const video = new Video({
            titulo: 'Video 1',
            descripcion: 'Descripción del video 1',
            grandaria: 1024,
            nombreArchivo: 'video1.mp4',
            duracion: 120,
            thumbnail: 'thumbnail1.jpg',
            reproducciones: 0,
            estado: 'publico',
            etiquetas: [etiqueta._id, etiqueta._id],
            usuario: usuario._id,
            fechaHoraPublicacion: new Date()
        });


        const likeDislikeVideo = new LikeDislikeVideo({
            usuario: usuario._id,
            video: video._id,
            tipo: 'like',
            fechaHora: new Date()
        });

        const comentario = new Comentario({
            texto: '¡Gran video!',
            fechaHora: new Date(),
            usuario: usuario._id,
            video: video._id
        });

        const likeDislikeComentario = new LikeDislikeComentario({
            usuario: usuario._id,
            comentario: comentario._id,
            tipo: 'dislike',
            fechaHora: new Date()
        });

        const playList = new Playlist({
            nombre: 'bloque albarracin',
            fechaCreacion: new Date(),
            estado: 'publica',
            videos: [video._id, video._id],
            usuario: usuario._id
        })

        Promise.all([
            Usuario.create(usuario),
            Video.create(video),
            Canal.create(canal),
            Etiqueta.create(etiqueta),
            LikeDislikeVideo.create(likeDislikeVideo),
            Comentario.create(comentario),
            LikeDislikeComentario.create(likeDislikeComentario),
            Playlist.create(playList),
        ])
            .then(() => {
                console.log('Documentos guardados correctamente');
                mongoose.connection.close();
            })
            .catch((error) => {
                console.error('Error al guardar los documentos:', error);
                mongoose.connection.close();
            });
    })
    .catch((error) => {
        console.error('Error al conectar a MongoDB:', error);
    });