const { StatusCodes } = require("http-status-codes")
const paymentService = require('../services/payment-service')

module.exports.createDeeplink = async (req, res) => {
    try {
        const deeplink = await paymentService.createDeeplink(req.user, req.body)
        res.status(StatusCodes.OK).send(deeplink)
    } catch (err) {
        throw err;
    }
}

module.exports.createQr = async (req, res) => {
    try {
        const qr = await paymentService.createQr(req.user, req.body)
        res.status(StatusCodes.OK).send(qr)
    } catch (err) {
        throw err;
    }
}

module.exports.paymentConfirmation = async (req, res) => {
    try {
        console.log(req.body)
        const transaction = await paymentService.paymentConfirmation(req.body)
        res.status(StatusCodes.OK).send(transaction)
    } catch (err) {
        throw err;
    }
}