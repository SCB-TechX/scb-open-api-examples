const { StatusCodes } = require("http-status-codes")
const scbService = require('../services/scb-service')

module.exports.createDeeplink = async (req, res) => {
    scbService.createDeeplink(req.user)
        .then((deeplink) => {
            res.status(StatusCodes.OK).send(deeplink)
        })
}