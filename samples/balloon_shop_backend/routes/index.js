const express = require('express')
const router = express.Router()

const authJwt = require('../middleware/auth-jwt-middleware')

const authController = require('../controllers/auth-controller')
const paymentController = require('../controllers/payment-controller')

router.post('/token', authController.token)
router.get('/payment/deeplink', authJwt, paymentController.getDeeplink)

module.exports = router