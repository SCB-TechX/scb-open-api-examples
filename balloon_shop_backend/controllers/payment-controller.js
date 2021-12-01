const { StatusCodes } = require("http-status-codes")
const scbService = require('../services/scb-service')

module.exports.createDeeplink = async (req, res) => {
    scbService.createDeeplink(req.user, req.body)
        .then((deeplink) => {
            res.status(StatusCodes.OK).send(deeplink)
        })
}

module.exports.paymentConfirmation = async (req, res) => {
    res.status(StatusCodes.OK)
}