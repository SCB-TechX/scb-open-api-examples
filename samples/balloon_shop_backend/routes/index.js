const express = require('express')
const router = express.Router()

const authJwt = require('../middleware/auth-jwt-middleware')

const authController = require('../controllers/auth-controller')
const paymentController = require('../controllers/payment-controller')

router.post('/token', authController.token)
router.post('/payment/deeplink', authJwt, paymentController.createDeeplink)

module.exports = router