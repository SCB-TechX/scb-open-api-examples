const { StatusCodes } = require("http-status-codes")

module.exports.getDeeplink = async (req, res) => {
    res.status(StatusCodes.OK).send(req.user)

}