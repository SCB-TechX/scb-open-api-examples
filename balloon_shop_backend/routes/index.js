const express = require('express')
const router = express.Router()

const authenticateJwt = require('../middlewares/auth-jwt-middleware')

const authController = require('../controllers/auth-controller')
const paymentController = require('../controllers/payment-controller')

router.post('/token', authController.token)
router.post('/payment/deeplink', authenticateJwt, paymentController.createDeeplink)
router.post('/payment/confirmation', paymentController.paymentConfirmation)

module.exports = router