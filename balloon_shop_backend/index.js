require('dotenv').config()

const express = require('express')
const app = express()
app.use(express.json())

const passport = require('passport')
app.use(passport.initialize());

const routes = require('./routes')
app.use(routes)

app.listen(process.env.PORT, () => {
    console.log('application started')
})