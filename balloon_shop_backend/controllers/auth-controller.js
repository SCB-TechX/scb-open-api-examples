const { StatusCodes } = require('http-status-codes')
const safeCompare = require('safe-compare')
const jwt = require("jsonwebtoken");
const userService = require('../services/user-service')

module.exports.token = async (req, res) => {

    const { email, password } = req.body
    const user = userService.getUser(email)
    if (!user || !safeCompare(user.password, password)) {
        res.status(StatusCodes.UNAUTHORIZED).send({
            code: 40101,
            developer_message: 'invalid email or password'
        })
    } else {
        const iatDate = new Date();
        const payload = {
            sub: req.body.email,
            iat: iatDate.getTime(),
            exp: iatDate.getTime() + (15 * 60000)
        };
        const secret = process.env.SERVER_JWT_SECRET;
        const token = jwt.sign(payload, secret);
        res.status(StatusCodes.OK).send({ access_token: token });
    }
}