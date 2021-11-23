const express = require('express')
const router = express.Router()

const authController = require('../controllers/auth-controller')

router.post('/token', authController.token)

module.exports = router