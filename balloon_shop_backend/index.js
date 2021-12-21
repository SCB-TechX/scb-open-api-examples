require('dotenv').config()

const _db = require('./data/db')
_db.connect()

const express = require('express')
const app = express()
const passport = require('passport')
const routes = require('./routes')
const errorHandler = require('./middlewares/error-handler-middleware')

app.use(express.json())
app.use(passport.initialize())
app.use(routes)
app.use(errorHandler)

const http = require('http')
const server = http.createServer(app)

server.listen(process.env.PORT, () => {
    console.log('application started')
})