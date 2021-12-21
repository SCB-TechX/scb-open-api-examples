const { StatusCodes } = require('http-status-codes')
const safeCompare = require('safe-compare')
const jwt = require("jsonwebtoken")
const userService = require('../services/users.service')
const ApiResponseCodes = require('../constants/api-response-codes')

module.exports.token = async (req, res) => {
    const { email, password } = req.body
    const user = await userService.getUserByEmail(email)
    if (!user || !safeCompare(user.password, password)) {
        throw { responseCode: ApiResponseCodes.INVALID_EMAIL_OR_PASSWORD }
    } else {
        const iatDate = new Date()
        const payload = {
            sub: req.body.email,
            iat: iatDate.getTime(),
            exp: iatDate.getTime() + (15 * 60000)
        }
        const secret = process.env.SERVER_JWT_SECRET
        const token = jwt.sign(payload, secret)
        res.status(StatusCodes.OK).send({ accessToken: token })
    }
}