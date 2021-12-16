require('dotenv').config()

const _db = require('./data/db')
_db.connect()

const express = require('express')
const app = express()
const http = require('http');
const server = http.createServer(app);
app.use(express.json())

const passport = require('passport')
app.use(passport.initialize());

const routes = require('./routes')
app.use(routes)

const errorHandler = require('./middlewares/error-handler-middleware')
app.use(errorHandler)

server.listen(process.env.PORT, () => {
    console.log('application started')
})