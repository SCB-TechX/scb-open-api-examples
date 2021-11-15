const express = require('express');
const controller = require('../controllers/auth-controller');
const router = express.Router();

router.route('/login').post(controller.login);

module.exports = router;