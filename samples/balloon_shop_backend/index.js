const express = require('express')
const app = express()
const routes = require('./routes')

require('dotenv').config()

app.use(express.json())
app.use(routes)

app.listen(process.env.PORT, () => {
    console.log('application started')
})