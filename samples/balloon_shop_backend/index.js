//index.js

const express = require("express");
const bodyParser = require('body-parser');
require('dotenv').config()

const app = express();

var authRoutes = require('./routes/auth-routes');
var paymentRoutes = require('./routes/payment-routes');

// Setup server port
var port = process.env.PORT || 3000;
app.use('/api/payment', apiRoutes);
app.use('/api/auth', authRoutes);

app.listen(3000); //บอกให้ server รอที่ port 3000