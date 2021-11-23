const { StatusCodes } = require("http-status-codes")
const scbService = require('../services/scb-service')

module.exports.getDeeplink = async (req, res) => {
    scbService.getDeeplink()
    res.status(StatusCodes.OK).send(req.user)

}