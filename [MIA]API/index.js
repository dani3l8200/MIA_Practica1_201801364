var mysql = require('mysql');

const express = require('express');

const morgan = require('morgan')

const app = express();

const bodyParser = require('body-parser');
const { request, response } = require('express');


app.use(bodyParser.json())


app.set('port', process.env.PORT || 4000);

app.use(function(req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    next();
});

const conexion = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    database: 'MIA_Practica1',
    password: 'JuanAnonymo2000@',
    useUTC: true,
    timezone: "utc"
})

app.get('/Consulta1', (request, response) => {
    var myQuery = "CALL SP_Consulta1();";

    conexion.query(myQuery, function(err, result) {
        if (err) {
            response.send(`<h1 style="text-align:center;  color: magenta;">Error en la consulta1</h1>`);
        } else {
            console.log(result[0]);
            response.send(result[0])
        }
    });
})

app.get('/Consulta2', (request, response) => {
    var myQuery = "CALL SP_Consulta2();";

    conexion.query(myQuery, function(err, result) {
        if (err) {
            response.send(`<h1 style="text-align:center;  color: magenta;">Error en la consulta2</h1>`);
        } else {
            console.log(result[0]);
            response.send(result[0])
        }
    });
})

app.get('/Consulta3', (request, response) => {
    var myQuery = "CALL SP_Consulta3();";

    conexion.query(myQuery, function(err, result) {
        if (err) {
            response.send(`<h1 style="text-align:center;  color: magenta;">Error en la consulta3</h1>`);
        } else {
            console.log(result[0]);
            response.send(result[0])
        }
    });
})

app.get('/Consulta4', (request, response) => {
    var myQuery = "CALL SP_Consulta4();";

    conexion.query(myQuery, function(err, result) {
        if (err) {
            response.send(`<h1 style="text-align:center;  color: magenta;">Error en la consulta4</h1>`);
        } else {
            console.log(result[0]);
            response.send(result[0])
        }
    });
})

app.get('/Consulta5', (request, response) => {
    var myQuery = "CALL SP_Consulta5();";

    conexion.query(myQuery, function(err, result) {
        if (err) {
            response.send(`<h1 style="text-align:center;  color: magenta;">Error en la consulta5</h1>`);
        } else {
            console.log(result[0]);
            response.send(result[0])
        }
    });
})

app.get('/Consulta6', (request, response) => {
    var myQuery = "CALL SP_Consulta6();";

    conexion.query(myQuery, function(err, result) {
        if (err) {
            response.send(`<h1 style="text-align:center;  color: magenta;">Error en la consulta6</h1>`);
        } else {
            console.log(result[0]);
            response.send(result[0])
        }
    });
})

app.get('/Consulta7', (request, response) => {
    var myQuery = "CALL SP_Consulta7();";

    conexion.query(myQuery, function(err, result) {
        if (err) {
            response.send(`<h1 style="text-align:center;  color: magenta;">Error en la consulta7</h1>`);
        } else {
            console.log(result[0]);
            response.send(result[0])
        }
    });
})

app.get('/Consulta8', (request, response) => {
    var myQuery = "CALL SP_Consulta8();";

    conexion.query(myQuery, function(err, result) {
        if (err) {
            response.send(`<h1 style="text-align:center;  color: magenta;">Error en la consulta8</h1>`);
        } else {
            console.log(result[0]);
            response.send(result[0])
        }
    });
})

app.get('/Consulta9', (request, response) => {
    var myQuery = "CALL SP_Consulta9();";

    conexion.query(myQuery, function(err, result) {
        if (err) {
            response.send(`<h1 style="text-align:center;  color: magenta;">Error en la consulta9</h1>`);
        } else {
            console.log(result[0]);
            response.send(result[0])
        }
    });
})

app.get('/Consulta10', (request, response) => {
    var myQuery = "CALL SP_Consulta10();";

    conexion.query(myQuery, function(err, result) {
        if (err) {
            response.send(`<h1 style="text-align:center;  color: magenta;">Error en la consulta10</h1>`);
        } else {
            console.log(result[0]);
            response.send(result[0])
        }
    });
})

app.get('/eliminarTemporal', (request, response) => {
    var myQuery = "CALL SP_EliminarTemporal();";
    conexion.query(myQuery, function(err, result) {
        if (err) {
            response.send(`<h1 style="text-align:center;  color: magenta;">Error al eliminar las tablas del modelo propuesto</h1>`);
        } else {
            console.log("Se eliminaron con exito los datos de la tabla temporal");
            response.send(`<h1 style="text-align:center;  color: blue;">Se eliminaron con exito los datos de la tabla temporal</h1>`);
        }
    });
})

app.get('/eliminarModelo', (request, response) => {
    var myQuery = "CALL SP_EliminarModeloPropuesto();";
    conexion.query(myQuery, function(err, result) {
        if (err) {
            response.send(`<h1 style="text-align:center;  color: magenta;">Error al eliminar los datos de la tabla temporal</h1>`);
        } else {
            console.log("Se eliminaron con exito las tablas del modelo propuesto");
            response.send(`<h1 style="text-align:center;  color: blue;">Se eliminaron con exito las tablas del modelo propuesto</h1>`);
        }
    });
})

app.get('/cargarTemporal', (request, response) => {
    var myQuery = `LOAD DATA LOCAL INFILE '/home/DataCenterData.csv' 
    INTO TABLE TablaTemporal 
    FIELDS TERMINATED BY ';' 
    LINES TERMINATED BY '\n' 
    IGNORE 1 LINES (nombre_compania, contacto_compania, correo_compania, telefono_compania, 
    tipo, nombre, correo, telefono, @var_fec, direccion, ciudad, 
    codigo_postal, region, producto, categoria_producto, cantidad, precio_unitario) 
    SET fecha_registro = STR_TO_DATE(@var_fec, '%d/%m/%Y');`;
    conexion.query(myQuery, function(err, result) {
        if (err) {
            response.send(`<h1 style="text-align:center;  color: magenta;">Error al hacer la carga masiva</h1>`);
        } else {
            console.log("Se realizo la carga masiva con exito");
            response.send(`<h1 style="text-align:center;  color: red;">Se realizo la carga masiva con exito</h1>`);
        }
    });
})

app.get('/cargarModelo', (request, response) => {
    var myQuery = `CALL SP_CrearModeloPropuesto();`;
    conexion.query(myQuery, function(err, result) {
        if (err) {
            response.send(`<h1 style="text-align:center;  color: magenta;">Error al crear las tablas y carga de datos al modelo propuesto </h1>`);
        } else {
            console.log("Se realizo la creacion de tablas y carga de datos al modelo propuesto con exito");
            response.send(`<h1 style="text-align:center;  color: red;">Se realizo la creacion de tablas y carga de datos al modelo propuesto con exito</h1>`);
        }
    });
})


app.listen(app.get('port'), () => {
    console.log("Backend inicializado");
});