const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const MONGO_URI =
    process.env.MONGODB_URI || "mongodb://localhost:27017/pizzeria";


const clienteSchema = new Schema({
    nom: { type: String, required: true },
    cognom: { type: String, required: true },
    direccio: { type: String, required: true },
    codiPostal: { type: String, required: true },
    localitat: { type: String, required: true },
    provincia: { type: String, required: true },
    telefon: { type: String, required: true },
});

const categoriaPizzaSchema = new Schema({
    nombre: { type: String, required: true },
});

const productoSchema = new Schema({
    nombre: { type: String, required: true },
    descripcion: { type: String, required: true },
    imagen: { type: String, required: true },
    precio: { type: Number, required: true },
    tipo: { type: String, enum: ['pizza', 'hamburguesa', 'bebida'], required: true },
    categoriaPizza: { type: Schema.Types.ObjectId, ref: 'Categoria' },
});

const empleadoSchema = new Schema({
    nombre: { type: String, required: true },
    apellidos: { type: String, required: true },
    nif: { type: String, required: true },
    telefono: { type: String, required: true },
    puesto: { type: String, enum: ['cocinero', 'repartidor'], required: true },
});

const tiendaSchema = new Schema({
    direccion: { type: String, required: true },
    codigoPostal: { type: String, required: true },
    localidad: { type: String, required: true },
    provincia: { type: String, required: true },
    empleados: [{ type: Schema.Types.ObjectId, ref: 'Empleado' }]
});

const pedidoSchema = new Schema({
    fechaHora: { type: Date, required: true },
    tipoEntrega: { type: String, enum: ['domicilio', 'recogida'], required: true },
    cantidadProductos: { type: Map, of: Number, required: true },
    precioTotal: { type: Number, required: true },
    cliente: { type: Schema.Types.ObjectId, ref: 'Cliente', required: true },
    productos: [{ type: Schema.Types.ObjectId, ref: 'Producto', required: true }],
    repartidor: { type: Schema.Types.ObjectId, ref: 'Empleado' },
    fechaHoraEntrega: { type: Date },
});

mongoose
    .connect(MONGO_URI)
    .then((x) => {
        const databaseName = x.connections[0].name;
        console.log(`Connected to Mongo! Database name: "Pizzeria"`);

        const Cliente = mongoose.model('Cliente', clienteSchema);
        const Producto = mongoose.model('Producto', productoSchema);
        const Categoria = mongoose.model('Categoria', categoriaPizzaSchema);
        const Empleado = mongoose.model('Empleado', empleadoSchema);
        const Tienda = mongoose.model('Tienda', tiendaSchema);
        const Pedido = mongoose.model('Pedido', pedidoSchema);

        const cliente = new Cliente({
            nom: 'Juan',
            cognom: 'De Gea',
            direccio: 'Calle 123',
            codiPostal: '12345',
            localitat: 'Ciudad',
            provincia: 'Provincia',
            telefon: '123456789',
        });

        const categoriaPizza = new Categoria({
            nombre: 'Clásica',
        });

        const producto = new Producto({
            nombre: 'Pizza Margarita',
            descripcion: 'Deliciosa pizza con tomate, mozzarella y albahaca',
            imagen: 'imagen-url',
            precio: 10,
            tipo: 'pizza',
            categoriaPizza: categoriaPizza._id,
        });

        const empleado = new Empleado({
            nombre: 'Juan',
            apellidos: 'Pérez',
            nif: '12345678A',
            telefono: '987654321',
            puesto: 'cocinero',
        });

        const tienda = new Tienda({
            direccion: 'Calle Tienda 1',
            codigoPostal: '54321',
            localidad: 'Ciudad Tienda',
            provincia: 'Provincia Tienda',
            empleados: [empleado._id]
        });

        const pedido = new Pedido({
            fechaHora: new Date(),
            tipoEntrega: 'domicilio',
            cantidadProductos: { pizza: 2, bebida: 1 },
            precioTotal: 25,
            cliente: cliente._id,
            productos: [producto._id],
            repartidor: empleado._id,
            fechaHoraEntrega: new Date(),
        });

        Promise.all([
            cliente.save(),
            categoriaPizza.save(),
            producto.save(),
            empleado.save(),
            tienda.save(),
            pedido.save()])
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
